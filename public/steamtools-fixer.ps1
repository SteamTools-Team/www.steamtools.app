$Script:Culture      = $env:LT_CULTURE
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Script:ProgressPreference = 'SilentlyContinue'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null
$OutputEncoding = [System.Text.Encoding]::UTF8
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Net.Http

# Locale defaults
function Get-DefaultStrings {
    param([string]$Culture)

    $tables = @{
        "en" = @{
            Title                 = "SteamTools Fixer"
            SteamRegNotFound      = "Steam registry key not found. Is Steam installed?"
            SteamKilling          = "Stopping Steam"
            SteamKilled           = "Steam stopped"
            SteamtoolsFound       = "Steamtools already installed"
            SteamtoolsNotFound    = "Steamtools not found"
            SteamtoolsInstalling  = "Installing Steamtools"
            SteamtoolsInstalled   = "Steamtools installed"
            SteamtoolsRetrying    = "Steamtools installation failed, retrying..."
            SteamtoolsFailed      = "Steamtools installation failed after 5 attempts"
            MillenniumNotFound    = "Millennium not found"
            MillenniumCountdown   = "Millennium will be installed in {0} second(s)... Press any key to cancel"
            MillenniumCancelled   = "Installation cancelled by user"
            MillenniumInstalling  = "Installing Millennium (legacy)"
            MillenniumInstalled   = "Millennium installed"
            MillenniumAlready     = "Millennium already installed"
            MillenniumFirstBoot   = "Steam startup may be slower on first boot -- let it sit."
            RemovingBeta          = "Cleaning up beta flag"
            RemovingCfg           = "Cleaning up steam.cfg"
            RemovingFlags         = "Cleaning up ForceX86 flags and offline mode"
            StartingSteam         = "Starting Steam"
            UpdateCheckDisabled   = "Millennium auto-updates disabled (keeps you on the legacy version)."
            UpdateCheckManual     = "Check for Millennium updates manually if you want the latest."

            ErrorTitle            = "SteamTools Fixer - ERROR"
            ErrorHeader           = "AN ERROR OCCURRED"
            ErrorBody             = "The SteamTools Fixer encountered a problem and could not complete. This is often caused by your ISP blocking the download servers we use."
            ErrorFaq              = ""
            ErrorExit             = "Press any key to exit."
        }

        "pt-BR" = @{
            Title                 = "SteamTools Fixer"
            SteamRegNotFound      = "Steam nÃ£o encontrada no registro. Sua Steam ta instalada?"
            SteamKilling          = "Parando a Steam"
            SteamKilled           = "Steam Encerrada"
            SteamtoolsFound       = "Steamtools ja instalado"
            SteamtoolsNotFound    = "Steamtools nÃ£o encontrado"
            SteamtoolsInstalling  = "Instalando Steamtools"
            SteamtoolsInstalled   = "Steamtools instalado"
            SteamtoolsRetrying    = "Falha ao instalar Steamtools, tentando denovo..."
            SteamtoolsFailed      = "Falha ao instalar Steamtools apÃ³s 5 tentativas"
            MillenniumNotFound    = "Millennium nÃ£o encontrado"
            MillenniumCountdown   = "Millennium vai ser instalado em {0} segundo(s)... Aperte qualquer tecla pra cancelar"
            MillenniumCancelled   = "InstalaÃ§Ã£o cancelada pelo usuÃ¡rio"
            MillenniumInstalling  = "Instalando Millennium (legado)"
            MillenniumInstalled   = "Millennium instalado"
            MillenniumAlready     = "O Millennium ja estÃ¡ instalado"
            MillenniumFirstBoot   = "A Steam pode demorar um pouco pra abrir pela primeira vez -- deixa rolar."
            RemovingBeta          = "Limpando flag de beta da Steam"
            RemovingCfg           = "Apagando steam.cfg"
            RemovingFlags         = "Limpando flags do ForceX86 e o modo offline"
            StartingSteam         = "Abrindo a Steam"
            UpdateCheckDisabled   = "AtualizaÃ§Ãµes automÃ¡ticas do Millennium desabilitadas (mantÃ©m vocÃª na versÃ£o legada)"
            UpdateCheckManual     = "Verifique manualmente por atualizaÃ§Ãµes do Millennium caso vocÃª queira a ultima versÃ£o"

            ErrorTitle            = "SteamTools Fixer - ERRO"
            ErrorHeader           = "OCORREU UM ERRO"
            ErrorBody             = "O SteamTools Fixer encontrou um problema e nÃ£o pÃ´de ser concluÃ­do. Isso geralmente Ã© causado pela tua internet bloqueando nossos servidores de Download"
            ErrorFaq              = ""
            ErrorExit             = "Aperte qualquer botÃ£o pra sair."
        }

        "es" = @{
            Title                 = "SteamTools Fixer"
            SteamRegNotFound      = "La clave de registro de Steam no se ha encontrado. EstÃ¡ Steam instalado?"
            SteamKilling          = "Deteniendo Steam"
            SteamKilled           = "Steam se ha detenido"
            SteamtoolsFound       = "Steamtools ya estÃ¡ instalado"
            SteamtoolsNotFound    = "Steamtools no se ha encontrado"
            SteamtoolsInstalling  = "Instalando Steamtools"
            SteamtoolsInstalled   = "Steamtools se ha instalado"
            SteamtoolsRetrying    = "La instalaciÃ³n de Steamtools ha fallado, reintentando..."
            SteamtoolsFailed      = "La instalaciÃ³n de Steamtools ha fallado despues de 5 intentos"
            MillenniumNotFound    = "Millenium no encontrado"
            MillenniumCountdown   = "Millenium sera instalado en {0} segundo(s) ... Presiona cualquier tecla para cancelar"
            MillenniumCancelled   = "InstalaciÃ³n cancelada por el usuario"
            MillenniumInstalling  = "Instalando Millenium (legado)"
            MillenniumInstalled   = "Millenium instalado"
            MillenniumAlready     = "Millenium ya estaba instalado"
            MillenniumFirstBoot   = "La carga de steam puede ser mÃ¡s lenta la primera vez para cargar las dependencias -- espera pacientemente"
            RemovingBeta          = "Limpiando indicador beta"
            RemovingCfg           = "Limpiando steam.cfg"
            RemovingFlags         = "Limpiando flags de ForceX86 y el modo sin conexiÃ³n"
            StartingSteam         = "Iniciando Steam"
            UpdateCheckDisabled   = "Las auto-actualizaciones de Millenium estÃ¡n deshabilitadas (te mantiene en la versiÃ³n legada)"
            UpdateCheckManual     = "Comprueba las actualizaciones de Millenium manualmente si necesitas la Ãºltima versiÃ³n"

            ErrorTitle            = "Error con el instalador SteamTools - ERROR"
            ErrorHeader           = "UN ERROR HA OCURRIDO"
            ErrorBody             = "El instalador del SteamTools Fixes encontrÃ³ un problema y no pudo completarse. Esto suele ocurrir cuando tu proveedor de internet (ISP) bloquea los servidores de descarga que utilizamos."
            ErrorFaq              = ""
            ErrorExit             = "Presiona cualquier tecla para salir."
        }

        "fr" = @{
            Title                 = "SteamTools Fixer"
            SteamRegNotFound      = "ClÃ© de registre steam introuvable. Est ce que Steam est installÃ©?"
            SteamKilling          = "ArrÃªt de Steam"
            SteamKilled           = "Steam arretÃ©"
            SteamtoolsFound       = "Steamtools dÃ©jÃ  installÃ©"
            SteamtoolsNotFound    = "Steamtools introuvable"
            SteamtoolsInstalling  = "Installation de Steamtools"
            SteamtoolsInstalled   = "Steamtools installÃ©"
            SteamtoolsRetrying    = "L'instalation de Steamtools a echouÃ©, nouvelle tentative..."
            SteamtoolsFailed      = "L'installation de Steamtools a echouÃ© apres 5 tentatives"
            MillenniumNotFound    = "Millennium introuvable"
            MillenniumCountdown   = "Millennium sera installÃ© dans {0} seconde(s)... Appuyez sur une touche pour annuler"
            MillenniumCancelled   = "Installation annulÃ©ee par l'utilisateur"
            MillenniumInstalling  = "Installation de Millennium (legacy)"
            MillenniumInstalled   = "Millennium installÃ©"
            MillenniumAlready     = "Millennium dÃ©jÃ  installÃ©"
            MillenniumFirstBoot   = "Le prochain lancement de Steam sera plus long -- laisser le temps."
            RemovingBeta          = "Nettoyage de la beta"
            RemovingCfg           = "Nettoyage de steam.cfg"
            RemovingFlags         = "Nettoyage des flags ForceX86 et du mode hors ligne"
            StartingSteam         = "Lancement de Steam"
            UpdateCheckDisabled   = "Les mises Ã  jour de Millennium ont Ã©tÃ© dÃ©sactivÃ©e (vous garde sur la version legacy)."
            UpdateCheckManual     = "VÃ©rifiez manuellement les mises Ã  jour de Millennium si vous souhaitez la derniere version."

            ErrorTitle            = "Installateur SteamTools - ERREUR"
            ErrorHeader           = "UNE ERREUR EST SURVENUE"
            ErrorBody             = "L'installation des fixes a rencontrÃ© un problÃ¨me et n'a pas pu se terminer. Ã‡a se produit souvent quand votre fournisseur d'internet (ISP) bloque les serveurs de tÃ©lÃ©chargement."
            ErrorFaq              = ""
            ErrorExit             = "Appuyez sur une touche pour quitter."
        }
    }

    foreach ($key in @($Culture, $Culture.Split('-')[0], "en")) {
        if ($tables.ContainsKey($key)) {
            return $tables[$key]
        }
    }
    return $tables["en"]
}

