
# Dashboard

Diese Dokumentation beschreibt den Aufbau und die Darstellung des eigenen **Home-Assistant-Dashboards**.

Das Dashboard dient der übersichtlichen Darstellung und Bedienung der Solar- und Raumklimasteuerung sowie der Anzeige von Anwesenheitsinformationen, Netzwerkgeräten, Freebox-Status und Datensicherungen.

Die Konfiguration ist zentral in der Datei `dashboard.yaml` dokumentiert.

## Aufbau

Das Dashboard verwendet die Home-Assistant-Ansicht **Sections** und enthält folgende Bereiche:

- **Solar:** Überwachung der beiden Zendure SolarFlow 800 Plus, Wetterinformationen und grafische Darstellung der Energieflüsse.
- **Klima:** Raumklimasteuerung, grafische Grundrissdarstellung, Heizungszustände, Midea Portasplit, Temperaturübertragung und Anwesenheitsinformationen.
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

## Klima

Die Klima-Ansicht dient der zentralen Darstellung und Bedienung der Raumklimasteuerung.

Sie umfasst folgende Bereiche:

- Grafische Grundrissdarstellung mit Raumtemperaturen, Heizungszuständen und Fensterkontakten.
- Globale Aktivierung und Deaktivierung der Heizungssteuerung.
- Anzeige der zentralen Temperaturvorgaben.
- Betriebsmodus, Betriebsfreigabe und Temperaturen der Midea Portasplit.
- Kontrolle der externen Temperaturübertragung an die Heizkörperthermostate.
- Anwesenheitsübersicht einschließlich Home-Office-Status.

Für die grafische Grundrissdarstellung wird die **Easy Floorplan Card** verwendet. Zustandsabhängige Farben ermöglichen eine schnelle Erkennung der jeweiligen Betriebszustände und möglicher Abweichungen.

Die vollständige Beschreibung befindet sich in der separaten Dokumentation `dashboard-raumklima.md`.

## Netzwerk

Die Netzwerkansicht zeigt Batteriestände von Kontaktsensoren, Thermostaten und Heizkörperventilen sowie eine Übersicht der `device_tracker`-Zustände.

Ergänzend werden Freebox-Kennzahlen und Informationen zu automatischen Backups und der Windows-Sicherung angezeigt.

Für die dynamischen Tabellen wird die **Flex Table Card** verwendet.

Die vollständige Beschreibung befindet sich in der separaten Dokumentation `dashboard_netzwerk.md`.

## Verwendete Dashboard-Erweiterungen

Für die Darstellung werden zusätzliche benutzerdefinierte Dashboard-Karten verwendet:

| Erweiterung | Verwendung |
|---|---|
| Button Card | Individuell gestaltbare Anzeigen und Bedienelemente mit zustandsabhängigen Symbolen und Farben. |
| card-mod | Anpassung von Hintergründen, Abständen, Schriftgrößen und zustandsabhängigen Farben. |
| Config Template Card | Dynamische Farbbereiche der Batterie-Rundinstrumente anhand des eingestellten und geplanten Mindest-SoC. |
| Easy Floorplan Card | Grafische Grundrissdarstellung mit zugeordneten Sensoren, Geräten und Betriebszuständen. |
| Flex Table Card | Dynamische Tabellen für Batteriestände und Netzwerkgeräte in der Netzwerkansicht. |
| Home Flow Card | Grafische Darstellung der Energieflüsse zwischen PV, Batterien, Haus und Netz. |

Die Erweiterungen wurden über den Home Assistant Marketplace installiert.

> [!WICHTIG]
> Die genannten Erweiterungen sind benutzerdefinierte Dashboard-Karten beziehungsweise Frontend-Anpassungen. Es handelt sich nicht um eigenständige Home-Assistant-Apps oder Geräteintegrationen.

## Konfiguration

Die vollständige Dashboard-Konfiguration ist in der folgenden Datei hinterlegt:

`dashboard.yaml`

Die Datei enthält die Ansichten, Karten, verwendeten Entitäten und Darstellungseinstellungen.

Die Solar- und Raumklimasteuerung werden unabhängig vom Dashboard über eigene Helfer, Template-Sensoren und Automationen umgesetzt. Das Dashboard dient der Visualisierung, Kontrolle und Bedienung der jeweiligen Steuerungsfunktionen.

## 🔗 Verwendung & Verknüpfungen

- [Dashboard – Solar](dashboard-solar.md) – Aufbau und Darstellung der Solaransicht
- [Dashboard – Raumklima](dashboard-raumklima.md) – Aufbau und Darstellung der Klima-Ansicht
- [Dashboard – Netzwerk](dashboard_netzwerk.md) – Aufbau und Darstellung der Netzwerkansicht
- [Button Card](../dashboard-tools/button-card.md) – individuell gestaltbare Dashboard-Karten
- [card-mod](../dashboard-tools/card-mod.md) – Gestaltung und farbliche Hervorhebungen
- [Config Template Card](../dashboard-tools/config-template-card.md) – dynamische Mindest-SoC-Anzeige
- [Easy Floorplan Card](../dashboard-tools/easy-floorplan-card.md) – grafische Grundrissdarstellung
- [Flex Table Card](../dashboard-tools/flex-table-card.md) – dynamische Tabellen in der Netzwerkansicht
- [Home Flow Card](../dashboard-tools/home-flow-card.md) – grafische Energieflussanzeige
- [Dashboard-Konfiguration](../skripte/home-assistant/dashboard.yaml) – vollständige YAML-Konfiguration

---

[⬅️ Zurück zur Übersicht](../README.md)
