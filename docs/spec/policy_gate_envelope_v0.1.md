# GOS Policy Gate Envelope v0.1 (Canonical)

## Purpose
A single deterministic envelope for ALL governed actions in GOS:
- host actions (restore, install, settings)
- plugin actions (scan, export, update apply)
- workload actions (exec, net connect, launch)

Everything becomes:
REQUEST → DECISION → OBLIGATIONS → AUDIT

Default deny if evaluation is incomplete or non-provable.

## Determinism Laws
- No embedded timestamps in the request (time must be passed as an explicit input field).
- Stable field ordering in canonical JSON serializer (pack already implements deterministic JSON).
- Decision MUST be reproducible given the same request + same policy bundles + same trust state.

## Request Schema
schema: "gos-gate/0.1"

Required fields:
- schema: "gos-gate/0.1"
- request_id: string (caller-generated UUID or deterministic id)
- device_id: string
- lane: "adult"|"child"|"admin"
- principal:
  - kind: "user"|"service"|"system"
  - id: string
  - proof: object|null (optional; e.g. presence/biometric proof, later)
- subject:
  - kind: "host"|"plugin"|"workload"
  - id: string (e.g. "gos", plugin_id, workload_id)
  - version: string|null
  - key_id: string|null
- action:
  - name: string (canonical action verb, see Action Vocabulary)
  - capability: string (capability name; must map 1:1 for enforcement)
  - policy_code: string (plugin_id:category:verb:detail or host equivalent)
  - target: object (capability-specific target)
- context:
  - time_utc: string (RFC3339/ISO8601) OR null if unknown
  - network:
    - state: "offline"|"online"|"unknown"
    - vpn: "on"|"off"|"unknown"
    - dest: object|null (hostname/ip/port when relevant)
  - presence: "present"|"absent"|"unknown"
  - risk:
    - score: number|null
    - signals: array (strings) (optional)
  - attestations:
    - clarity_state: "pass"|"fail"|"unknown"
    - firmware_state: "pass"|"fail"|"unknown"
    - gos_state: "pass"|"fail"|"unknown"
- inputs:
  - params: object (capability params; MUST be fully explicit)
  - hashes: object|null (sha256, etc. when relevant)
  - metadata: object|null (optional; must not influence decision unless policy reads it)

Forbidden:
- Any implicit environment reads not represented in context/inputs.
- Any nondeterministic field not captured as an explicit input.

## Action Vocabulary (v0.1)
Canonical actions MUST include:
- EXEC
- LAUNCH_APP
- INSTALL_PACKAGE
- NET_CONNECT
- SETTINGS_CHANGE
- FILE_READ
- FILE_WRITE
- EXPORT_BUNDLE
- SCAN_MEDIA
- UPDATE_APPLY (reserved)
- RESTORE_TRIGGER (reserved)
- ATTESTATION_READ

Mapping rule:
action.capability MUST be the controlling capability for enforcement.

## Decision Schema
schema: "gos-gate-decision/0.1"

Required fields:
- schema: "gos-gate-decision/0.1"
- request_id: string (echo)
- decision: "ALLOW"|"DENY"
- reason_code: string (see reason_codes_v0.1.md)
- obligations: array of obligation objects (possibly empty)
- audit:
  - audit_id: string (stable id created by audit system)
  - seal_required: boolean (true for all gate decisions)
  - evidence_refs: array of strings (paths/ids to evidence objects; optional)
- policy:
  - canonical_policy_id: string
  - overlay_policy_ids: array of strings
  - evaluation_hash: string (sha256 over canonical+overlay policy bundle ids + request canonical json)

Obligation object:
- name: string (canonical obligation)
- params: object (deterministic)
- enforce: "pre"|"post"|"continuous"

## Overlay Semantics (Monotonic Tightening)
Effective decision E(req):
- If canonical denies → deny.
- If canonical allows and any overlay denies → deny.
- If canonical allows and all overlays allow → allow.
Obligations = union(canonical, overlays)

The decision MUST record which overlay ids participated.

## Audit Requirements
Each decision emits a sealed audit event containing:
- request canonical JSON (deterministic)
- decision canonical JSON (deterministic)
- evaluation_hash
- selected policy bundles digests

## Failure Rules
- Missing required field → DENY with reason_code=deny.malformed_request
- Unknown capability/action → DENY with reason_code=deny.unknown_capability
- Non-provable evaluation (unknown trust state required) → DENY with reason_code=deny.insufficient_trust
- Policy engine error → DENY with reason_code=deny.gate_error
