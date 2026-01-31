# GOS Attestation Model v0.1

## Purpose
Defines how trust flows from firmware → OS → workloads.

GOS does not assume trust.
It consumes proofs.

---

## Trust Chain

Clarity → Firmware → GOS → Policy → Workloads → Data

---

## Attestation Artifacts

Attestations are sealed bundles.

Example:
clarity_attestation.gosaf

Contains:
- firmware measurements
- secure boot state
- validator report
- signature

---

## States

Each layer reports:

- pass
- fail
- unknown

Unknown MUST be treated as fail for privileged actions.

---

## Workload Requirements

Workloads may declare:

required_attestations

Example:

{
  "firmware": "pass",
  "gos": "pass"
}

If unmet → deny execution.

---

## Philosophy

GOS does not verify hardware directly.

It verifies:
- signed attestation
- hash
- signature chain

Attestations are data, not code.

This keeps GOS small and portable.
