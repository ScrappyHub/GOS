# GOS Workload Bundle Contract v0.1 (Canonical)

## Purpose
Defines the contract ALL runtime software must follow inside GOS.

Every executable thing is a workload bundle:
- CORE
- Covenant Gate
- Rooted
- Atlas
- Legacy Doctor
- Rebound
- Clarity runtime
- future engines

There are NO exceptions.

If it is not a signed bundle, it does not run.

---

## First Principles

Workloads are:

- signed
- hashed
- sandboxed
- capability-scoped
- audited
- revocable
- replaceable

Default deny always applies.

---

## Bundle Structure (GOS-AF payload)

payload/
  plugin.json
  bin/ or app/
  policy/ (optional)
  docs/ (optional)

manifest.json
sha256sums.txt
signature.ed25519

---

## plugin.json (required)

Fields:

- plugin_id (stable unique id, reverse DNS style)
- name
- version
- type: workload|provider|policy|preos
- entrypoints
- requested_capabilities
- required_attestations
- publisher_key_id

Example:

{
  "plugin_id": "gos.rebound.runtime",
  "name": "Rebound",
  "version": "0.1.0",
  "type": "workload",
  "entrypoints": ["main"],
  "requested_capabilities": [
    "NET_CONNECT",
    "EXPORT_BUNDLE",
    "AUDIT_APPEND"
  ],
  "required_attestations": {
    "firmware": "pass",
    "gos": "pass"
  },
  "publisher_key_id": "rebound-key-01"
}

---

## Runtime Guarantees

If installed:

GOS guarantees:
- verified integrity
- sandbox enforcement
- capability gating
- audit sealing
- deterministic execution boundaries

Workload guarantees:
- never escape sandbox
- only use granted capabilities
- emit auditable state transitions

---

## Prohibited

Workloads MUST NOT:
- read arbitrary filesystem
- open arbitrary network connections
- load unsigned code
- self-update
- bypass policy gate
- modify other workloads

All such behavior is denied by design.

---

## Philosophy

Workloads are instruments, not administrators.

They ask permission.
They do not assume power.
