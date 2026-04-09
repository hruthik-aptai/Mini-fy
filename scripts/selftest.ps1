param(
  [switch]$SkipDoctor,
  [switch]$SkipEvalValidation
)

$ErrorActionPreference = "Stop"
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

$Python = $null
foreach ($Candidate in @("python", "py")) {
  $Command = Get-Command $Candidate -ErrorAction SilentlyContinue
  if ($Command) {
    $Python = $Command.Name
    break
  }
}

if (-not $Python) {
  throw "Python is required for scripts/selftest.ps1."
}

Get-ChildItem -LiteralPath (Join-Path $RepoRoot "scripts") -Filter *.ps1 | ForEach-Object {
  [void][System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$null, [ref]$null)
}

$ShellChecks = @(
  "scripts/install.sh",
  "scripts/doctor.sh",
  "scripts/patch_openclaw_config.sh",
  "scripts/apply_profile.sh",
  "scripts/eval.sh",
  "scripts/openclaw_snapshot.sh",
  "scripts/bootstrap_workspace.sh"
)

Push-Location $RepoRoot
try {
  foreach ($Item in $ShellChecks) {
    bash -n $Item
    if ($LASTEXITCODE -ne 0) {
      throw "Shell parse failed for $Item"
    }
  }
}
finally {
  Pop-Location
}

& $Python -m py_compile `
  (Join-Path $RepoRoot "scripts/patch_openclaw_config.py") `
  (Join-Path $RepoRoot "scripts/eval_suite.py") `
  (Join-Path $RepoRoot "scripts/compare_eval_reports.py")

& $Python -m unittest discover -s (Join-Path $RepoRoot "tests") -p "test_*.py"

& $Python (Join-Path $RepoRoot "scripts/patch_openclaw_config.py") `
  --config (Join-Path $env:TEMP "mini-fy-selftest-config.json") `
  --snippet (Join-Path $RepoRoot "config/openclaw.secure-baseline.example.jsonc") `
  --snippet (Join-Path $RepoRoot "config/openclaw.efficient.example.jsonc") `
  --profile coding `
  --set-workspace $RepoRoot `
  --output (Join-Path $env:TEMP "mini-fy-selftest-merged.json")

if (-not $SkipEvalValidation) {
  & $Python (Join-Path $RepoRoot "scripts/eval_suite.py") `
    --cases `
    (Join-Path $RepoRoot "data/evals/core.json") `
    (Join-Path $RepoRoot "data/evals/coding.json") `
    (Join-Path $RepoRoot "data/evals/research.json") `
    (Join-Path $RepoRoot "data/evals/ops.json") `
    --skip-run `
    --output (Join-Path $env:TEMP "mini-fy-selftest-evals.json")
}

if (-not $SkipDoctor) {
  & (Join-Path $RepoRoot "scripts/doctor.ps1") -Workspace $RepoRoot -SkipOpenClawChecks
}

Write-Host "Mini-fy selftest passed."
