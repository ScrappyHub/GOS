# Overlay Install Flow v0.1

## Goal
Admin can install overlay policy bundles that restrict behavior further.

## Flow
1) Receive overlay bundle (gosaf bundle_type="overlay")
2) Verify signature against admin_overlay scope keys
3) Verify bundle not revoked
4) Dry-run merge:
   effective = canonical INTERSECT overlay
   If widening detected => fail
5) Install overlay into policy store
6) Emit audit event + sealable receipt

## Removal
Removal is also governed:
- requires admin lane
- produces audit record

## Invariants
Overlay cannot:
- change canonical rules
- introduce new allow
- suppress audit obligations
