<#
.SYNOPSIS
  Generates and pushes a local streak commit to GitHub to increment your consecutive contribution streak.
.DESCRIPTION
  This script creates/updates daily streak files using your GitHub author identity (Lohith Ravi <lohitravi69@gmail.com>)
  and pushes the commit to origin/main.
.PARAMETER Push
  If specified, pushes automatically to origin/main without prompting.
.PARAMETER Cleanup
  If specified, removes the temporary files after the commit and pushes a cleanup commit.
.EXAMPLE
  .\scripts\streak-commit.ps1
  .\scripts\streak-commit.ps1 -Push
#>
param(
    [switch]$Push,
    [switch]$Cleanup,
    [string]$AuthorName = "Lohith Ravi",
    [string]$AuthorEmail = "lohitravi69@gmail.com"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Set-Location $repoRoot

Write-Host "=== GitHub Streak Contribution Runner ===" -ForegroundColor Cyan
Write-Host "Repository: $repoRoot"
Write-Host "Author: $AuthorName <$AuthorEmail>`n"

# Ensure git is available
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git CLI is not installed or not found in PATH."
    exit 1
}

# Ensure daily folder exists
$dailyDir = Join-Path $repoRoot "daily"
if (-not (Test-Path $dailyDir)) {
    New-Item -ItemType Directory -Path $dailyDir -Force | Out-Null
}

$today = (Get-Date).ToString("yyyy-MM-dd")
$timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

$fileOne = Join-Path $dailyDir "file-one-$today.txt"
$fileTwo = Join-Path $dailyDir "file-two-$today.txt"

"Daily streak contribution at $timestamp" | Set-Content -Path $fileOne -Force
"Daily streak contribution at $timestamp" | Set-Content -Path $fileTwo -Force

# Stage files
git -C $repoRoot add $fileOne $fileTwo

# Check staged changes
$staged = git -C $repoRoot diff --cached --name-only
if (-not $staged) {
    Write-Host "No staged changes detected. Files are already up-to-date." -ForegroundColor Yellow
} else {
    $commitMsg = "chore: daily streak contribution [$today]"
    
    # Commit with explicit author to ensure GitHub attribution
    git -C $repoRoot -c user.name="$AuthorName" -c user.email="$AuthorEmail" commit -m "$commitMsg" --author="$AuthorName <$AuthorEmail>"
    Write-Host "Created commit: $commitMsg" -ForegroundColor Green
    
    $sha = (git -C $repoRoot rev-parse --short HEAD).Trim()
    Write-Host "Commit SHA: $sha" -ForegroundColor Gray
}

if ($Cleanup) {
    Write-Host "`nPerforming cleanup commit..." -ForegroundColor Cyan
    git -C $repoRoot rm -f $fileOne $fileTwo 2>$null
    git -C $repoRoot -c user.name="$AuthorName" -c user.email="$AuthorEmail" commit -m "chore: cleanup streak files [$today]" --author="$AuthorName <$AuthorEmail>"
    Write-Host "Cleanup commit created." -ForegroundColor Green
}

# Push handling
if ($Push) {
    $doPush = $true
} else {
    $response = Read-Host "`nPush commits to origin/main now? (Y/n)"
    $doPush = ($response -eq '' -or $response -match '^[Yy]')
}

if ($doPush) {
    Write-Host "Pushing to origin/main..." -ForegroundColor Cyan
    git -C $repoRoot push origin main
    Write-Host "Push successful! Your GitHub contribution graph will update shortly." -ForegroundColor Green
} else {
    Write-Host "Skipping push. You can push manually when ready:`n  git push origin main" -ForegroundColor Yellow
}
