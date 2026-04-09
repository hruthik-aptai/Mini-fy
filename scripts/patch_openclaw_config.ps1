param(
  [string]$Config = (Join-Path $HOME ".openclaw/openclaw.json"),
  [string[]]$Snippet = @(),
  [string[]]$Profile = @(),
  [string]$SetWorkspace,
  [string]$Output,
  [switch]$DryRun,
  [switch]$NoBackup
)

$ErrorActionPreference = "Stop"

$Python = $null
foreach ($Candidate in @("python", "py")) {
  $Command = Get-Command $Candidate -ErrorAction SilentlyContinue
  if ($Command) {
    $Python = $Command.Name
    break
  }
}

if (-not $Python) {
  throw "Python is required for scripts/patch_openclaw_config.py."
}

$ScriptPath = Join-Path $PSScriptRoot "patch_openclaw_config.py"
$ArgsList = @($ScriptPath, "--config", $Config)

foreach ($Item in $Snippet) {
  $ArgsList += @("--snippet", $Item)
}

foreach ($Item in $Profile) {
  $ArgsList += @("--profile", $Item)
}

if ($SetWorkspace) {
  $ArgsList += @("--set-workspace", $SetWorkspace)
}

if ($Output) {
  $ArgsList += @("--output", $Output)
}

if ($DryRun) {
  $ArgsList += "--dry-run"
}

if ($NoBackup) {
  $ArgsList += "--no-backup"
}

& $Python @ArgsList
exit $LASTEXITCODE
