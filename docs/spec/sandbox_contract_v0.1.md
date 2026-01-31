# Sandbox Contract v0.1

## Goal
A workload cannot exceed the box it is placed in.

## Sandbox Dimensions (v0.1)
- filesystem scope: read-only vs read-write, scoped roots only
- network: off by default, allowlist only
- device access: none by default
- process isolation: workload may not spawn arbitrary children unless allowed
- IPC: none unless explicitly granted

## Enforcement Rule
A request must pass:
Policy Gate AND Capability Gate AND Sandbox Gate

If sandbox cannot enforce something reliably:
DENY.

## Logs
Sandbox produces:
- deny events
- violation events
- all are audited + sealable
