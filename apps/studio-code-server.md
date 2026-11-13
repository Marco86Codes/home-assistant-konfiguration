
# Studio Code Server

Diese Dokumentation beschreibt die Einrichtung der Home-Assistant-App **Studio Code Server**.

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
| --- | --- |
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

## Home-Assistant-Konfiguration

Studio Code Server wird zur Bearbeitung der zentralen `configuration.yaml` und der thematisch gegliederten Home-Assistant-Packages verwendet.

Die Verzeichnisstruktur, die Package-Einbindung und die Prüfung der YAML-Konfiguration sind in der Grundlagen-Dokumentation beschrieben.

## Nützliche Links & Quellen

- [Studio Code Server](https://github.com/hassio-addons/addon-vscode)

## 🔗 Verwendung & Verknüpfungen

- [Home-Assistant-Konfiguration](../grundlagen/konfiguration.md) – zentrale YAML-Konfiguration, Packages und Dateistruktur

---

[⬅️ Zurück zur Übersicht](../README.md)
