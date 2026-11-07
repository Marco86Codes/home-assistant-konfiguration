# Zigbee2MQTT

Diese Dokumentation beschreibt die Einrichtung der Home-Assistant-App **Zigbee2MQTT**.

Zigbee2MQTT stellt die Verbindung zwischen dem verwendeten Zigbee-Koordinator und dem MQTT-Broker her. Dadurch können Zigbee-Geräte über MQTT in Home Assistant eingebunden werden.

## Installation

Zigbee2MQTT wird über das Home-Assistant-Repository von Zigbee2MQTT installiert.

Nach der Installation wurden folgende App-Einstellungen verwendet:

| Einstellung | Konfiguration |
| --- | --- |
| Beim Systemstart starten | Aktiviert |
| Watchdog | Aktiviert |
| Automatische Updates | Deaktiviert |
| In Seitenleiste anzeigen | Aktiviert |

Durch die aktivierte Seitenleistenoption kann die Zigbee2MQTT-Oberfläche direkt über die Home-Assistant-Seitenleiste geöffnet werden.

Automatische Updates sind deaktiviert, damit Aktualisierungen bewusst durchgeführt und anschließend auf Funktion geprüft werden können.

## Zigbee-Koordinator

Der Zigbee-Koordinator ist die zentrale Schnittstelle zwischen dem Zigbee-Funknetzwerk und Zigbee2MQTT.

Er kommuniziert per Zigbee-Funk mit den eingebundenen Zigbee-Geräten und ist über USB mit dem Home-Assistant-System verbunden. Zigbee2MQTT greift auf den Koordinator zu und überträgt die Informationen der Zigbee-Geräte anschließend über MQTT.

In dieser Installation wird ein USB-Zigbee-Koordinator verwendet.

Für die Konfiguration wird der dauerhafte Gerätepfad unter `/dev/serial/by-id/` verwendet. Dadurch ist die Konfiguration nicht von der möglicherweise veränderlichen Zuordnung wie `/dev/ttyUSB0` abhängig.

Verwendete Konfiguration:

| Einstellung | Konfiguration |
| --- | --- |
| Port | `/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0` |
| Adapter | `ember` |
| Baudrate | `115200` |
| RTS/CTS | Deaktiviert |

## MQTT

Zigbee2MQTT verwendet die Home-Assistant-App **Mosquitto broker** als MQTT-Broker.

Als Broker-Adresse wird `mqtt://core-mosquitto:1883` verwendet.

Für die Anmeldung wird der separat angelegte Home-Assistant-Benutzer ohne Administratorrechte verwendet.

Als MQTT-Basisthema wird `zigbee2mqtt` verwendet.

## Home Assistant

Die Home-Assistant-Unterstützung von Zigbee2MQTT ist aktiviert.

Verwendete Konfiguration:

| Einstellung | Konfiguration |
| --- | --- |
| Home Assistant | Aktiviert |
| Discovery Topic | `homeassistant` |
| Status Topic | `homeassistant/status` |
| Experimental Event Entities | Deaktiviert |
| Legacy Action Sensor | Deaktiviert |

Dadurch stellt Zigbee2MQTT unterstützte Geräte und Entitäten über MQTT Discovery für Home Assistant bereit.

## Zigbee-Netzwerk

Bei der Ersteinrichtung wurde ein neues Zigbee-Netzwerk erstellt.

Zigbee2MQTT erzeugt und verwaltet dafür unter anderem den Network Key sowie die Netzwerkkennungen des Zigbee-Netzwerks.

Die Koordinator-Sicherung wird von Zigbee2MQTT unter `/config/zigbee2mqtt/coordinator_backup.json` gespeichert.

## Zigbee-Gerät einbinden

Die Einbindung eines Zigbee-Geräts erfolgt über die Zigbee2MQTT-Oberfläche.

Dafür wird in Zigbee2MQTT der Beitritt neuer Geräte erlaubt. Anschließend wird das einzubindende Gerät in seinen Kopplungsmodus versetzt.

Wie der Kopplungsmodus aktiviert wird, ist vom jeweiligen Gerät abhängig und wird daher nicht für jedes Gerät separat in dieser Dokumentation beschrieben.

Nach erfolgreicher Einbindung erscheint das Gerät in Zigbee2MQTT.

Durch die aktivierte Home-Assistant-Unterstützung wird das Gerät anschließend über MQTT Discovery automatisch für Home Assistant bereitgestellt.

Nach der Einbindung wird geprüft, ob das Gerät und seine Entitäten in Home Assistant vorhanden sind.

Die tatsächlich eingesetzten Geräte werden zentral in der Hardwareübersicht dokumentiert.

## Funktionstest

Nach Abschluss der Einrichtung konnte Zigbee2MQTT den Zigbee-Koordinator erfolgreich öffnen und das Zigbee-Netzwerk starten.

Anschließend wurde die Verbindung zum Mosquitto broker hergestellt und Zigbee2MQTT als online veröffentlicht.

In Home Assistant wurde die **Zigbee2MQTT Bridge** automatisch über die **MQTT**-Integration erkannt.

Zusätzlich wurde ein Zigbee-Gerät erfolgreich über Zigbee2MQTT eingebunden und anschließend mit seinen Entitäten in Home Assistant bereitgestellt.

Damit wurde die Kommunikationskette erfolgreich geprüft:

```text
Zigbee-Gerät
     ↓
Zigbee-Koordinator
     ↓
Zigbee2MQTT
     ↓
Mosquitto broker
     ↓
MQTT
     ↓
Home Assistant
```

## Nützliche Links & Quellen

- [Zigbee2MQTT – Installation als Home-Assistant-App](https://www.zigbee2mqtt.io/guide/installation/03_ha_addon.html)

## 🔗 Verwendung & Verknüpfungen

- [Hardware & Geräte](../hardware.md) – Übersicht der eingesetzten Geräte und ihrer Einbindungsart
- [Mosquitto broker](mosquitto-broker.md) – stellt den verwendeten MQTT-Broker bereit
- [MQTT](mqtt.md) – Home-Assistant-Integration für die MQTT-Kommunikation

---

[⬅️ Zurück zur Übersicht](../README.md)
