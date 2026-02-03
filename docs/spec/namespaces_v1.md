# Namespaces v1 (GOS Runtime)

Namespaces are the signing/verification contexts. A signature is invalid if:
- it verifies cryptographically BUT
- its namespace is not allowed for that principal per trust_bundle.json

## v1 namespaces (locked)
- gos/packet
- gos/snapshot
- nfl/ingest

## Rules
- Namespaces are ASCII strings
- Stable and versioned only by policy evolution (not per-event)
- Adding a namespace requires:
  - updating trust_bundle.json
  - regenerating allowed_signers
  - committing test vectors (later)
