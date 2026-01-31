# Lanes v0.1

## Lanes
- adult: normal governed use
- child: materially restricted
- admin: privileged but still governed
- service: non-interactive system workload lane (updates, scans, etc.)

## Lane switching
Lane switching is an ACTION:
LANE_SWITCH_REQUEST
subject_id required; unknown user => deny.

## Child lane defaults
- network denied unless allowlisted
- installs denied
- exports denied
- only allow canonical apps list
- explicit time windows

## Admin lane defaults
- still cannot bypass canonical policy
- overlay policy installation allowed if signed by admin key and policy allows
