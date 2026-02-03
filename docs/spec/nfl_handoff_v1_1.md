# NFL Handoff v1.1 — GOS Runtime

For every runtime event:

1) build commitment
2) append local pledge
3) build packet
4) duplicate to NFL
5) store receipt

No event is complete until duplicated.

Offline:
queue in outbox and retry.
