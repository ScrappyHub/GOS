# Capabilities Registry v0.1

## Purpose
Capabilities are the ONLY way workloads access system powers.

Default: none.

## Capability List
AUDIT_APPEND
EXPORT_BUNDLE
IMPORT_BUNDLE
NET_CONNECT
FS_READ_SCOPED
FS_WRITE_SCOPED
DEVICE_CONTROL_LIMITED
DEVICE_CONTROL_PRIVILEGED
RESTORE_TRIGGER
UPDATE_REQUEST
PACKAGE_QUERY
ATTESTATION_READ
LANE_READ
LANE_SWITCH_REQUEST

## Enforcement
A request must pass:
1) policy gate allows
2) workload has capability
3) sandbox allows
4) audit is written
Otherwise deny.

## Note
Capabilities are not "permissions" like consumer OS.
They are contractual powers, tied to audit and sealing.
