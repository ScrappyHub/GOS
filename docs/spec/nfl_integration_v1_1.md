# GOS Runtime — NFL Integration v1.1 (Producer → Witness)

This spec defines the minimal, canonical GOS Runtime producer behavior:
- produce a local pledge (append-only)
- produce a packet (directory bundle)
- duplicate byte-identically to NFL inbox

## 1) Terminology
- CommitHash: SHA-256 of canonical bytes of payload/commit.payload.json
- PacketId: SHA-256 of canonical bytes of manifest.json
- Packet: directory bundle named by PacketId

## 2) Canonical packet layout (MUST)
<PacketRoot>\
  manifest.json
  sha256sums.txt
  payload\
    commit.payload.json
    commit_hash.txt
    nfl.ingest.json
    sig_envelope.json
  signatures\
    ingest.sig

Packet folder name MUST be: <PacketId>

## 3) Hash laws (MUST)
### 3.1 CommitHash
CommitHash = SHA-256( canonical_bytes(payload/commit.payload.json) )

Stored as:
payload/commit_hash.txt = lowercase hex (+ optional trailing newline)

### 3.2 PacketId
PacketId = SHA-256( canonical_bytes(manifest.json) )

Packet folder name MUST equal PacketId.

### 3.3 Local pledge chain hash
Each NDJSON entry includes:
- prev_log_hash
- log_hash

log_hash = SHA-256( canonical_bytes(log_entry_without_log_hash) )

GENESIS is allowed only for the first entry.

## 4) Required payload objects
### 4.1 payload/commit.payload.json (commitment.v1)
Required fields:
- schema: "commitment.v1"
- producer: "gos_runtime"
- producer_instance: stable string
- tenant: string (single-tenant in v1)
- principal: principal string
- event_type: stable string (see section 8)
- event_time_utc: ISO8601 UTC
- prev_links: array (may be empty)
- content_ref: string ("sealed" or content-address ref)
- strength: "evidence" | "deterministic"

Optional:
- meta: small dictionary (no secrets unless content_ref sealed)
- notes_ref: content-address ref

### 4.2 payload/nfl.ingest.json (nfl.ingest.v1)
Required fields:
- schema: "nfl.ingest.v1"
- packet_id
- commit_hash
- producer: "gos_runtime"
- producer_instance
- tenant
- principal
- event_type
- event_time_utc
- prev_links
- payload_mode: "pointer_only" | "inline_sealed" | "inline_plain"
- payload_ref
- producer_key_id
- producer_sig_ref

### 4.3 payload/sig_envelope.json (sig_envelope.v1)
Required fields:
- schema: "sig_envelope.v1"
- algo: "ed25519"
- key_id
- signing_context: "nfl.ingest.v1"
- signs:
  - commit_hash
  - packet_id
  - ingest_hash (recommended)

### 4.4 signatures/ingest.sig
Detached signature over canonical bytes of payload/nfl.ingest.json (or over an explicit signing message defined in signing rules).
Verification uses key_id from sig_envelope.

## 5) Local pledge log (MUST)
Path:
C:\ProgramData\GOSRuntime\pledges\pledges.ndjson

Each line is one canonical JSON object (no whitespace padding, one object per line).

Required fields:
- schema: "local_pledge.v1"
- created_at_utc
- seq
- producer: "gos_runtime"
- producer_instance
- tenant
- principal
- key_id
- commit_hash
- sig_path (relative path to signature inside packet)
- prev_log_hash
- log_hash

## 6) Mandatory producer behaviors (MUST)
GOS Runtime MUST implement these functions (script + library form later):

1) BuildCommitment(event_type, prev_links, content_ref, strength, meta?)
Outputs:
- payload/commit.payload.json
- payload/commit_hash.txt

2) BuildPacket()
Outputs:
- payload/nfl.ingest.json
- payload/sig_envelope.json
- signatures/ingest.sig
- manifest.json
- sha256sums.txt
- packet directory named <PacketId> under outbox

3) PledgeLocal()
Appends to pledges.ndjson with chained hashes.

4) DuplicateToNFL()
Copies packet byte-identically to:
C:\ProgramData\NFL\inbox\<PacketId>\...

Offline rule:
If NFL not reachable, packet stays in outbox and a failure pledge MUST be recorded.

## 7) Verification routines (MUST ship)
GOS Runtime MUST ship:
- verify_packet (packet integrity + hashes + signature)
- verify_local_pledges (pledge chain integrity)

verify_packet MUST fail-fast on:
- sha256sums mismatch
- manifest mismatch / missing files
- CommitHash mismatch (recompute)
- signature verification failure

## 8) Event types (GOS Runtime v1: small boring set)
GOS Runtime MUST keep the event type set small and stable.

Initial set:
- gos.runtime.snapshot.created.v1
- gos.runtime.snapshot.verified.v1
- gos.runtime.snapshot.failed.v1

Any addition requires:
- updating contracts/event_types.v1.json
- updating test vectors
- updating acceptance proof script
