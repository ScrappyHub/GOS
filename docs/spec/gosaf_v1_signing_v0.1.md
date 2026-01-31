# GOS-AF v1 Signing v0.1

## Goal
GOS-AF bundles become authentic, tamper-evident, and revocable.

## Bundle Layout (v1)
- manifest.json
- sha256sums.txt
- signature.ed25519
- payload/

## Signing Material
signature.ed25519 is Ed25519 signature over the following bytes (exact):
1) UTF-8 bytes of manifest.json (LF newlines)
2) then LF ("\n")
3) UTF-8 bytes of sha256sums.txt (LF newlines)

Concatenation order is fixed and deterministic.

## Required manifest fields
manifest.json must include:
- schema: "gosaf/1"
- created_utc: null
- payload_root: "payload"
- file_count: integer
- bundle_id: stable string (recommended: sha256 of signing material)
- publisher_key_id: string (key identifier)
- bundle_type: "policy"|"overlay"|"workload"|"registry"|"audit"|"snapshot"
- revocation: { supports: true, scope: "key|bundle|both" }

## Key Identifier
publisher_key_id is an opaque string that maps to a pinned pubkey in trust store.
Example:
- "gos.release.2026.q1"
- "admin.overlay.household.alec"
- "workload.publisher.core"

## Verification
Verify must:
- validate sha256sums.txt matches payload hashes
- validate manifest references payload exactly
- validate signature against trust store for publisher_key_id
- validate not revoked (revocation bundle)
- emit verify_report.json/txt

If any step cannot be proven => DENY.
