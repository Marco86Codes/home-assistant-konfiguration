
# Windows-Backup-Synchronisation

Diese Dokumentation beschreibt die technische Einrichtung der automatischen Übertragung von Home-Assistant-Backups auf einen Windows-PC und die anschließende Synchronisierung mit Proton Drive.

Die Übertragung erfolgt über ein PowerShell-Skript, das durch die Windows-Aufgabenplanung gestartet wird.

## Lokale Ordnerstruktur

Für die Home-Assistant-Sicherung wird folgende lokale Ordnerstruktur verwendet:

```text
<BACKUP-BASISPFAD>\HomeAssistant\
├── Backup\
└── Skripte\
    ├── home-assistant-backup.ps1
    └── config.ps1
```

Der Ordner `Backup` enthält die von Home Assistant übernommenen `.tar`-Backups.

Im Ordner `Skripte` befinden sich das PowerShell-Skript und die lokale Konfigurationsdatei.

## Windows-Anmeldeinformationen

Die Zugangsdaten für die Samba-Freigabe von Home Assistant werden im **Windows-Anmeldeinformationsmanager** hinterlegt.

Dabei werden gespeichert:

- die lokale IPv4-Adresse von Home Assistant als Netzwerkadresse
- der separat für Samba share angelegte Benutzername
- das zugehörige Samba-Passwort

Dadurch kann das PowerShell-Skript auf die Samba-Freigabe zugreifen, ohne selbst Zugangsdaten enthalten zu müssen.

Eine dauerhaft eingebundene Netzwerkfreigabe beziehungsweise ein Netzlaufwerk ist nicht erforderlich.

## PowerShell-Skript

Die Sicherung wird durch `home-assistant-backup.ps1` durchgeführt.

Das Skript übernimmt folgende Aufgaben:

1. Lokale Konfiguration und benötigte Windows-Komponenten laden
2. Windows-Benachrichtigung zum Start anzeigen
3. Samba-Freigabe auf Erreichbarkeit prüfen und bei Bedarf die Verbindung neu herstellen
4. Lokale Backups löschen, die älter als 90 Tage sind
5. Home-Assistant-Backups mit Robocopy kopieren
6. Robocopy-Ergebnis prüfen
7. Home Assistant über den erfolgreichen Kopierlauf informieren
8. Windows-Benachrichtigung über den Abschluss anzeigen

Die technischen Einzelheiten sind im PowerShell-Skript selbst dokumentiert.

## Private Konfiguration

Systemspezifische Werte werden nicht direkt im PowerShell-Skript gespeichert.

Dafür wird die separate Datei `config.ps1` verwendet.

Sie enthält:

- die lokale IPv4-Adresse von Home Assistant
- die vollständige Webhook-URL

Das PowerShell-Skript lädt diese Datei beim Start aus seinem eigenen Verzeichnis.

Im Repository wird lediglich die Vorlage `config.example.ps1` bereitgestellt.

Diese wird lokal kopiert, in `config.ps1` umbenannt und anschließend mit den eigenen Werten ergänzt.

## Prüfung der Samba-Freigabe

Vor dem Löschen alter lokaler Backups prüft das PowerShell-Skript den Zugriff auf die Samba-Freigabe.

Ist der erste Zugriff nicht möglich, wird eine möglicherweise bestehende Windows-Verbindung zu Home Assistant getrennt.

Nach einer Wartezeit von zwei Sekunden wird der Zugriff erneut geprüft.

Windows verwendet dabei die im **Windows-Anmeldeinformationsmanager** hinterlegten Zugangsdaten.

Schlägt auch der zweite Zugriffsversuch fehl, wird die Sicherung abgebrochen.

In diesem Fall werden weder alte lokale Backups gelöscht noch neue Backups kopiert.

Zusätzlich wird eine Windows-Fehlerbenachrichtigung angezeigt.

## Lokale Aufbewahrung

