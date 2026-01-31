# Communication Layer: Rebound v0.1

## Goal
Canonical verified communications from sender to receiver.

## Role
Rebound is a workload bundle that provides:
- message hashing
- signature verification
- sealed delivery receipts
- exportable audit proof of communication

## Rules
- messages are data artifacts
- communication events are audited
- any tamper -> explicit deny + report

## Integration
Other workloads can request:
SEND_MESSAGE / RECEIVE_MESSAGE actions.
Policy gate decides.
Rebound executes if allowed.
