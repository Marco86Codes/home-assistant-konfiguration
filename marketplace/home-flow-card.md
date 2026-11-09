
# Home Flow Card

Diese Dokumentation beschreibt die Verwendung der **Home Flow Card** zur grafischen Darstellung der Energieflüsse im Home-Assistant-Dashboard.

Die Erweiterung visualisiert die Verbindungen und Leistungsflüsse zwischen den Komponenten der Solaranlage.

## Installation

Die **Home Flow Card** wurde über den Home Assistant Marketplace installiert.

> [!WICHTIG]
> Die Home Flow Card ist eine benutzerdefinierte Dashboard-Karte. Es handelt sich nicht um eine eigenständige Home-Assistant-App oder Geräteintegration.

## Verwendung

Im Solar-Dashboard zeigt die Home Flow Card die Energieflüsse zwischen:

- Den jeweils zwei PV-Eingängen beider Zendure SolarFlow 800 Plus.
- Den beiden Zendure-Geräten und ihren Batteriespeichern.
- Den AC-Ausgängen beider Zendure-Geräte.
- Dem gesamten Hausverbrauch.
- Dem öffentlichen Stromnetz.

Die Batterien werden mit bidirektionalen Energieflüssen dargestellt, sodass sowohl Lade- als auch Entladeleistung berücksichtigt werden.

Für die Darstellung werden unter anderem die PV-Eingangsleistungen, die Batterieleistungen, die tatsächlichen AC-Ausgangsleistungen, der berechnete Hausverbrauch und die gesamte Netzleistung verwendet.

Die einzelnen Komponenten werden über Knoten und Verbindungen zu einem gemeinsamen Energieflussdiagramm zusammengeführt.

## Konfiguration

Die vollständige Konfiguration mit Knoten, Verbindungen, Positionen und Darstellungseinstellungen befindet sich in:

[Home Assistant – dashboard.yaml](../skripte/home-assistant/dashboard.yaml)

## Nützliche Links & Quellen

- [Home Flow Card – GitHub](https://github.com/rosenrot00/home-flow-card)

## 🔗 Verwendung & Verknüpfungen

- [Dashboard-Konfiguration](../skripte/home-assistant/dashboard.yaml) – Energieflussdiagramm mit allen Knoten und Verbindungen

---

[⬅️ Zurück zur Übersicht](../README.md)
