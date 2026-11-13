
# Flex Table Card

Diese Dokumentation beschreibt die Installation und Verwendung der **Flex Table Card** im eigenen Home-Assistant-Dashboard.

Die Flex Table Card ist eine benutzerdefinierte Lovelace-Karte für dynamische Tabellen. Sie kann vorhandene Home-Assistant-Entitäten anhand von Mustern auswählen, Werte aufbereiten, Spalten definieren und die Ergebnisse sortieren.

## Installation

Die **Flex Table Card** wird über den **Home Assistant Marketplace** beziehungsweise die dort verfügbare Verwaltung benutzerdefinierter Frontend-Karten installiert.

1. Den Home Assistant Marketplace öffnen.
2. Nach **Flex Table Card** suchen.
3. Die Karte installieren.
4. Prüfen, ob die Frontend-Ressource eingebunden wurde; falls erforderlich, die Dashboard-Oberfläche neu laden.
5. Die Karte im Dashboard mit `type: custom:flex-table-card` verwenden.

> [!WICHTIG]
> Die Flex Table Card ist eine **benutzerdefinierte Dashboard-Karte** und keine eigenständige Home-Assistant-App oder Geräteintegration. Die benötigten Entitäten müssen bereits in Home Assistant vorhanden sein.

## Verwendung

Im Dashboard **Netzwerk** werden vier Flex-Table-Tabellen verwendet:

| Tabelle | Auswahl der Entitäten |
|---|---|
| Kontaktsensoren | `sensor.kontakt*_battery` |
| Thermostate | `sensor.thermostat*_battery` |
| Heizkörperventile | `sensor.heizung*_battery` |
| WLAN-Geräte | `device_tracker.*` mit expliziten Ausschlüssen |

Die Tabellen zeigen jeweils einen aufbereiteten Gerätenamen sowie den Batterie- oder Verbindungsstatus. Neue passende Entitäten können automatisch in den Tabellen erscheinen, sofern sie in Home Assistant aktiviert sind.

## Beispiel: Batterietabelle

Das folgende reduzierte Beispiel zeigt die Grundstruktur der im Dashboard verwendeten Karte:

```yaml
type: custom:flex-table-card
entities:
  include:
    - sensor.kontakt*_battery
columns:
  - name: Gerätename
    data: friendly_name
    modify: >-
      x.replace(/_/g, ' ')
       .replace(/ Batterie$/i, '')
       .replace(/ Battery$/i, '')
  - name: Batterie
    data: state
    modify: "x + ' %'"
sort_by: Gerätename
```

Die tatsächliche Konfiguration enthält zusätzlich eine leere Abstandsspalte, CSS-Spaltenbreiten und zustandsabhängige Formatierungen über `card-mod`.

## Beispiel: Netzwerkstatus

Für die Netzwerkübersicht werden die `device_tracker`-Entitäten verwendet. Nicht gewünschte Tracker sind in `entities.exclude` aufgeführt.

Die Spalte **Status** übersetzt `home` in **Online** und alle anderen Zustände in **Offline**. Offline-Werte werden rot dargestellt. Die Gerätenamen werden ebenfalls abhängig vom Zustand formatiert.

Diese Statusanzeige ist eine bewusst vereinfachte Darstellung der Tracker-Zustände; sie ersetzt keine separate technische Erreichbarkeitsprüfung.

## Darstellung mit card-mod

Zusätzlich zur Flex Table Card wird **card-mod** verwendet, um:

- Kartenhintergründe und Tabellenzeilen transparent darzustellen.
- Spaltenbreiten und Tabellenlayout anzupassen.
- Batteriestände unter **25 % rot** und zwischen **25 % und 50 % blau** hervorzuheben.
- Offline-Geräte in der WLAN-Tabelle rot anzuzeigen.

Die Farbregeln sind Teil der Dashboard-Konfiguration und nicht der Installation der Flex Table Card.

## Konfiguration und Hinweise

Die vollständigen Kartenkonfigurationen stehen in `dashboard.yaml` innerhalb der Ansicht `netzwerk`.

Die Auswahl über Muster wie `sensor.kontakt*_battery` hängt von den tatsächlichen Entitäts-IDs ab. Bei umbenannten Entitäten müssen die Filter gegebenenfalls angepasst werden. Bei fehlenden Tabelleninhalten zuerst die Entitätsverfügbarkeit und anschließend die Filter prüfen.

## Nützliche Links & Quellen

- [Flex Table Card – GitHub](https://github.com/custom-cards/flex-table-card)

## 🔗 Verwendung & Verknüpfungen

- [Dashboard – Netzwerk](../grundlagen/dashboard_netzwerk.md) – Verwendung der Tabellen
- [Dashboard](../grundlagen/dashboard.md) – Übersicht und Erweiterungen
- [Dashboard-Konfiguration](../skripte/home-assistant/dashboard.yaml) – vollständige Konfiguration

---

[⬅️ Zurück zur Übersicht](../README.md)