function Show-Loading {
    param([string]$Text, [int]$Seconds = 2)

    Write-Host -NoNewline $Text -ForegroundColor DarkGray

    for ($i=0; $i -lt $Seconds * 3; $i++) {
        Write-Host -NoNewline "." -ForegroundColor DarkGray
        Start-Sleep -Milliseconds 300
    }

    Write-Host ""
}

function Write-Step {
    param([string]$Text)

    Write-Host ""
    Write-Host "â†’ $Text" -ForegroundColor Cyan
    Start-Sleep -Milliseconds 150
}

$DetectedCulture = if ($Script:Culture) { $Script:Culture } else { [System.Globalization.CultureInfo]::CurrentUICulture.Name }
$L = Get-DefaultStrings -Culture $DetectedCulture
$Script:OriginalErrorAction = $ErrorActionPreference
$ErrorActionPreference = "Stop"

trap {
    $errMsg = $_.Exception.Message

    if (-not $L) { $L = Get-DefaultStrings -Culture "en" }

    $host.UI.RawUI.CursorPosition = @{ X=0; Y=0 }
    $errTitle = if ($L.ContainsKey("ErrorTitle")) { $L["ErrorTitle"] } else { "SteamTools Fixer - ERROR" }
    $host.UI.RawUI.WindowTitle = $errTitle
    Clear-Host

    $width = $host.UI.RawUI.WindowSize.Width

    Write-Host ("=" * $width) -ForegroundColor Red
    Write-Host ""

    $header = if ($L.ContainsKey("ErrorHeader")) { $L["ErrorHeader"] } else { "AN ERROR OCCURRED" }
    $pad = [Math]::Max(0, [int](($width - $header.Length) / 2))
    Write-Host (" " * $pad) -NoNewline
    Write-Host $header -ForegroundColor Red -BackgroundColor Black
    Write-Host ""

    $body = if ($L.ContainsKey("ErrorBody")) { $L["ErrorBody"] } else { "The installer encountered a problem." }
    Write-Host $body -ForegroundColor White
    Write-Host ""

    Write-Host ">>> " -NoNewline -ForegroundColor Yellow
    Write-Host $errMsg -ForegroundColor Gray
    Write-Host ""

    $faq = if ($L.ContainsKey("ErrorFaq")) { $L["ErrorFaq"] } else { "Visit (www.steamtools.app/discord)" }
    Write-Host $faq -ForegroundColor Cyan
    Write-Host ""

    Write-Host ("=" * $width) -ForegroundColor Red
    Write-Host ""

    $exitMsg = if ($L.ContainsKey("ErrorExit")) { $L["ErrorExit"] } else { "Press any key to exit." }
    Write-Host $exitMsg -ForegroundColor Yellow
    try { $null = [System.Console]::ReadKey($true) } catch {}

    $ErrorActionPreference = $Script:OriginalErrorAction
    break
}

