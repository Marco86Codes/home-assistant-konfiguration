
# Dashboard – Solar

Diese Dokumentation beschreibt den Aufbau und die Darstellung der Solaransicht im Home-Assistant-Dashboard.

Die Ansicht dient der Überwachung der beiden Zendure SolarFlow 800 Plus, ihrer PV- und Batteriewerte sowie der aktuellen Solarsteuerung.

## Aufbau

Die Solaransicht verwendet das Home-Assistant-Layout **Sections** und ist in mehrere Bereiche gegliedert:

- **Zendure 1:** PV-Erzeugung, Batteriestatus, AC-Leistung und Betriebszustände des ersten Geräts.
- **Zendure 2:** Entsprechende Informationen für das zweite Gerät.
- **Wetter und Übersicht:** Wettervorhersagen sowie zusammengefasste Leistungswerte.
- **Energiefluss:** Grafische Darstellung der Energieflüsse zwischen PV, Batterien, Haus und Netz.

## Zendure-Geräte

Für beide Zendure SolarFlow 800 Plus werden die gleichen Informationen angezeigt.

### Batteriestatus

Der aktuelle Batterie-SoC wird als Rundinstrument dargestellt.

Die Farbbereiche berücksichtigen:

- Den aktuell eingestellten Mindest-SoC.
- Den geplanten Mindest-SoC der Solarsteuerung.
- Den verbleibenden Ladebereich.

Die dynamische Darstellung erfolgt über die **Config Template Card**.

### PV-Leistung

Für jedes Gerät werden folgende Werte angezeigt:

- PV-Leistung des ersten Eingangs.
- PV-Leistung des zweiten Eingangs.
- Gesamte PV-Leistung beider Eingänge.

### Steuerung

Der Bereich **Steuerung** zeigt:

- Die tatsächliche AC-Ausgangsleistung.
- Die neu berechnete AC-Soll-Leistung.
- Den prozentualen Leistungsanteil an der gesamten AC-Ausgabe.
- Die Batterieladeleistung.
- Die Batterieentladeleistung.
- Den Status der dynamischen PV-Begrenzung.

Dadurch lassen sich die aktuelle Leistung und die berechneten Vorgaben der Solarsteuerung direkt vergleichen.

### Temperaturen

Für beide Geräte werden folgende Betriebswerte dargestellt:

- Temperatur des Wechselrichters.
- Temperatur des Batteriespeichers.
- Status der Batterieheizung.

## Wetter und Gesamtübersicht

### Wettervorhersage

Die Solaransicht enthält zwei Wettervorhersagen:

- Eine tägliche Wettervorhersage.
- Eine stündliche Wettervorhersage.

Beide verwenden die in Home Assistant eingebundene Wetterentität.

### Leistungsübersicht

Die Gesamtübersicht zeigt folgende Werte:

| Anzeige | Bedeutung |
| --- | --- |
| Gesamt | Aktueller Hausverbrauch |
| Zendure | Gesamte AC-Einspeiseleistung beider Zendure-Geräte |
| Netz | Aktuelle Netzleistung |
| Netz Soll | Gewünschter Netzbezugs-Sollwert |

Die Gesamteinspeisung der beiden Zendure-Geräte wird über den Sensor `sensor.zendure_gesamt_einspeisung` erfasst.

## Statusfarben

Bestimmte Werte werden abhängig vom aktuellen Betriebszustand farblich hervorgehoben.

| Farbe | Bedeutung |
| --- | --- |
| Blau | Berechnete AC-Soll-Leistung weicht von der eingestellten AC-Ausgangsgrenze ab. |
| Gelb | Dynamische PV-Begrenzung ist aktiv oder die Batterieheizung ist eingeschaltet. |
| Rot | Wechselrichtertemperatur außerhalb von 0 bis 60 °C oder Batterietemperatur außerhalb von 0 bis 40 °C. |

Die farbliche Darstellung dient der schnellen Erkennung besonderer Betriebszustände.

Die zustandsabhängige Gestaltung erfolgt über **card-mod**.

## Energiefluss

Eine grafische Energieflussanzeige stellt das Zusammenspiel folgender Komponenten dar:

- PV-Eingänge beider Zendure-Geräte.
- Beide Batteriespeicher mit Lade- und Entladerichtung.
- AC-Ausgangsleistung beider Zendure-Geräte.
- Gesamter Hausverbrauch.
- Netzbezug beziehungsweise Netzeinspeisung.

Die Energieflussanzeige verwendet die **Home Flow Card**.

Die Darstellung zeigt die einzelnen Komponenten und ihre Verbindungen innerhalb eines gemeinsamen Energieflussdiagramms.

## Konfiguration

Die Solaransicht ist Bestandteil der zentralen Dashboard-Konfiguration `dashboard.yaml`.

Die Datei enthält die verwendeten Karten, Entitäten, Layout-Einstellungen und zustandsabhängigen Darstellungen.

Die Solarsteuerung selbst wird unabhängig vom Dashboard über eigene Template-Sensoren und Automationen umgesetzt.

## 🔗 Verwendung & Verknüpfungen

- [Dashboard](dashboard.md) – allgemeiner Aufbau und gemeinsam verwendete Dashboard-Tools
- [Solarsteuerung](solarsteuerung.md) – Berechnung und Regelung der AC-Leistung
- [Home Assistant – dashboard.yaml](../skripte/home-assistant/dashboard.yaml) – vollständige Dashboard-Konfiguration

---

[⬅️ Zurück zur Übersicht](../README.md)
