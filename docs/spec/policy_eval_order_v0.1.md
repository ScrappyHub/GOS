# Policy Evaluation Order v0.1

## Deterministic evaluation
1) Validate request envelope
2) Validate lane
3) Validate subject identity
4) Check required attestations (if policy demands)
5) Evaluate Canonical Policy rules (top-to-bottom)
6) Evaluate Overlay Policy rules (top-to-bottom)
7) Combine decision:
   - Start with canonical result
   - Overlay can only restrict (deny or add obligations)
8) Apply Capability Gate
9) Apply Sandbox Gate
10) Emit audit event
11) Return decision + reason_code + obligations + audit_id

## Ties
- First matching rule wins within each policy file.
- If no rule matches => defaults.decision (DENY).
