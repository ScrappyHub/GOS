# Trust Store Format v0.1

## File
`trust_store.json` (pinned keys, boring, small)

## Fields
- schema: "truststore/1"
- keys: list of:
  - key_id
  - algorithm: "ed25519"
  - public_key_b64
  - scope: "gos"|"admin_overlay"|"workload"|"attestation"
  - not_before_utc (optional)
  - not_after_utc (optional)
- revoked:
  - key_ids: []
  - bundle_ids: []
  - updated_utc: null (must be null for determinism; time lives in signed revocation bundle)

## Rule
- Trust store updates must themselves be a signed bundle (bundle_type="registry" or "policy")
- Trust store is part of the GOS host baseline and is auditable.
