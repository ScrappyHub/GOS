# R2 Acceptance — GOS Runtime NFL Producer v1.1

R2 is complete when GOS Runtime can produce a commitment, pack it into a canonical packet, pledge locally, and duplicate to NFL.

## 1) Required files exist
Repo MUST include:
- LAW.md
- docs/spec/nfl_integration_v1_1.md
- docs/spec/r2_acceptance_nfl_v1_1.md
- contracts/event_types.v1.json
- schemas/* (v1 IDs)
- scripts/* (producer + verify routines)
- tests/vectors/sample_packet/*

## 2) Required runtime paths
Producer:
- C:\ProgramData\GOSRuntime\pledges\pledges.ndjson
- C:\ProgramData\GOSRuntime\outbox\<PacketId>\...

NFL:
- C:\ProgramData\NFL\inbox\<PacketId>\...

## 3) Proof script (MUST)
A proof script MUST exist and succeed:
- ops/pipelines/r2_prove_nfl.ps1

Proof script MUST:
1) Create a sample commitment:
   event_type = gos.runtime.snapshot.created.v1
2) Build packet under outbox/<PacketId>
3) Append pledge line to pledges.ndjson
4) Duplicate packet to NFL inbox
5) Run verify_packet on:
   - outbox packet
   - NFL inbox packet
6) Run verify_local_pledges

Expected result:
- verify_packet passes both locations
- pledge log chain verifies
- Packet directory in outbox and NFL inbox is byte-identical

## 4) Negative tests (MUST)
Proof script MUST also demonstrate at least one fail-fast:
- tamper a payload file and ensure verify_packet fails
OR
- remove a file and ensure manifest/sha256sums verification fails

## 5) Default deny
If duplication to NFL fails, it MUST NOT be silent:
- A failure pledge event MUST be written
- Packet remains in outbox
- Later retry is allowed, but missing pledge is not allowed