Das PowerShell-Skript sucht im lokalen Backup-Verzeichnis nach `.tar`-Dateien, deren Änderungsdatum mehr als 90 Tage zurückliegt.

Diese Dateien werden nach erfolgreicher Prüfung der Samba-Freigabe und vor dem anschließenden Kopiervorgang entfernt.

Die grundsätzlichen Aufbewahrungsregeln der verschiedenen Speicherorte sind in der zentralen Backup-Dokumentation beschrieben.

## Kopieren mit Robocopy

Die Übertragung der Backup-Dateien erfolgt mit **Robocopy**.

Kopiert werden ausschließlich Dateien mit der Endung `.tar`.

Verwendete Optionen:

| Option | Bedeutung |
| --- | --- |
| `*.tar` | Ausschließlich Backup-Dateien mit der Endung `.tar` |
| `/R:3` | Drei Wiederholungsversuche bei Kopierfehlern |
| `/W:5` | Fünf Sekunden Wartezeit zwischen Wiederholungsversuchen |

Eine Spiegelung mit `/MIR` wird nicht verwendet.

### Robocopy-Exit-Codes

Robocopy verwendet eigene Exit-Codes.

Das PowerShell-Skript wertet deshalb den zurückgegebenen Exit-Code aus.

| Exit-Code | Bewertung |
| --- | --- |
| `0` bis `7` | Kein als fehlgeschlagen gewerteter Kopiervorgang |
| Ab `8` | Kopiervorgang fehlgeschlagen |

Ab Exit-Code `8` wird eine Windows-Fehlerbenachrichtigung angezeigt und das Skript mit dem entsprechenden Exit-Code beendet.

## Windows-Benachrichtigungen

Das PowerShell-Skript verwendet `System.Windows.Forms.NotifyIcon`, um den angemeldeten Windows-Benutzer über den Sicherungsvorgang zu informieren.

Benachrichtigungen erfolgen:

- beim Start der Sicherung
- wenn die Samba-Freigabe auch nach einem erneuten Verbindungsversuch nicht erreichbar ist
- wenn Robocopy den Kopiervorgang nicht erfolgreich abschließen konnte
- nach erfolgreichem Abschluss der Sicherung

Die benötigte Assembly `System.Windows.Forms` wird vor der Definition der Benachrichtigungsfunktion geladen.

Dies ist insbesondere bei der Ausführung über die Windows-Aufgabenplanung relevant, da dort eine neue PowerShell-Sitzung gestartet wird.

## Rückmeldung an Home Assistant

Nach einem erfolgreich abgeschlossenen Kopierlauf ruft das PowerShell-Skript einen Home-Assistant-Webhook auf.

Eine Automation aktualisiert daraufhin den Zeitstempel der letzten erfolgreichen Windows-Sicherung.

### Helfer erstellen

In Home Assistant wurde ein Helfer vom Typ **Datum und/oder Uhrzeit** angelegt.

Verwendete Konfiguration:

| Einstellung | Konfiguration |
| --- | --- |
| Name | `Letzte Windows-Sicherung` |
| Typ | Datum und Uhrzeit |
| Entity-ID | `input_datetime.letzte_windows_sicherung` |

Der Helfer speichert Datum und Uhrzeit des letzten erfolgreich abgeschlossenen Windows-Sicherungslaufs.

### Automation erstellen

Für die Aktualisierung des Helfers wurde die Automation `Aktualisierung Windows-Sicherung Zeitstempel` angelegt.

Verwendete Konfiguration:

| Einstellung | Konfiguration |
| --- | --- |
| Auslöser | Webhook |
| Erlaubte Methoden | `POST`, `PUT` |
| Lokaler Zugriff | Aktiviert |
| Aktion | `input_datetime.set_datetime` |
| Ziel | `input_datetime.letzte_windows_sicherung` |
| Datum und Uhrzeit | `{{ now() }}` |
| Modus | `single` |

