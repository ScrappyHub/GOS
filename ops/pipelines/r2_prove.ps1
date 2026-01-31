param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\.."))
Set-Location -LiteralPath $RepoRoot
if ((Get-Location).Path -ne $RepoRoot) { throw "Not in repo root; refusing." }

Write-Host "R2 PROVE: repo=$RepoRoot"

$Out = Join-Path $RepoRoot "artifacts\_r2_prove"
Remove-Item -LiteralPath $Out -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $Out -Force | Out-Null

# Minimal deterministic serializer (same style as pack.ps1 intent: stable ordering + LF)
function Write-DetJson([string]$Path, $Obj) {
  function Esc([string]$s) {
    $s = $s -replace '\\','\\\\'
    $s = $s -replace '"','\"'
    $s = $s -replace "`r",""
    $s = $s -replace "`n","\n"
    $s = $s -replace "`t","\t"
    return $s
  }
  function Render($v, [int]$indent) {
    $pad = (' ' * $indent)
    if ($null -eq $v) { return "null" }
    if ($v -is [bool]) { return ($(if ($v) { "true" } else { "false" })) }
    if ($v -is [int] -or $v -is [long] -or $v -is [double] -or $v -is [decimal]) { return [string]$v }
    if ($v -is [string]) { return '"' + (Esc $v) + '"' }

    if ($v -is [System.Collections.IEnumerable] -and -not ($v -is [System.Collections.IDictionary]) -and -not ($v -is [string])) {
      $items = @(); foreach ($x in $v) { $items += $x }
      if ($items.Length -eq 0) { return "[]" }
      $inner = New-Object System.Collections.Generic.List[string]
      foreach ($x in $items) { $inner.Add(($pad + "  " + (Render $x ($indent + 2)))) }
      return "[`n" + ($inner -join ",`n") + "`n" + $pad + "]"
    }

    $dict = $null
    if ($v -is [System.Collections.IDictionary]) { $dict = $v }
    else {
      $dict = @{}
      foreach ($p in $v.PSObject.Properties) { $dict[$p.Name] = $p.Value }
    }

    $keys = @($dict.Keys | Sort-Object)
    if ($keys.Length -eq 0) { return "{}" }

    $lines = New-Object System.Collections.Generic.List[string]
    foreach ($k in $keys) {
      $lines.Add(($pad + "  " + '"' + (Esc [string]$k) + '": ' + (Render $dict[$k] ($indent + 2))))
    }
    return "{`n" + ($lines -join ",`n") + "`n" + $pad + "}"
  }

  $json = Render $Obj 0
  $json = $json -replace "`r`n", "`n"
  Set-Content -LiteralPath $Path -Value $json -Encoding UTF8
}

function Sha([string]$p) { (Get-FileHash -LiteralPath $p -Algorithm SHA256).Hash.ToLowerInvariant() }

# Canonical request (should be ALLOW canonically)
$req = @{
  schema = "gos-gate/0.1"
  request_id = "r2-test-001"
  device_id = "device-local"
  lane = "adult"
  principal = @{ kind="user"; id="local"; proof=$null }
  subject   = @{ kind="plugin"; id="gos.clarity.runtime"; version="0.1.0"; key_id="devkey1" }
  action    = @{
    name="SCAN_MEDIA"
    capability="SCAN_MEDIA"
    policy_code="gos.clarity.runtime:media:scan:removable"
    target=@{ scope="removable_media" }
  }
  context = @{
    time_utc = "2026-01-31T00:00:00Z"
    network = @{ state="offline"; vpn="unknown"; dest=$null }
    presence = "present"
    risk = @{ score=$null; signals=@() }
    attestations = @{ clarity_state="pass"; firmware_state="pass"; gos_state="pass" }
  }
  inputs = @{ params=@{ scan_mode="hash_only"; max_files=1000 }; hashes=$null; metadata=$null }
}

$reqPath = Join-Path $Out "request.json"
Write-DetJson -Path $reqPath -Obj $req

