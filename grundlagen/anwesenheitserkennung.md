# Anwesenheitserkennung

Diese Dokumentation beschreibt die Anwesenheitserkennung der Home-Assistant-Installation.

Ziel ist es, die Anwesenheit der eingebundenen Personen zuverlässig und zentral zu erfassen, um diese Informationen für Automationen und insbesondere für die Raumklimasteuerung verwenden zu können.

Die Standorterkennung erfolgt über **OwnTracks** auf den Smartphones. Home Assistant verarbeitet die Standortdaten und aktualisiert entsprechende Anwesenheits-Helfer.

## Konzept

Die Anwesenheitserkennung ist in mehrere voneinander getrennte Komponenten aufgeteilt:

```text
Android- und iOS-Smartphones
           │
           │ GPS-Standortdaten
           ▼
        OwnTracks
           │
           │ HTTP
           ▼
Home Assistant – OwnTracks-Integration
           │
           │ Geräte-Tracker
           ▼
     Home-Assistant-Zonen
           │
           │ in_zones
           ▼
   Anwesenheits-Automation
           │
           │ Aktualisierung
           ▼
     Anwesenheits-Helfer
           │
           ├── Dashboard
           │
           └── Steuerung Raumklima
```

Dadurch sind die eigentliche Standorterkennung und die Verwendung der Anwesenheitsinformationen voneinander getrennt.

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

Die Anwesenheit wird anhand der in Home Assistant definierten geografischen Zonen ausgewertet.

Die wichtigste Zone ist `zone.home`.

| Zone | Verwendung |
|---|---|
| `zone.home` | Erkennung der Anwesenheit zu Hause |

Die verwendeten OwnTracks-Geräte-Tracker enthalten das Attribut `in_zones`.

Dieses Attribut gibt an, in welchen Home-Assistant-Zonen sich das jeweilige Smartphone befindet.

Befindet sich das Smartphone innerhalb der Home-Zone, enthält `in_zones` den Eintrag `zone.home`.

## Anwesenheits-Helfer

Für jede eingebundene Person wird ein eigener `input_boolean` verwendet.

Diese Helfer speichern den aktuellen Anwesenheitsstatus unabhängig vom jeweiligen Geräte-Tracker.

Beispiel:

| Geräte-Tracker | Anwesenheits-Helfer |
|---|---|
| `device_tracker.person1_handy1owntracks` | `input_boolean.anwesend_person1` |

Die Helfer besitzen zwei Zustände:

| Zustand | Bedeutung |
|---|---|
| `on` | Person ist zu Hause |
| `off` | Person ist abwesend |

Die Definition der Helfer erfolgt in `mobilgeraete.yaml`.

## Automatische Aktualisierung der Anwesenheit

Die Automation **Aktualisierung Anwesenheit Home** überwacht die OwnTracks-Geräte-Tracker.

Sie wird bei Zustandsänderungen der überwachten Tracker sowie beim Start von Home Assistant ausgeführt.

Für jede Person wird das Attribut `in_zones` geprüft.

| Bedingung | Aktion |
|---|---|
| `in_zones` enthält `zone.home` | Anwesenheits-Helfer einschalten |
| `in_zones` enthält `zone.home` nicht | Anwesenheits-Helfer ausschalten |
| Tracker ist `unknown` oder `unavailable` | Letzten Anwesenheitsstatus beibehalten |

Dadurch müssen nachfolgende Automationen nicht direkt auf die einzelnen OwnTracks-Geräte-Tracker zugreifen.

Stattdessen verwenden sie die zentralen Anwesenheits-Helfer.

> [!WICHTIG]
> Der Anwesenheitsstatus entspricht der zuletzt von Home Assistant verarbeiteten Standortmeldung. Bleiben neue Standortmeldungen aus, kann der gespeicherte Status vorübergehend vom tatsächlichen Aufenthaltsort abweichen.
>
> Bei einem verfügbaren Tracker ohne Attribut `in_zones` behandelt die aktuelle Automation die Person als abwesend.

## Warum separate Anwesenheits-Helfer verwendet werden

Die Steuerung des Raumklimas soll nicht direkt von den Standortmeldungen einzelner Smartphones abhängig sein.

Die Verwendung separater Helfer bietet mehrere Vorteile:

- **Zentrale Auswertung:** Die Standortdaten werden an einer Stelle verarbeitet.
- **Einheitliche Zustände:** Nachfolgende Automationen verwenden ausschließlich `on` und `off`.
- **Unabhängigkeit:** Die verwendete Standort-App kann ausgetauscht werden, ohne sämtliche nachfolgenden Automationen anzupassen.
- **Fehlerbehandlung:** Bei `unknown` oder `unavailable` bleibt der zuletzt gespeicherte Anwesenheitsstatus erhalten.

Damit bilden die Anwesenheits-Helfer die zentrale Schnittstelle zwischen der Standorterkennung und der Raumklimasteuerung.

## Verwendung in der Raumklimasteuerung

Die Anwesenheits-Helfer sind als zentrale Grundlage für die automatische Raumklimasteuerung vorgesehen.

Die Raumklimasteuerung kann anhand der Helfer feststellen, ob sich relevante Personen zu Hause befinden.

Zusätzlich kann der Arbeitsstatus berücksichtigt werden, um kurze Aufenthalte während eines Arbeitstags gesondert zu behandeln.

Die konkrete Steuerungslogik wird unabhängig von der Standorterkennung umgesetzt.

Änderungen an OwnTracks oder den Geräte-Trackern müssen dadurch nicht unmittelbar in der Raumklimasteuerung nachvollzogen werden.

## Funktionstest

Nach der Einrichtung wurde geprüft, ob die OwnTracks-Geräte-Tracker in Home Assistant verfügbar sind und Standortdaten übermitteln.

Die Geräte-Tracker liefern GPS-Koordinaten und das Attribut `in_zones`.

Die Home-Zone wird über `zone.home` erkannt.

Die Anwesenheits-Automation verarbeitet diese Informationen und aktualisiert die entsprechenden Helfer.

Die Standorterkennung über OwnTracks funktioniert im bisherigen Praxistest. Die langfristige Zuverlässigkeit wird weiterhin beobachtet.

## 🔗 Verwendung & Verknüpfungen

- [Anwesenheits-Automation](../skripte/home-assistant/automationen/aktualisierung-anwesenheit_home.yaml) – automatische Aktualisierung der Anwesenheits-Helfer
- [Mobilgeräte-Sensoren](../skripte/home-assistant/sensoren/mobilgeraete.yaml) – Definition der Anwesenheits-Helfer
- [OwnTracks](../apps/own-tracks.md) – Einrichtung der OwnTracks-Integration in Home Assistant
- [OwnTracks – Android](../externe-systeme/mobilgeraete/own-tracks-android.md) – Konfiguration auf Android-Smartphones
- [OwnTracks – iOS](../externe-systeme/mobilgeraete/own-tracks-ios.md) – Konfiguration auf iPhones

---

[⬅️ Zurück zur Übersicht](../README.md)
