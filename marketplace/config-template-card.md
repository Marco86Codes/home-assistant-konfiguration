
# Config Template Card

Diese Dokumentation beschreibt die Verwendung der **Config Template Card** im Home-Assistant-Dashboard.

Die Erweiterung ermöglicht es, Werte aus Home-Assistant-Entitäten dynamisch innerhalb einer Kartenkonfiguration zu verwenden.

## Installation

Die **Config Template Card** wurde über den Home Assistant Marketplace installiert.

> [!WICHTIG]
> Die Config Template Card ist eine benutzerdefinierte Dashboard-Karte. Es handelt sich nicht um eine eigenständige Home-Assistant-App oder Geräteintegration.

## Verwendung

Im Solar-Dashboard wird die Config Template Card für die Batterie-Rundinstrumente beider Zendure SolarFlow 800 Plus verwendet.

Das Batterie-Rundinstrument verwendet drei Farbbereiche: Rot unterhalb des tatsächlich im Zendure-Gerät eingestellten Mindest-SoC, Blau zwischen diesem Wert und einem höheren geplanten Mindest-SoC sowie Grau oberhalb der Mindest-SoC-Grenzen. Sind beide Mindest-SoC-Werte gleich, entfällt der blaue Bereich.

Verwendete Helfer:

- `input_number.zendure_1_neuer_min_soc`
- `input_number.zendure_2_neuer_min_soc`

Dadurch passt sich die Darstellung automatisch an die wetterabhängig berechneten Mindest-SoC-Werte an.

## Konfiguration

Die vollständige Kartenkonfiguration befindet sich in:

[Home Assistant – dashboard.yaml](../skripte/home-assistant/dashboard.yaml)

## Nützliche Links & Quellen

- [Config Template Card – GitHub](https://github.com/iantrich/config-template-card)

## 🔗 Verwendung & Verknüpfungen

- [Dashboard-Konfiguration](../skripte/home-assistant/dashboard.yaml) – Verwendung der Config Template Card

---

[⬅️ Zurück zur Übersicht](../README.md)
