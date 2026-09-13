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

$zipFile = Join-Path $SteamPath "bst.zip"
try {
    Write-Host "Downloading BetterSteamTools v1.0.3 (Release)..."
    Invoke-WebRequest `
        -Uri "https://github.com/madoiscool/BetterSteamTools/releases/download/v1.0.3/OpenSteamTool-v1.0.3-Release.zip" `
        -OutFile $zipFile `
        -TimeoutSec 60 `
        -UseBasicParsing

    Write-Host "Stopping Steam..."
    Get-Process -Name "steam", "steamwebhelper" -ErrorAction SilentlyContinue |
        Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2

    Write-Host "Extracting bst.zip..."
    Expand-Archive -LiteralPath $zipFile -DestinationPath $SteamPath -Force

    Write-Host "Done! BetterSteamTools installed successfully." -ForegroundColor Green
}
finally {
    Remove-Item -LiteralPath $zipFile -Force -ErrorAction SilentlyContinue
}

Write-Host "Starting Steam..."
Start-Process -FilePath (Join-Path $SteamPath "steam.exe")
