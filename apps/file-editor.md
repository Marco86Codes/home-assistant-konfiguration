
# File editor

Diese Dokumentation beschreibt die Einrichtung der Home-Assistant-App **File editor**.

Der File editor ermöglicht das direkte Bearbeiten von Konfigurationsdateien über die Home-Assistant-Oberfläche. Er wird insbesondere verwendet, um YAML-Dateien auf Mobilgeräten einfacher bearbeiten zu können.

## Installation

Die App **File editor** wird über den Home-Assistant-App-Store installiert.

Nach der Installation wurden folgende App-Einstellungen verwendet:

| Einstellung | Konfiguration |
| --- | --- |
| Beim Systemstart starten | Aktiviert |
| Watchdog | Aktiviert |
| Automatische Updates | Deaktiviert |
| In Seitenleiste anzeigen | Aktiviert |

Durch die aktivierte Seitenleistenoption kann der File editor direkt über die Home-Assistant-Seitenleiste geöffnet werden.

Automatische Updates sind deaktiviert, damit Aktualisierungen bewusst durchgeführt werden können.

## Verwendung

Der File editor wird verwendet, um YAML-Konfigurationsdateien direkt in Home Assistant zu öffnen, zu bearbeiten und zu speichern.

Dies erleichtert insbesondere die Bearbeitung auf Smartphones und Tablets, ohne dass ein separater Dateizugriff erforderlich ist.

Nach Änderungen an YAML-Dateien muss je nach Konfiguration die entsprechende Integration oder Automation neu geladen beziehungsweise Home Assistant neu gestartet werden.

Der Aufbau der Home-Assistant-Konfiguration und die Einbindung zusätzlicher YAML-Dateien sind zentral in der Grundlagen-Dokumentation beschrieben.

## Funktionstest

Die App **File editor** wurde erfolgreich gestartet und ist über die Home-Assistant-Seitenleiste erreichbar.

## Nützliche Links & Quellen

- [Home Assistant – File editor](https://github.com/home-assistant/addons/tree/master/configurator)

## 🔗 Verwendung & Verknüpfungen

- [Home-Assistant-Konfiguration](../grundlagen/konfiguration.md) – Aufbau und Einbindung der YAML-Konfiguration

---

[⬅️ Zurück zur Übersicht](../README.md)
