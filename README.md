
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

- [Backups](grundlagen/backups.md) – Backup-Strategie und Aufbewahrung der Home-Assistant-Backups
- [Dashboard](grundlagen/dashboard.md) – Visualisierung der Zendure-Solaranlage mit Statusanzeigen, Wetterinformationen und Energieflussdiagramm
- [Solarsteuerung](grundlagen/solarsteuerung.md) – Dynamische AC-Leistungsregelung mit zwei Zendure SolarFlow 800 Plus, wetterabhängiger Mindest-SoC-Steuerung und automatischer Leistungsverteilung

### Apps & Integrationen

- [Mosquitto broker](apps/mosquitto-broker.md) – MQTT-Broker für die Kommunikation zwischen MQTT-Komponenten
- [MQTT](apps/mqtt.md) – Home-Assistant-Integration für die MQTT-Kommunikation
- [Samba share](apps/samba-share.md) – Bereitstellung des Backup-Verzeichnisses im lokalen Netzwerk
- [Shelly](apps/shelly.md) – Einbindung des Shelly 3EM zur Messung der Netzleistung
- [Studio Code Server](apps/studio-code-server.md) – Bearbeitung der Home-Assistant-Konfiguration über einen integrierten Code-Editor
- [Zendure](apps/zendure.md) – Einbindung der SolarFlow 800 Plus mit lokaler MQTT-Kommunikation
- [Zigbee2MQTT](apps/zigbee2mqtt.md) – Einbindung von Zigbee-Geräten über MQTT

### Marketplace

- [Config Template Card](marketplace/config-template-card.md) – Dynamische Darstellung des geplanten Mindest-SoC in den Batterie-Rundinstrumenten
- [card-mod](marketplace/card-mod.md) – Individuelle Gestaltung der Dashboard-Karten und farbliche Statusanzeigen
- [Home Flow Card](marketplace/home-flow-card.md) – Grafische Darstellung der Energieflüsse zwischen PV, Batterien, Haus und Netz

### Externe Systeme

- [DHCP-Zuweisungen in der Freebox](externe-systeme/freebox/dhcp-zuweisungen.md) – feste DHCP-Zuweisungen für die beteiligten Netzwerkgeräte
- [Windows-Backup-Synchronisation](externe-systeme/windows/backup-synchronisation.md) – automatische Übertragung der Backups auf einen Windows-PC und Synchronisierung mit Proton Drive

## Skripte und Konfigurationen

### Home Assistant

**Dashboard**

- [Dashboard-Konfiguration](skripte/home-assistant/dashboard.yaml) – YAML-Konfiguration der Dashboard-Ansichten, Karten und Energieflussdarstellung

**Automationen**

- [Aktualisierung des Windows-Sicherungszeitstempels](skripte/home-assistant/automationen/aktualisierung-windows-sicherung-zeitstempel.yaml) – aktualisiert den Zeitpunkt der letzten erfolgreichen Windows-Sicherung
- [Zendure Leistungsanpassung](skripte/home-assistant/automationen/zendure-leistungsanpassung.yaml) – überträgt die berechneten AC-Sollwerte an beide Wechselrichter
- [Zendure Mindest-SoC Berechnung](skripte/home-assistant/automationen/zendure-mindest-soc-berechnung.yaml) – berechnet die geplanten Mindest-SoC-Werte anhand der Wetterprognose
- [Zendure Mindest-SoC Übernahme](skripte/home-assistant/automationen/zendure-mindest-soc-uebernahme.yaml) – überträgt die geplanten Mindest-SoC-Werte unter Berücksichtigung der Batterieladestände

**Sensoren**

- [Solarsteuerung](skripte/home-assistant/sensors/solarsteuerung.yaml) – Template-Sensoren für Netzleistung, Hausverbrauch, PV-Leistung, Batteriefreigabe und dynamische AC-Leistungsverteilung

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
