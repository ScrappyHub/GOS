# Revocation Model v0.1

## Goal
Everything must be replaceable and removable without destroying the OS.

## Revocable Objects
- keys
- bundles
- policies
- overlays
- attestations (by expiry)

## Revocation Bundle
A signed bundle containing:
- revoked_key_ids
- revoked_bundle_ids (optional)
- effective_time_utc
- reason

## Evaluation
Policy gate includes revocation in every decision:
- if revoked -> DENY

## Audit
Every revocation update is sealed and exportable.
