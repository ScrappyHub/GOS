# Acceptance Criteria

GOS Runtime is considered locked when:

- snapshots deterministic
- manifests identical across runs
- signatures verify
- allowed_signers regenerates deterministically
- receipts append only
- NFL duplication succeeds or failure is pledged
- empty payloads fail by default
- namespaces enforced
