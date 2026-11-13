
# Home Flow Card

Diese Dokumentation beschreibt die Verwendung der **Home Flow Card** zur grafischen Darstellung von Energieflüssen im Home-Assistant-Dashboard.

Die Erweiterung visualisiert Leistungswerte und Verbindungen zwischen verschiedenen Komponenten in einem gemeinsamen Energieflussdiagramm.

## Installation

Die **Home Flow Card** wurde über den Home Assistant Marketplace installiert.

> [!WICHTIG]
> Die Home Flow Card ist eine benutzerdefinierte Dashboard-Karte. Es handelt sich nicht um eine eigenständige Home-Assistant-App oder Geräteintegration.

## Verwendung

Die Home Flow Card stellt Komponenten als Knoten dar, die über Verbindungen miteinander verknüpft werden.

Dadurch lassen sich Leistungsflüsse und ihre Richtungen grafisch nachvollziehen.

### Beispiel: Solaransicht

In der Solaransicht zeigt die Home Flow Card die Energieflüsse zwischen:

- Den jeweils zwei PV-Eingängen beider Zendure SolarFlow 800 Plus.
- Den beiden Zendure-Geräten und ihren Batteriespeichern.
- Den AC-Ausgängen beider Zendure-Geräte.
- Dem gesamten Hausverbrauch.
- Dem öffentlichen Stromnetz.

Die Batterien werden mit bidirektionalen Energieflüssen dargestellt, sodass sowohl Lade- als auch Entladeleistung berücksichtigt werden.

Für die Darstellung werden unter anderem die PV-Eingangsleistungen, die Batterieleistungen, die tatsächlichen AC-Ausgangsleistungen, der berechnete Hausverbrauch und die gesamte Netzleistung verwendet.

Die einzelnen Komponenten werden über Knoten und Verbindungen zu einem gemeinsamen Energieflussdiagramm zusammengeführt.

## Konfiguration

Die Konfiguration der Home Flow Card ist Bestandteil der zentralen `dashboard.yaml`.

Dort werden die Knoten, Verbindungen, Positionen und Darstellungseinstellungen festgelegt.

## 🔗 Verwendung & Verknüpfungen

- [Dashboard](../grundlagen/dashboard.md) – allgemeiner Aufbau und verwendete Dashboard-Tools
- [Home Assistant – dashboard.yaml](../skripte/home-assistant/dashboard.yaml) – vollständige Dashboard-Konfiguration
- [Home Flow Card – GitHub](https://github.com/rosenrot00/home-flow-card) – Projektseite und Dokumentation

---

[⬅️ Zurück zur Übersicht](../README.md)
