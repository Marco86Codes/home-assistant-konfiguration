# Shelly

## Beschreibung

Shelly-Geräte können über die native Shelly-Integration in Home Assistant eingebunden werden.

Der eingesetzte **Shelly 3EM (SHEM-3)** misst die elektrische Leistung auf drei Phasen und stellt die Messwerte in Home Assistant bereit.

Die Messwerte dienen als Grundlage für die Solarsteuerung der beiden **Zendure SolarFlow 800 Plus**.

## Installation

Die Shelly-Integration wurde von Home Assistant automatisch erkannt.

1. **Einstellungen → Geräte & Dienste** öffnen.
2. Das automatisch erkannte Shelly-Gerät auswählen.
3. Die Einrichtung der **Shelly-Integration** bestätigen.
4. Prüfen, ob das Gerät und seine Entitäten verfügbar sind.

Eine zusätzliche App ist für diese Integration nicht erforderlich.

## Konfiguration

### Gerätebezeichnung

Das Gerät wurde in Home Assistant in `shelly3em` umbenannt.

### Geräte und Entitäten

Die Integration stellt insgesamt folgende Einträge bereit:

| Typ | Anzahl |
|---|---:|
| Geräte | 4 |
| Entitäten | 26 |

Die vier Geräte umfassen den Shelly 3EM sowie die drei einzelnen Phasen A, B und C.

### Leistungsmessung

Für die Leistungsmessung stehen folgende Entitäten zur Verfügung:

| Phase | Entität |
|---|---|
| A | `sensor.shelly3em_phase_a_leistung` |
| B | `sensor.shelly3em_phase_b_leistung` |
| C | `sensor.shelly3em_phase_c_leistung` |

Die Leistungswerte werden in Watt (W) angegeben.

Ein nativer Sensor für die aufsummierte Netzleistung aller drei Phasen wurde von der Integration nicht bereitgestellt.

Die Berechnung der Gesamtleistung erfolgt deshalb separat über die Home-Assistant-YAML-Konfiguration.

Hierzu werden die drei Phasenleistungen im Template-Sensor `sensor.shelly_netzleistung_gesamt` addiert.

Dieser Sensor wird anschließend zur Berechnung des Hausverbrauchs und des AC-Leistungsbedarfs der Solarsteuerung verwendet.

### Vorzeichen der Netzleistung

Die Netzleistung wird mit folgendem Vorzeichen dargestellt:

- **Positive Werte:** Netzbezug aus dem öffentlichen Stromnetz.
- **Negative Werte:** Einspeisung in das öffentliche Stromnetz.

Diese Vorzeichen werden bei der Solarsteuerung berücksichtigt.

## Funktionsprüfung

Nach der Einrichtung wurden die Messwerte in Home Assistant mit den Werten der Shelly-Weboberfläche verglichen.

Die Leistungswerte der einzelnen Phasen stimmten überein.

Die drei Phasensensoren sind damit als Datenquelle für die Solarsteuerung verfügbar.

Die Gesamtleistung wird über den Template-Sensor `sensor.shelly_netzleistung_gesamt` bereitgestellt.

## Nützliche Links & Quellen

- [Hardware & Geräte](../hardware.md) – Übersicht der eingesetzten Geräte und ihrer Einbindungsart
- [Home Assistant – Shelly-Integration](https://www.home-assistant.io/integrations/shelly/)
- [Shelly – Offizielle Website](https://www.shelly.com/)

## 🔗 Verwendung & Verknüpfungen

- [Solarsteuerung](../grundlagen/solarsteuerung.md) – Gesamtkonzept, Berechnungslogik, dynamische Leistungsaufteilung und wetterabhängige Mindest-SoC-Strategie

---

- [⬅️ Zurück zur Übersicht](../README.md)
