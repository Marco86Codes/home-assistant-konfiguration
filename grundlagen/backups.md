
# Backups

Diese Dokumentation beschreibt die Backup-Strategie der Home-Assistant-Installation.

Ziel ist es, die Home-Assistant-Backups nicht ausschließlich auf dem internen Datenträger des Home-Assistant-Systems aufzubewahren, sondern zusätzliche Kopien auf einem Windows-PC und in Proton Drive vorzuhalten.

## Backup-Strategie

Die Sicherung erfolgt in mehreren voneinander getrennten Schritten:

```text
Home Assistant
    │
    │ automatisches Backup
    ▼
Lokaler Home-Assistant-Speicher
    │
    │ Samba share
    ▼
Windows-Aufgabenplanung
    │
    └── Start des PowerShell-Skripts
            │
            ├── Windows-Benachrichtigung: Sicherung gestartet
            │
            ├── Samba-Freigabe prüfen
            │       │
            │       └── Fehler → Windows-Benachrichtigung
            │                    Sicherung nicht durchgeführt
            │
            ├── lokale Backups älter als 90 Tage löschen
            │
            ├── Home-Assistant-Backups kopieren
            │       │
            │       └── Fehler → Windows-Benachrichtigung
            │                    Sicherung fehlgeschlagen
            │
            ├── erfolgreicher Kopiervorgang
            │       │
            │       └── Webhook → Home Assistant
            │                    │
            │                    └── Zeitstempel-Helfer aktualisieren
            │
            └── Windows-Benachrichtigung: Sicherung erfolgreich
                    │
                    ▼
         Lokaler Windows-Sicherungsordner
                    │
                    │ Proton Drive „Mein Computer“
                    ▼
               Proton Drive
```

Dadurch befinden sich die Backups an drei unterschiedlichen Speicherorten:

1. auf dem internen Datenträger des Home-Assistant-Systems
2. auf dem Windows-PC
3. in Proton Drive

Die einzelnen Schritte sind voneinander getrennt. Home Assistant erstellt die eigentlichen Backups, Windows übernimmt deren zusätzliche lokale Sicherung und Proton Drive synchronisiert den Windows-Sicherungsordner.

## Automatische Home-Assistant-Backups

Home Assistant erstellt automatisch tägliche Backups.

Verwendete Einstellungen:

| Einstellung | Konfiguration |
| --- | --- |
| Zeitplan | Täglich |
| Uhrzeit | Systemoptimum |
| Backup-Präferenz bei App-Updates | Backup vor dem Update |
| Aufbewahrung | Benutzerdefiniert |
| Maximal aufbewahren | 10 Backups |
| Home-Assistant-Einstellungen | Enthalten |
| Verlauf | Enthalten |
| Medien | Enthalten |
| Share-Ordner | Enthalten |

Die Backups werden lokal auf dem Home-Assistant-System gespeichert.

Die Begrenzung auf 10 automatische Backups betrifft ausschließlich die lokale Aufbewahrung in Home Assistant. Die längerfristige Aufbewahrung auf dem Windows-PC und die anschließende Synchronisierung mit Proton Drive werden davon unabhängig verwaltet.

## Verschlüsselung

Die Home-Assistant-Backups sind verschlüsselt.

Der bei der Einrichtung bereitgestellte Wiederherstellungs- beziehungsweise Verschlüsselungsschlüssel wurde separat außerhalb von Home Assistant gesichert.

> [!WICHTIG]
> Ohne den erforderlichen Schlüssel können verschlüsselte Backups im Wiederherstellungsfall unter Umständen nicht verwendet werden.

## Warum die Sicherung über Windows erfolgt

Die zusätzliche Sicherung in Proton Drive erfolgt bewusst nicht direkt aus Home Assistant.

Für die hier verwendete Backup-Lösung steht keine direkte offizielle Anbindung zwischen Home Assistant und Proton Drive zur Verfügung. Auf Drittanbieter-Lösungen wird bewusst verzichtet, insbesondere um keine Proton-Zugangsdaten oder vergleichbare sensible Anmeldeinformationen an zusätzliche Anwendungen oder Integrationen weitergeben zu müssen.

Stattdessen werden ausschließlich die dafür vorgesehenen beziehungsweise offiziellen Komponenten der beteiligten Systeme verwendet:

- Home Assistant erstellt und verwaltet die eigentlichen Backups.
- Die Home-Assistant-App **Samba share** stellt das Backup-Verzeichnis im lokalen Netzwerk bereit.
- Windows kopiert die Backups mit einem lokalen PowerShell-Skript.
- Die offizielle **Proton Drive Windows-App** synchronisiert den lokalen Sicherungsordner über **„Mein Computer“**.

Home Assistant selbst benötigt dadurch keinen Zugriff auf das Proton-Konto.

## Aufbewahrung

Für die einzelnen Speicherorte gelten unterschiedliche Aufbewahrungsregeln:

| Speicherort | Aufbewahrung |
| --- | --- |
| Home Assistant | Maximal 10 automatische Backups |
| Windows-PC | 90 Tage |
| Proton Drive | Synchronisierung des Windows-Sicherungsordners |

Die Windows-Aufbewahrung ist unabhängig von der Begrenzung in Home Assistant.

