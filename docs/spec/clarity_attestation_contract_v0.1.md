# Clarity Attestation Contract v0.1

## Purpose
Clarity produces a signed statement that:
- firmware is verified (or not)
- boot chain is consistent (or not)
- GOS image is verified (or not)

GOS consumes this attestation as an input fact.
If missing or invalid => treat as unknown => deny where required.

## Artifact
Clarity emits a GOS-AF bundle:
bundle_type: "attestation"

payload includes:
- attestation.json
- evidence/ (optional)

## attestation.json
- schema: "clarity_attestation/1"
- created_utc: null
- device_id
- firmware:
  - verified: true|false
  - measurement_sha256 (optional)
- gos_image:
  - verified: true|false
  - image_sha256 (optional)
- secure_boot:
  - enabled: true|false|unknown
- notes (optional)
- verdict: "pass"|"fail"

## Consumption
GOS Policy Gate uses:
- firmware.verified
- gos_image.verified
- secure_boot.enabled

Unknown => deny if action requires attestation.
