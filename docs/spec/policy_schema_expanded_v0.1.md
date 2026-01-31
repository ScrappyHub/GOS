# Policy Schema Expanded v0.1

## Files
- canonical_policy.json  (ships with GOS)
- overlay_policy.json    (optional; admin-installed; can only restrict)

## Canonical Policy JSON (schema="gospolicy/1")
Top-level:
- schema: "gospolicy/1"
- created_utc: null
- policy_id
- version
- lanes: { adult, child, admin, service }
- rules: list of rule objects
- defaults:
  - decision: "DENY"
  - reason_code: "DENY_UNKNOWN_ACTION"
  - obligations: ["OBL_AUDIT_LOG"]

Rule object:
- id
- match:
  - lane
  - action
  - target (optional)
  - conditions (optional): time_window, network_state, user_presence, attestation_required
- decision: "ALLOW"|"DENY"
- reason_code
- obligations: []

## Overlay policy constraints
Overlay is schema="gospolicy_overlay/1" and must declare:
- base_policy_id (must match canonical policy_id)
- base_version_min (optional)
- base_version_max (optional)

Overlay merge rule:
effective = INTERSECTION
- Overlay may add DENY rules
- Overlay may tighten conditions
- Overlay may add obligations
Overlay may NOT:
- introduce an ALLOW where canonical would DENY
- remove obligations required by canonical
- broaden lanes/actions/targets
