param(
  [string[]]$Cases = @("data/evals/core.json"),
  [string]$Workspace = ".",
  [string]$Output,
  [switch]$SkipRun
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
  throw "Python is required for scripts/eval_suite.py."
}

$ScriptPath = Join-Path $PSScriptRoot "eval_suite.py"
$ArgsList = @($ScriptPath, "--workspace", $Workspace, "--cases") + $Cases

if ($Output) {
  $ArgsList += @("--output", $Output)
}

if ($SkipRun) {
  $ArgsList += "--skip-run"
}

& $Python @ArgsList
exit $LASTEXITCODE