# Canonical evaluator stub:
# - Deny if firmware_state != pass
# - Deny if lane=child and scan_mode != hash_only
# - Else allow
function Eval-Canonical($r) {
  if ($r.context.attestations.firmware_state -ne "pass") {
    return @{ decision="DENY"; reason_code="deny.firmware_untrusted"; obligations=@() }
  }
  if ($r.lane -eq "child" -and $r.inputs.params.scan_mode -ne "hash_only") {
    return @{ decision="DENY"; reason_code="deny.lane.permitted"; obligations=@() }
  }
  return @{ decision="ALLOW"; reason_code="allow.canonical.ok"; obligations=@(@{ name="seal_event"; params=@{}; enforce="post" }) }
}

# Overlay evaluator stub:
# overlay can only deny or add obligations
# - Deny if max_files > 500
function Eval-Overlay($r) {
  if ([int]$r.inputs.params.max_files -gt 500) {
    return @{ decision="DENY"; reason_code="deny.overlay_restriction"; obligations=@() }
  }
  return @{ decision="ALLOW"; reason_code="allow.overlay.ok"; obligations=@(@{ name="rate_limit"; params=@{ per_minute=60 }; enforce="continuous" }) }
}

$canonical = Eval-Canonical $req
$overlay   = Eval-Overlay $req

# Effective decision (tighten-only intersection)
$eff = $canonical
$overlayIds = @("overlay.local.dev/0.1")

if ($canonical.decision -eq "DENY") {
  $eff = $canonical
} else {
  if ($overlay.decision -eq "DENY") {
    $eff = $overlay
  } else {
    $eff = @{
      decision = "ALLOW"
      reason_code = "allow.overlay.ok"
      obligations = @($canonical.obligations + $overlay.obligations)
    }
  }
}

# Build decision envelope
$decision = @{
  schema="gos-gate-decision/0.1"
  request_id=$req.request_id
  decision=$eff.decision
  reason_code=$eff.reason_code
  obligations=$eff.obligations
  audit=@{ audit_id="audit-r2-test-001"; seal_required=$true; evidence_refs=@() }
  policy=@{
    canonical_policy_id="gos-canonical/0.1"
    overlay_policy_ids=$overlayIds
    evaluation_hash="" # filled below
  }
}

# evaluation_hash = sha256(request.json + canonical id + overlays) simplified for proof
$tmp = Join-Path $Out "_eval.txt"
Set-Content -LiteralPath $tmp -Encoding UTF8 -Value ("{0}`n{1}`n{2}" -f (Get-Content -Raw -LiteralPath $reqPath), $decision.policy.canonical_policy_id, ($overlayIds -join ","))

$decision.policy.evaluation_hash = Sha $tmp
Remove-Item -LiteralPath $tmp -Force

$decPath = Join-Path $Out "decision.json"
Write-DetJson -Path $decPath -Obj $decision

Write-Host "R2 PROVE wrote:"
Write-Host " - $reqPath"
Write-Host " - $decPath"
Write-Host ("Decision: {0} ({1})" -f $decision.decision, $decision.reason_code)

# Now prove overlay denial: bump max_files and ensure deny
$req2 = $req.Clone()
$req2.request_id = "r2-test-002"
$req2.inputs = @{ params=@{ scan_mode="hash_only"; max_files=9999 }; hashes=$null; metadata=$null }

$req2Path = Join-Path $Out "request_overlay_denied.json"
Write-DetJson -Path $req2Path -Obj $req2

$canonical2 = Eval-Canonical $req2
$overlay2   = Eval-Overlay $req2

if ($canonical2.decision -eq "DENY") { $eff2 = $canonical2 }
elseif ($overlay2.decision -eq "DENY") { $eff2 = $overlay2 }
else { $eff2 = @{ decision="ALLOW"; reason_code="allow.overlay.ok"; obligations=@($canonical2.obligations + $overlay2.obligations) } }

if ($canonical2.decision -eq "ALLOW" -and $eff2.decision -ne "DENY") {
  throw "R2 PROVE FAILED: overlay should have denied but did not."
}

Write-Host "R2 PROVE OK (tighten-only overlay semantics observed)"
