# Windows-Backup-Synchronisation

Diese Dokumentation beschreibt die automatische Übertragung der Home-Assistant-Backups auf einen Windows-PC und die anschließende Synchronisierung mit Proton Drive.

Die Automatisierung wird über ein PowerShell-Skript und die Windows-Aufgabenplanung ausgeführt.

## Lokale Ordnerstruktur

Für die Home-Assistant-Sicherung wird folgende lokale Ordnerstruktur verwendet:

```text
C:\PC Sicherungen\HomeAssistant\
├── Backup\
└── Skripte\
    ├── home-assistant-backup.ps1
    └── config.ps1
```

Der Ordner `Backup` enthält die von Home Assistant übernommenen `.tar`-Backups.

Im Ordner `Skripte` befinden sich das eigentliche PowerShell-Skript und die lokale Konfigurationsdatei.

## Windows-Anmeldeinformationen

Die Zugangsdaten für die Samba-Freigabe von Home Assistant werden im **Windows-Anmeldeinformationsmanager** hinterlegt.

Dabei werden gespeichert:

- die lokale IPv4-Adresse von Home Assistant als Netzwerkadresse
- der separat für Samba share angelegte Benutzername
- das zugehörige Samba-Passwort

Dadurch kann das PowerShell-Skript auf die Samba-Freigabe zugreifen, ohne selbst Zugangsdaten enthalten zu müssen.

Eine dauerhaft eingebundene Netzwerkfreigabe beziehungsweise ein Netzlaufwerk ist nicht erforderlich.

## PowerShell-Skript

Die Sicherung wird durch das Skript `home-assistant-backup.ps1` durchgeführt.

Das Skript übernimmt folgende Aufgaben:

1. lokale Konfiguration laden
2. benötigte Windows-Komponenten laden
3. Windows-Benachrichtigung zum Start anzeigen
4. Samba-Freigabe auf Erreichbarkeit prüfen
5. bei Bedarf die Verbindung zur Samba-Freigabe neu herstellen
6. lokale Backups löschen, die älter als 90 Tage sind
7. aktuelle Home-Assistant-Backups mit Robocopy kopieren
8. Ergebnis von Robocopy prüfen
9. Home Assistant über die erfolgreiche Sicherung informieren
10. Windows-Benachrichtigung über den erfolgreichen Abschluss anzeigen

Das im Repository bereitgestellte Skript befindet sich unter `skripte/windows/home-assistant-backup.ps1`.

## Private Konfiguration

Systemspezifische Werte werden nicht direkt im eigentlichen PowerShell-Skript gespeichert.

Dafür wird die separate Datei `config.ps1` verwendet.

Sie enthält die lokale Home-Assistant-Adresse sowie die vollständige Webhook-URL.

Das PowerShell-Skript lädt diese Datei beim Start.

Im Repository wird lediglich eine Vorlage unter `skripte/windows/config.example.ps1` bereitgestellt.

Diese kann lokal kopiert, in `config.ps1` umbenannt und anschließend mit den eigenen Werten ergänzt werden.

## Prüfung der Samba-Freigabe

Bevor lokale Backups aufgrund der Aufbewahrungsfrist gelöscht werden, prüft das Skript zunächst den Zugriff auf die Samba-Freigabe.

Ist der erste Zugriff nicht möglich, wird eine möglicherweise bestehende Windows-Verbindung zu Home Assistant getrennt. Nach einer kurzen Wartezeit wird erneut versucht, auf die Freigabe zuzugreifen.

Windows verwendet dabei die im Windows-Anmeldeinformationsmanager hinterlegten Zugangsdaten.

Schlägt auch der zweite Zugriffsversuch fehl, wird die Sicherung abgebrochen.

Es werden in diesem Fall weder alte lokale Backups gelöscht noch neue Backups kopiert.

Zusätzlich wird eine Windows-Fehlerbenachrichtigung angezeigt.

## Lokale Aufbewahrung

Backups auf dem Windows-PC werden 90 Tage aufbewahrt.

