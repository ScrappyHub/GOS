# Security Model + Threats v0.1

## Threat Assumption
User is not trusted unless proven.
Software is not trusted unless verified.
Network is hostile by default.

## Primary Threats
- unsigned code execution
- privilege escalation
- data exfiltration
- policy bypass
- persistence across restores
- supply-chain tampering

## Controls
- default deny
- signature + hash verification
- capability gating
- sandboxing
- audit sealing
- revocation
- restore baseline

## Invariant
If something cannot be proven:
it does not run.
