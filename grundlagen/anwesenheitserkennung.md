# Anwesenheitserkennung

Diese Dokumentation beschreibt die Anwesenheitserkennung der Home-Assistant-Installation.

Ziel ist es, die Anwesenheit der eingebundenen Personen zuverlässig und zentral zu erfassen, um diese Informationen für Automationen und insbesondere für die Raumklimasteuerung verwenden zu können.

Die Standorterkennung erfolgt über **OwnTracks** auf den Smartphones. Home Assistant verarbeitet die Standortdaten und aktualisiert entsprechende Anwesenheits-Helfer.

## Konzept

Die Anwesenheitserkennung besteht aus mehreren getrennten Komponenten:

```text
Smartphones / OwnTracks             Radar-Präsenzsensor
          │                                  │
          ▼                                  ▼
Home-Assistant-Personen          Radar-Automation (10 / 30 Min.)
          │                                  │
          ▼                                  ▼
Anwesenheits-Prüfsensoren        Radar-Anwesenheits-Helfer
          │                                  │
          └───────────┬──────────────────────┘
                      ▼
          OwnTracks-Anwesenheits-Automation
                      │
                      ▼
              Anwesenheits-Helfer
                      │
              Raumklimasteuerung
```

Die Erkennung und die nachfolgende Verwendung der Anwesenheitsinformationen bleiben voneinander getrennt. Für eine Person ergänzt ein Radar-Präsenzsensor die Standorterkennung.

## Warum OwnTracks verwendet wird

Die Standorterkennung über die Home-Assistant-Companion-App erwies sich insbesondere bei der Hintergrundortung als nicht ausreichend zuverlässig.

Auf iOS-Geräten wurden Standortwechsel teilweise verzögert oder nicht zuverlässig erkannt. Auf Android-Geräten führte die Standorterkennung teilweise zu häufigen Aktualisierungen. Daher wurde für beide Plattformen eine einheitliche Standortübertragung über OwnTracks gewählt.

Aus diesem Grund wird **OwnTracks** als eigenständige Anwendung für die Standortübertragung verwendet.

OwnTracks übermittelt die GPS-Koordinaten der Smartphones über HTTP an Home Assistant.

Die Standorterkennung funktioniert damit unabhängig von der Home-Assistant-Companion-App.

## OwnTracks-Integration

In Home Assistant wird die **OwnTracks-Integration** verwendet.

Sie empfängt die Standortmeldungen der Smartphones und stellt für jedes eingebundene Gerät einen eigenen Geräte-Tracker bereit.

Die Verbindung erfolgt über HTTP.

Die Einrichtung der Integration und die Konfiguration der Smartphones sind in den jeweiligen Dokumentationen beschrieben.

## Home-Assistant-Zonen

OwnTracks liefert Standortinformationen, die in Home Assistant den Personen und geografischen Zonen zugeordnet werden. Die neue Automation wertet die daraus gebildeten Prüf-Sensoren aus.

Die wichtigste Zone ist `zone.home`.

| Zone | Verwendung |
|---|---|
| `zone.home` | Erkennung der Anwesenheit zu Hause |

Die verwendeten OwnTracks-Geräte-Tracker enthalten das Attribut `in_zones`.

Dieses Attribut gibt an, in welchen Home-Assistant-Zonen sich das jeweilige Smartphone befindet.

Befindet sich das Smartphone innerhalb der Home-Zone, enthält `in_zones` den Eintrag `zone.home`.

## Anwesenheits-Helfer und Prüf-Sensoren

Für fünf Personen wird jeweils ein `input_boolean` verwendet. Die Helfer speichern den zentralen Anwesenheitsstatus (`on` oder `off`) für nachfolgende Automationen.

Zusätzlich stellt `mobilgeraete.yaml` fünf Template-Sensoren zur Anwesenheitsprüfung bereit. Jeder Prüf-Sensor wertet den Zustand der zugehörigen `person.*`-Entität aus:

| Zustand der Person | Prüf-Sensor |
|---|---|
| `not_home` | `not_home` |
| Andere verfügbare Zustände, beispielsweise `home` | `home` |
| `unknown` oder `unavailable` | Sensor nicht verfügbar |

Die Zuordnung der Personen zu den Helfern ist in der veröffentlichten YAML-Datei anonymisiert (`person1` bis `person5`).

Ergänzend wird `input_boolean.anwesend_person5_radar` verwendet. Dieser Helfer speichert den zeitverzögert ausgewerteten Radarstatus.

## Home-Office-Erkennung

Ergänzend zur Anwesenheitserkennung über OwnTracks wird der Home-Office-Status einer Person anhand des WLAN-Geräte-Trackers ihres Laptops ermittelt.

Der Geräte-Tracker `device_tracker.laptop_person1_wlan` zeigt an, ob sich der Laptop im Heimnetz befindet. Die Automation **Aktualisierung Status Home Office** überträgt diesen Zustand auf den separaten Helfer `input_boolean.home_office_person1`.

| Zustand des Laptop-Trackers | Home-Office-Helfer |
|---|---|
| `home` | `on` |
| `not_home` | `off` |
| `unknown` oder `unavailable` | Letzten Status beibehalten |

Die Automation wird bei Zustandsänderungen des Laptop-Trackers und beim Start von Home Assistant ausgeführt. Der Home-Office-Helfer ist ebenfalls in `mobilgeraete.yaml` definiert.

Die Home-Office-Erkennung ist unabhängig von der Standorterkennung über OwnTracks. Beide Informationen stehen später für die Raumklimasteuerung zur Verfügung; die konkrete Steuerungslogik wird separat umgesetzt.

