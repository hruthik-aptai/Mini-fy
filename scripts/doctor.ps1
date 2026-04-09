param(
  [string]$Workspace = (Join-Path $PSScriptRoot ".."),
  [string]$ConfigPath = (Join-Path $HOME ".openclaw/openclaw.json"),
  [switch]$SkipOpenClawChecks
)

$ErrorActionPreference = "Stop"

function Expand-UserPath {
  param([string]$PathValue)

  if ([string]::IsNullOrWhiteSpace($PathValue)) {
    return $null
  }

  if ($PathValue -eq "~") {
    return $HOME
  }

  if ($PathValue.StartsWith("~/") -or $PathValue.StartsWith("~\")) {
    return Join-Path $HOME $PathValue.Substring(2)
  }

  return $PathValue
}

function Get-NormalizedPath {
  param([string]$PathValue)

  $Expanded = Expand-UserPath $PathValue
  if ([string]::IsNullOrWhiteSpace($Expanded)) {
    return $null
  }

  return [System.IO.Path]::GetFullPath($Expanded)
}

function Write-Check {
  param(
    [string]$Level,
    [string]$Message
  )

  Write-Host "[$Level] $Message"
}

function Get-ConfiguredWorkspace {
  param([string]$PathValue)

  if (-not (Test-Path -LiteralPath $PathValue)) {
    return $null
  }

  $Raw = Get-Content -LiteralPath $PathValue -Raw

  try {
    $Parsed = $Raw | ConvertFrom-Json -ErrorAction Stop
    if ($Parsed.agents.defaults.workspace) {
      return Get-NormalizedPath $Parsed.agents.defaults.workspace
    }
  }
  catch {
    # Fall back to a simple regex for JSONC-ish files.
  }

  $Match = [regex]::Match($Raw, '"workspace"\s*:\s*"(?<path>(?:\\.|[^"])*)"')
  if ($Match.Success) {
    $Value = $Match.Groups["path"].Value -replace "\\\\", "\"
    return Get-NormalizedPath $Value
  }

  return $null
}

$WorkspacePath = Get-NormalizedPath $Workspace
$ExpectedPaths = @(
  "AGENTS.md",
  "BOOT.md",
  "SOUL.md",
  "USER.md",
  "IDENTITY.md",
  "TOOLS.md",
  "HEARTBEAT.md",
  "MEMORY.md",
  "skills",
  "scripts",
  "profiles",
  "docs",
  "config",
  "data"
)

Write-Host "Mini-fy doctor"
Write-Host "Workspace under test: $WorkspacePath"
Write-Host ""

if (-not (Test-Path -LiteralPath $WorkspacePath)) {
  Write-Check "FAIL" "Workspace path does not exist."
  exit 1
}

$Missing = @()
foreach ($Relative in $ExpectedPaths) {
  $Candidate = Join-Path $WorkspacePath $Relative
  if (-not (Test-Path -LiteralPath $Candidate)) {
    $Missing += $Relative
  }
}

if ($Missing.Count -eq 0) {
  Write-Check "PASS" "Expected Mini-fy workspace files are present."
}
else {
  Write-Check "WARN" ("Missing expected paths: " + ($Missing -join ", "))
}

$ConfiguredWorkspace = Get-ConfiguredWorkspace $ConfigPath
if ($ConfiguredWorkspace) {
  Write-Check "INFO" "Configured OpenClaw workspace: $ConfiguredWorkspace"

  if ($ConfiguredWorkspace -eq $WorkspacePath) {
    Write-Check "PASS" "Mini-fy matches the configured active workspace."
  }
  else {
    Write-Check "WARN" "Mini-fy is not the configured active workspace. This looks like a template-only clone or alternate workspace."
  }
}
else {
  Write-Check "WARN" "Could not determine the configured OpenClaw workspace from $ConfigPath."
}

if (Test-Path -LiteralPath (Join-Path $WorkspacePath "BOOTSTRAP.md")) {
  Write-Check "INFO" "BOOTSTRAP.md still exists. One-time setup may still be pending."
}

$SkillFiles = Get-ChildItem -LiteralPath (Join-Path $WorkspacePath "skills") -Filter SKILL.md -Recurse -ErrorAction SilentlyContinue
Write-Check "INFO" ("Detected {0} Mini-fy skill files." -f $SkillFiles.Count)

$AgentsPath = Join-Path $WorkspacePath "AGENTS.md"
if (Test-Path -LiteralPath $AgentsPath) {
  $AgentsText = Get-Content -LiteralPath $AgentsPath -Raw
  $ProfileMatches = [regex]::Matches($AgentsText, '<!-- MINI-FY PROFILE:(?<name>[^ ]+) START -->')
  if ($ProfileMatches.Count -gt 0) {
    $Profiles = $ProfileMatches | ForEach-Object { $_.Groups["name"].Value } | Select-Object -Unique
    Write-Check "INFO" ("Active Mini-fy profiles: " + ($Profiles -join ", "))
  }
}

if ($SkipOpenClawChecks) {
  Write-Check "INFO" "Skipped live OpenClaw command checks by request."
  exit 0
}

$OpenClaw = Get-Command openclaw -ErrorAction SilentlyContinue
if (-not $OpenClaw) {
  Write-Check "WARN" "OpenClaw CLI is not on PATH, so live command checks were skipped."
  exit 0
}

$Commands = @(
  @{ Label = "openclaw skills list"; Args = @("skills", "list") },
  @{ Label = "openclaw status"; Args = @("status") },
  @{ Label = "openclaw memory status"; Args = @("memory", "status") }
)

foreach ($CommandInfo in $Commands) {
  $Output = & openclaw @($CommandInfo.Args) 2>&1
  $ExitCode = $LASTEXITCODE

  if ($ExitCode -eq 0) {
    Write-Check "PASS" ($CommandInfo.Label + " succeeded.")
  }
  else {
    $Preview = (($Output | Select-Object -First 3) -join " ").Trim()
    if ([string]::IsNullOrWhiteSpace($Preview)) {
      $Preview = "No output captured."
    }
    Write-Check "WARN" ($CommandInfo.Label + " failed. " + $Preview)
  }
}
