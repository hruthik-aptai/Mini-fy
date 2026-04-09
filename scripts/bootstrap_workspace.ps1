param(
  [ValidateSet("fresh", "merge")]
  [string]$Mode = "fresh",
  [string]$Target = (Join-Path $HOME ".openclaw/workspace"),
  [string]$Config = (Join-Path $HOME ".openclaw/openclaw.json"),
  [string[]]$Snippet = @(
    "config/openclaw.secure-baseline.example.jsonc",
    "config/openclaw.efficient.example.jsonc"
  ),
  [string]$Profile,
  [switch]$SkipDoctor
)

$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$WorkspacePath = $RepoRoot

if ($Mode -eq "merge") {
  & (Join-Path $RepoRoot "scripts/install.ps1") -Target $Target
  $WorkspacePath = (Resolve-Path $Target).Path
}

$PatchArgs = @{
  Config = $Config
  SetWorkspace = $WorkspacePath
}

if ($Snippet) {
  $PatchArgs.Snippet = $Snippet
}

if ($Profile) {
  $PatchArgs.Profile = @($Profile)
}

& (Join-Path $RepoRoot "scripts/patch_openclaw_config.ps1") @PatchArgs

if ($Profile) {
  & (Join-Path $RepoRoot "scripts/apply_profile.ps1") -Profile $Profile -Target $WorkspacePath
}

if (-not $SkipDoctor) {
  & (Join-Path $RepoRoot "scripts/doctor.ps1") -Workspace $WorkspacePath
}

Write-Host ""
Write-Host "Mini-fy bootstrap completed."
Write-Host "Mode: $Mode"
Write-Host "Workspace: $WorkspacePath"
if ($Profile) {
  Write-Host "Profile: $Profile"
}
Write-Host "Next step: restart OpenClaw or start a new session, then run your evals."
