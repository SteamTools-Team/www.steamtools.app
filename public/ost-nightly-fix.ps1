$ErrorActionPreference = "Stop"

# GitHub requires TLS 1.2 on older Windows PowerShell versions.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "Finding Steam..."
$registries = @(
    "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam",
    "HKLM:\SOFTWARE\Valve\Steam",
    "HKCU:\SOFTWARE\Valve\Steam"
)

$SteamPath = $null
foreach ($reg in $registries) {
    if (-not (Test-Path -LiteralPath $reg)) {
        continue
    }

    $path = (Get-ItemProperty -LiteralPath $reg -Name "InstallPath" -ErrorAction SilentlyContinue).InstallPath
    if ($path -and (Test-Path -LiteralPath $path) -and (Test-Path -LiteralPath (Join-Path $path "steam.exe"))) {
        $SteamPath = $path
        break
    }
}

if (-not $SteamPath) {
    Write-Host "Steam not found." -ForegroundColor Red
    exit 1
}

Write-Host "Steam found at: $SteamPath"

$zipFile = Join-Path $SteamPath "OST-Nightly.zip"

try {
    Write-Host "Getting latest OST-Nightly release..."

    $release = Invoke-RestMethod "https://api.github.com/repos/madoiscool/OST-Nightly/releases/latest"
    $asset = $release.assets | Where-Object { $_.name -like "*.zip" } | Select-Object -First 1

    if (-not $asset) {
        throw "No ZIP asset found in the latest OST-Nightly release."
    }

    Write-Host "Downloading $($asset.name)..."

    Invoke-WebRequest `
        -Uri $asset.browser_download_url `
        -OutFile $zipFile `
        -TimeoutSec 60 `
        -UseBasicParsing

    Write-Host "Stopping Steam..."
    Get-Process -Name "steam", "steamwebhelper" -ErrorAction SilentlyContinue |
        Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2

    Write-Host "Extracting archive..."
    Expand-Archive -LiteralPath $zipFile -DestinationPath $SteamPath -Force

    $steamCfg = Join-Path $SteamPath "steam.cfg"
    $steamCfgBak = Join-Path $SteamPath "steam.cfg.bak"

    if (Test-Path -LiteralPath $steamCfg) {
        Write-Host "Renaming steam.cfg to steam.cfg.bak..."
        Move-Item -LiteralPath $steamCfg -Destination $steamCfgBak -Force
    }

    Write-Host "Done! OST-Nightly installed successfully." -ForegroundColor Green
}
finally {
    Remove-Item -LiteralPath $zipFile -Force -ErrorAction SilentlyContinue
}

Write-Host "Starting Steam..."
Start-Process -FilePath (Join-Path $SteamPath "steam.exe")
