# Home Assistant Companion App – Android

Diese Dokumentation beschreibt die Einrichtung der Home-Assistant-Companion-App auf Android-Smartphones für den lokalen und externen Zugriff auf Home Assistant sowie für die Anwesenheitserkennung.

## Verbindung

Unter **Verbindungsinformation** werden folgende Einstellungen verwendet:

| Einstellung | Konfiguration |
|---|---|
| Home Assistant-URL | Externe Home-Assistant-URL |
| Heimnetzwerk | SSID des Heim-WLANs |
| Interne Verbindungs-URL | Lokale Home-Assistant-Adresse im WLAN |
| Sicherheitsstufe der Fernverbindung | Am sichersten |

## App-Sicherheit

| Einstellung | Konfiguration |
|---|---|
| App sperren | Aktiviert |
| Im Heimnetzwerk entsperren | Deaktiviert |
| Sitzungstimeout (in Sekunden) | 30 |

Damit bleibt die App-Sperre auch im Heimnetzwerk aktiv.

## Darstellung und Verhalten

| Einstellung | Konfiguration |
|---|---|
| Bildschirmausrichtung | Hochformat |
| Beim Öffnen der App immer letzte Ansicht anzeigen | Aktiviert |
| Design | Dunkel |
| Mit Kopfhörer-Taste öffnen | Deaktiviert |
| Nach Updates Neuerungen anzeigen | Deaktiviert |
| Absturzberichte | Deaktiviert |

## Standort-Sensoren

Unter **Sensoren verwalten** sind folgende Sensoren aktiviert:

| Sensor | Konfiguration |
|---|---|
| Hintergrund-Standort | Aktiviert |
| Zone des Standorts | Aktiviert |

## Android-Systemeinstellungen

In den Android-Systemeinstellungen werden für die Home-Assistant-App folgende Berechtigungen verwendet:

| Einstellung | Konfiguration |
|---|---|
| Berechtigungen → Standort | Immer zulassen |
| Berechtigungen → Standort → Genauen Standort verwenden | Aktiviert |
| Akku | Nicht eingeschränkt |

Die uneingeschränkte Akkunutzung verhindert, dass Android die App durch die normale Akkuoptimierung unnötig im Hintergrund einschränkt.

## Anwesenheitserkennung

Die Companion App stellt für jedes eingebundene Smartphone einen Geräte-Tracker bereit. Dieser kann über eine Home-Assistant-Automation zur Anwesenheitserkennung verwendet werden.

Beispiel:

| Geräte-Tracker | Anwesenheits-Helfer |
|---|---|
| `device_tracker.person1_handy` | `input_boolean.anwesend_person1` |

Bei `home` wird der zugehörige Helfer eingeschaltet und bei `not_home` ausgeschaltet. Bei `unknown` oder `unavailable` bleibt der letzte Zustand erhalten.

Die Automation prüft bei jeder Zustandsänderung eines überwachten Trackers sowie beim Start von Home Assistant die aktuell konfigurierten Geräte-Tracker.

## Funktionstest

Nach der Einrichtung wird geprüft, ob die App im Heim-WLAN über die interne Adresse und außerhalb des WLANs über die externe Adresse erreichbar ist.

Für die Anwesenheitserkennung wird zusätzlich geprüft, ob der Tracker beim Betreten der Home-Zone `home` und beim Verlassen `not_home` meldet. Ein erfolgreicher Praxistest ist noch nicht dokumentiert.

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