Wird ein Backup aufgrund der Begrenzung auf 10 Backups aus Home Assistant entfernt, bleibt eine bereits auf den Windows-PC kopierte Sicherung dort bis zum Ablauf ihrer eigenen 90-Tage-Aufbewahrung erhalten.

Aus diesem Grund wird keine Spiegelung verwendet, bei der auf der Quelle gelöschte Backups automatisch auch auf dem Windows-PC entfernt würden.

Die Bereinigung auf dem Windows-PC erfolgt anhand des Änderungsdatums der lokalen Backup-Dateien.

Proton Drive synchronisiert den Windows-Sicherungsordner. Die dortige Aufbewahrung ist deshalb nicht als unabhängige zusätzliche 90-Tage-Regel zu verstehen.

## Sicherheitsverhalten der Windows-Sicherung

Bevor alte lokale Sicherungen entfernt werden, prüft das PowerShell-Skript, ob die Samba-Freigabe von Home Assistant erreichbar ist.

Ist sie nicht erreichbar, versucht das Skript zunächst, die Verbindung zur Samba-Freigabe neu herzustellen.

Schlägt auch dieser Versuch fehl, wird der Sicherungsvorgang abgebrochen.

Dadurch werden keine lokalen Backups aufgrund der 90-Tage-Regel gelöscht, wenn Home Assistant beziehungsweise dessen Backup-Freigabe nicht erreichbar ist.

Beim Start, bei einem Abbruch aufgrund einer nicht erreichbaren Freigabe, bei einem fehlgeschlagenen Kopiervorgang und nach erfolgreichem Abschluss informiert das Skript den angemeldeten Windows-Benutzer über entsprechende Benachrichtigungen.

Eine fehlgeschlagene Übertragung wird nicht als erfolgreiche Sicherung an Home Assistant zurückgemeldet.

## Überwachung in Home Assistant

Nach einem erfolgreich abgeschlossenen Kopierlauf meldet das PowerShell-Skript das Ergebnis über einen Webhook an Home Assistant zurück.

Eine Home-Assistant-Automation aktualisiert daraufhin den Helfer `input_datetime.letzte_windows_sicherung`.

Der Helfer enthält dadurch Datum und Uhrzeit des letzten erfolgreich abgeschlossenen Windows-Sicherungslaufs.

Ein erfolgreicher Kopierlauf bedeutet nicht zwingend, dass neue Backup-Dateien übertragen wurden. Auch wenn bereits alle Dateien vorhanden sind und kein Kopierfehler festgestellt wird, kann der Zeitstempel aktualisiert werden.

Der Helfer enthält dadurch Datum und Uhrzeit der letzten erfolgreichen Windows-Sicherung.

Der Zeitpunkt wird im Netzwerk-Dashboard angezeigt.

Kann nur die Rückmeldung an Home Assistant nicht ausgeführt werden, bleibt die erfolgreich abgeschlossene Windows-Sicherung davon unberührt. Das PowerShell-Skript gibt in diesem Fall eine Warnung aus.

### Template-Sensoren für die Backup-Anzeige

Für die Darstellung der Backup-Zeitpunkte werden drei Template-Sensoren verwendet.

| Sensor | Verwendung |
|---|---|
| `sensor.backup_last_successful_automatic_backup_anzeige` | Letztes erfolgreiches automatisches Home-Assistant-Backup |
| `sensor.letzte_windows_sicherung_anzeige` | Letzte erfolgreiche Windows-Sicherung |
| `sensor.backup_next_scheduled_automatic_backup_anzeige` | Nächstes geplantes automatisches Home-Assistant-Backup |

Die Template-Sensoren bereiten die vorhandenen Zeitangaben im Format `TT.MM.JJJJ HH:MM` auf. Ist der jeweilige Ausgangswert nicht verfügbar, wird `Unbekannt` angezeigt.

Die Sensoren sind direkt in der `configuration.yaml` definiert. Ihre YAML-Konfiguration ist separat im Repository dokumentiert.

## Wiederherstellung

Abhängig vom jeweiligen Ausfallszenario kann für eine Wiederherstellung eine Sicherung verwendet werden, die sich

- auf dem Home-Assistant-System,
- auf dem Windows-PC oder
- in Proton Drive

befindet.

Die konkrete Wiederherstellung richtet sich nach dem jeweiligen Fehlerfall und der zu diesem Zeitpunkt aktuellen Home-Assistant-Version.

Bei verschlüsselten Backups muss der erforderliche Wiederherstellungs- beziehungsweise Verschlüsselungsschlüssel verfügbar sein.

## Nützliche Links & Quellen

- [Home Assistant – Backups](https://www.home-assistant.io/common-tasks/general/backups/)

## 🔗 Verwendung & Verknüpfungen

- [Backup-Template-Sensoren](../skripte/home-assistant/sensoren/backup_anzeige.yaml) – Aufbereitung der Backup-Zeitpunkte
- [Dashboard – Netzwerk](dashboard_netzwerk.md) – Anzeige und Überwachung der letzten erfolgreichen Windows-Sicherung
- [Samba share](../apps/samba-share.md) – Bereitstellung des Home-Assistant-Backup-Verzeichnisses im lokalen Netzwerk
- [Windows-Backup-Synchronisation](../externe-systeme/windows/backup-synchronisation.md) – technische Einrichtung der automatischen Windows-Sicherung und Synchronisierung mit Proton Drive

---

[⬅️ Zurück zur Übersicht](../README.md)
