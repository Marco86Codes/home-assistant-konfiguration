
# Config Template Card

Diese Dokumentation beschreibt die Verwendung der **Config Template Card** im Home-Assistant-Dashboard.

Die Erweiterung ermöglicht es, Werte aus Home-Assistant-Entitäten dynamisch innerhalb einer Kartenkonfiguration zu verwenden.

## Installation

Die **Config Template Card** wurde über den Home Assistant Marketplace installiert.

> [!WICHTIG]
> Die Config Template Card ist eine benutzerdefinierte Dashboard-Karte. Es handelt sich nicht um eine eigenständige Home-Assistant-App oder Geräteintegration.

## Verwendung

Die Config Template Card wird für dynamische Kartendarstellungen verwendet, deren Eigenschaften von aktuellen Entitätszuständen oder berechneten Werten abhängen.

### Beispiel: Solaransicht

In der Solaransicht wird die Config Template Card für die Batterie-Rundinstrumente beider Zendure SolarFlow 800 Plus verwendet.

Das Batterie-Rundinstrument verwendet drei Farbbereiche:

| Farbe | Bedeutung |
| --- | --- |
| Rot | Unterhalb des tatsächlich im Zendure-Gerät eingestellten Mindest-SoC |
| Blau | Zwischen dem eingestellten Mindest-SoC und einem höheren geplanten Mindest-SoC |
| Grau | Oberhalb der Mindest-SoC-Grenzen |

Sind beide Mindest-SoC-Werte gleich, entfällt der blaue Bereich.

Verwendete Helfer:

- `input_number.zendure_1_neuer_min_soc`
- `input_number.zendure_2_neuer_min_soc`

Dadurch passt sich die Darstellung automatisch an die wetterabhängig berechneten Mindest-SoC-Werte an.

## Konfiguration

Die Kartenkonfiguration ist Bestandteil der zentralen `dashboard.yaml`.

Dort werden die verwendeten Entitäten, dynamischen Werte und Darstellungseinstellungen festgelegt.

## 🔗 Verwendung & Verknüpfungen

- [Dashboard](../grundlagen/dashboard.md) – allgemeiner Aufbau und verwendete Dashboard-Tools
- [Home Assistant – dashboard.yaml](../skripte/home-assistant/dashboard.yaml) – vollständige Dashboard-Konfiguration
- [Config Template Card – GitHub](https://github.com/iantrich/config-template-card) – Projektseite und Dokumentation

---

[⬅️ Zurück zur Übersicht](../README.md)
