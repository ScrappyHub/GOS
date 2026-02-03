# NeverLost Receipts v1 (GOS Runtime)

Receipts live at:
- proofs/receipts/neverlost.ndjson

## Required properties
- append-only
- UTF-8 no BOM
- one canonical JSON object per line
- includes:
  - action
  - ok/fail
  - hashes of relevant files
  - trust_bundle_sha256 used
  - allowed_signers_sha256 used (when relevant)
  - namespace (for sign/verify actions)
