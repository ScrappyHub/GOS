# Canonicalization Rules v1.1

## JSON
- UTF-8 no BOM
- keys sorted ascending
- minimal whitespace
- LF newlines only
- arrays preserve order

## NDJSON
- one object per line
- canonical JSON per line
- append-only

## Hashing
SHA-256 lowercase hex

## Prohibited
ConvertTo-Json default output
timestamps inside canonical artifacts
machine-local paths
random ordering
