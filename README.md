# Home Assistant Konfiguration

Dokumentation und Konfiguration meiner persönlichen Home-Assistant-Installation.

Dieses Repository dokumentiert den Aufbau meines Smart Homes mit Home Assistant. Neben der eigentlichen Konfiguration werden verwendete Apps, Integrationen, Automationen, eingesetzte Hardwarekomponenten und besondere technische Lösungen dokumentiert.

## System

- **Home Assistant:** Home Assistant OS
- **Plattform:** Generic x86-64
- **Hardware:** Lenovo ThinkCentre M715q Gen 2

## Dokumentation

### Grundlagen

- [Backups](grundlagen/backups.md) – Backup-Strategie und Aufbewahrung der Home-Assistant-Backups

### Apps

- [Samba share](apps/samba-share.md) – Bereitstellung des Backup-Verzeichnisses im lokalen Netzwerk

### Externe Systeme

- [Windows-Backup-Synchronisation](externe-systeme/windows/backup-synchronisation.md) – automatische Übertragung der Backups auf einen Windows-PC und Synchronisierung mit Proton Drive
- [DHCP-Zuweisungen in der Freebox](externe-systeme/freebox/dhcp-zuweisungen.md) – feste DHCP-Zuweisungen für die beteiligten Netzwerkgeräte

## Skripte und Konfigurationen

### Windows

- [PowerShell-Skript](skripte/windows/home-assistant-backup.ps1) – führt die Windows-Backup-Synchronisation aus
- [Beispielkonfiguration](skripte/windows/config.example.ps1) – Vorlage für die lokale Konfiguration des PowerShell-Skripts

### Home Assistant

- [Automation zur Aktualisierung des Windows-Sicherungszeitstempels](skripte/home-assistant/automationen/aktualisierung-windows-sicherung-zeitstempel.yaml) – aktualisiert den Zeitpunkt der letzten erfolgreichen Windows-Sicherung

## Dokumentationsprinzip

Die Dokumentation bildet die tatsächlich eingesetzte Home-Assistant-Konfiguration ab.

Allgemeine Installations- und Konfigurationsschritte werden möglichst nicht dupliziert. Wenn Home Assistant oder ein anderes Projekt eine entsprechende offizielle Dokumentation bereitstellt, wird auf diese verwiesen.

Eigene Dokumentationen konzentrieren sich insbesondere auf:

- die verwendete Konfiguration
- eingesetzte Hardwarekomponenten
- individuelle Einstellungen und Entscheidungen
- Abweichungen von Standardeinstellungen
- Verknüpfungen zwischen Komponenten
- eigene Problemlösungen

Dadurch soll die Dokumentation möglichst übersichtlich und unabhängig von Änderungen an der Home-Assistant-Benutzeroberfläche bleiben.

## Hinweise

Die in dieser Dokumentation genannten Software- und Hardwareprodukte sowie Marken und Hersteller dienen ausschließlich der Information und Veranschaulichung. Ihre Nennung stellt keine Werbung oder ausdrückliche Empfehlung dar. Für die Nennung oder Darstellung der aufgeführten Produkte, Hersteller und Dienste erhalte ich keine Vergütung oder sonstige Gegenleistung.

Die Auswahl und Verwendung von Software und Hardware sollte grundsätzlich den individuellen Anforderungen hinsichtlich Sicherheit, Kompatibilität, Funktionsumfang und Budget entsprechen.

Die Verantwortung für die Auswahl, Installation und Verwendung der jeweiligen Produkte liegt beim Anwender.

Die hier bereitgestellten Konfigurationen und Anleitungen beziehen sich auf meine persönliche Home-Assistant-Installation und können nicht ohne Prüfung auf andere Systeme übertragen werden.

Zugangsdaten, Passwörter, API-Schlüssel und andere vertrauliche Informationen sind nicht Bestandteil der veröffentlichten Konfiguration.