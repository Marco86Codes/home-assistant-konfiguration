# MQTT

Diese Dokumentation beschreibt die Einrichtung der **MQTT**-Integration in Home Assistant.

Die Integration stellt die Verbindung zwischen Home Assistant und dem MQTT-Broker her. In dieser Installation wird sie insbesondere für die Kommunikation mit Zigbee2MQTT verwendet.

## Einrichtung

Nach der Installation und dem Start der Home-Assistant-App **Mosquitto broker** wurde die **MQTT**-Integration von Home Assistant automatisch erkannt.

Die angebotene Integration wurde über **Hinzufügen** eingerichtet.

Eine manuelle Eingabe von Broker-Adresse, Port oder Zugangsdaten war dabei nicht erforderlich.

> [!WICHTIG]
> **MQTT** wird in Home Assistant als Integration eingerichtet. Es handelt sich nicht um eine separat installierte Home-Assistant-App.

## Verwendung

Als MQTT-Broker wird die Home-Assistant-App **Mosquitto broker** verwendet.

Zigbee2MQTT verbindet sich mit diesem Broker und veröffentlicht darüber seine MQTT-Nachrichten.

Die aktivierte Home-Assistant-Unterstützung von Zigbee2MQTT ermöglicht die automatische Bereitstellung der entsprechenden Geräte und Entitäten über MQTT Discovery.

## Funktionstest

Nach der Einrichtung von Zigbee2MQTT wurde die **Zigbee2MQTT Bridge** über die **MQTT**-Integration automatisch in Home Assistant erkannt.

Damit wurde die Kommunikation zwischen Zigbee2MQTT, Mosquitto broker und der MQTT-Integration erfolgreich geprüft.

## Nützliche Links & Quellen

- [Home Assistant – MQTT](https://www.home-assistant.io/integrations/mqtt/)

## 🔗 Verwendung & Verknüpfungen

- [Mosquitto broker](mosquitto-broker.md) – stellt den verwendeten MQTT-Broker bereit
- [Zigbee2MQTT](zigbee2mqtt.md) – verwendet MQTT für die Kommunikation mit Home Assistant

---

[⬅️ Zurück zur Übersicht](../README.md)
