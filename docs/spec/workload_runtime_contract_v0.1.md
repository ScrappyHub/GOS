# Workload Runtime Contract v0.1

## Purpose
Define how GOS starts/controls workloads without becoming “feature OS”.

## Execution Model
Workloads run as bundles + entrypoints.
GOS never runs random binaries. It runs:
- verified bundle payload
- declared entrypoint
- in a sandbox

## Workload Bundle Types
- workload: apps/services/tools (CORE, Rooted, Covenant Gate, Atlas, Legacy Doctor, Rebound)
- provider: OS-adjacent helpers (optional), still workloads

## Required files in workload payload
- plugin.json
- entrypoints/ (or bin/) containing the executables/scripts
- assets/ (optional)

## plugin.json fields (minimum)
- plugin_id
- version
- type
- entrypoints: [{ name, relative_path, args_schema (optional) }]
- requested_capabilities: []
- lane_compatibility: ["adult","child","admin","service"]
- required_attestations: { firmware: "required|optional|none", gos: "...", workload_chain: "..." }

## Start/Stop
GOS provides lifecycle verbs:
- START(plugin_id, entrypoint, args)
- STOP(plugin_id)
- STATUS(plugin_id)

All lifecycle actions go through policy gate.

## Output
Workloads may emit:
- results artifacts (GOS-AF bundles)
- audit events (always)
