
# Home Assistant Konfiguration

Dokumentation und Konfiguration meiner persönlichen Home-Assistant-Installation.

Dieses Repository dokumentiert den Aufbau meines Smart Homes mit Home Assistant. Neben der eigentlichen Konfiguration werden verwendete Apps, Integrationen, Automationen, eingesetzte Hardwarekomponenten und besondere technische Lösungen dokumentiert.

## System

- **Home Assistant:** Home Assistant OS
- **Plattform:** Generic x86-64
- **Hardware:** Lenovo ThinkCentre M715q Gen 2
- [Hardware & Geräte](hardware.md) – Übersicht der eingebundenen Hardware und ihrer Einbindungsart

## Dokumentation

### Grundlagen

- [Anwesenheitserkennung](grundlagen/anwesenheitserkennung.md) – Standortbasierte Anwesenheitserkennung über OwnTracks und zentrale Anwesenheits-Helfer
- [Backups](grundlagen/backups.md) – Backup-Strategie und Aufbewahrung der Home-Assistant-Backups
- [Dashboard](grundlagen/dashboard.md) – Übersicht der Dashboard-Ansichten
- [Dashboard – Netzwerk](grundlagen/dashboard_netzwerk.md) – Überwachung von Netzwerkgeräten und Backup-Status
- [Dashboard – Solar](grundlagen/dashboard-solar.md) – Visualisierung der Solaranlage, Statusanzeigen und Energieflüsse
- [Home-Assistant-Konfiguration](grundlagen/konfiguration.md) – Aufbau der `configuration.yaml`, YAML-Einbindungen und Home-Assistant-Packages
- [Solarsteuerung](grundlagen/solarsteuerung.md) – Dynamische AC-Leistungsregelung und wetterabhängige Mindest-SoC-Steuerung

### Apps & Integrationen

- [File editor](apps/file-editor.md) – Bearbeitung von YAML-Konfigurationsdateien, insbesondere auf Mobilgeräten
- [Freebox](apps/freebox.md) – Einbindung der Freebox zur Überwachung von Netzwerkgeräten
- [Mosquitto broker](apps/mosquitto-broker.md) – Zentraler MQTT-Broker für die Kommunikation zwischen MQTT-Komponenten
- [MQTT](apps/mqtt.md) – Home-Assistant-Integration für die MQTT-Kommunikation
- [OwnTracks](apps/own-tracks.md) – Einrichtung der OwnTracks-Integration für die Standortübertragung
- [Samba share](apps/samba-share.md) – Bereitstellung des Backup-Verzeichnisses im lokalen Netzwerk
- [Shelly](apps/shelly.md) – Einbindung des Shelly 3EM zur Messung der Netzleistung
- [Studio Code Server](apps/studio-code-server.md) – Bearbeitung und Verwaltung der Home-Assistant-Konfiguration im Browser
- [Zendure](apps/zendure.md) – Einbindung der SolarFlow 800 Plus mit lokaler MQTT-Kommunikation
- [Zigbee2MQTT](apps/zigbee2mqtt.md) – Einbindung von Zigbee-Geräten über MQTT

### Dashboard-Tools

- [card-mod](dashboard-tools/card-mod.md) – Individuelle Gestaltung der Dashboard-Karten und farbliche Statusanzeigen
- [Config Template Card](dashboard-tools/config-template-card.md) – Dynamische Farbbereiche in den Batterie-Rundinstrumenten anhand des eingestellten und des geplanten Mindest-SoC
- [Flex Table Card](dashboard-tools/flex-table-cards.md) – Tabellarische Darstellung von Entitätsinformationen im Dashboard
- [Home Flow Card](dashboard-tools/home-flow-card.md) – Grafische Darstellung der Energieflüsse zwischen PV, Batterien, Haus und Netz

### Externe Systeme

- [DHCP-Zuweisungen in der Freebox](externe-systeme/freebox/dhcp-zuweisungen.md) – feste DHCP-Zuweisungen für die beteiligten Netzwerkgeräte
- [OwnTracks – Android](externe-systeme/mobilgeraete/own-tracks-android.md) – Konfiguration der Standortübertragung auf Android-Smartphones
- [OwnTracks – iOS](externe-systeme/mobilgeraete/own-tracks-ios.md) – Konfiguration der Standortübertragung auf iPhones
- [Windows-Backup-Synchronisation](externe-systeme/windows/backup-synchronisation.md) – automatische Übertragung der Backups auf einen Windows-PC und Synchronisierung mit Proton Drive

## Skripte und Konfigurationen

### Home Assistant

**Dashboard**

- [Dashboard](grundlagen/dashboard.md) – Allgemeiner Aufbau und Übersicht der Dashboard-Ansichten
- [Dashboard – Netzwerk](grundlagen/dashboard_netzwerk.md) – Überwachung der Netzwerkgeräte und des Backup-Status
- [Dashboard – Solar](grundlagen/dashboard-solar.md) – Überwachung der Solaranlage mit Statusanzeigen, Wetterinformationen und Energieflussdiagramm

**Automationen**

- [Aktualisierung Anwesenheit Home](skripte/home-assistant/automationen/aktualisierung-anwesenheit_home.yaml) – Aktualisiert die Anwesenheits-Helfer anhand der OwnTracks-Geräte-Tracker
- [Aktualisierung des Windows-Sicherungszeitstempels](skripte/home-assistant/automationen/aktualisierung-windows-sicherung-zeitstempel.yaml) – aktualisiert den Zeitpunkt der letzten erfolgreichen Windows-Sicherung
- [Zendure Leistungsanpassung](skripte/home-assistant/automationen/zendure-leistungsanpassung.yaml) – überträgt die berechneten AC-Sollwerte an beide Wechselrichter
- [Zendure Mindest-SoC Berechnung](skripte/home-assistant/automationen/zendure-mindest-soc-berechnung.yaml) – berechnet die geplanten Mindest-SoC-Werte anhand der Wetterprognose
- [Zendure Mindest-SoC Übernahme](skripte/home-assistant/automationen/zendure-mindest-soc-uebernahme.yaml) – überträgt die geplanten Mindest-SoC-Werte unter Berücksichtigung der Batterieladestände

**Sensoren**

- [Backup-Anzeige](skripte/home-assistant/sensoren/backup_anzeige.yaml) – Template-Sensoren zur Darstellung der letzten erfolgreichen und der nächsten geplanten Home-Assistant-Sicherung sowie der letzten Windows-Sicherung
- [Solarsteuerung](skripte/home-assistant/sensoren/solarsteuerung.yaml) – Template-Sensoren für Netzleistung, Hausverbrauch, PV-Leistung, Batteriefreigabe und dynamische AC-Leistungsverteilung


### Windows

- [Beispielkonfiguration](skripte/windows/config.example.ps1) – Vorlage für die lokale Konfiguration des PowerShell-Skripts
- [PowerShell-Skript](skripte/windows/home-assistant-backup.ps1) – führt die Windows-Backup-Synchronisation aus

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
