<#
Runs the repo's `ci-demo.sh` inside the same alpine/git image used previously,
handling Windows quoting and offering to push results.

Usage (PowerShell, run from repository root):
  .\scripts\run-local.ps1

Requirements:
 - Docker installed and running
 - Git CLI available (to push commits)

This script will:
 - run `/workspace/ci-demo.sh` inside `alpine/git:2.45.2`
 - show the container output
 - ask whether to `git push origin main` (yes/no)
#>
param()

Set-StrictMode -Version Latest

$repo = (Get-Location).Path
Write-Host "Repository: $repo`n"

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error "Docker not found in PATH. Install Docker Desktop or run in WSL/Git Bash instead."
    exit 1
}

# Run the helper script in the alpine/git container. Use the packaged script to avoid complex quoting.
$image = 'alpine/git:2.45.2'
$entry = '/workspace/ci-demo.sh'

Write-Host "Pulling image $image (if needed) and running $entry in container..." -ForegroundColor Cyan

$dockerArgs = @(
    'run','--rm',
    '--entrypoint','sh',
    '-v', "$repo`:/workspace",
    '-w','/workspace',
    $image,
    '-c', "`"$entry`""
)

Write-Host "docker $($dockerArgs -join ' ')`n"

$proc = Start-Process -FilePath docker -ArgumentList $dockerArgs -NoNewWindow -Wait -PassThru -RedirectStandardOutput stdout.txt -RedirectStandardError stderr.txt

Write-Host "--- Container STDOUT ---`n"
Get-Content stdout.txt -Raw | Write-Host
Write-Host "--- Container STDERR ---`n"
Get-Content stderr.txt -Raw | Write-Host

Remove-Item stdout.txt, stderr.txt -ErrorAction SilentlyContinue

# Ask to push
$push = Read-Host "Push commits created by the script to origin/main? (y/N)"
if ($push -match '^[Yy]') {
    Write-Host "Pushing to origin/main..." -ForegroundColor Green
    git -C $repo push origin main
    Write-Host "Push complete."
} else {
    Write-Host "Skipping push. You can push manually: `n  git -C $repo push origin main" -ForegroundColor Yellow
}

Write-Host "Done. If you want me to run the GitHub workflow instead, say 'run workflow'."
