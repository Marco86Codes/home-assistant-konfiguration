
# Home-Assistant-Konfiguration

Diese Dokumentation beschreibt den Aufbau der zentralen Home-Assistant-Konfiguration und die Einbindung zusätzlicher YAML-Dateien.

Die Konfigurationsdateien werden über die Home-Assistant-Apps **File editor** und **Studio Code Server** bearbeitet.

## Konfigurationsverzeichnis

Die zentrale Konfiguration befindet sich im Verzeichnis `/config/`.

Die Datei `configuration.yaml` legt unter anderem fest, welche zusätzlichen Konfigurationsdateien und Verzeichnisse von Home Assistant eingebunden werden.

Die grundlegende Verzeichnisstruktur umfasst:

```text
/config/
├── configuration.yaml
├── automations.yaml
├── scripts.yaml
├── scenes.yaml
├── packages/
│   └── <PACKAGE-NAME>.yaml
└── themes/
```

Der Ordner `packages` enthält thematisch gegliederte YAML-Konfigurationen. Neue Packages können hinzugefügt werden, ohne die `configuration.yaml` erneut anzupassen.

Der Ordner `themes` wird für die Einbindung von Frontend-Themes verwendet.

## Zentrale configuration.yaml

Die verwendete `configuration.yaml` enthält folgende Einbindungen:

```yaml
# Loads default set of integrations. Do not remove.
default_config:

# Load Home Assistant packages
homeassistant:
  packages: !include_dir_named packages

# Load frontend themes from the themes folder
frontend:
  themes: !include_dir_merge_named themes

automation: !include automations.yaml
script: !include scripts.yaml
scene: !include scenes.yaml
```

### Standardintegrationen

```yaml
default_config:
```

`default_config` aktiviert die von Home Assistant vorgesehenen Standardintegrationen.

### Packages

```yaml
homeassistant:
  packages: !include_dir_named packages
```

Über diese Einbindung werden die YAML-Dateien aus dem Verzeichnis `/config/packages/` als Home-Assistant-Packages geladen.

Packages ermöglichen es, zusammengehörige Konfigurationen nach Themengebieten zu organisieren.

Ein Package kann beispielsweise folgende Konfigurationsbereiche enthalten:

- Automationen
- Helfer
- Sensoren
- Skripte
- Template-Sensoren

Die einzelnen Konfigurationsbereiche werden innerhalb der Package-Datei unter ihren jeweiligen YAML-Schlüsseln definiert.

### Frontend-Themes

```yaml
frontend:
  themes: !include_dir_merge_named themes
```

Die Einbindung lädt Theme-Definitionen aus den YAML-Dateien im Verzeichnis `/config/themes/`.

### Standarddateien

```yaml
automation: !include automations.yaml
script: !include scripts.yaml
scene: !include scenes.yaml
```

Diese Einbindungen verweisen auf die separaten Standarddateien für Automationen, Skripte und Szenen.

| Datei | Verwendung |
| --- | --- |
| `automations.yaml` | Automationen |
| `scenes.yaml` | Szenen |
| `scripts.yaml` | Skripte |

Die Standarddateien und die Package-Einbindung können parallel verwendet werden.

## Home-Assistant-Packages

### Aufbau

Im Verzeichnis `/config/packages/` werden zusammengehörige YAML-Konfigurationen in thematisch benannten Dateien organisiert.

Jede Package-Datei kann mehrere unterstützte Home-Assistant-Konfigurationsbereiche enthalten. Dadurch lassen sich beispielsweise Sensoren, Helfer und Automationen eines Themengebiets gemeinsam verwalten.

### Neue Packages einbinden

Neue YAML-Dateien werden im Verzeichnis `/config/packages/` angelegt.

Durch die vorhandene Einbindung mit `!include_dir_named` werden die Dateien beim Laden der Home-Assistant-Konfiguration berücksichtigt.

Eine erneute Anpassung der `configuration.yaml` ist dafür nicht erforderlich.

## Konfiguration bearbeiten

Für die Bearbeitung der Home-Assistant-Konfigurationsdateien werden zwei Apps eingesetzt.

| App | Verwendung |
| --- | --- |
| **File editor** | Direkte Bearbeitung von YAML-Dateien, insbesondere auf Smartphones und Tablets |
| **Studio Code Server** | Umfangreichere Bearbeitung und Verwaltung der YAML-Konfiguration im Browser |

Beide Apps greifen auf die Home-Assistant-Konfigurationsdateien zu.

Die Installation und die jeweiligen App-Einstellungen sind separat dokumentiert.

## Konfiguration prüfen

Nach Änderungen an YAML-Konfigurationen:

1. **Einstellungen → Werkzeuge → YAML** öffnen.
2. Die Konfiguration prüfen.
3. Bei gültiger Konfiguration die betroffenen Bereiche neu laden oder Home Assistant neu starten, sofern die Änderung dies erfordert.

Die Package-Einbindung wurde erfolgreich geprüft.

## Nützliche Links & Quellen

- [Home Assistant – Packages](https://www.home-assistant.io/docs/configuration/packages/)
- [Home Assistant – YAML-Konfiguration](https://www.home-assistant.io/docs/configuration/)

## 🔗 Verwendung & Verknüpfungen

- [File editor](../apps/file-editor.md) – Bearbeitung von Konfigurationsdateien
- [Studio Code Server](../apps/studio-code-server.md) – umfangreiche YAML-Bearbeitung im Browser

---

[⬅️ Zurück zur Übersicht](../README.md)
