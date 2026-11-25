
# Mosquitto broker

Diese Dokumentation beschreibt die Einrichtung der Home-Assistant-App **Mosquitto broker**.

Die App stellt einen zentralen MQTT-Broker für die Kommunikation zwischen verschiedenen MQTT-basierten Geräten, Anwendungen und Home Assistant bereit.

## Installation

Verwendet wird die offizielle Home-Assistant-App **Mosquitto broker**.

Nach der Installation wurden folgende App-Einstellungen festgelegt:

| Einstellung | Konfiguration |
| --- | --- |
| Beim Systemstart starten | Aktiviert |
| Watchdog | Aktiviert |
| Automatische Updates | Deaktiviert |

Automatische Updates sind deaktiviert, damit Aktualisierungen bewusst durchgeführt und anschließend auf Funktion geprüft werden können.

## Benutzer

Für die MQTT-Kommunikation werden separate Home-Assistant-Benutzer ohne Administratorrechte verwendet.

Die Benutzer werden unter **Home Assistant → Einstellungen → Personen → Benutzer** angelegt.

Für die verwendeten MQTT-Benutzer ist die Option **„Nur lokaler Zugriff“** aktiviert.

Die Zuordnung der Benutzer zu den jeweiligen MQTT-Komponenten erfolgt in deren eigener Dokumentation.

## Konfiguration

Für **Mosquitto broker** werden die vorgesehenen Standardeinstellungen verwendet.

Die vorhandenen Netzwerk-Ports wurden nicht verändert.

Für die MQTT-Kommunikation wird Port `1883` verwendet.

Eine eigene TLS-Konfiguration oder ein eigenes Client-Zertifikat wird für die interne Kommunikation dieser Installation nicht verwendet.

## Verbindung mit Home Assistant

Nach dem Start von **Mosquitto broker** wurde der Broker von Home Assistant automatisch erkannt.

Die angebotene **MQTT**-Integration wurde anschließend über **Hinzufügen** eingerichtet.

Eine manuelle Eingabe von Broker-Adresse, Port oder Zugangsdaten war dabei nicht erforderlich.

## Funktionsprüfung

Nach dem Start meldete **Mosquitto broker** einen erfolgreichen Betrieb des MQTT-Brokers auf Port `1883`.

Die Verbindung mit der **MQTT**-Integration wurde erfolgreich hergestellt.

Zusätzlich wurde die Kommunikation mit MQTT-Clients erfolgreich geprüft.

## Nützliche Links & Quellen

- [Home Assistant – Mosquitto broker](https://github.com/home-assistant/addons/tree/master/mosquitto)
- [Eclipse Mosquitto](https://mosquitto.org/)

## 🔗 Verwendung & Verknüpfungen

- [MQTT](mqtt.md) – Home-Assistant-Integration für MQTT
- [Zendure](zendure.md) – verwendet den Broker für die MQTT-Kommunikation
- [Zigbee2MQTT](zigbee2mqtt.md) – verwendet den Broker zur Einbindung von Zigbee-Geräten

---

[⬅️ Zurück zur Übersicht](../README.md)
