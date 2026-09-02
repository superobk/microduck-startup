# Daily history

The collector writes at most one normalized JSON path per UTC date:

```text
YYYY/MM/YYYY-MM-DD.json
```

Later runs on the same day replace that date's snapshot; Git history preserves the earlier revision without creating an unbounded number of files per day.
