# Capabilities v0.1

## Goal
Capabilities are explicit, enumerable permissions that workloads request.
Default is NONE.

## Capability list (initial)
CAP_NET_BASIC
CAP_NET_ALLOWLIST_ONLY
CAP_FS_READ_PAYLOAD
CAP_FS_WRITE_WORKDIR
CAP_FS_EXPORT
CAP_DEVICE_USB
CAP_DEVICE_MEDIA
CAP_INSTALL_PACKAGES
CAP_UPDATE_PACKAGES
CAP_RESTORE_BASELINE
CAP_AUDIT_EXPORT
CAP_AUDIT_SEAL
CAP_OVERLAY_INSTALL
CAP_OVERLAY_REMOVE

## Granting
Capabilities are granted only by canonical policy, and may be further restricted by overlay.

## Enforcement
A request that implies a capability must be denied if capability is not granted:
DENY_CAPABILITY_NOT_GRANTED