Nach erfolgreicher Prüfung der Samba-Freigabe sucht das PowerShell-Skript im lokalen Backup-Verzeichnis nach `.tar`-Dateien, deren Änderungsdatum mehr als 90 Tage zurückliegt.

Diese Dateien werden entfernt.

Die Bereinigung findet bewusst vor dem anschließenden Kopiervorgang statt, jedoch erst nachdem die Erreichbarkeit der Home-Assistant-Freigabe erfolgreich geprüft wurde.

## Kopieren mit Robocopy

Die eigentliche Übertragung der Backup-Dateien erfolgt mit **Robocopy**.

Kopiert werden ausschließlich Dateien mit der Endung `.tar`.

Für Wiederholungsversuche werden die Optionen `/R:3` und `/W:5` verwendet.

`/R:3` begrenzt die Anzahl der Wiederholungsversuche bei einem fehlerhaften Kopiervorgang auf drei.

`/W:5` legt eine Wartezeit von fünf Sekunden zwischen den Wiederholungsversuchen fest.

Auf eine Spiegelung mit `/MIR` wird bewusst verzichtet.

Dadurch werden Backups, die aufgrund der kürzeren Aufbewahrung bereits aus Home Assistant entfernt wurden, nicht automatisch auch vom Windows-PC gelöscht.

### Robocopy-Exit-Codes

Robocopy verwendet eigene Exit-Codes.

Das PowerShell-Skript wertet deshalb den von Robocopy zurückgegebenen Exit-Code aus.

Exit-Codes von `0` bis `7` werden nicht als fehlgeschlagener Kopiervorgang behandelt.

Ab Exit-Code `8` wird der Sicherungsvorgang als fehlgeschlagen gewertet.

In diesem Fall wird eine Windows-Fehlerbenachrichtigung angezeigt und das Skript mit dem entsprechenden Exit-Code beendet.

## Windows-Benachrichtigungen

Das PowerShell-Skript verwendet Windows-Benachrichtigungen, um den angemeldeten Benutzer über den Sicherungsvorgang zu informieren.

Eine Benachrichtigung wird angezeigt:

- beim Start der Sicherung
- wenn die Samba-Freigabe auch nach dem erneuten Verbindungsversuch nicht erreichbar ist
- wenn Robocopy den Kopiervorgang nicht erfolgreich abschließen konnte
- nach erfolgreichem Abschluss der Sicherung

Für die Benachrichtigungen wird `System.Windows.Forms.NotifyIcon` verwendet.

Die benötigte Assembly wird bereits vor der Definition der Benachrichtigungsfunktion geladen.

Dies ist insbesondere bei der Ausführung über die Windows-Aufgabenplanung relevant, da dort eine neue PowerShell-Sitzung ohne bereits zuvor geladene Komponenten gestartet wird.

## Rückmeldung an Home Assistant

Nach einem erfolgreichen Kopiervorgang meldet das PowerShell-Skript den Erfolg an Home Assistant zurück.

Dadurch kann Home Assistant den Zeitpunkt der letzten erfolgreichen Windows-Sicherung speichern.

### Helfer erstellen

In Home Assistant wurde ein Helfer vom Typ **Datum und/oder Uhrzeit** angelegt.

Verwendete Konfiguration:

| Einstellung | Konfiguration |
| --- | --- |
| Name | `Letzte Windows-Sicherung` |
| Typ | Datum und Uhrzeit |
| Entity-ID | `input_datetime.letzte_windows_sicherung` |

Der Helfer speichert Datum und Uhrzeit der letzten erfolgreichen Übertragung auf den Windows-PC.

### Automation erstellen

Für die Aktualisierung des Helfers wurde in Home Assistant die Automation `Aktualisierung Windows-Sicherung Zeitstempel` angelegt.

Als Auslöser wird ein **Webhook** verwendet.

Die Webhook-ID wird von Home Assistant erzeugt.

Als Aktion setzt die Automation Datum und Uhrzeit des Helfers `input_datetime.letzte_windows_sicherung` auf den aktuellen Zeitpunkt.

Dafür wird in der Automation `{{ now() }}` verwendet.

