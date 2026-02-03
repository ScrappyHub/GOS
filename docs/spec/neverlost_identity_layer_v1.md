# NeverLost v1 — Identity Layer (GOS Runtime)

NeverLost is the canonical identity + trust boundary for GOS Runtime.

## Scope (GOS Runtime only)
NeverLost in this repo exists to:
- materialize `allowed_signers` deterministically from `trust_bundle.json`
- sign/verify files with `ssh-keygen -Y`
- enforce namespace/context on every verification
- emit append-only deterministic receipts to `proofs/receipts/neverlost.ndjson`

NeverLost does NOT:
- manage device inventory
- do remote auth
- merge trust bundles across products
- become an umbrella

## Required repo paths (v1)
- proofs/trust/trust_bundle.json  (source of truth)
- proofs/trust/allowed_signers    (derived)
- proofs/receipts/neverlost.ndjson (append-only receipts)
- scripts/* (canonical entrypoints)

## Principal + KeyId (GOS Runtime defaults)
Principal format is locked:
`single-tenant/<tenant_authority>/authority/<producer>`

For this repo:
- principal: `single-tenant/gos_runtime_authority/authority/gos_runtime`
- key_id: `gos-runtime-authority-ed25519`

## Namespace law (non-negotiable)
Every sign/verify MUST include a namespace string.
Verification MUST fail if:
- crypto verifies but namespace is not allowed for the signing principal.

## Allowed namespaces (GOS Runtime v1)
Minimal set (small + boring):
- `gos/packet`       (packet signing / envelope)
- `gos/snapshot`     (snapshot artifacts)
- `nfl/ingest`       (nfl ingest envelope signing)

## Receipts (mandatory)
Every NeverLost action appends one NDJSON line:
- show_identity
- make_allowed_signers
- verify_sig
- sign (if used)

Receipts are:
- UTF-8 (no BOM)
- one JSON object per line
- deterministic canonical JSON serialization
- append-only forever
