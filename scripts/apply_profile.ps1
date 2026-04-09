param(
  [Parameter(Mandatory = $true)]
  [string]$Profile,
  [string]$Target = (Join-Path $PSScriptRoot "..")
)

$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$ProfileRoot = Join-Path $RepoRoot ("profiles\" + $Profile)
$TargetRoot = (Resolve-Path $Target).Path

if (-not (Test-Path -LiteralPath $ProfileRoot)) {
  throw "Unknown profile: $Profile"
}

$AgentsFragmentPath = Join-Path $ProfileRoot "AGENTS.append.md"
$TargetAgentsPath = Join-Path $TargetRoot "AGENTS.md"
$TargetSkillsRoot = Join-Path $TargetRoot "skills"
$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

New-Item -ItemType Directory -Force -Path $TargetSkillsRoot | Out-Null

$MarkerStart = "<!-- MINI-FY PROFILE:$Profile START -->"
$MarkerEnd = "<!-- MINI-FY PROFILE:$Profile END -->"
$Fragment = Get-Content -LiteralPath $AgentsFragmentPath -Raw
$AgentsContent = Get-Content -LiteralPath $TargetAgentsPath -Raw

if ($AgentsContent -match [regex]::Escape($MarkerStart)) {
  Write-Host "Profile marker already present in AGENTS.md: $Profile"
}
else {
  $AppendBlock = "`r`n`r`n$MarkerStart`r`n$Fragment`r`n$MarkerEnd`r`n"
  Set-Content -LiteralPath $TargetAgentsPath -Value ($AgentsContent + $AppendBlock)
  Write-Host "Appended profile guidance to AGENTS.md"
}

$ProfileSkillsRoot = Join-Path $ProfileRoot "skills"
if (Test-Path -LiteralPath $ProfileSkillsRoot) {
  Get-ChildItem -LiteralPath $ProfileSkillsRoot -Directory | ForEach-Object {
    $Destination = Join-Path $TargetSkillsRoot $_.Name
    if (Test-Path -LiteralPath $Destination) {
      $Backup = "$Destination.bak-$Timestamp"
      Move-Item -LiteralPath $Destination -Destination $Backup
      Write-Host "Backed up existing skill to $Backup"
    }
    Copy-Item -LiteralPath $_.FullName -Destination $TargetSkillsRoot -Recurse -Force
    Write-Host "Installed profile skill $($_.Name)"
  }
}

Write-Host ""
Write-Host "Profile '$Profile' applied to $TargetRoot"
Write-Host "Next steps:"
Write-Host "  1. Merge profiles/$Profile/config.example.jsonc with scripts/patch_openclaw_config.ps1 -Profile $Profile"
Write-Host "  2. Restart OpenClaw or start a new session"
Write-Host "  3. Run the doctor script"
Write-Host "  4. Run the matching eval file in data/evals/"
