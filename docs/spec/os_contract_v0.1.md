# GOS OS Contract v0.1 

## Purpose
GOS is a governed execution substrate.
It is not a feature OS. It is not a store. It is not a cloud.

## GOS Responsibilities (ONLY)
- boot trust consumption (Clarity attestation)
- package verification (hash + signature)
- policy gate (ALLOW/DENY, reason codes, obligations)
- capability enforcement
- sandboxing / isolation
- audit logging + sealing
- restore to baseline
- revocation & replacement

If it doesn't fit here, it is a workload bundle.

## Canonical Rule
If an action cannot be evaluated deterministically:
DENY.

## Default Deny
All actions are denied unless explicitly allowed via:
- canonical policy
- optional overlay policy (more walls only)

## Workloads
Everything non-host is a workload bundle:
CORE / Covenant Gate / Rooted / Atlas / Legacy Doctor / Rebound / future engines.
All identical class citizens.

## Determinism
- deterministic manifests (no embedded timestamps)
- deterministic decision outputs (stable reason codes)
- deterministic audit sealing
