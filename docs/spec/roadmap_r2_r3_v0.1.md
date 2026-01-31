# Roadmap R2–R3 v0.1

## R2 (Alive Runtime MVP)
- policy gate library (evaluate canonical + overlay)
- capability gate (requested vs granted)
- sandbox gate contract (stub + deny-by-default enforcement)
- workload harness:
  - load plugin.json
  - request START/STOP through policy gate
  - record audit events
- trust store + signature verify hook (Ed25519)
- minimal sealed audit export

Acceptance:
- You can run a dummy workload entrypoint under governance.
- Every action emits audit.
- Overlay can restrict but never widen.
- Unknown user => deny.

## R3 (Canonical installs)
- signed workload bundles (GOS-AF signed)
- local registry bundle listing approved plugin_ids + versions + hashes
- revocation bundle consumption
- install/update/remove flows all governed + audited

Acceptance:
- tampered bundle rejected
- revoked key rejects all bundles
