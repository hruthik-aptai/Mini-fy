param(
  [string]$Target = (Join-Path $HOME ".openclaw/workspace")
)

$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$Items = @(
  ".gitignore",
  "README.md",
  "AGENTS.md",
  "SOUL.md",
  "USER.md",
  "IDENTITY.md",
  "TOOLS.md",
  "HEARTBEAT.md",
  "BOOTSTRAP.md",
  "MEMORY.md",
  "docs",
  "data",
  "config",
  "skills"
)

function Backup-Path {
  param([string]$DestinationPath)

  if (Test-Path -LiteralPath $DestinationPath) {
    $BackupPath = "$DestinationPath.bak-$Timestamp"
    Move-Item -LiteralPath $DestinationPath -Destination $BackupPath
    Write-Host "Backed up $DestinationPath -> $BackupPath"
  }
}

New-Item -ItemType Directory -Force -Path $Target | Out-Null

foreach ($Item in $Items) {
  $SourcePath = Join-Path $RepoRoot $Item
  $DestinationPath = Join-Path $Target $Item

  Backup-Path -DestinationPath $DestinationPath

  if (Test-Path -LiteralPath $SourcePath -PathType Container) {
    Copy-Item -LiteralPath $SourcePath -Destination $Target -Recurse -Force
  }
  else {
    Copy-Item -LiteralPath $SourcePath -Destination $DestinationPath -Force
  }

  Write-Host "Installed $Item"
}

Write-Host ""
Write-Host "Mini-fy installed into $Target"
Write-Host "Next steps:"
Write-Host "  1. Review USER.md, TOOLS.md, and HEARTBEAT.md"
Write-Host "  2. Merge config snippets from config/"
Write-Host "  3. Restart OpenClaw or start a new session"
Write-Host "  4. Run: openclaw skills list"
