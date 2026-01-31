# GOS Sandboxing Model v0.1

## Purpose
Defines the enforcement boundary for every workload.

GOS is small and boring.
Security is enforced through walls, not trust.

---

## Isolation Rules

Each workload runs inside:

- separate UID
- separate filesystem namespace
- restricted syscalls
- capability-only API surface
- no ambient authority

No shared memory between workloads unless explicitly granted.

---

## Access Model

Everything is:

explicit allow OR deny

Never implicit.

Examples:

- filesystem: deny all → allow scoped paths
- network: deny all → allow specific hosts/ports
- devices: deny all → allow specific capability

---

## Enforcement Stack

Host enforcement layers:

1) policy gate decision
2) capability check
3) sandbox enforcement
4) audit log
5) optional restore/rollback

If any layer denies → deny.

---

## Determinism Rule

Sandbox must not introduce nondeterministic behavior.

Examples:
- no hidden environment reads
- no unpredictable host state
- no silent privilege escalations

---

## Design Principle

Sandbox first.
Policy second.
Trust last.