$LogTheme = @{
    INFO  = @{ Color = "Cyan";    Icon = "i" }
    OK    = @{ Color = "Green";   Icon = "+" }
    WARN  = @{ Color = "Yellow";  Icon = "!" }
    ERROR = @{ Color = "Red";     Icon = "x" }
    STEP  = @{ Color = "Magenta"; Icon = ">" }
    AUX = @{ Color = "DarkCyan"; Icon = "~" }
}

function Write-Type {
    param(
        [string]$Text,
        [ConsoleColor]$Color = "Gray",
        [int]$Delay = 5
    )

    foreach ($c in $Text.ToCharArray()) {
        Write-Host -NoNewline $c -ForegroundColor $Color
        Start-Sleep -Milliseconds $Delay
    }
    Write-Host ""
}

function Write-Log {
    param(
        [ValidateSet("INFO","OK","WARN","ERROR","STEP","AUX")]
        [string]$Type,
        [string]$Message
    )

    $t = Get-Date -Format "HH:mm:ss"
    $style = $LogTheme[$Type]

    Write-Host -NoNewline "[$t] " -ForegroundColor DarkGray
    Write-Host -NoNewline "[$($style.Icon)] " -ForegroundColor $style.Color
    Write-Type $Message $style.Color 3
}

function Show-Spinner {
    param(
        [string]$Message,
        [int]$Seconds = 2
    )

    $chars = "|/-\"
    $end = (Get-Date).AddSeconds($Seconds)

    while ((Get-Date) -lt $end) {
        foreach ($c in $chars.ToCharArray()) {
            Write-Host -NoNewline "`r[$c] $Message" -ForegroundColor DarkCyan
            Start-Sleep -Milliseconds 100
        }
    }

    Write-Host "`r[+] $Message" -ForegroundColor Green
}

