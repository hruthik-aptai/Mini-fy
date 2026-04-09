$ErrorActionPreference = "Stop"

function Write-Step {
  param([string]$Label, [string[]]$Args)

  Write-Host ""
  Write-Host "==> $Label"
  $Output = & openclaw @Args 2>&1
  $ExitCode = $LASTEXITCODE
  if ($Output) {
    $Output | Select-Object -First 20 | ForEach-Object { Write-Host $_ }
  }
  if ($ExitCode -ne 0) {
    Write-Host "Command failed with exit code $ExitCode"
  }
}

if (-not (Get-Command openclaw -ErrorAction SilentlyContinue)) {
  throw "OpenClaw CLI is not on PATH."
}

Write-Step "openclaw status" @("status")
Write-Step "openclaw skills list" @("skills", "list")
Write-Step "openclaw memory status" @("memory", "status")
Write-Step "openclaw sandbox explain" @("sandbox", "explain")
