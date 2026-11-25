
# Shelly

Diese Dokumentation beschreibt die Einrichtung und Konfiguration der nativen **Shelly**-Integration in Home Assistant.

Der eingesetzte **Shelly 3EM (SHEM-3)** misst die elektrische Leistung auf drei Phasen und stellt die Messwerte in Home Assistant bereit.

## Einrichtung

Die Shelly-Integration wurde von Home Assistant automatisch erkannt.

1. **Einstellungen → Geräte & Dienste** öffnen.
2. Das automatisch erkannte Shelly-Gerät auswählen.
3. Die Einrichtung der **Shelly**-Integration bestätigen.
4. Prüfen, ob das Gerät und seine Entitäten verfügbar sind.

> [!WICHTIG]
> **Shelly** wird in Home Assistant als Integration eingerichtet. Eine separat installierte Home-Assistant-App ist nicht erforderlich.

## Konfiguration

### Gerätebezeichnung

Das Gerät wurde in Home Assistant in `shelly3em` umbenannt.

### Geräte und Entitäten

Die Integration stellt folgende Einträge bereit:

| Typ | Anzahl |
| --- | ---: |
| Geräte | 4 |
| Entitäten | 26 |

Die vier Geräte umfassen den Shelly 3EM sowie die drei einzelnen Phasen A, B und C.

### Leistungsmessung

Für die Leistungsmessung stehen folgende Entitäten zur Verfügung:

| Phase | Entität |
| --- | --- |
| A | `sensor.shelly3em_phase_a_leistung` |
| B | `sensor.shelly3em_phase_b_leistung` |
| C | `sensor.shelly3em_phase_c_leistung` |

Die Leistungswerte werden in Watt (W) angegeben.

Ein nativer Sensor für die aufsummierte Netzleistung aller drei Phasen wurde von der Integration nicht bereitgestellt.

Die Gesamtleistung wird deshalb über den eigenen Template-Sensor `sensor.shelly_netzleistung_gesamt` berechnet.

Die zugehörige YAML-Konfiguration befindet sich in `solarsteuerung.yaml`.

### Vorzeichen der Netzleistung

Die Netzleistung wird mit folgendem Vorzeichen dargestellt:

- **Positive Werte:** Netzbezug aus dem öffentlichen Stromnetz
- **Negative Werte:** Einspeisung in das öffentliche Stromnetz

## Funktionsprüfung

Nach der Einrichtung wurden die Messwerte in Home Assistant mit den Werten der Shelly-Weboberfläche verglichen.

Die Leistungswerte der einzelnen Phasen stimmten überein.

Die drei Phasensensoren stehen damit für die weitere Verarbeitung in Home Assistant zur Verfügung.

## Nützliche Links & Quellen

- [Home Assistant – Shelly-Integration](https://www.home-assistant.io/integrations/shelly/)
- [Shelly – Offizielle Website](https://www.shelly.com/)

## 🔗 Verwendung & Verknüpfungen

- [Hardware & Geräte](../hardware.md) – Übersicht der eingesetzten Geräte
- [Solarsteuerung](../grundlagen/solarsteuerung.md) – Verwendung der Netzleistungsmessung und Berechnung des Hausverbrauchs
- [Solarsteuerung – Template-Sensoren](../skripte/home-assistant/sensoren/solarsteuerung.yaml) – YAML-Konfiguration der Netzleistungsberechnung

---

[⬅️ Zurück zur Übersicht](../README.md)
