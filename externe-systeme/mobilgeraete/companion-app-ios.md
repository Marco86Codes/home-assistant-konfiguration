
# Home Assistant Companion App – iPhone

Diese Dokumentation beschreibt die Einrichtung der Home-Assistant-Companion-App auf dem iPhone für den lokalen und externen Zugriff auf Home Assistant sowie für die Anwesenheitserkennung.

## Verbindung

In den Einstellungen der Companion App werden die Verbindungsinformationen des Home-Assistant-Servers hinterlegt.

| Einstellung | Konfiguration |
|---|---|
| Home Assistant-URL | Externe Home-Assistant-URL |
| Heimnetzwerk | SSID des Heim-WLANs |
| Interne Verbindungs-URL | Lokale Home-Assistant-Adresse im WLAN |
| Sicherheitsstufe der Fernverbindung | Am sichersten |

## App-Sicherheit

Auf dem iPhone wird der Zugriff auf die Home-Assistant-App über die iOS-App-Sperre geschützt.

Dazu wird auf dem Home-Bildschirm das Symbol der Home-Assistant-App länger gedrückt und die Option **„Face ID anfordern“** aktiviert.

| Einstellung | Konfiguration |
|---|---|
| App mit Face ID schützen | Aktiviert |

Dadurch wird beim Öffnen der App eine Authentifizierung über Face ID beziehungsweise eine zulässige alternative Entsperrmethode verlangt.

Diese Funktion wird ab iOS 18 unterstützt.

## iPhone-Systemeinstellungen

Für die Standorterkennung und die Hintergrundaktualisierung werden folgende Berechtigungen verwendet.

| Einstellung | Konfiguration |
|---|---|
| Einstellungen → Datenschutz & Sicherheit → Ortungsdienste → Home Assistant | Immer |
| Genauer Standort | Aktiviert |
| Einstellungen → Allgemein → Hintergrundaktualisierung → Home Assistant | Aktiviert |
| Einstellungen → Mitteilungen → Home Assistant | Mitteilungen erlauben |

Der Stromsparmodus kann Hintergrundaktivitäten einschränken. Für eine möglichst zuverlässige Standortaktualisierung sollte der **Stromsparmodus** möglichst deaktiviert bleiben.

Die tatsächliche Häufigkeit der Standortaktualisierungen wird durch iOS gesteuert und kann nicht vollständig durch die Companion App festgelegt werden.

## Anwesenheitserkennung

Die Companion App stellt für jedes eingebundene iPhone einen Geräte-Tracker bereit. Dieser kann über eine Home-Assistant-Automation zur Anwesenheitserkennung verwendet werden.

Beispiel:

| Geräte-Tracker | Anwesenheits-Helfer |
|---|---|
| `device_tracker.person1_handy` | `input_boolean.anwesend_person1` |

Bei `home` wird der zugehörige Helfer eingeschaltet und bei `not_home` ausgeschaltet. Bei `unknown` oder `unavailable` bleibt der letzte Zustand erhalten.

Die Automation prüft bei jeder Zustandsänderung eines überwachten Trackers sowie beim Start von Home Assistant die aktuell konfigurierten Geräte-Tracker.

Die Anzahl der eingebundenen Geräte und die tatsächlichen Entitätsnamen werden ausschließlich in Home Assistant und in der zugehörigen Automation verwaltet.

## Funktionstest

Nach der Einrichtung wird geprüft, ob die App im Heim-WLAN über die interne Adresse und außerhalb des WLANs über die externe Adresse erreichbar ist.

Zusätzlich wird geprüft, ob die App beim Öffnen die konfigurierte Authentifizierung verlangt.

Für die Anwesenheitserkennung wird geprüft, ob der Geräte-Tracker beim Betreten der Home-Zone `home` und beim Verlassen `not_home` meldet.

Ein erfolgreicher Praxistest der Standorterkennung ist noch nicht dokumentiert.

## Nützliche Links & Quellen

- [Home Assistant Companion App – Offizielle Dokumentation](https://companion.home-assistant.io/) – Dokumentation der Companion App für Android und iOS
- [Home Assistant Companion App – Einrichtung](https://companion.home-assistant.io/docs/getting_started/) – Installation, Verbindung und Berechtigungen
- [Home Assistant Companion App – Standorterkennung](https://companion.home-assistant.io/docs/core/location/) – Standortaktualisierungen und Anwesenheitserkennung
- [Home Assistant Companion App – Verbindungssicherheit](https://companion.home-assistant.io/docs/getting_started/connection-security-level/) – Sicherheitsstufen für interne und externe Verbindungen

## 🔗 Verwendung & Verknüpfungen

- [Anwesenheits-Automation](../../skripte/home-assistant/automationen/aktualisierung-anwesenheit_home.yaml) – aktualisiert die Anwesenheits-Helfer anhand der Handy-Tracker
- [Mobilgeräte-Sensoren](../../skripte/home-assistant/sensoren/mobilgeraete.yaml) – definiert die Anwesenheits-Helfer für die eingebundenen Mobilgeräte

---

[⬅️ Zurück zur Übersicht](../../README.md)
