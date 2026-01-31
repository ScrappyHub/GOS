# GOS Plugin Model v0.1 (Canonical)

## Purpose
Define a **boring, enforceable** plugin contract so GOS stays small, deterministic,
and governed while workloads evolve independently.

A plugin is **not** “an app.”
A plugin is a **bundle with declared intent**, explicit capabilities, and
policy-governed execution.

## Definitions
- **GOS**: Host OS providing verification, sandboxing, policy gate, audit/seal, restore.
- **Plugin Bundle**: A signed+hashed GOS-AF bundle containing a plugin payload.
- **Plugin**: A bundle whose payload includes `plugin.json` that registers a unit of execution.
- **Capability**: A named, parameterized permission granted by the policy gate.
- **Policy Gate**: Deterministic ALLOW/DENY engine with reason codes + obligations.
- **Canonical Policy**: The baseline policy shipped with GOS (non-negotiable).
- **Overlay Policy**: Admin-provided policy that can only *tighten* constraints.

## Plugin Types (Canonical)
1. **workload**: Runs app/service processes inside a sandbox.
2. **provider**: Exposes a narrow OS API (scanner/updater/verifier) via brokered calls.
3. **policy**: Data/rules only (no code) that augments policy decisions (tightening only).
4. **preos**: Runs before GOS (attestation/validator stage) and emits signed reports.

## Plugin Identity
Each plugin MUST have:
- `plugin_id` (reverse-DNS, stable): e.g., `gos.clarity.runtime`
- `version` (semver): e.g., `0.1.0`
- `publisher` (string)
- `key_id` (the signing key identifier used for trust + revocation)
- `type` (one of the canonical types above)

The tuple `(plugin_id, version, key_id)` uniquely identifies a release.

## Payload Contract (Required)
A plugin bundle payload MUST contain:
- `plugin.json` (required)
- `docs/acceptance.md` (required)
- `docs/threat_model.md` (required)
- `policy/` (optional; default overlay rules shipped by publisher)
- `bin/` or platform artifacts:
  - Android: `apk/*.apk`
  - Linux: `bin/*.elf` or container image reference (later)
  - Pre-OS: `preos/*.efi` or equivalent stage artifact (later)

## plugin.json (Required)
`plugin.json` is the **machine-enforced declaration** of intent.

Required fields:
- `schema`: `"gos-plugin/0.1"`
- `plugin_id`
- `name`
- `version`
- `type`: `workload|provider|policy|preos`
- `entrypoints`: array of entrypoint objects
- `requested_capabilities`: array of capability requests
- `required_attestations`: array (may be empty)
- `policy_codes`: array of codes the plugin emits (see Policy Codes section)

Entrypoint object (v0.1):
- `name`
- `kind`: `android_activity|android_service|linux_exec|preos_stage`
- `target`: string (package/component path)
- `run_as`: `unprivileged|brokered|system` (system is reserved; default deny)

Capability request object:
- `capability`: string (from capabilities vocabulary)
- `params`: object (capability-specific parameters)

## Policy Codes (Required)
Plugins MUST emit **policy codes** for all gated actions.
Policy codes are stable identifiers used by:
- audit reports
- obligations
- overlay restrictions
- deterministic triage

Format:
`<plugin_id>:<category>:<verb>:<detail>`
Example:
`gos.clarity.runtime:media:scan:removable`
`gos.atlas:updates:apply:stable_channel`

Rules:
- Must be ASCII, lowercase, `[-_.:a-z0-9]` only.
- Codes are declared in `plugin.json` and MUST NOT change meaning over time.
- A plugin action request MUST include exactly one policy code.

## Execution Contract (Instrument Law)
GOS treats every plugin action as:
- **Request** (input) → **Decision** (ALLOW/DENY) → **Obligations** → **Audit**
- Default deny if any required fact is missing.

Plugins MUST NOT bypass the gate:
- No direct privileged syscalls without broker/capability.
- No network/disk/export without an explicit capability grant.

## Registration
On install, GOS:
1. verifies bundle signature + hashes (trust chain)
2. validates `plugin.json` schema
3. writes local registry entry (read-only from plugin POV)
4. computes sandbox profile from granted capabilities
5. marks plugin as runnable only if policy allows

## Revocation
Revocation is first-class:
- By `key_id` (publisher key compromised)
- By `plugin_id`
- By `plugin_id@version` range (later)

Revoked plugins:
- cannot be installed
- cannot be launched
- remain on disk only if policy allows quarantine retention

## Determinism Requirements
- `plugin.json` must be deterministic (stable ordering, no timestamps).
- Plugins must not rely on wall-clock time unless gated and captured as inputs.
- Any nondeterminism must be declared as a capability + audited.

## Acceptance Discipline
A plugin is “shippable” only when:
- `docs/acceptance.md` has pass/fail criteria
- `docs/threat_model.md` exists and is non-empty
- requested capabilities are minimal
- overlay policy cannot expand privileges (see Overlay Policy spec)

# ======================================================================
