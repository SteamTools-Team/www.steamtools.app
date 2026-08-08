$url = "https://github.com/Selectively11/CloudRedirect/releases/latest/download/CloudRedirectCLI.exe"
$out = "$env:TEMP\CloudRedirectCLI.exe"

Write-Host "Downloading CloudRedirectCLI..." -ForegroundColor Cyan

try {
    Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -ErrorAction Stop
}
catch {
    Write-Host "Download error:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $out)) {
    Write-Host "The file was not downloaded." -ForegroundColor Red
    exit 1
}

$size = (Get-Item $out).Length
Write-Host "Downloaded file size: $size bytes" -ForegroundColor Yellow

if ($size -lt 10000) {
    Write-Host "The downloaded file appears to be invalid or incomplete." -ForegroundColor Red
    Write-Host "The program will not be executed." -ForegroundColor Red
    exit 1
}

Write-Host "Download completed successfully." -ForegroundColor Green
Write-Host "Launching CloudRedirect STFixer..." -ForegroundColor Cyan

& $out /stfixer