# Steam path
function Get-SteamPath {
    $registries = @(
        "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam",
        "HKLM:\SOFTWARE\Valve\Steam",
        "HKCU:\SOFTWARE\Valve\Steam"
    )

    foreach ($reg in $registries) {
        if (!(Test-Path $reg)) { continue }

        $path = (Get-ItemProperty -Path $reg -Name "InstallPath" -ErrorAction SilentlyContinue).InstallPath
        $potentialExe = Join-Path $path "steam.exe"
        if ((Test-Path $path) -and (Test-Path $potentialExe)) {
            return $path
        }
    }
    Write-Log -Type ERROR -Message $L["SteamRegNotFound"]
}

# Steamtools -- REQUIRED, no user choice
function Test-Steamtools {
    param([string]$SteamPath)
    foreach ($f in @("dwmapi.dll", "xinput1_4.dll")) {
        if (Test-Path (Join-Path $SteamPath $f)) { return $true }
    }
    return $false
}

function Install-Steamtools {
    param([string]$SteamPath)

    Write-Log -Type WARN -Message $L["SteamtoolsInstalling"]

    $exe = Join-Path $SteamPath "CloudRedirectCLI.exe"
    Invoke-WebRequest -Uri "https://github.com/Selectively11/CloudRedirect/releases/latest/download/CloudRedirectCLI.exe" -OutFile $exe -TimeoutSec 60 -UseBasicParsing
    if (-not (Test-Path $exe)) { throw $L["SteamtoolsFailed"] }

    for ($attempt = 1; $attempt -le 5; $attempt++) {
        Write-Log -Type INFO -Message $L["SteamtoolsInstalling"]
        Start-Process $exe "/stfixer" -Wait
        if (Test-Steamtools $SteamPath) {
            Write-Log -Type OK -Message $L["SteamtoolsInstalled"]
            Remove-Item $exe -Force -ErrorAction SilentlyContinue
            return
        }
        Write-Log -Type ERR -Message $L["SteamtoolsRetrying"]
    }

    Remove-Item $exe -Force -ErrorAction SilentlyContinue
    throw $L["SteamtoolsFailed"]
}

function Test-Millennium {
    param([string]$SteamPath)
    foreach ($f in @("wsock32.dll", "millennium.dll", "python311.dll")) {
        if (Test-Path -LiteralPath (Join-Path $SteamPath $f)) { return $true }
    }
    return $false
}

function Install-Millennium {
    param([string]$SteamPath)

    Write-Log -Type INFO -Message $L["MillenniumInstalling"]
    $msUrls = @(
        "https://ps.lua.tools/millennium-py.ps1"
    )
    $msCode = $null
    foreach ($url in $msUrls) {
        try {
            $msCode = Invoke-RestMethod $url -TimeoutSec 30
            if ($msCode) { break }
        } catch {}
    }
    if (-not $msCode) { throw $L["MillenniumNotFound"] }
    $scriptBlock = [scriptblock]::Create($msCode)

    & $scriptBlock -NoLog -DontStart -SteamPath $SteamPath

    if (Test-Millennium $SteamPath) {
        Write-Log -Type OK -Message $L["MillenniumInstalled"]
    }
}