> [!WICHTIG]
> Die Home-Office-Erkennung erfolgt anhand des WLAN-Geräte-Trackers eines ausschließlich für das Home Office verwendeten Laptops. Da dieser Laptop nicht anderweitig genutzt wird, kann seine Anwesenheit im Heimnetz als Indikator für den Home-Office-Status verwendet werden.

## Automatische Aktualisierung der Anwesenheit

Die Automation **Aktualisierung OwnTracks Anwesenheit Home** reagiert auf Änderungen der fünf Anwesenheits-Prüfsensoren, des Radar-Helfers und des Radar-Präsenzsensors sowie auf den Start von Home Assistant.

Für vier Personen gilt:

| Prüf-Sensor | Anwesenheits-Helfer |
|---|---|
| `home` | `on` |
| `not_home` | `off` |
| `unknown` oder `unavailable` | Bisherigen Zustand beibehalten |

### Ergänzende Radar-Erkennung

Aufgrund der Problematik, dass iOS-Geräte ihre Standortdaten nicht immer zuverlässig übertragen, wird die Anwesenheitserkennung zusätzlich durch einen **HOBEIAN ZG-204ZK (24-GHz-Präsenzsensor)** unterstützt. Die Automation **Aktualisierung Radar Anwesenheit Home** aktualisiert den separaten Radar-Helfer mit Verzögerung:

| Radarsensor | Verhalten |
|---|---|
| `on` | Radar-Helfer nach 10 Minuten ununterbrochener Erkennung einschalten |
| `off` | Radar-Helfer nach 30 Minuten ununterbrochener Nichterkennung ausschalten |
| `unknown` oder `unavailable` | Radar-Helfer nicht verändern |

Wechselt der Sensor während der Wartezeit den Zustand, wird die laufende Verzögerung durch `mode: restart` abgebrochen und die neue Situation ausgewertet.

Die übergeordnete OwnTracks-Anwesenheits-Automation verwendet bei verfügbarem Radarsensor (`on` oder `off`) den **gespeicherten Radar-Helfer**. Ist der Radarsensor `unknown` oder `unavailable`, greift sie auf den zugehörigen Anwesenheits-Prüfsensor zurück, sofern dieser `home` oder `not_home` liefert. Sind beide Quellen nicht auswertbar, bleibt der bisherige Anwesenheits-Helfer unverändert.


> [!WICHTIG]
> Die Radar-Auswertung verwendet bei verfügbarem Radarsensor den verzögerten Radar-Helfer und nicht unmittelbar den aktuellen Zustand des Sensors.
>
> Nach einem Home-Assistant-Neustart wird der aktuelle Radarzustand erneut geprüft und die entsprechende Verzögerung von 10 beziehungsweise 30 Minuten neu gestartet. Eine zuvor bereits abgelaufene Wartezeit wird dabei nicht berücksichtigt.


## Warum separate Anwesenheits-Helfer verwendet werden

Die Steuerung des Raumklimas soll nicht direkt von den Standortmeldungen einzelner Smartphones abhängig sein.

Die Verwendung separater Helfer bietet mehrere Vorteile:

- **Zentrale Auswertung:** Die Standortdaten werden an einer Stelle verarbeitet.
- **Einheitliche Zustände:** Nachfolgende Automationen verwenden ausschließlich `on` und `off`.
- **Unabhängigkeit:** Die verwendete Standort-App kann ausgetauscht werden, ohne sämtliche nachfolgenden Automationen anzupassen.
- **Fehlerbehandlung:** Bei `unknown` oder `unavailable` bleibt der zuletzt gespeicherte Anwesenheitsstatus erhalten.

Damit bilden die Anwesenheits-Helfer die zentrale Schnittstelle zwischen der Standorterkennung und der Raumklimasteuerung.

## Verwendung in der Raumklimasteuerung

Die Anwesenheits-Helfer bilden eine zentrale Grundlage für die Raumklimasteuerung.

Die Raumklimasteuerung kann anhand der Helfer feststellen, ob sich relevante Personen zu Hause befinden.

Zusätzlich kann der separat erfasste Home-Office-Status berücksichtigt werden, um die Anwesenheit im Zusammenhang mit einem Arbeitstag auszuwerten.

Die konkrete Steuerungslogik wird unabhängig von der Standorterkennung umgesetzt.

Änderungen an OwnTracks oder den Geräte-Trackern müssen dadurch nicht unmittelbar in der Raumklimasteuerung nachvollzogen werden.

## 🔗 Verwendung & Verknüpfungen

- [OwnTracks-Anwesenheits-Automation](../skripte/home-assistant/automationen/aktualisierung-owntracks-anwesenheit-home.yaml) – automatische Aktualisierung der Anwesenheits-Helfer
- [Radar-Anwesenheits-Automation](../skripte/home-assistant/automationen/aktualisierung-radar-anwesenheit-home.yaml) – verzögerte Auswertung der Radar-Präsenz
- [Freebox](../apps/freebox.md) – Routerintegration und bewusst deaktivierte Geräte
- [Home-Office-Automation](../skripte/home-assistant/automationen/aktualisierung-status-home-office.yaml) – automatische Aktualisierung des Home-Office-Helfers
- [Mobilgeräte-Sensoren](../skripte/home-assistant/sensoren/mobilgeraete.yaml) – Definition der Anwesenheits-, Radar- und Home-Office-Helfer sowie der Prüf-Sensoren
- [OwnTracks](../apps/own-tracks.md) – Einrichtung der OwnTracks-Integration in Home Assistant
- [OwnTracks – Android](../externe-systeme/mobilgeraete/own-tracks-android.md) – Konfiguration auf Android-Smartphones
- [OwnTracks – iOS](../externe-systeme/mobilgeraete/own-tracks-ios.md) – Konfiguration auf iPhones

---

[⬅️ Zurück zur Übersicht](../README.md)
