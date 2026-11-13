
# Dashboard

Diese Dokumentation beschreibt den Aufbau und die Darstellung des eigenen **Home-Assistant-Dashboards**.

Das Dashboard dient der übersichtlichen Anzeige der Solarsteuerung, von Klima- und Anwesenheitsinformationen sowie von Netzwerkgeräten, Freebox-Status und Datensicherungen.

Die Konfiguration ist zentral in der Datei `dashboard.yaml` dokumentiert.

## Aufbau

Das Dashboard verwendet die Home-Assistant-Ansicht **Sections** und enthält folgende Bereiche:

- **Solar:** Überwachung der beiden Zendure SolarFlow 800 Plus, Wetterinformationen und grafische Darstellung der Energieflüsse.
- **Klima:** Anwesenheits- und Standortinformationen.
- **Netzwerk:** Batteriestände, WLAN-Geräte, Freebox und Datensicherungen.
- **neu:** Weitere in der YAML vorhandene, noch nicht näher dokumentierte Ansicht.

### Solar

Die Solaransicht zeigt für beide Zendure-Geräte:

- Aktuellen Batterie-SoC als Rundinstrument mit dynamischen Farbbereichen für den eingestellten und geplanten Mindest-SoC.
- PV-Leistung der beiden Eingänge und deren Gesamtleistung.
- Tatsächliche AC-Ausgangsleistung und neu berechnete AC-Soll-Leistung.
- Prozentualen Leistungsanteil an der gesamten AC-Ausgabe.
- Batterielade- und Entladeleistung.
- Status der dynamischen PV-Begrenzung (0–100 %).
- Temperaturen von Wechselrichter und Akku.
- Status der Batterieheizung.

Zusätzlich werden eine tägliche und eine stündliche Wettervorhersage angezeigt.

Eine zusätzliche Übersicht zeigt den gesamten Hausverbrauch, die aktuelle AC-Einspeiseleistung beider Zendure-Geräte als Summe, die aktuelle Netzleistung und den gewünschten Netzbezugs-Sollwert.

Die Gesamteinspeisung wird über den Sensor `sensor.zendure_gesamt_einspeisung` erfasst und im Dashboard als „Zendure“ angezeigt.

### Statusfarben

Bestimmte Werte werden abhängig vom aktuellen Zustand farblich hervorgehoben:

| Farbe | Bedeutung |
|---|---|
| Blau | Berechnete AC-Soll-Leistung weicht von der eingestellten AC-Ausgangsgrenze ab. |
| Gelb | Dynamische PV-Begrenzung ist aktiv oder die Batterieheizung ist eingeschaltet. |
| Rot | Wechselrichtertemperatur außerhalb von 0 bis 60 °C oder Batterietemperatur außerhalb von 0 bis 40 °C. |

Die farbliche Darstellung dient der schnellen Erkennung besonderer Betriebszustände.

### Energiefluss

Eine grafische Energieflussanzeige stellt das Zusammenspiel folgender Komponenten dar:

- PV-Eingänge beider Zendure-Geräte.
- Beide Batteriespeicher mit Lade- und Entladerichtung.
- AC-Ausgangsleistung beider Zendure-Geräte.
- Gesamter Hausverbrauch.
- Netzbezug beziehungsweise Netzeinspeisung.

Die Energieflussanzeige verwendet die **Home Flow Card**.

## Netzwerk

Die Netzwerkansicht zeigt Batteriestände von Kontaktsensoren, Thermostaten und Heizkörperventilen sowie eine Übersicht der `device_tracker`-Zustände.

Ergänzend werden Freebox-Kennzahlen und Informationen zu automatischen Backups und der Windows-Sicherung angezeigt.

Für die dynamischen Tabellen wird die **Flex Table Card** verwendet.

Die vollständige Beschreibung befindet sich in der separaten Dokumentation `dashboard_netzwerk.md`.

## Verwendete Dashboard-Erweiterungen

Für die Darstellung werden zusätzliche benutzerdefinierte Dashboard-Karten verwendet:

| Erweiterung | Verwendung |
|---|---|
| Config Template Card | Dynamische Farbbereiche der Batterie-Rundinstrumente anhand des eingestellten und geplanten Mindest-SoC. |
| card-mod | Anpassung von Hintergründen, Abständen, Schriftgrößen und zustandsabhängigen Farben. |
| Home Flow Card | Grafische Darstellung der Energieflüsse zwischen PV, Batterien, Haus und Netz. |
| Flex Table Card | Dynamische Tabellen für Batteriestände und Netzwerkgeräte in der Netzwerkansicht. |

Die Erweiterungen wurden über den Home Assistant Marketplace installiert.

> [!WICHTIG]
> Die genannten Erweiterungen sind benutzerdefinierte Dashboard-Karten beziehungsweise Frontend-Anpassungen. Es handelt sich nicht um eigenständige Home-Assistant-Apps oder Geräteintegrationen.

## Konfiguration

Die vollständige Dashboard-Konfiguration ist in der folgenden Datei hinterlegt:

`dashboard.yaml`

Die Datei enthält die Ansichten, Karten, verwendeten Entitäten und Darstellungseinstellungen.

Die Solarsteuerung selbst wird unabhängig vom Dashboard über eigene Template-Sensoren und Automationen umgesetzt.


## 🔗 Verwendung & Verknüpfungen

- [Dashboard – Solarsteuerung](dashboard_solarsteuerung.md) – Aufbau und Darstellung der Solaransicht
- [Dashboard – Netzwerk](dashboard_netzwerk.md) – Aufbau und Darstellung der Netzwerkansicht
- [Config Template Card](../marketplace/config-template-card.md) – dynamische Mindest-SoC-Anzeige
- [card-mod](../marketplace/card-mod.md) – Gestaltung und farbliche Hervorhebungen
- [Home Flow Card](../marketplace/home-flow-card.md) – grafische Energieflussanzeige
- [Flex Table Card](../marketplace/flex-table-card.md) – dynamische Tabellen in der Netzwerkansicht
- [Dashboard-Konfiguration](../skripte/home-assistant/dashboard.yaml) – vollständige YAML-Konfiguration

---

[⬅️ Zurück zur Übersicht](../README.md)
