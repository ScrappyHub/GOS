# GOS Capabilities v0.1 (Canonical Vocabulary)

## Purpose
Capabilities are the **walls**. A plugin is only allowed to operate within the
capabilities granted by the policy gate.

GOS MUST deny any action that does not map to an explicit capability grant.

## Capability Model
A capability is:
- `name` (string)
- `params` (object with typed fields)
- `scope` (what it applies to)
- `obligations` (audit, rate limit, vpn-required, etc.)

Capabilities are granted per:
- lane (adult/child/admin)
- plugin_id
- policy code
- device attestation state

## Core Capabilities (v0.1)

### AUDIT_APPEND
Allows plugin to emit audit events (always brokered by GOS).
Params:
- `channel`: `default|security|compliance|operations`
Obligations:
- `seal_event` (always)

### EXPORT_BUNDLE
Allows plugin to export a GOS-AF bundle (logs, scans, reports).
Params:
- `bundle_type`: `audit|scan|attestation|snapshot|custom`
- `max_mb`: integer
Obligations:
- `seal_bundle`
- `include_manifest`

### FILE_READ
Read files from allowed scopes only.
Params:
- `scope`: `app_private|removable_media|shared_docs|cache`
- `path_allowlist`: array of path prefixes (optional)
Obligations:
- `audit_paths`

### FILE_WRITE
Write files to allowed scopes only.
Params:
- `scope`: `app_private|removable_media|shared_docs|cache`
- `path_allowlist`: array (optional)
Obligations:
- `audit_paths`

### NET_CONNECT
Network egress (default deny).
Params:
- `allowlist`: array of hostnames/IP CIDRs
- `ports`: array of ints
- `tls_required`: bool (default true)
Obligations:
- `audit_destinations`
- `rate_limit` (optional)

### LAUNCH_APP
Launch other packages/components (Android runtime).
Params:
- `package_allowlist`: array
- `component_allowlist`: array (optional)
Obligations:
- `audit_launch`

### INSTALL_PACKAGE
Install/update a package from canonical source only.
Params:
- `channel`: `stable|beta|pinned`
- `source`: `local_bundle|registry`
Obligations:
- `verify_signature`
- `verify_hash`
- `audit_install`

### SETTINGS_CHANGE
Modify system settings (high risk).
Params:
- `setting_allowlist`: array of keys
Obligations:
- `audit_changes`
- `require_admin_lane` (typical)

### SCAN_MEDIA
Scan removable media / file sets (Clarity-like).
Params:
- `scan_mode`: `hash_only|hash+metadata|full_index`
- `max_files`: integer
Obligations:
- `audit_scan`
- `export_required` (optional)

### UPDATE_APPLY (Reserved)
Reserved for updater class plugins (Atlas).
Params:
- `target`: `os|plugin|firmware` (firmware only if attestation allows later)
- `channel`: `stable|pinned`
Obligations:
- `verify_signature`
- `verify_hash`
- `rollback_plan_required`
- `audit_update`

### RESTORE_TRIGGER (Reserved)
Trigger restore to baseline (dangerous).
Params:
- `mode`: `soft|hard` (hard requires platform support)
Obligations:
- `require_admin_lane`
- `audit_restore`
- `seal_restore_report`

### ATTESTATION_READ
Read the current attestation report objects (no raw privileged access).
Params:
- `sources`: `clarity|platform|gos`
Obligations:
- `audit_reads`

## Default Deny Rules
- Unknown capability name → DENY
- Missing params or invalid types → DENY
- Capability not granted for lane/plugin/policy_code → DENY

## Capability Minimization
Plugins MUST request the smallest set required.
Overlay policy may further restrict (intersection only).

# ======================================================================
