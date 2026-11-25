# OwnTracks – Android

Diese Dokumentation beschreibt die Einrichtung von **OwnTracks** auf Android-Smartphones für die GPS-basierte Standortübertragung an Home Assistant.

Die Verbindung erfolgt über HTTP zur OwnTracks-Integration in Home Assistant.

## Verbindung

In der OwnTracks-App wird unter den Verbindungseinstellungen folgende Konfiguration verwendet:

| Einstellung | Konfiguration |
|---|---|
| Modus | HTTP |
| URL | URL aus dem Pop-up bei der Einrichtung der OwnTracks-Integration |
| Benutzername | Eindeutige OwnTracks-Benutzerkennung |
| Passwort | Bei der von Home Assistant bereitgestellten Webhook-URL nicht erforderlich |
| Verschlüsselungsschlüssel | Schlüssel aus der Einrichtung der OwnTracks-Integration, sofern in der App entsprechend konfiguriert |
| Geräte-ID | Individueller Gerätename |

> [!WICHTIG]
> Für die Authentifizierung wird ein zuvor angelegter Home-Assistant-Benutzer verwendet. Dieser darf nicht auf lokalen Zugriff begrenzt sein, damit die Standortübertragung auch außerhalb des Heimnetzwerks funktioniert. Die Verbindung erfolgt verschlüsselt über HTTPS.


> [!WICHTIG]
> Wird ein Smartphone ersetzt, sollte nach Möglichkeit die bisherige Geräte-ID in OwnTracks weiterverwendet werden, sofern diese weiterhin sinnvoll ist.
>
> Bei Verwendung einer neuen Geräte-ID wird in Home Assistant ein zusätzliches Gerät angelegt. Bereits vorhandene OwnTracks-Geräte lassen sich in der aktuellen Installation nicht löschen, sondern lediglich deaktivieren.


## OwnTracks-App-Einstellungen

| Einstellung | Konfiguration |
|---|---|
| Dauerhafte Hintergrundbenachrichtigung | Aktiviert (für zuverlässigen Hintergrundbetrieb erforderlich) |
| Minimale Standortänderung | 200 |
| Standortintervall | 180 |
| Standortintervall (Bewegungsmodus) | 180 |
| Intervall für die Standortbestimmung | Deaktiviert |

Die minimale Standortänderung ist in Metern angegeben, die Standortintervalle in Sekunden.

## Android-Systemeinstellungen

In den Android-Systemeinstellungen werden für **OwnTracks** folgende Berechtigungen verwendet:

| Einstellung | Konfiguration |
|---|---|
| Berechtigungen → Standort | Immer zulassen |
| Berechtigungen → Standort → Genauen Standort verwenden | Aktiviert |
| Akku | Nicht eingeschränkt |

Diese Einstellungen unterstützen die Hintergrundortung. Android kann Standortmeldungen dennoch verzögern. Die dauerhafte OwnTracks-Benachrichtigung sollte deshalb nicht deaktiviert werden.

## Ergänzende Radar-Anwesenheitserkennung

Da die Standortmeldungen auf iPhones im bisherigen Betrieb nicht immer zuverlässig beziehungsweise zeitnah eintreffen, wird für eine Person zusätzlich ein Radar-Präsenzsensor verwendet. Die Kombination der Signale und die zeitverzögerte Radar-Auswertung sind zentral in der [Anwesenheitserkennung](../../grundlagen/anwesenheitserkennung.md) dokumentiert. Diese Radar-Ergänzung ist keine zusätzliche Einstellung in OwnTracks.

## Funktionstest

Nach der Einrichtung wird geprüft, ob das Smartphone seine GPS-Position an Home Assistant übermittelt.

Unter **Entwicklerwerkzeuge → Zustände** kann der entsprechende OwnTracks-Geräte-Tracker kontrolliert werden.

Dabei wird geprüft, ob die GPS-Koordinaten aktualisiert werden und das Attribut `in_zones` beim Betreten und Verlassen der Home-Zone entsprechend aktualisiert wird.

Die Standortübertragung über OwnTracks wurde erfolgreich getestet.

## 🔗 Verwendung & Verknüpfungen

- [OwnTracks – Home Assistant](../../apps/own-tracks.md) – Einrichtung der OwnTracks-Integration in Home Assistant
- [Anwesenheitserkennung](../../grundlagen/anwesenheitserkennung.md) – Gesamtkonzept und Verarbeitung der Standortdaten

---

[⬅️ Zurück zur Übersicht](../../README.md)
