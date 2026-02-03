# Packet Constitution v1 (GOS Runtime)

All cross-boundary communication uses directory packets.

No APIs.
No RPC.
No sockets required.

## Canonical layout

<packet_id>/
  manifest.json
  sha256sums.txt
  payload/
  signatures/

## Transport
outbox/ → copy → inbox/

## Verification
- hashes
- signatures
- trust bundle
- namespace

If any step fails:
→ quarantine
