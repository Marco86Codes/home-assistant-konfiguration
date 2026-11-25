
# MQTT

Diese Dokumentation beschreibt die Einrichtung der **MQTT**-Integration in Home Assistant.

Die Integration verbindet Home Assistant mit einem MQTT-Broker und ermöglicht die Kommunikation mit verschiedenen MQTT-basierten Geräten und Anwendungen.

## Einrichtung

Nach der Installation und dem Start der Home-Assistant-App **Mosquitto broker** wurde die **MQTT**-Integration von Home Assistant automatisch erkannt.

Die angebotene Integration wurde über **Hinzufügen** eingerichtet.

Eine manuelle Eingabe von Broker-Adresse, Port oder Zugangsdaten war dabei nicht erforderlich.

> [!WICHTIG]
> **MQTT** wird in Home Assistant als Integration eingerichtet. Es handelt sich nicht um eine separat installierte Home-Assistant-App.

## Konfiguration

Als MQTT-Broker wird die Home-Assistant-App **Mosquitto broker** verwendet.

Die Integration stellt die Verbindung zwischen Home Assistant und dem Broker her.

Über **MQTT Discovery** können kompatible Geräte und Anwendungen ihre Geräte und Entitäten automatisch in Home Assistant bereitstellen.

Die jeweiligen MQTT-Verbindungen, Zugangsdaten und gerätespezifischen Einstellungen werden in den Dokumentationen der betreffenden Komponenten beschrieben.

## Funktionsprüfung

Die Verbindung zum **Mosquitto broker** wurde erfolgreich hergestellt.

Über **MQTT Discovery** wurden Geräte und Entitäten in Home Assistant erkannt.

Damit wurde die grundlegende Kommunikation zwischen dem Broker und der **MQTT**-Integration erfolgreich geprüft.

## Nützliche Links & Quellen

- [Home Assistant – MQTT](https://www.home-assistant.io/integrations/mqtt/)

## 🔗 Verwendung & Verknüpfungen

- [Mosquitto broker](mosquitto-broker.md) – stellt den verwendeten MQTT-Broker bereit
- [Zendure](zendure.md) – verwendet MQTT für die Kommunikation mit den SolarFlow-Geräten
- [Zigbee2MQTT](zigbee2mqtt.md) – bindet Zigbee-Geräte über MQTT in Home Assistant ein

---

[⬅️ Zurück zur Übersicht](../README.md)
