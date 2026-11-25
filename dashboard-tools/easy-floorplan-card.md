# Easy Floorplan Card

Diese Dokumentation beschreibt die Verwendung der **Easy Floorplan Card** zur grafischen Darstellung des Gebäudegrundrisses im Home-Assistant-Dashboard.

Die Erweiterung ermöglicht es, Zustände und Messwerte von Home-Assistant-Entitäten direkt an ihrer räumlichen Position darzustellen und bei Bedarf Geräte über den Grundriss zu bedienen.

## Installation

Die Easy Floorplan Card kann über HACS als benutzerdefiniertes Dashboard-Repository installiert werden. Alternativ ist eine manuelle Installation entsprechend der Projektdokumentation möglich.

> [!WICHTIG]
> Die Easy Floorplan Card ist eine benutzerdefinierte Dashboard-Karte. Es handelt sich nicht um eine eigenständige Home-Assistant-App oder Geräteintegration.

## Erstellung des Grundrisses

Die Karte verfügt über einen integrierten grafischen Editor. Wände, Fenster, Türen und weitere Elemente können direkt im Dashboard positioniert und bearbeitet werden. Ein externes Grundrissbild ist dafür nicht erforderlich, kann aber als Zeichenvorlage verwendet werden.

Mehrere Etagen können innerhalb einer Karte separat angelegt werden. Die zugehörige YAML-Konfiguration wird durch den Editor erzeugt und kann anschließend auch manuell angepasst werden.

## Verwendung

Im Klima-Dashboard wird die Easy Floorplan Card verwendet, um die Raumklimainformationen unmittelbar den jeweiligen Räumen zuzuordnen:

- Anzeige der aktuellen Raumtemperaturen und der Solltemperaturen.
- Farbliche Darstellung der gemeldeten Heizungszustände.
- Anzeige geöffneter Fenster und Türen anhand der zugeordneten Kontaktsensoren.
- Darstellung des Betriebszustands und der Temperaturen der Midea Portasplit.

Durch die räumliche Darstellung lassen sich die Zustände mehrerer Räume erfassen, ohne die einzelnen Geräteansichten öffnen zu müssen.

Die Karte übernimmt ausschließlich die Darstellung und gegebenenfalls die Bedienung der zugeordneten Entitäten. Die automatische Raumklimasteuerung erfolgt unabhängig davon über Template-Sensoren und Automationen.

## Konfiguration

Die Karte wird über den Kartentyp `custom:easy-floorplan-card` eingebunden. Die Konfiguration umfasst unter anderem die Abmessungen der Zeichenfläche, das Raster, die Etagen, die Wandverläufe, die Öffnungen und die positionierten Anzeigeelemente einschließlich ihrer Entitätszuordnungen.

Die veröffentlichte Dashboard-Konfiguration enthält einen anonymisierten Beispielgrundriss mit zwei Räumen. Der tatsächliche Gebäudegrundriss wird nicht veröffentlicht.

## Nützliche Links & Quellen

- [Easy Floorplan – GitHub](https://github.com/nicosandller/easy-floorplan)
- [Easy Floorplan – Konfiguration](https://github.com/nicosandller/easy-floorplan/blob/main/docs/configuration.md)

## 🔗 Verwendung & Verknüpfungen

- [Dashboard](../grundlagen/dashboard.md) – allgemeiner Aufbau und verwendete Dashboard-Tools
- [Home Assistant – dashboard.yaml](../skripte/home-assistant/dashboard.yaml) – vollständige Dashboard-Konfiguration

---

[⬅️ Zurück zur Übersicht](../README.md)
