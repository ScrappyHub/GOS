# ADR 0003 — Overlay policy is intersection-only

## Status
Accepted

## Decision
Overlay policy can only restrict.

effective_policy = canonical_policy INTERSECT overlay_policy

## Why
This guarantees canonical invariants cannot be weakened by admins.
Admins can add walls, not remove them.

## Consequence
Some environments will deny more than canonical.
This is intended.
