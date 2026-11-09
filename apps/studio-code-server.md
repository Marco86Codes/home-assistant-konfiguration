# Studio Code Server

## Beschreibung

Studio Code Server ermöglicht die Bearbeitung der Home-Assistant-Konfigurationsdateien direkt im Browser.

Die App wird insbesondere zur Verwaltung von YAML-Konfigurationen und Home-Assistant-Packages verwendet.

## Installation

1. **Einstellungen → Apps → App-Store** öffnen.
2. **Studio Code Server** auswählen.
3. **Installieren** anklicken.
4. App starten und über die Seitenleiste öffnen.

## Konfiguration

Folgende Einstellungen wurden vorgenommen:

| Einstellung | Wert |
|---|---|
| Beim Systemstart starten | Aktiviert |
| Watchdog | Aktiviert |
| Automatische Updates | Deaktiviert |
| In Seitenleiste anzeigen | Aktiviert |

Weitere App-Einstellungen wurden nicht verändert.

## Deutsche Rechtschreibprüfung

Für die Rechtschreibprüfung deutscher Kommentare und YAML-Dateien wurde die Erweiterung **German – Code Spell Checker** installiert.

### Installation des Sprachpakets

1. **Studio Code Server** öffnen.
2. Mit **Strg + Umschalt + X** die Erweiterungsverwaltung öffnen.
3. Nach **German – Code Spell Checker** suchen.
4. Die Erweiterung von **Street Side Software** auswählen.
5. **Installieren** anklicken.
6. Die Sicherheitsabfrage mit **Trust Publisher & Install** bestätigen.

Die Erweiterung **Code Spell Checker** wird ebenfalls benötigt.

### Spracheinstellungen

1. In **Studio Code Server** mit **Strg + Umschalt + P** die Befehlspalette öffnen.
2. **Preferences: Open User Settings (JSON)** auswählen.
3. In der geöffneten `settings.json` bis zum Ende der Datei scrollen.
4. Die neuen Einstellungen unmittelbar vor der letzten schließenden geschweiften Klammer `}` ergänzen.

Der bisherige Abschluss der Datei lautet:

```json
  "yaml.format.enable": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.rulers": [80, 88, 100, 120]
}
```

Dieser Abschnitt wird folgendermaßen erweitert:

```json
  "yaml.format.enable": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.rulers": [80, 88, 100, 120],
  "cSpell.language": "en,de",
  "editor.unicodeHighlight.nonBasicASCII": false
}
```

5. Die Änderungen mit **Strg + S** speichern.

Die neuen Einstellungen werden innerhalb der bestehenden `settings.json` auf der obersten Ebene ergänzt. Alle übrigen Einstellungen bleiben unverändert.

Das Komma hinter `"editor.rulers"` ist erforderlich, da weitere Eigenschaften folgen.

Die Einstellung `cSpell.language` aktiviert die deutsche und englische Rechtschreibprüfung.

Die Einstellung `editor.unicodeHighlight.nonBasicASCII` deaktiviert die Hervorhebung von Nicht-ASCII-Zeichen, sodass deutsche Umlaute nicht mehr eingerahmt werden.

**Hinweis:** Die Unicode-Einstellung betrifft sämtliche Nicht-ASCII-Zeichen, nicht ausschließlich deutsche Umlaute.

## Home-Assistant-Packages

Zur strukturierten Verwaltung der YAML-Konfigurationen werden Home-Assistant-Packages verwendet.

Dadurch lassen sich zusammengehörige Sensoren, Helfer, Automationen und Skripte nach Themengebieten organisieren.

### Package-Einbindung

In der Datei `/config/configuration.yaml` wurde folgender Abschnitt ergänzt:

```yaml
homeassistant:
  packages: !include_dir_named packages
```

Die vorhandenen Standard-Einbindungen bleiben bestehen.

### Verzeichnisstruktur

Im Home-Assistant-Konfigurationsverzeichnis wurde der Ordner `packages` angelegt.

```text
/config/
├── configuration.yaml
├── automations.yaml
├── scripts.yaml
├── scenes.yaml
└── packages/
    └── spezifische-konfiguration.yaml
```

Die Dateien im Ordner `packages` werden thematisch getrennt angelegt und enthalten die jeweils zusammengehörigen Home-Assistant-Konfigurationen.

Neue YAML-Dateien werden automatisch über die Package-Einbindung berücksichtigt. Eine erneute Anpassung der `configuration.yaml` ist dafür nicht erforderlich.

### Konfiguration prüfen

Nach Änderungen an der YAML-Konfiguration:

1. **Einstellungen → Werkzeuge → YAML** öffnen.
2. Konfiguration prüfen.
3. Bei gültiger Konfiguration Home Assistant neu starten, sofern die Änderung dies erfordert.

Die Package-Einbindung wurde erfolgreich geprüft.

## Nützliche Links & Quellen

- [Home Assistant Packages](https://www.home-assistant.io/docs/configuration/packages/)
- [Studio Code Server](https://github.com/hassio-addons/addon-vscode)

---

## 🔗 Verwendung & Verknüpfungen

- [⬅️ Zurück zur Übersicht](../README.md)
