# OwnTracks

Diese Dokumentation beschreibt die Einrichtung der **OwnTracks**-Integration in Home Assistant.

Die Integration empfängt die GPS-Standortdaten der eingebundenen Android- und iOS-Smartphones über HTTP und stellt sie als Geräte-Tracker bereit.

Die Standortdaten werden für die Anwesenheitserkennung und die Auswertung von Home-Assistant-Zonen verwendet.

## Einrichtung

Unter **Einstellungen → Geräte & Dienste → Integration hinzufügen** wurde die Integration **OwnTracks** ausgewählt und eingerichtet.

Für die Verbindung der Smartphones wird **HTTP** verwendet.

Bei der Einrichtung werden in einem Pop-up die benötigten Verbindungsdaten angezeigt:

- HTTP-URL
- Verschlüsselungsschlüssel

Diese Daten werden anschließend in der OwnTracks-App auf den jeweiligen Smartphones hinterlegt. Die konkrete Eingabe ist in den Android- und iOS-Anleitungen beschrieben.

## Benutzer

Für die verwendeten Smartphones wurden zuvor eigene Benutzer in Home Assistant angelegt.

Bei der Einrichtung von OwnTracks wird der jeweilige Home-Assistant-Benutzer als Benutzerkennung verwendet. Zusätzlich erhält jedes Smartphone eine eindeutige Geräte-ID.

Die Benutzer dürfen nicht auf lokalen Zugriff begrenzt sein, damit die Standortübertragung auch außerhalb des Heimnetzwerks funktioniert.

> [!WICHTIG]
> Die von Home Assistant bereitgestellte Webhook-URL und der Verschlüsselungsschlüssel sind vertraulich zu behandeln. Für die Übertragung über das Internet ist eine erreichbare HTTPS-Adresse erforderlich.

## Verwendung

OwnTracks übermittelt die GPS-Positionen der Smartphones an Home Assistant.

Die Integration stellt dafür entsprechende Geräte-Tracker bereit.

Beispiel für einen durch OwnTracks bereitgestellten Geräte-Tracker:

| Geräte-Tracker | Beschreibung |
|---|---|
| `device_tracker.person1_handy1owntracks` | GPS-Standort eines eingebundenen Smartphones |

Die Geräte-Tracker enthalten unter anderem GPS-Koordinaten, die GPS-Genauigkeit und das Attribut `in_zones`.

Das Attribut `in_zones` enthält die geografischen Zonen, denen Home Assistant den aktuellen Standort des Smartphones zuordnet.

Die weitere Verarbeitung der Standortdaten ist in der Dokumentation zur Anwesenheitserkennung beschrieben.

## Funktionstest

Nach der Einrichtung wurden die OwnTracks-Geräte-Tracker in Home Assistant erkannt.

Die übertragenen Standortdaten enthalten GPS-Koordinaten und das Attribut `in_zones`.

Die Home-Zone wird über `zone.home` erkannt und von der Anwesenheits-Automation ausgewertet.

Die Standortübertragung über OwnTracks wurde erfolgreich getestet.

## Nützliche Links & Quellen

- [Home Assistant – OwnTracks](https://www.home-assistant.io/integrations/owntracks/) – offizielle Dokumentation der Integration
- [OwnTracks](https://owntracks.org/) – offizielle Website
- [OwnTracks – Dokumentation](https://owntracks.org/booklet/) – Dokumentation der mobilen Anwendungen

## 🔗 Verwendung & Verknüpfungen

- [Anwesenheitserkennung](../grundlagen/anwesenheitserkennung.md) – Gesamtkonzept und Verarbeitung der Standortdaten
- [Anwesenheits-Automation](../skripte/home-assistant/automationen/aktualisierung-anwesenheit_home.yaml) – aktualisiert die Anwesenheits-Helfer anhand der Handy-Tracker
- [OwnTracks – Android](../externe-systeme/mobilgeraete/own-tracks-android.md) – Einrichtung auf Android-Smartphones
- [OwnTracks – iOS](../externe-systeme/mobilgeraete/own-tracks-ios.md) – Einrichtung auf iPhones

---

[⬅️ Zurück zur Übersicht](../README.md)