Die Automation verwendet eine individuelle Webhook-ID.

Die YAML-Datei dient als technische Referenz für die tatsächlich eingerichtete Automation.

### Webhook im PowerShell-Skript

Die von Home Assistant bereitgestellte vollständige Webhook-URL wird über die Kopierfunktion von Home Assistant übernommen und in der lokalen `config.ps1` gespeichert.

Das PowerShell-Skript verwendet diese URL für einen HTTP-POST-Aufruf:

```powershell
Invoke-WebRequest `
    -UseBasicParsing `
    -Method POST `
    -Uri $HaWebhookUrl `
    -ErrorAction Stop |
    Out-Null
```

Die Webhook-Adresse wird vollständig aus der lokalen Konfiguration übernommen.

Das PowerShell-Skript ergänzt weder Protokoll noch Port oder andere Bestandteile der Adresse.

Kann der Webhook nach einem erfolgreichen Kopierlauf nicht aufgerufen werden, wird eine Warnung ausgegeben.

Die Windows-Sicherung wird dadurch nicht nachträglich als fehlgeschlagen behandelt.

## Windows-Aufgabenplanung

Das PowerShell-Skript wird automatisch über die Windows-Aufgabenplanung gestartet.

Verwendete Aufgabe: `Home-Assistant-Backup`

Beschreibung:

> Kopiert Home-Assistant-Backups auf den Windows-PC und aktualisiert anschließend den Zeitstempel in Home Assistant.

### Allgemeine Einstellungen

| Einstellung | Konfiguration |
| --- | --- |
| Ausführung | Nur ausführen, wenn Benutzer angemeldet ist |
| Mit höchsten Privilegien ausführen | Deaktiviert |
| Konfigurieren für | Windows 10 |

Die Ausführung bei angemeldetem Benutzer ermöglicht die Anzeige der Windows-Benachrichtigungen.

### Trigger

| Einstellung | Konfiguration |
| --- | --- |
| Zeitplan | Täglich |
| Uhrzeit | 18:00 Uhr |
| Wiederholung | Keine |
| Aktiviert | Ja |

### Aktion

Als Programm wird `powershell.exe` verwendet.

Argumente:

```text
-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "<BACKUP-BASISPFAD>\HomeAssistant\Skripte\home-assistant-backup.ps1"
```

Starten in: <BACKUP-BASISPFAD>\HomeAssistant\Skripte

Verwendete Parameter:

| Parameter | Bedeutung |
| --- | --- |
| `-NoProfile` | Verhindert das Laden des persönlichen PowerShell-Profils |
| `-WindowStyle Hidden` | Startet PowerShell mit ausgeblendetem Fenster |
| `-ExecutionPolicy Bypass` | Umgeht die Ausführungsrichtlinie für diesen PowerShell-Prozess |
| `-File` | Gibt das auszuführende PowerShell-Skript an |

Beim Start kann das PowerShell-Fenster beziehungsweise dessen Eintrag kurz sichtbar sein und verschwindet anschließend wieder.

### Bedingungen

Für die Aufgabe sind keine zusätzlichen Bedingungen aktiviert.

Insbesondere besteht keine Abhängigkeit von:

- Leerlauf des Computers
- Netzbetrieb
- automatischem Aufwecken des Computers
- einer in der Aufgabenplanung definierten Netzwerkbedingung

### Weitere Einstellungen

| Einstellung | Konfiguration |
| --- | --- |
| Ausführung bei Bedarf zulassen | Aktiviert |
| Aufgabe nach verpasstem Start so bald wie möglich ausführen | Aktiviert |
| Bei Fehler neu starten | Deaktiviert |
| Aufgabe beenden, falls Ausführung länger als | 1 Stunde |
| Beenden erzwingen, falls erforderlich | Aktiviert |
| Aufgabe ohne weiteren Zeitplan löschen | Deaktiviert |
| Bei bereits laufender Aufgabe | Keine neue Instanz starten |

