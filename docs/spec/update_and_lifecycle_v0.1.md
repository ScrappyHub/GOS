# Update and Lifecycle v0.1 (Host vs Workloads)

## Host Updates (GOS)
GOS updates are rare and boring.
They are signed OS releases with strict rollout.

## Workload Updates
Workloads do not self-update.
They are replaced by:
- verified bundle install
- audit record
- optional restore checkpoint

## Update Agent
The update mechanism can be:
- a minimal host function OR
- a dedicated workload (Atlas)

Regardless, host enforces:
- signature verification
- revocation checks
- policy gate approval
- audit sealing

## Why Atlas Fits
Atlas can be the "lifecycle workload":
- schedules updates
- executes allowed installs
- emits reports
But it still cannot bypass GOS.
