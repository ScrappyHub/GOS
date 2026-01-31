# ADR 0004 — GOS stays small and boring

## Status
Accepted

## Decision
Anything that is not:
- verification
- policy
- sandbox
- audit/seal
- restore
- revocation

...must be a workload bundle.

## Why
Small host surface = auditable, portable, defendable.
Workloads can evolve without destabilizing the OS.