Damit wird insbesondere verhindert, dass mehrere Instanzen des Backup-Skripts gleichzeitig durch die Aufgabenplanung gestartet werden.

## Proton Drive

Der lokale Sicherungsordner HomeAssistant befindet sich unterhalb des für die Synchronisierung mit Proton Drive ausgewählten Basisverzeichnisses.

Dieser Ordner wird mit der offiziellen **Proton Drive Windows-App** über die Funktion **„Mein Computer“** synchronisiert.

Damit wird ein bereits vorhandener lokaler Ordner synchronisiert.

Nach der erfolgreichen Übertragung auf den Windows-PC übernimmt die Proton-Drive-Anwendung die weitere Synchronisierung.

Für diese Synchronisierung benötigt das PowerShell-Skript keine Zugangsdaten zum Proton-Konto.

## Getestetes Verhalten

Die Backup-Automatisierung wurde mit den für den Betrieb relevanten Fällen getestet.

Erfolgreich geprüft wurden:

- Zugriff auf die Samba-Freigabe mit den im Windows-Anmeldeinformationsmanager gespeicherten Zugangsdaten
- erneuter Verbindungsversuch nach fehlgeschlagenem ersten Zugriff
- Abbruch bei nicht erreichbarer Samba-Freigabe
- kein Löschen lokaler Backups bei nicht erreichbarer Samba-Freigabe
- Erkennung und Löschung einer Testdatei außerhalb der 90-Tage-Aufbewahrung
- Kopieren der Home-Assistant-Backups mit Robocopy
- Auswertung des Robocopy-Exit-Codes
- Windows-Benachrichtigung beim Start
- Windows-Benachrichtigung nach erfolgreichem Abschluss
- Windows-Fehlerbenachrichtigung
- Aktualisierung des Home-Assistant-Zeitstempels über den Webhook
- automatische Ausführung über die Windows-Aufgabenplanung
- Ausführung von PowerShell mit ausgeblendetem Fenster
- Synchronisierung des lokalen Home-Assistant-Backup-Ordners mit Proton Drive über **„Mein Computer“**

## Nützliche Links & Quellen

- [Microsoft – Anmeldeinformations-Manager in Windows](https://support.microsoft.com/de-de/windows/security/credential-manager-in-windows)
- [Microsoft Learn – about_PowerShell_exe](https://learn.microsoft.com/de-de/powershell/module/microsoft.powershell.core/about/about_powershell_exe?view=powershell-5.1)
- [Microsoft Learn – Robocopy](https://learn.microsoft.com/de-de/windows-server/administration/windows-commands/robocopy)
- [Microsoft Learn – Schtasks.exe / Aufgabenplanung](https://learn.microsoft.com/de-de/windows/win32/taskschd/schtasks)
- [Proton – Ordner mit der Proton Drive Windows-App synchronisieren](https://proton.me/de/support/proton-drive-windows-sync-folder)

## 🔗 Verwendung & Verknüpfungen

- [Backups](../../grundlagen/backups.md) – übergeordnete Backup-Strategie
- [Beispielkonfiguration](../../skripte/windows/config.example.ps1) – Vorlage für die lokale Konfiguration des PowerShell-Skripts
- [DHCP-Zuweisungen in der Freebox](../freebox/dhcp-zuweisungen.md) – feste lokale Adressen der beteiligten Geräte
- [Home-Assistant-Automation](../../skripte/home-assistant/automationen/aktualisierung-windows-sicherung-zeitstempel.yaml) – aktualisiert den Zeitstempel der letzten erfolgreichen Windows-Sicherung
- [PowerShell-Skript](../../skripte/windows/home-assistant-backup.ps1) – führt die Windows-Backup-Synchronisation aus
- [Samba share](../../apps/samba-share.md) – Bereitstellung des Home-Assistant-Backup-Verzeichnisses

---

[⬅️ Zurück zur Übersicht](../../README.md)
