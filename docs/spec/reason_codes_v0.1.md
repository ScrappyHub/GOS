# GOS Reason Codes v0.1 (Canonical)

## Purpose
Stable, machine-parseable reason codes for every ALLOW/DENY.
Reason codes MUST be deterministic and MUST NOT leak secrets.

Format:
- allow.<category>.<detail>
- deny.<category>.<detail>

## Allow Codes (v0.1)
- allow.canonical.ok
- allow.overlay.ok
- allow.capability.granted
- allow.lane.permitted

## Deny Codes (v0.1)
### Request / schema failures
- deny.malformed_request
- deny.missing_required_field
- deny.invalid_field_value

### Capability / action failures
- deny.unknown_action
- deny.unknown_capability
- deny.capability_not_granted
- deny.capability_params_out_of_bounds

### Trust / attestation failures
- deny.insufficient_trust
- deny.attestation_failed
- deny.firmware_untrusted
- deny.device_state_untrusted

### Overlay tightening
- deny.overlay_restriction
- deny.overlay_time_window
- deny.overlay_allowlist

### Safety / policy
- deny.default_deny
- deny.non_canonical_artifact
- deny.signature_invalid
- deny.hash_mismatch
- deny.revoked_publisher
- deny.revoked_plugin

### System failures
- deny.gate_error
- deny.audit_unavailable
- deny.seal_failed

## Requirement
Every DENY must pick exactly one primary reason_code.
Additional detail can be added as obligations or audit evidence references.
