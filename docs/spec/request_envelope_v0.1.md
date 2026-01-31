# Request Envelope v0.1

## schema
"gos_request/1"

## Fields
- request_id: stable string (caller-provided; required)
- device_id: required
- subject:
  - subject_id: string or "unknown"
  - lane: adult|child|admin|service
- action: string (must be in system_actions list)
- target:
  - type: "package"|"file"|"url"|"capability"|"device"|"bundle"|"plugin"
  - value: string
- context:
  - user_presence: true|false|unknown
  - network: "offline"|"online"|"unknown"
  - risk_score: integer (optional)
- attestations:
  - clarity_bundle_id: string (optional)
- bundle_refs:
  - workload_bundle_id: string (optional)
  - registry_bundle_id: string (optional)

## Output schema
"gos_decision/1"
- decision: ALLOW|DENY
- reason_code
- obligations: []
- audit_id
