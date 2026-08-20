$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       CloudRedirect STFixer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$out = "$env:TEMP\CloudRedirect.exe"
$api = "https://api.github.com/repos/Selectively11/CloudRedirect/releases/latest"

Write-Host "Getting latest CloudRedirect release..." -ForegroundColor Yellow

try {
    $release = Invoke-RestMethod -Uri $api -Headers @{
        "User-Agent" = "CloudRedirect-Installer"
    }

    $asset = $release.assets |
        Where-Object {
            $_.name -match '\.exe$' -and
            $_.name -notmatch 'linux'
        } |
        Select-Object -First 1

    if (-not $asset) {
        throw "No Windows EXE was found in the latest GitHub release."
    }

    Write-Host "Found: $($asset.name)" -ForegroundColor Green
    Write-Host "Downloading CloudRedirect..." -ForegroundColor Yellow

    & curl.exe -L --fail --silent --show-error `
        "$($asset.browser_download_url)" `
        -o "$out"

    if ($LASTEXITCODE -ne 0) {
        throw "Download failed with exit code $LASTEXITCODE"
    }

    if (-not (Test-Path $out)) {
        throw "The downloaded file does not exist."
    }

    $size = (Get-Item $out).Length

    if ($size -lt 10000) {
        Remove-Item $out -Force -ErrorAction SilentlyContinue
        throw "The downloaded file is too small ($size bytes)."
    }

    Write-Host "Download completed successfully." -ForegroundColor Green
    Write-Host "Launching STFixer..." -ForegroundColor Cyan
    Write-Host ""

    & $out /stfixer

    Write-Host ""
    Write-Host "CloudRedirect STFixer finished." -ForegroundColor Green
}
catch {
    Write-Host ""
    Write-Host "ERROR:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
}