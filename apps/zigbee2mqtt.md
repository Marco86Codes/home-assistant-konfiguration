
# Zigbee2MQTT

Diese Dokumentation beschreibt die Installation und Konfiguration der Home-Assistant-App **Zigbee2MQTT**.

Zigbee2MQTT verbindet den verwendeten Zigbee-Koordinator mit dem MQTT-Broker. Dadurch können Zigbee-Geräte über MQTT in Home Assistant eingebunden werden.

## Installation

Zigbee2MQTT wird über das offizielle Home-Assistant-Repository von Zigbee2MQTT installiert.

Nach der Installation wurden folgende App-Einstellungen festgelegt:

| Einstellung | Konfiguration |
| --- | --- |
| Beim Systemstart starten | Aktiviert |
| Watchdog | Aktiviert |
| Automatische Updates | Deaktiviert |
| In Seitenleiste anzeigen | Aktiviert |

Durch die aktivierte Seitenleistenoption kann die Zigbee2MQTT-Oberfläche direkt über die Home-Assistant-Seitenleiste geöffnet werden.

Automatische Updates sind deaktiviert, damit Aktualisierungen bewusst durchgeführt und anschließend auf Funktion geprüft werden können.

## Zigbee-Koordinator

In dieser Installation wird ein über USB angeschlossener Zigbee-Koordinator verwendet.

Für die Konfiguration wird der dauerhafte Gerätepfad unter `/dev/serial/by-id/` verwendet. Dadurch ist die Zuordnung unabhängig von möglicherweise wechselnden Gerätepfaden wie `/dev/ttyUSB0`.

Verwendete Konfiguration:

| Einstellung | Konfiguration |
| --- | --- |
| Port | `/dev/serial/by-id/<ZIGBEE-KOORDINATOR>` |
| Adapter | `ember` |
| Baudrate | `115200` |
| RTS/CTS | Deaktiviert |

## MQTT-Verbindung

Zigbee2MQTT verwendet die Home-Assistant-App **Mosquitto broker** als MQTT-Broker.

Verwendete Konfiguration:

| Einstellung | Konfiguration |
| --- | --- |
| Broker-Adresse | `mqtt://core-mosquitto:1883` |
| Benutzer | Separater Home-Assistant-Benutzer |
| Administratorrechte | Keine |
| Nur lokaler Zugriff | Aktiviert |
| MQTT-Basisthema | `zigbee2mqtt` |

Der MQTT-Benutzer wird unter **Home Assistant → Einstellungen → Personen → Benutzer** angelegt.

## Home-Assistant-Anbindung

Die Home-Assistant-Unterstützung von Zigbee2MQTT ist aktiviert.

Verwendete Konfiguration:

| Einstellung | Konfiguration |
| --- | --- |
| Home Assistant | Aktiviert |
| Discovery Topic | `homeassistant` |
| Status Topic | `homeassistant/status` |
| Experimental Event Entities | Deaktiviert |
| Legacy Action Sensor | Deaktiviert |

Dadurch stellt Zigbee2MQTT unterstützte Geräte und Entitäten über **MQTT Discovery** für Home Assistant bereit.

## Zigbee-Netzwerk

Bei der Ersteinrichtung wurde ein neues Zigbee-Netzwerk erstellt.

Zigbee2MQTT erzeugt und verwaltet dafür unter anderem den Network Key und die Netzwerkkennungen.

Die Koordinator-Sicherung wird unter folgendem Pfad gespeichert:

`/config/zigbee2mqtt/coordinator_backup.json`

## Zigbee-Geräte einbinden

Die Einbindung erfolgt über die Zigbee2MQTT-Oberfläche.

1. In Zigbee2MQTT den Beitritt neuer Geräte erlauben.
2. Das einzubindende Gerät in den Kopplungsmodus versetzen.
3. Die erfolgreiche Einbindung in Zigbee2MQTT prüfen.
4. Prüfen, ob das Gerät und seine Entitäten in Home Assistant verfügbar sind.

Wie der Kopplungsmodus aktiviert wird, hängt vom jeweiligen Gerät ab.

Die tatsächlich eingesetzten Geräte werden zentral in der Hardwareübersicht dokumentiert.

## Funktionsprüfung

Nach Abschluss der Einrichtung konnte Zigbee2MQTT den Zigbee-Koordinator erfolgreich öffnen und das Zigbee-Netzwerk starten.

Anschließend wurde die Verbindung zum **Mosquitto broker** hergestellt und Zigbee2MQTT als online veröffentlicht.

In Home Assistant wurde die **Zigbee2MQTT Bridge** automatisch über die **MQTT**-Integration erkannt.

Zusätzlich wurde ein Zigbee-Gerät erfolgreich eingebunden und mit seinen Entitäten in Home Assistant bereitgestellt.

Damit wurde die vollständige Kommunikationskette geprüft:

```text
Zigbee-Gerät
    │
    ▼
Zigbee-Koordinator
    │
    ▼
Zigbee2MQTT
    │
    ▼
Mosquitto broker
    │
    ▼
MQTT-Integration
    │
    ▼
Home Assistant
```

## Nützliche Links & Quellen

- [Zigbee2MQTT – Installation als Home-Assistant-App](https://www.zigbee2mqtt.io/guide/installation/03_ha_addon.html)

## 🔗 Verwendung & Verknüpfungen

- [Hardware & Geräte](../hardware.md) – Übersicht der eingesetzten Geräte
- [Mosquitto broker](mosquitto-broker.md) – stellt den verwendeten MQTT-Broker bereit
- [MQTT](mqtt.md) – Home-Assistant-Integration für die MQTT-Kommunikation

---

[⬅️ Zurück zur Übersicht](../README.md)
