# R2 Runtime Plan (Minimal Executable Reality)

## Goal
Get a real "alive" runtime with the smallest possible host surface.

## R2.1
Implement policy gate library skeleton:
- parse request envelope
- evaluate canonical policy + overlay
- emit decision envelope + reason code + obligations

## R2.2
Implement capability enforcement + audit stubs:
- every decision produces audit_id
- every denied action is logged

## R2.3
Implement sandbox boundary contract:
- workload execution request must pass policy+capability
- deny outside boundaries

## R2.4
Workload launcher harness:
- loads plugin.json
- runs entrypoint (in sandbox)
- emits lifecycle events

## R2.5
Minimal restore hook:
- soft restore for workload state
- audit sealing

Acceptance: the OS substrate “lives” even before a full UI.
