# Mosquitto broker

Diese Dokumentation beschreibt die Einrichtung der Home-Assistant-App **Mosquitto broker**.

Mosquitto stellt den MQTT-Broker für die Kommunikation zwischen MQTT-Komponenten bereit. In dieser Installation wird der Broker insbesondere für die Verbindung zwischen Zigbee2MQTT und Home Assistant verwendet.

## Installation

Verwendet wird die Home-Assistant-App **Mosquitto broker**.

Nach der Installation wurden folgende App-Einstellungen verwendet:

| Einstellung | Konfiguration |
| --- | --- |
| Beim Systemstart starten | Aktiviert |
| Watchdog | Aktiviert |
| Automatische Updates | Deaktiviert |

Automatische Updates sind deaktiviert, damit Aktualisierungen bewusst durchgeführt und anschließend auf Funktion geprüft werden können.

## Benutzer

Für die Kommunikation zwischen Zigbee2MQTT und dem MQTT-Broker wird ein separater Home-Assistant-Benutzer ohne Administratorrechte verwendet.

Der Benutzer wird unter **Home Assistant → Einstellungen → Personen → Benutzer** angelegt.

Für diesen Benutzer ist in Home Assistant die Option **„Nur lokaler Zugriff“** aktiviert.

## Konfiguration

Für Mosquitto werden die vorgesehenen Standardeinstellungen verwendet.

Die vorhandenen Netzwerk-Ports wurden nicht verändert.

Für die Kommunikation mit Zigbee2MQTT wird der normale MQTT-Dienst über Port `1883` verwendet.

Eine eigene TLS-Konfiguration oder ein eigenes Client-Zertifikat wird für die interne Kommunikation dieser Installation nicht verwendet.

## MQTT-Integration

Nach dem Start von Mosquitto wurde der Broker von Home Assistant automatisch erkannt.

Die angebotene **MQTT**-Integration wurde anschließend über **Hinzufügen** eingerichtet. Eine manuelle Eingabe von Broker-Adresse, Port oder Zugangsdaten war dabei nicht erforderlich.

## Funktionstest

Nach dem Start meldete Mosquitto einen erfolgreichen Betrieb des MQTT-Brokers auf Port `1883`.

Anschließend wurde Zigbee2MQTT erfolgreich mit dem Broker verbunden.

Das Zigbee2MQTT-Protokoll bestätigte die Verbindung zum MQTT-Broker. In Home Assistant wurde danach die **Zigbee2MQTT Bridge** über die **MQTT**-Integration erkannt.

Damit wurde die Kommunikation zwischen Mosquitto, Zigbee2MQTT und Home Assistant erfolgreich geprüft.

## Nützliche Links & Quellen

- [Home Assistant – Mosquitto broker](https://github.com/home-assistant/addons/tree/master/mosquitto)
- [Eclipse Mosquitto](https://mosquitto.org/)

## 🔗 Verwendung & Verknüpfungen

- [MQTT](mqtt.md) – Home-Assistant-Integration für MQTT
- [Zigbee2MQTT](zigbee2mqtt.md) – verwendet Mosquitto für die MQTT-Kommunikation

---

[⬅️ Zurück zur Übersicht](../README.md)
