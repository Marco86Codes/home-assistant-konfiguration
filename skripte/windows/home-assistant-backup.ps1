# Home-Assistant-Backup
# Erstellt eine zusätzliche lokale Kopie der Home-Assistant-Backups.
#
# Ablauf:
# 1. Lokale Konfiguration laden
# 2. Benötigte Windows-Komponenten laden
# 3. Windows-Benachrichtigung zum Start anzeigen
# 4. Samba share auf Erreichbarkeit prüfen
# 5. Bei Bedarf Verbindung zur Samba-Freigabe neu herstellen
# 6. Lokale Backups älter als 90 Tage löschen
# 7. Aktuelle Home-Assistant-Backups mit Robocopy kopieren
# 8. Robocopy-Ergebnis prüfen
# 9. Home Assistant über die erfolgreiche Sicherung informieren
# 10. Windows-Benachrichtigung über den erfolgreichen Abschluss anzeigen

# ------------------------------------------------------------
# Lokale Konfiguration laden
# ------------------------------------------------------------

$ConfigDatei = Join-Path $PSScriptRoot "config.ps1"

if (-not (Test-Path $ConfigDatei)) {
    Write-Host "FEHLER: Die lokale Konfigurationsdatei config.ps1 wurde nicht gefunden."
    exit 1
}

. $ConfigDatei

$HaShare = "\\$HaServer\backup"
$BackupZiel = "C:\PC Sicherungen\HomeAssistant\Backup"
$AufbewahrungTage = 90

# ------------------------------------------------------------
# Benötigte Windows-Komponenten laden
# ------------------------------------------------------------

try {
    Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
}
catch {
    Write-Host "FEHLER: System.Windows.Forms konnte nicht geladen werden."
    Write-Host $_.Exception.Message
    exit 1
}

# ------------------------------------------------------------
# Windows-Benachrichtigung
# ------------------------------------------------------------

function Show-BackupNotification {
    param (
        [string]$Titel,
        [string]$Text,
        [System.Windows.Forms.ToolTipIcon]$Symbol = [System.Windows.Forms.ToolTipIcon]::Info
    )

    try {
        $Benachrichtigung = New-Object System.Windows.Forms.NotifyIcon
        $Benachrichtigung.Icon = [System.Drawing.SystemIcons]::Information
        $Benachrichtigung.BalloonTipTitle = $Titel
        $Benachrichtigung.BalloonTipText = $Text
        $Benachrichtigung.BalloonTipIcon = $Symbol
        $Benachrichtigung.Visible = $true

        $Benachrichtigung.ShowBalloonTip(5000)

        Start-Sleep -Seconds 6

        $Benachrichtigung.Dispose()
    }
    catch {
        Write-Host "Hinweis: Windows-Benachrichtigung konnte nicht angezeigt werden."
    }
}

# ------------------------------------------------------------
# Start
# ------------------------------------------------------------

Write-Host "Home-Assistant-Backup wird gestartet."
Write-Host ""

Show-BackupNotification `
    -Titel "Home-Assistant-Backup" `
    -Text "Sicherung wurde gestartet."

# ------------------------------------------------------------
# Samba share prüfen
# ------------------------------------------------------------

Write-Host "Prüfe Samba share..."

try {
    Get-ChildItem -Path $HaShare -ErrorAction Stop | Out-Null
    Write-Host "Samba share ist erreichbar."
}
catch {
    Write-Host "Erster Zugriff fehlgeschlagen."
    Write-Host "Versuche, die Verbindung zur Samba-Freigabe neu herzustellen..."

    cmd /c "net use \\$HaServer\IPC$ /delete /y" 2>$null | Out-Null

    Start-Sleep -Seconds 2

    try {
        Get-ChildItem -Path $HaShare -ErrorAction Stop | Out-Null
        Write-Host "Verbindung zur Samba-Freigabe wurde erfolgreich neu hergestellt."
    }
    catch {
        Write-Host "FEHLER: Samba share ist auch nach einem erneuten Verbindungsversuch nicht erreichbar."
        Write-Host $_.Exception.Message

        Show-BackupNotification `
            -Titel "Home-Assistant-Backup – Fehler" `
            -Text "Sicherung konnte nicht durchgeführt werden. Samba share ist nicht erreichbar." `
            -Symbol ([System.Windows.Forms.ToolTipIcon]::Error)

        exit 1
    }
}

Write-Host ""

# ------------------------------------------------------------
# Alte lokale Backups löschen
# ------------------------------------------------------------

Write-Host "Prüfe lokale Backups auf ein Alter von mehr als $AufbewahrungTage Tagen..."

$AlteBackups = Get-ChildItem -Path $BackupZiel -Filter "*.tar" -File |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$AufbewahrungTage) }

if ($AlteBackups) {
    foreach ($Backup in $AlteBackups) {
        Write-Host "Lösche: $($Backup.Name)"
        Remove-Item -Path $Backup.FullName -Force
    }
}
else {
    Write-Host "Keine Backups älter als $AufbewahrungTage Tage gefunden."
}

Write-Host ""

# ------------------------------------------------------------
# Home-Assistant-Backups kopieren
# ------------------------------------------------------------

Write-Host "Kopiere Home-Assistant-Backups..."

robocopy $HaShare $BackupZiel "*.tar" /R:3 /W:5

$RobocopyExitCode = $LASTEXITCODE

Write-Host ""
Write-Host "Robocopy Exit-Code: $RobocopyExitCode"

# ------------------------------------------------------------
# Robocopy-Ergebnis auswerten
# ------------------------------------------------------------

if ($RobocopyExitCode -ge 8) {
    Write-Host "FEHLER: Der Kopiervorgang konnte nicht erfolgreich abgeschlossen werden."

    Show-BackupNotification `
        -Titel "Home-Assistant-Backup – Fehler" `
        -Text "Sicherung konnte nicht erfolgreich abgeschlossen werden." `
        -Symbol ([System.Windows.Forms.ToolTipIcon]::Error)

    exit $RobocopyExitCode
}

# ------------------------------------------------------------
# Home Assistant über erfolgreiche Sicherung informieren
# ------------------------------------------------------------

Write-Host ""
Write-Host "Aktualisiere Zeitstempel in Home Assistant..."

try {
    Invoke-WebRequest `
        -UseBasicParsing `
        -Method POST `
        -Uri $HaWebhookUrl `
        -ErrorAction Stop |
        Out-Null

    Write-Host "Zeitstempel in Home Assistant wurde aktualisiert."
}
catch {
    Write-Host "WARNUNG: Die Sicherung war erfolgreich, der Zeitstempel in Home Assistant konnte jedoch nicht aktualisiert werden."
    Write-Host $_.Exception.Message
}

# ------------------------------------------------------------
# Erfolgreich abgeschlossen
# ------------------------------------------------------------

Write-Host ""
Write-Host "Home-Assistant-Backup wurde erfolgreich abgeschlossen."

Show-BackupNotification `
    -Titel "Home-Assistant-Backup" `
    -Text "Sicherung wurde erfolgreich abgeschlossen." `
    -Symbol ([System.Windows.Forms.ToolTipIcon]::Info)

exit 0