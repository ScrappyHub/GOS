# Restore Model v0.1

## Goal
Return the device to known-good baseline.

Restore is not a feature; it's a safety mechanism.

## Types
Soft Restore:
- reset workload state
- reapply canonical policy + overlay
- re-verify bundles

Hard Restore:
- reimage from signed baseline
- requires firmware trust attestation

## Triggers
Restore can be triggered by:
- admin decision
- policy obligation
- compliance failure

## Interaction with Legacy Doctor
Legacy Doctor is the hardware verifier/repair workload.
It can:
- diagnose disks, mounts, device health
- produce sealed reports
- request restore actions via policy gate

But it cannot perform privileged restore unless granted capability and allowed.
