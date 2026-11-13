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

## OwnTracks-App-Einstellungen

| Einstellung | Konfiguration |
|---|---|
| Dauerhafte Hintergrundbenachrichtigung | Aktiviert (für zuverlässigen Hintergrundbetrieb erforderlich) |
| Minimale Standortänderung | 500 |
| Standortintervall | 300 |
| Standortintervall (Bewegungsmodus) | 300 |
| Intervall für die Standortbestimmung | Aktiviert |

Die minimale Standortänderung ist in Metern angegeben, die Standortintervalle in Sekunden.

## Android-Systemeinstellungen

In den Android-Systemeinstellungen werden für **OwnTracks** folgende Berechtigungen verwendet:

| Einstellung | Konfiguration |
|---|---|
| Berechtigungen → Standort | Immer zulassen |
| Berechtigungen → Standort → Genauen Standort verwenden | Aktiviert |
| Akku | Nicht eingeschränkt |

Diese Einstellungen unterstützen die Hintergrundortung. Android kann Standortmeldungen dennoch verzögern. Die dauerhafte OwnTracks-Benachrichtigung sollte deshalb nicht deaktiviert werden.

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
