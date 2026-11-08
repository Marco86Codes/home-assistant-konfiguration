
# card-mod

Diese Dokumentation beschreibt die Verwendung von **card-mod** zur individuellen Gestaltung der Karten im Home-Assistant-Dashboard.

Die Erweiterung ermöglicht die Anpassung der Darstellung über CSS und Home-Assistant-Templates.

## Installation

**card-mod** wurde über den Home Assistant Marketplace installiert.

> [!WICHTIG]
> card-mod ist eine benutzerdefinierte Erweiterung für Dashboard-Karten. Es handelt sich nicht um eine eigenständige Home-Assistant-App oder Geräteintegration.

## Verwendung

Im Solar-Dashboard wird card-mod für folgende Anpassungen verwendet:

- Transparente Kartenhintergründe und ausgeblendete Kartenrahmen.
- Anpassung von Abständen und Schriftgrößen.
- Zentrierte Überschriften.
- Ausblendung nicht benötigter Kartensymbole.
- Farbliche Hervorhebung bestimmter Betriebszustände.

Die farblichen Hervorhebungen werden über Templates abhängig von aktuellen Sensorwerten gesteuert.

| Farbe | Bedingung |
|---|---|
| Blau | Berechnete AC-Soll-Leistung unterscheidet sich von der eingestellten AC-Ausgangsgrenze. |
| Gelb | 50-%-PV-Begrenzung aktiv oder Batterieheizung eingeschaltet. |
| Rot | Wechselrichtertemperatur unter 0 °C oder über 60 °C beziehungsweise Batterietemperatur unter 0 °C oder über 40 °C. |

Die übrigen Karten werden überwiegend transparent dargestellt, um ein einheitliches Erscheinungsbild zu erreichen.

## Konfiguration

Die vollständigen CSS- und Template-Anpassungen befinden sich in:

[Home Assistant – dashboard.yaml](../../skripte/home-assistant/dashboard.yaml)

## Nützliche Links & Quellen

- [card-mod – GitHub](https://github.com/thomasloven/lovelace-card-mod)

## 🔗 Verwendung & Verknüpfungen

- [Dashboard-Konfiguration](../../skripte/home-assistant/dashboard.yaml) – CSS-Anpassungen und Statusfarben

---

[⬅️ Zurück zur Übersicht](../README.md)
