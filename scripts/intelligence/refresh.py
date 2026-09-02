#!/usr/bin/env python3
from __future__ import annotations

import argparse
import datetime as dt
import html
import json
import os
from pathlib import Path
import re
from typing import Any
import urllib.error
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET

USER_AGENT = "microduck-startup-intelligence/1.0"
GITHUB_API = "https://api.github.com"


def now_utc() -> dt.datetime:
    return dt.datetime.now(dt.timezone.utc)


def iso_utc(value: dt.datetime | None = None) -> str:
    return (value or now_utc()).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def read_json(path: Path) -> dict[str, Any]:
    with path.open(encoding="utf-8") as f:
        value = json.load(f)
    if not isinstance(value, dict):
        raise ValueError(f"{path} must contain a JSON object")
    return value


def write_text_atomic(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temp = path.with_suffix(path.suffix + ".tmp")
    temp.write_text(content, encoding="utf-8")
    temp.replace(path)


def write_json_atomic(path: Path, value: Any) -> None:
    write_text_atomic(path, json.dumps(value, ensure_ascii=False, indent=2) + "\n")


def http_get(url: str, token: str | None = None, accept: str | None = None) -> bytes:
    headers = {"User-Agent": USER_AGENT}
    if accept:
        headers["Accept"] = accept
    if token and url.startswith(GITHUB_API):
        headers["Authorization"] = f"Bearer {token}"
        headers["X-GitHub-Api-Version"] = "2022-11-28"
    request = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            return response.read()
    except urllib.error.HTTPError as exc:
        body = exc.read(500).decode("utf-8", errors="replace")
        raise RuntimeError(f"HTTP {exc.code} for {url}: {body}") from exc
    except urllib.error.URLError as exc:
        raise RuntimeError(f"request failed for {url}: {exc.reason}") from exc


def get_json(url: str, token: str | None = None) -> Any:
    return json.loads(http_get(url, token=token, accept="application/vnd.github+json"))


def api_url(path: str, params: dict[str, Any] | None = None) -> str:
    url = f"{GITHUB_API}{path}"
    if params:
        url += "?" + urllib.parse.urlencode(params)
    return url


def first_line(text: str | None) -> str:
    return (text or "").strip().splitlines()[0] if (text or "").strip() else ""


def collect_repo(source: dict[str, Any], limits: dict[str, int], token: str | None) -> dict[str, Any]:
    slug = source["repo"]
    encoded = urllib.parse.quote(slug, safe="/")
    metadata = get_json(api_url(f"/repos/{encoded}"), token)
    branch = source.get("branch") or metadata["default_branch"]
    branch_encoded = urllib.parse.quote(branch, safe="")
    branch_data = get_json(api_url(f"/repos/{encoded}/branches/{branch_encoded}"), token)
    commits_data = get_json(
        api_url(f"/repos/{encoded}/commits", {"sha": branch, "per_page": limits["commits"]}),
        token,
    )

    result: dict[str, Any] = {
        "repo": slug,
        "role": source.get("role", ""),
        "branch": branch,
        "head": {
            "sha": branch_data["commit"]["sha"],
            "url": branch_data["commit"].get("html_url"),
        },
        "updated_at": metadata.get("updated_at"),
        "pushed_at": metadata.get("pushed_at"),
        "open_issues_count": metadata.get("open_issues_count"),
        "commits": [],
        "releases": [],
        "pulls": [],
        "issues": [],
    }

    for item in commits_data:
        commit = item.get("commit") or {}
        author_info = item.get("author") or {}
        commit_author = commit.get("author") or {}
        result["commits"].append(
            {
                "id": item["sha"],
                "sha": item["sha"],
                "message": first_line(commit.get("message")),
                "author": author_info.get("login") or commit_author.get("name"),
                "date": commit_author.get("date"),
                "url": item.get("html_url"),
            }
        )

    if source.get("include_releases", True):
        releases_data = get_json(
            api_url(f"/repos/{encoded}/releases", {"per_page": limits["releases"]}), token
        )
        for item in releases_data:
            result["releases"].append(
                {
                    "id": str(item.get("id") or item.get("tag_name")),
                    "tag": item.get("tag_name"),
                    "name": item.get("name") or item.get("tag_name"),
                    "published_at": item.get("published_at"),
                    "prerelease": bool(item.get("prerelease")),
                    "url": item.get("html_url"),
                }
            )

    if source.get("include_pulls", True):
        pulls_data = get_json(
            api_url(
                f"/repos/{encoded}/pulls",
                {
                    "state": "all",
                    "sort": "updated",
                    "direction": "desc",
                    "per_page": limits["pulls"],
                },
            ),
            token,
        )
        for item in pulls_data:
            result["pulls"].append(
                {
                    "id": str(item["number"]),
                    "number": item["number"],
                    "title": item.get("title"),
                    "state": item.get("state"),
                    "draft": bool(item.get("draft")),
                    "updated_at": item.get("updated_at"),
                    "merged_at": item.get("merged_at"),
                    "url": item.get("html_url"),
                }
            )

    if source.get("include_issues", False):
        issues_data = get_json(
            api_url(
                f"/repos/{encoded}/issues",
                {
                    "state": "all",
                    "sort": "updated",
                    "direction": "desc",
                    "per_page": limits["issues"],
                },
            ),
            token,
        )
        for item in issues_data:
            if "pull_request" in item:
                continue
            result["issues"].append(
                {
                    "id": str(item["number"]),
                    "number": item["number"],
                    "title": item.get("title"),
                    "state": item.get("state"),
                    "updated_at": item.get("updated_at"),
                    "url": item.get("html_url"),
                }
            )
    return result


def local_name(tag: str) -> str:
    return tag.rsplit("}", 1)[-1].lower()


def node_text(node: ET.Element, names: set[str]) -> str | None:
    for child in list(node):
        if local_name(child.tag) in names and child.text:
            return child.text.strip()
    return None


def feed_link(node: ET.Element) -> str | None:
    for child in list(node):
        if local_name(child.tag) != "link":
            continue
        href = child.attrib.get("href")
        relation = child.attrib.get("rel", "alternate")
        if href and relation in {"alternate", ""}:
            return href
        if child.text and child.text.strip():
            return child.text.strip()
    return None


def strip_markup(text: str | None, limit: int = 500) -> str:
    clean = html.unescape(re.sub(r"<[^>]+>", " ", text or ""))
    clean = re.sub(r"\s+", " ", clean).strip()
    return clean[:limit]


def collect_feed(source: dict[str, Any], limit: int) -> dict[str, Any] | None:
    enabled = source.get("enabled", False)
    url_env = source.get("url_env")
    environment_url = os.getenv(url_env, "").strip() if url_env else ""
    if enabled == "auto":
        enabled = bool(environment_url or source.get("url"))
    if not enabled:
        return None
    url = environment_url or str(source.get("url") or "").strip()
    if not url:
        raise ValueError(f"social source {source.get('name')} is enabled but has no URL")

    root = ET.fromstring(
        http_get(url, accept="application/rss+xml, application/atom+xml, application/xml, text/xml")
    )
    entries = [node for node in root.iter() if local_name(node.tag) in {"item", "entry"}]
    items: list[dict[str, Any]] = []
    for entry in entries[:limit]:
        title = node_text(entry, {"title"}) or "(untitled)"
        link = feed_link(entry)
        identifier = node_text(entry, {"id", "guid"}) or link or title
        published = node_text(entry, {"published", "updated", "pubdate", "date"})
        summary = node_text(entry, {"summary", "description", "content", "encoded"})
        items.append(
            {
                "id": identifier,
                "title": title,
                "published_at": published,
                "url": link,
                "summary": strip_markup(summary),
            }
        )
    return {
        "id": source.get("id") or source.get("name"),
        "name": source.get("name"),
        "account": source.get("account"),
        "kind": source.get("kind", "rss"),
        "source_url": url,
        "items": items,
    }


def previous_ids(snapshot: dict[str, Any] | None) -> set[str]:
    identifiers: set[str] = set()
    if not snapshot:
        return identifiers
    for repo in snapshot.get("github", []):
        slug = repo.get("repo", "")
        for group in ("commits", "releases", "pulls", "issues"):
            for item in repo.get(group, []):
                identifiers.add(f"github:{slug}:{group}:{item.get('id')}")
    for feed in snapshot.get("social", []):
        feed_id = feed.get("id", "")
        for item in feed.get("items", []):
            identifiers.add(f"social:{feed_id}:{item.get('id')}")
    return identifiers


def item_is_new(prefix: str, item: dict[str, Any], old_ids: set[str]) -> bool:
    return f"{prefix}:{item.get('id')}" not in old_ids


def md_link(label: str, url: str | None) -> str:
    safe_label = label.replace("[", "\\[").replace("]", "\\]")
    return f"[{safe_label}]({url})" if url else safe_label


def render_digest(snapshot: dict[str, Any], previous: dict[str, Any] | None) -> str:
    old_ids = previous_ids(previous)
    lines = [
        "# Microduck Intelligence Digest",
        "",
        f"Generated: `{snapshot['generated_at']}`",
        "",
        "The pinned reproduction baseline is not changed by this digest. Review upstream changes in a worktree before updating pins.",
        "",
        "## New since previous snapshot",
        "",
    ]
    new_count = 0
    for repo in snapshot["github"]:
        prefix = f"github:{repo['repo']}"
        new_commits = [
            item for item in repo["commits"] if item_is_new(f"{prefix}:commits", item, old_ids)
        ]
        new_releases = [
            item for item in repo["releases"] if item_is_new(f"{prefix}:releases", item, old_ids)
        ]
        new_pulls = [
            item for item in repo["pulls"] if item_is_new(f"{prefix}:pulls", item, old_ids)
        ]
        if not (new_commits or new_releases or new_pulls):
            continue
        lines += [f"### {repo['repo']}", ""]
        for item in new_releases:
            suffix = " (prerelease)" if item["prerelease"] else ""
            lines.append(
                f"- Release {md_link(item['name'] or item['tag'] or 'release', item['url'])}{suffix}"
            )
            new_count += 1
        for item in new_commits:
            lines.append(
                f"- Commit `{item['sha'][:12]}` {md_link(item['message'] or '(no message)', item['url'])}"
            )
            new_count += 1
        for item in new_pulls:
            lines.append(
                f"- PR #{item['number']} {md_link(item['title'] or '', item['url'])} — {item['state']}"
            )
            new_count += 1
        lines.append("")

    for feed in snapshot["social"]:
        new_items = [
            item for item in feed["items"] if item_is_new(f"social:{feed['id']}", item, old_ids)
        ]
        if not new_items:
            continue
        lines += [f"### {feed['name']}", ""]
        for item in new_items:
            lines.append(
                f"- {md_link(item['title'], item['url'])} — {item.get('published_at') or 'unknown date'}"
            )
            new_count += 1
        lines.append("")

    if new_count == 0:
        lines += ["No new normalized items were detected.", ""]

    lines += ["## Repository heads", ""]
    for repo in snapshot["github"]:
        head = repo["head"]
        lines.append(
            f"- **{repo['repo']}** `{repo['branch']}` → "
            f"{md_link(head['sha'][:12], head.get('url'))}; pushed `{repo.get('pushed_at')}`"
        )

    lines += ["", "## Social feeds", ""]
    if snapshot["social"]:
        for feed in snapshot["social"]:
            lines.append(f"- **{feed['name']}**: {len(feed['items'])} recent item(s)")
    else:
        lines.append(
            "No social feed is active. Configure `MICRODUCK_SOCIAL_FEED_URL` or edit "
            "`configs/intelligence-sources.json`."
        )

    if snapshot["errors"]:
        lines += ["", "## Collection warnings", ""]
        for error in snapshot["errors"]:
            lines.append(f"- **{error['source']}**: `{error['error']}`")

    lines += [
        "",
        "## Review checklist",
        "",
        "- Read upstream diffs before moving a pinned SHA.",
        "- Run tests, the 64×5 smoke test and frozen evaluation in an isolated worktree.",
        "- Do not treat a community commit or social post as verified hardware fact.",
        "",
    ]
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description="Refresh Microduck GitHub and feed intelligence.")
    parser.add_argument("--config", type=Path, default=Path("configs/intelligence-sources.json"))
    parser.add_argument("--output-root", type=Path, default=Path("intelligence"))
    parser.add_argument("--fail-on-error", action="store_true")
    args = parser.parse_args()

    config = read_json(args.config)
    limits = {
        "commits": int(config.get("limits", {}).get("commits", 8)),
        "releases": int(config.get("limits", {}).get("releases", 3)),
        "pulls": int(config.get("limits", {}).get("pulls", 5)),
        "issues": int(config.get("limits", {}).get("issues", 5)),
        "social_items": int(config.get("limits", {}).get("social_items", 10)),
    }
    token = os.getenv("GITHUB_TOKEN") or os.getenv("GH_TOKEN")
    output_root = args.output_root.resolve()
    latest_path = output_root / "snapshots" / "latest.json"
    previous: dict[str, Any] | None = None
    if latest_path.exists():
        try:
            previous = read_json(latest_path)
        except (OSError, ValueError, json.JSONDecodeError):
            previous = None

    snapshot: dict[str, Any] = {
        "schema_version": 1,
        "generated_at": iso_utc(),
        "github": [],
        "social": [],
        "errors": [],
    }

    for source in config.get("github", []):
        if not source.get("enabled", True):
            continue
        try:
            snapshot["github"].append(collect_repo(source, limits, token))
        except Exception as exc:
            snapshot["errors"].append({"source": source.get("repo", "github"), "error": str(exc)})

    for source in config.get("social_feeds", []):
        try:
            feed = collect_feed(source, limits["social_items"])
            if feed:
                snapshot["social"].append(feed)
        except Exception as exc:
            snapshot["errors"].append({"source": source.get("name", "social"), "error": str(exc)})

    write_json_atomic(latest_path, snapshot)
    generated = now_utc()
    day = generated.strftime("%Y-%m-%d")
    history_path = (
        output_root / "history" / generated.strftime("%Y") / generated.strftime("%m") / f"{day}.json"
    )
    write_json_atomic(history_path, snapshot)

    digest = render_digest(snapshot, previous)
    write_text_atomic(output_root / "digests" / "latest.md", digest)
    write_text_atomic(output_root / "digests" / f"{day}.md", digest)

    print(f"wrote {latest_path}")
    print(f"wrote {history_path}")
    print(f"GitHub sources: {len(snapshot['github'])}")
    print(f"Social feeds: {len(snapshot['social'])}")
    print(f"Errors: {len(snapshot['errors'])}")

    if args.fail_on_error and snapshot["errors"]:
        return 2
    if not snapshot["github"] and not snapshot["social"]:
        return 3
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
