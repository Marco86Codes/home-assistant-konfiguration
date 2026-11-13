
# card-mod

Diese Dokumentation beschreibt die Verwendung von **card-mod** zur individuellen Gestaltung der Karten im Home-Assistant-Dashboard.

Die Erweiterung ermöglicht die Anpassung der Darstellung über CSS und Home-Assistant-Templates.

## Installation

**card-mod** wurde über den Home Assistant Marketplace installiert.

> [!WICHTIG]
> card-mod ist eine benutzerdefinierte Erweiterung für Dashboard-Karten. Es handelt sich nicht um eine eigenständige Home-Assistant-App oder Geräteintegration.

## Verwendung

card-mod wird verwendet, um das Erscheinungsbild von Dashboard-Karten individuell anzupassen.

Dazu gehören unter anderem:

- Transparente Kartenhintergründe und ausgeblendete Kartenrahmen.
- Anpassung von Abständen und Schriftgrößen.
- Zentrierte Überschriften.
- Ausblendung nicht benötigter Kartensymbole.
- Farbliche Hervorhebung bestimmter Betriebszustände.

Die Darstellung kann über Templates abhängig von aktuellen Sensorwerten verändert werden.

### Beispiel: Solaransicht

In der Solaransicht werden bestimmte Betriebszustände farblich hervorgehoben.

| Farbe | Bedingung |
| --- | --- |
| Blau | Berechnete AC-Soll-Leistung unterscheidet sich von der eingestellten AC-Ausgangsgrenze. |
| Gelb | Dynamische PV-Begrenzung (0–100 %) aktiv oder Batterieheizung eingeschaltet. |
| Rot | Wechselrichtertemperatur unter 0 °C oder über 60 °C beziehungsweise Batterietemperatur unter 0 °C oder über 40 °C. |

Die übrigen Karten werden überwiegend transparent dargestellt, um ein einheitliches Erscheinungsbild zu erreichen.

## Konfiguration

Die CSS- und Template-Anpassungen sind Bestandteil der zentralen `dashboard.yaml`.

Dort werden die individuellen Darstellungsregeln und zustandsabhängigen Formatierungen festgelegt.

## 🔗 Verwendung & Verknüpfungen

- [Dashboard](../grundlagen/dashboard.md) – allgemeiner Aufbau und verwendete Dashboard-Tools
- [Home Assistant – dashboard.yaml](../skripte/home-assistant/dashboard.yaml) – vollständige Dashboard-Konfiguration
- [card-mod – GitHub](https://github.com/thomasloven/lovelace-card-mod) – Projektseite und Dokumentation

---

[⬅️ Zurück zur Übersicht](../README.md)
