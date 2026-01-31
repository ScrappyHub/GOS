# Audit + Seal Contract v0.1

## Goal
Every meaningful action is recorded and can be sealed/exported deterministically.

## Audit events
Each event:
- event_id (stable)
- request_id (from caller)
- timestamp_utc: null (time captured elsewhere; for determinism keep null in canonical artifacts)
- actor:
  - subject_id (or "unknown")
  - lane
- action
- target
- decision (ALLOW|DENY)
- reason_code
- obligations
- bundle_refs (optional)

## Local store
Runtime can append events to a local log file/database.
Export must be a GOS-AF "audit" bundle.

## Seal
Seal operation:
- takes an export bundle
- verifies internal integrity
- signs it
- produces signature + report

## Rule
If audit cannot be written:
DENY the action (fail closed).
