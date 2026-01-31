# GOS Audit and Sealing v0.1

## Purpose
Every action must be provable after the fact.

If something happens and cannot be audited,
it is considered untrusted.

---

## What is logged

Every policy gate decision:
- request envelope
- decision envelope
- hashes
- policy ids
- obligations

Every workload:
- start
- stop
- update
- restore
- export

---

## Sealing Rules

Audit logs are:

- append only
- hashed
- chunked
- sealed as GOS-AF bundles

Each seal contains:
- sha256 tree
- signature
- metadata

---

## Properties

Seals must be:

- tamper evident
- exportable
- reproducible
- verifiable offline

---

## Restore Interaction

After restore:
- logs remain valid
- new logs start new seal chain

---

## Philosophy

Logs are evidence, not diagnostics.

Design for courts, not consoles.