Die im Repository bereitgestellte YAML-Konfiguration der Automation befindet sich unter `skripte/home-assistant/automationen/aktualisierung-windows-sicherung-zeitstempel.yaml`.

Die veröffentlichte YAML-Datei enthält keine tatsächliche Webhook-ID. Ein entsprechender Platzhalter muss bei der Verwendung durch die eigene Webhook-ID ersetzt werden.

### Webhook im PowerShell-Skript

Die von Home Assistant bereitgestellte vollständige Webhook-URL wird über die Kopierfunktion von Home Assistant übernommen und in der lokalen `config.ps1` gespeichert.

Das PowerShell-Skript verwendet diese URL anschließend für einen HTTP-POST-Aufruf:

```powershell
Invoke-WebRequest `
    -UseBasicParsing `
    -Method POST `
    -Uri $HaWebhookUrl `
    -ErrorAction Stop |
    Out-Null
```

Die Webhook-Adresse wird bewusst vollständig aus der lokalen Konfiguration übernommen. Das PowerShell-Skript ergänzt selbst weder Protokoll noch Port oder andere Bestandteile der Adresse.

Dadurch wird genau die von Home Assistant bereitgestellte Adresse verwendet.

Kann der Webhook nach einem erfolgreichen Kopiervorgang nicht aufgerufen werden, wird eine Warnung ausgegeben. Das bereits erfolgreich erstellte Windows-Backup wird dadurch nicht als fehlgeschlagen behandelt.

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

Die Aufgabe wird täglich ausgeführt:

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
-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\PC Sicherungen\HomeAssistant\Skripte\home-assistant-backup.ps1"
```

Starten in: `C:\PC Sicherungen\HomeAssistant\Skripte`

`-NoProfile` verhindert das Laden eines persönlichen PowerShell-Profils.

`-WindowStyle Hidden` startet die PowerShell-Sitzung mit ausgeblendetem Fenster. Beim Start kann das Fenster beziehungsweise dessen Eintrag kurz sichtbar sein und verschwindet anschließend wieder.

`-File` gibt das auszuführende PowerShell-Skript an.

### Bedingungen

Für die Aufgabe sind keine zusätzlichen Bedingungen aktiviert.

Insbesondere besteht keine Abhängigkeit von:

- Leerlauf des Computers
- Netzbetrieb
- automatischem Aufwecken des Computers
- einer in der Aufgabenplanung definierten Netzwerkbedingung

### Weitere Einstellungen

Folgende Einstellungen werden verwendet:

| Einstellung | Konfiguration |
| --- | --- |
| Ausführung bei Bedarf zulassen | Aktiviert |
| Aufgabe nach verpasstem Start so bald wie möglich ausführen | Aktiviert |
| Bei Fehler neu starten | Deaktiviert |
| Aufgabe beenden, falls Ausführung länger als | 1 Stunde |
| Beenden erzwingen, falls erforderlich | Aktiviert |
| Aufgabe ohne weiteren Zeitplan löschen | Deaktiviert |
| Bei bereits laufender Aufgabe | Keine neue Instanz starten |

Dadurch wird insbesondere verhindert, dass mehrere Instanzen des Backup-Skripts gleichzeitig ausgeführt werden.

## Proton Drive

Der lokale Home-Assistant-Ordner befindet sich innerhalb der Ordnerstruktur `C:\PC Sicherungen`.

Dieser Ordner wird mit der offiziellen **Proton Drive Windows-App** über die Funktion **„Mein Computer“** synchronisiert.

Damit wird ein bereits vorhandener lokaler Ordner synchronisiert. Die Home-Assistant-Backups müssen nicht direkt in den regulären Proton-Drive-Ordner geschrieben werden.

Nach der erfolgreichen Übertragung auf den Windows-PC übernimmt die Proton-Drive-Anwendung die weitere Synchronisierung.

Home Assistant und das PowerShell-Skript benötigen dafür keine Zugangsdaten zum Proton-Konto.

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
- Synchronisierung des lokalen Home-Assistant-Backup-Ordners mit Proton Drive über „Mein Computer“

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
