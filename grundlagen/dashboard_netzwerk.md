# Dashboard – Netzwerk

Diese Dokumentation beschreibt die Ansicht **Netzwerk** im eigenen Home-Assistant-Dashboard. Sie fasst Batteriestände ausgewählter Geräte, den Status von Netzwerkgeräten, Informationen zur Freebox und den Stand der Datensicherungen zusammen.

Die Ansicht ist in `dashboard.yaml` als **Sections-Ansicht** mit dem Pfad `netzwerk` und dem Symbol `mdi:lan` eingerichtet.

## Aufbau

Die Ansicht enthält folgende Bereiche:

| Bereich | Inhalt | Darstellung |
|---|---|---|
| Kontaktsensoren | Batteriestände von Kontaktsensoren | Flex Table Card |
| Thermostate | Batteriestände von Thermostaten | Flex Table Card |
| Heizkörperventile | Batteriestände von Heizkörperventilen | Flex Table Card |
| WLAN | Anwesenheitsstatus ausgewählter Netzwerkgeräte | Flex Table Card |
| Freebox | WLAN-Status, Datenraten, Temperaturen und Ventilator | Tile-Karten |
| Backups | Letztes Backup, nächster Termin und letzte Windows-Sicherung | Tile-Karten |

## Batteriestände

Die drei Batterietabellen werden automatisch aus vorhandenen Sensoren aufgebaut. Es müssen nicht für jedes Gerät eigene Tabellenzeilen angelegt werden.

| Gerätegruppe | Einbezogene Entitäten |
|---|---|
| Kontaktsensoren | `sensor.kontakt*_battery` |
| Thermostate | `sensor.thermostat*_battery` |
| Heizkörperventile | `sensor.heizung*_battery` |

Die Tabellen zeigen den **Gerätenamen** und den **Batteriestand in Prozent**. Die Namen werden für die Anzeige bereinigt, unter anderem um die Endungen `Batterie` und `Battery`. Die Sortierung erfolgt nach dem Gerätenamen.

### Farbige Batteriewarnungen

Über `card-mod` werden die Zeilen beziehungsweise Werte anhand des Batteriestands hervorgehoben:

| Batteriestand | Darstellung |
|---|---|
| Unter 25 % | Rot (`#E74C3C`), gesamte Tabellenzeile |
| Ab 25 % und unter 50 % | Blau (`#3498DB`), Batteriewert |
| Ab 50 % | Normale Darstellung |

Die Schwellen sind Darstellungsregeln des Dashboards; sie lösen in dieser Konfiguration keine eigenständige Benachrichtigung aus.

## WLAN-Geräteliste

Die WLAN-Tabelle verwendet `device_tracker.*` zur Darstellung der erkannten Netzwerkgeräte. Nicht relevante oder anderweitig erfasste Tracker können über eine Ausschlussliste gezielt ausgeblendet werden. Dadurch werden doppelte Einträge vermieden und die Netzwerkübersicht bleibt übersichtlich.

Die Tabelle zeigt **Gerätename** und **Status**:

| Tracker-Zustand | Anzeige |
|---|---|
| `home` | `Online` |
| Jeder andere Zustand | `Offline`, rot hervorgehoben |

Auch unbekannte oder nicht verfügbare Zustände erscheinen nach der aktuellen Kartenlogik als **Offline**. Die Anzeige ist daher eine vereinfachte Statusdarstellung und kein garantierter technischer Erreichbarkeitstest.

Die WLAN-Tabelle ist nach Gerätenamen sortiert. Die Datenbasis sind die in Home Assistant verfügbaren `device_tracker`-Entitäten; die Freebox-Integration ist eine mögliche Quelle dieser Entitäten.

## Freebox-Status

Der Freebox-Bereich verwendet die folgenden Entitäten:

| Anzeige | Entität |
|---|---|
| WLAN | `switch.freebox_v8_r1_wlan` |
| Download | `sensor.freebox_v8_r1_download_geschwindigkeit` |
| Upload | `sensor.freebox_v8_r1_upload_geschwindigkeit` |
| Temperatur 1 | `sensor.freebox_v8_r1_temperature_1` |
| Temperatur 2 | `sensor.freebox_v8_r1_temperature_2` |
| Interner Ventilator | `sensor.freebox_v8_r1_ventilateur_1` |

Die Werte stammen aus den jeweiligen Home-Assistant-Entitäten. Der WLAN-Schalter ist als Tile-Karte eingebunden; die konkrete Bedienbarkeit hängt von der Kartenkonfiguration und den Berechtigungen ab.

## Backup-Übersicht

Der Backup-Bereich zeigt drei Informationen:

| Anzeige | Entität |
|---|---|
| Letztes Backup | `sensor.letztes_erfolgreiches_automatisches_backup_anzeige` |
| Nächstes Backup | `sensor.nachstes_geplantes_automatisches_backup_datum` |
| Letzte Sicherung | `sensor.letzte_windows_sicherung_anzeige` |

Für die letzte Windows-Sicherung wird die Zeit seit `input_datetime.letzte_windows_sicherung` berechnet. Die Anzeige wird **blau bei mehr als 24 Stunden** und **rot bei mehr als 48 Stunden** hervorgehoben. Ohne gültigen Zeitstempel wird in der vorliegenden Darstellung kein Warnalter berechnet.

## Gestaltung und Erweiterungen

Die Ansicht verwendet die Home-Assistant-**Sections**-Darstellung, Standardkarten wie `markdown` und `tile` sowie folgende benutzerdefinierte Erweiterungen:

- **Flex Table Card:** Dynamische Tabellen für Batteriestände und Netzwerkgeräte.
- **card-mod:** Transparente Karten, angepasste Abstände und zustandsabhängige Farben.

Die Flex Table Card filtert Entitäten anhand von Namensmustern, verändert Anzeigetexte und sortiert die Tabellen. Änderungen an Entitätsnamen oder den verwendeten Mustern können beeinflussen, welche Geräte angezeigt werden.

## Funktionsprüfung

Nach Änderungen am Dashboard prüfen, ob alle vier Tabellen erscheinen, die Batteriestände korrekt zugeordnet werden, die WLAN-Statusanzeige plausibel ist und die Freebox- und Backup-Entitäten Werte liefern. Außerdem die Farbgrenzen für Batterien und die Zeitwarnungen der Windows-Sicherung kontrollieren.

Die Darstellung hängt von den tatsächlich verfügbaren und aktivierten Entitäten ab. Eine leere Tabelle kann daher auch auf fehlende passende Entitätsnamen zurückzuführen sein.

## 🔗 Verwendung & Verknüpfungen

- [Dashboard](../grundlagen/dashboard.md) – Übersicht aller Dashboard-Ansichten
- [Dashboard-Konfiguration](../skripte/home-assistant/dashboard.yaml) – vollständige YAML-Konfiguration
- [Freebox](../apps/freebox.md) – Routerintegration und bewusst deaktivierte Geräte

---

[⬅️ Zurück zur Übersicht](../README.md)