# Config legacy <Steam>\ext\config.json, with updates forced OFF
function Enable-Plugin {
    param([string]$SteamPath, [string]$Name)
    $configPath = Join-Path $SteamPath "ext\config.json"

    if (-not (Test-Path $configPath)) {
        $config = @{
            general = @{ checkForMillenniumUpdates = $false }
            plugins = @{ enabledPlugins = @($Name) }
        }
        New-Item -Path (Split-Path $configPath) -ItemType Directory -Force | Out-Null
        $config | ConvertTo-Json -Depth 10 | Set-Content $configPath -Encoding UTF8
    }
    else {
        $config = (Get-Content $configPath -Raw -Encoding UTF8) | ConvertFrom-Json

        if (-not $config.general) {
            $config | Add-Member -MemberType NoteProperty -Name "general" -Value ([PSCustomObject]@{}) -Force
        }
        $config.general | Add-Member -MemberType NoteProperty -Name "checkForMillenniumUpdates" -Value $false -Force

        if (-not $config.plugins) {
            $config | Add-Member -MemberType NoteProperty -Name "plugins" -Value ([PSCustomObject]@{ enabledPlugins = @() }) -Force
        }
        if (-not $config.plugins.enabledPlugins) {
            $config.plugins | Add-Member -MemberType NoteProperty -Name "enabledPlugins" -Value @() -Force
        }

        $pluginsList = @($config.plugins.enabledPlugins)
        if ($pluginsList -notcontains $Name) {
            $pluginsList += $Name
            $config.plugins.enabledPlugins = $pluginsList
        }

        $config | ConvertTo-Json -Depth 10 | Set-Content $configPath -Encoding UTF8
    }

    Write-Log -Type OK -Message $L["PluginEnabled"]
}

# Cleanup
function Remove-BetaFlag {
    param([string]$SteamPath)
    $beta = Join-Path $SteamPath "package\beta"
    if (Test-Path $beta) {
        Write-Log -Type STEP -Message $L["RemovingBeta"]
        Remove-Item $beta -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function Reset-SteamFlags {
    param([string]$SteamPath)
    Write-Log -Type AUX -Message $L["RemovingFlags"]

    @("HKCU:\Software\Valve\Steam","HKLM:\SOFTWARE\Valve\Steam","HKLM:\SOFTWARE\WOW6432Node\Valve\Steam") | ForEach-Object {
        Remove-ItemProperty -Path $_ -Name "SteamCmdForceX86" -ErrorAction SilentlyContinue
    }

    $loginUsersPath = Join-Path $SteamPath "config\loginusers.vdf"
    if (Test-Path $loginUsersPath) {
        $content = Get-Content -Path $loginUsersPath -Raw
        if ($content -match '"WantsOfflineMode"\s+"1"') {
            $newContent = $content -replace '("WantsOfflineMode"\s+)"1"', '$1"0"'
            Set-Content -Path $loginUsersPath -Value $newContent -Encoding UTF8
        }
    }
}

function Remove-SteamCfg {
    param([string]$SteamPath)
    $cfg = Join-Path $SteamPath "steam.cfg"
    if (Test-Path $cfg) {
        Write-Log -Type AUX -Message $L["RemovingCfg"]
        Remove-Item $cfg -Force -ErrorAction SilentlyContinue
    }
}

# Main

function Main {

    $steamPath = Get-SteamPath

    Write-Log STEP "Stopping Steam"
    Show-Spinner "Closing Steam processes" 2

    Get-Process steam -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

    Write-Log INFO "Checking SteamTools"

    if (Test-Steamtools $steamPath) {
        Write-Log OK "Steamtools already installed"
    } else {
        Write-Log WARN "Steamtools not found"
        Install-Steamtools $steamPath
    }

    Write-Log STEP "Installing Millennium"

    $was = Test-Millennium $steamPath
    Install-Millennium $steamPath

    Remove-BetaFlag $steamPath
    Remove-SteamCfg $steamPath
    Reset-SteamFlags $steamPath

    Write-Host ""

    if (-not $was) {
        Write-Log WARN "First boot may take longer..."
    }

    Write-Log INFO "Launching Steam"

    Start-Process -FilePath (Join-Path $steamPath "steam.exe") -ArgumentList "-clearbeta"
}

Main

# Modify the version of the LuaTools plugin installer to keep only the fixed (LuaTools Discord .gg/luatools)
