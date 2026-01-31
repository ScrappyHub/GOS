# GOS Overlay Policy v0.1 (Admin Walls, Never Weaken Canonical)

## Purpose
Admins may add an overlay policy that **does not tarnish or weaken**
the canonical policy. It can only add walls.

Formally: the effective policy is the **intersection** of canonical and overlays.

## Model
Policy Gate returns:
- decision: ALLOW|DENY
- reason_code
- obligations

Canonical policy is evaluated first (conceptually).
Overlay policies may only turn ALLOW into DENY or add obligations,
never DENY into ALLOW.

## Monotonic Constraint (Non-Negotiable)
Given:
- `C(req)` = canonical decision for request `req`
- `O_i(req)` = overlay i decision for request `req`

Effective decision `E(req)` is:

- If `C(req)=DENY` → `E(req)=DENY` (always)
- If `C(req)=ALLOW` and ANY overlay denies → `E(req)=DENY`
- If `C(req)=ALLOW` and ALL overlays allow → `E(req)=ALLOW`

Obligations:
- Effective obligations are the union of canonical obligations plus overlay obligations
  (overlay may add stricter obligations, never remove canonical obligations).

## Overlay Storage + Format
Overlays are delivered as **signed policy bundles** (GOS-AF) and stored locally.
Overlays have:
- `overlay_id`
- `version`
- `scope`: device | group | lane | plugin_id
- `rules`: deterministic, order-independent

Overlays MUST be:
- signed (trusted admin key)
- hashed
- revocable (by admin key_id or overlay_id)

## Overlay Rule Types (v0.1)
Overlays can only do:

### 1) deny_action
Deny requests matching selectors.
Selectors may include:
- lane
- plugin_id
- capability
- policy_code
- time_window
- network_destination (for NET_CONNECT)
- package/component (for LAUNCH_APP/INSTALL_PACKAGE)

### 2) tighten_capability_params
Restrict parameter space for a capability already allowed canonically.
Example:
- canonical allows NET_CONNECT to `*.example.com`
- overlay tightens to only `api.example.com`

### 3) add_obligations
Add obligations for matching requests:
- require_vpn
- rate_limit
- require_user_presence
- require_admin_lane (if not already required)

Overlays MUST NOT:
- introduce new capabilities
- grant capabilities not allowed canonically
- expand allowlists
- remove obligations

## Conflict Handling
If overlays conflict:
- deny wins
- tighter params win
- obligations union

## Admin UX Contract (Covenant Gate pattern)
Admins author overlays through a governed interface (later can be Covenant Gate):
- overlay requests are validated deterministically
- the system proves “overlay can only tighten” before installing it
- overlay install emits sealed audit evidence

## Failure Modes
If overlay validation cannot be proven:
- overlay is rejected
- system emits sealed audit with reason codes

## Acceptance Tests (v0.1)
1. Canonical denies request → overlay cannot allow it (must remain deny).
2. Canonical allows request → overlay can deny it.
3. Canonical allows NET_CONNECT allowlist → overlay may only reduce.
4. Canonical obligations always present in effective obligations.

# ======================================================================
