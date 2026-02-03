# GOS Runtime — LAW (Immutable)

This document is immutable for v1.x. Any change requires a new versioned LAW (LAW.v2.md) and updated test vectors.

## 1) Scope (GOS Runtime only)
GOS Runtime is a producer of canonical commitments about GOS runtime actions (e.g., snapshots, verifications, policy outcomes).

GOS Runtime does NOT become an umbrella for other projects.
GOS Runtime does NOT compute other systems' truth.
GOS Runtime only produces its own events and witnesses them to NFL.

## 2) Non-negotiable rules
### 2.1 Producer-only truth
GOS Runtime MUST maintain a local append-only pledge log.
Local truth is authoritative for GOS Runtime events.

### 2.2 Mandatory NFL duplication
For every local pledge event, GOS Runtime MUST also create an NFL packet and duplicate it to NFL inbox.

No silent divergence is allowed.

If NFL is unavailable:
- GOS Runtime MUST keep the packet in outbox
- GOS Runtime MUST record a failure pledge event (readable/replayable) describing the duplication failure
- GOS Runtime MUST retry later until success

### 2.3 Hash-first integration
GOS Runtime never calls other projects directly.
All external integration is by:
- CommitHash
- PacketId
- NFL receipts (later)

### 2.4 Canonicalization is law
All canonical JSON and NDJSON MUST be produced with canonical bytes rules:
- UTF-8 without BOM
- Object keys sorted (ordinal)
- No insignificant whitespace
- Numbers minimally serialized
- Newlines are LF (`\n`) only
- Arrays preserve order
- Strings preserved exactly (JSON escaped only)

GOS Runtime MUST NOT use ConvertTo-Json for canonical outputs.

### 2.5 Readable + replayable is mandatory
Every pledge event MUST be readable and replayable by deterministic verification:
- recompute CommitHash from commit.payload.json
- verify signature over the signing context
- verify sha256sums + manifest coverage
- verify pledge chain integrity

No "interpretive truth" is allowed.

## 3) Versioning
All schemas and contracts are versioned.
Any schema change increments version:
- v1_1 → v1_2 → v2_0 ...

Test vectors MUST be updated for any change.

## 4) Required runtime paths (Windows v1)
Producer (GOS Runtime):
- C:\ProgramData\GOSRuntime\pledges\pledges.ndjson
- C:\ProgramData\GOSRuntime\outbox\<PacketId>\...

NFL (witness):
- C:\ProgramData\NFL\inbox\<PacketId>\...

Zip is not required in v1. Canonical form is directory packets.
