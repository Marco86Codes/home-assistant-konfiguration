# OwnTracks – iOS

Diese Dokumentation beschreibt die Einrichtung von **OwnTracks** auf iPhones für die GPS-basierte Standortübertragung an Home Assistant.

Die Verbindung erfolgt über HTTP zur OwnTracks-Integration in Home Assistant.

## Verbindung

In der OwnTracks-App oben links auf das **ⓘ-Symbol** tippen und **Einstellungen (Settings)** öffnen.

Folgende Konfiguration wird verwendet:

| Einstellung | Konfiguration |
|---|---|
| Modus (Mode) | HTTP |
| URL | URL aus dem Pop-up bei der Einrichtung der OwnTracks-Integration |
| Authentifizierung (Authentication) | Aktiviert |
| UserID | Eindeutige OwnTracks-Benutzerkennung |
| Encryption Key | Verschlüsselungsschlüssel aus dem Pop-up bei der Einrichtung |

> [!WICHTIG]
> Für die Authentifizierung wird ein zuvor angelegter Home-Assistant-Benutzer verwendet. Dieser darf nicht auf lokalen Zugriff begrenzt sein, damit die Standortübertragung auch außerhalb des Heimnetzwerks funktioniert. Die Verbindung erfolgt verschlüsselt über HTTPS.

> [!WICHTIG]
> Wird ein Smartphone ersetzt, sollte nach Möglichkeit die bisherige Geräte-ID in OwnTracks weiterverwendet werden, sofern diese weiterhin sinnvoll ist.
>
> Bei Verwendung einer neuen Geräte-ID wird in Home Assistant ein zusätzliches Gerät angelegt. Bereits vorhandene OwnTracks-Geräte lassen sich in der aktuellen Installation nicht löschen, sondern lediglich deaktivieren.

## OwnTracks-App-Einstellungen

| Einstellung | Konfiguration |
|---|---|
| Minimale Standortänderung | 200 |
| Standortintervall | 180 |
| Standortintervall (Bewegungsmodus) | 180 |
| Intervall für die Standortbestimmung | Deaktiviert |

Die minimale Standortänderung ist in Metern angegeben, die Standortintervalle in Sekunden.

## iOS-Systemeinstellungen

In den iOS-Systemeinstellungen werden für **OwnTracks** folgende Berechtigungen verwendet:

| Einstellung | Konfiguration |
|---|---|
| Einstellungen → Datenschutz & Sicherheit → Ortungsdienste → OwnTracks | Immer |
| Genauer Standort | Aktiviert |
| Einstellungen → Allgemein → Hintergrundaktualisierung → OwnTracks | Aktiviert |
| Einstellungen → Mitteilungen → OwnTracks | Mitteilungen deaktiviert |

Die Standortberechtigung und die aktivierte Hintergrundaktualisierung unterstützen die Standorterfassung im Hintergrund. iOS steuert jedoch selbst, wann Standortänderungen an die App gemeldet werden. Ein festes Meldeintervall ist deshalb nicht garantiert.

## Ergänzende Radar-Anwesenheitserkennung

Da die Standortmeldungen auf iPhones im bisherigen Betrieb nicht immer zuverlässig beziehungsweise zeitnah eintreffen, wird für eine Person zusätzlich ein Radar-Präsenzsensor verwendet. Die Kombination der Signale und die zeitverzögerte Radar-Auswertung sind zentral in der [Anwesenheitserkennung](../../grundlagen/anwesenheitserkennung.md) dokumentiert. Diese Radar-Ergänzung ist keine zusätzliche Einstellung in OwnTracks.

## Funktionstest

Nach der Einrichtung wird geprüft, ob das iPhone seine GPS-Position an Home Assistant übermittelt.

Unter **Entwicklerwerkzeuge → Zustände** kann der entsprechende OwnTracks-Geräte-Tracker kontrolliert werden.

Dabei wird geprüft, ob die GPS-Koordinaten aktualisiert werden und das Attribut `in_zones` beim Betreten und Verlassen der Home-Zone entsprechend aktualisiert wird.

Die Standortübertragung über OwnTracks wurde erfolgreich getestet.

## 🔗 Verwendung & Verknüpfungen

- [OwnTracks – Home Assistant](../../apps/own-tracks.md) – Einrichtung der OwnTracks-Integration in Home Assistant
- [Anwesenheitserkennung](../../grundlagen/anwesenheitserkennung.md) – Gesamtkonzept und Verarbeitung der Standortdaten

---

[⬅️ Zurück zur Übersicht](../../README.md)
