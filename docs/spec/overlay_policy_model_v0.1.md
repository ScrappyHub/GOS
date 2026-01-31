# Overlay Policy Model v0.1 (More Walls)

## Goal
Admins can add overlay policy that:
- never alters canonical policy
- only adds restrictions (additional walls)
- is auditable and removable

## Merge Rule
effective_policy = canonical_policy INTERSECT overlay_policy

Overlay MUST NOT:
- add new allow paths
- weaken deny paths
- change reason codes of canonical denies

## Conflict Handling
If overlay conflicts with canonical allow:
- DENY_OVERLAY_RESTRICTED

## Overlay Signing
Overlay bundles must be:
- signed by an authorized admin key
- revocable
- audited on install/remove

## Use Cases
- stricter child rules per household
- stricter network allowlist per facility
- stricter export controls for regulated environments
