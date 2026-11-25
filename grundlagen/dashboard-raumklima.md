# Dashboard – Raumklima

Diese Dokumentation beschreibt die Ansicht **Klima** im eigenen Home-Assistant-Dashboard. Ziel ist es, den Zustand der Räume, die Wärmeversorgung und die für die Steuerung relevanten Informationen auf einen Blick erfassen zu können, ohne die einzelnen Geräteansichten öffnen zu müssen.

Die Ansicht ist als **Sections-Ansicht** mit dem Symbol `mdi:home-thermometer` und maximal drei Spalten eingerichtet. Die eigentliche Raumklimasteuerung erfolgt unabhängig vom Dashboard über Template-Sensoren und Automationen.

## Aufbau

| Bereich | Darstellung |
| :--- | :--- |
| Grundriss | Easy Floorplan Card |
| Heizungssteuerung und Temperaturvorgaben | Tile-Karten |
| Midea Portasplit | Tile-Karten und Anzeige im Grundriss |
| Vergleich der Temperaturmessungen | Markdown- und Tile-Karten |
| Anwesenheit | Tile-Karten |

## Grundriss

Die Easy Floorplan Card stellt die Räume, Wände, Fenster und Türen in einer zweidimensionalen Ansicht dar. In der produktiven Konfiguration werden die Etagen getrennt dargestellt. Die anonymisierte Beispielkonfiguration soll die Darstellungsprinzipien anhand zweier Räume vermitteln, ohne den tatsächlichen Gebäudegrundriss offenzulegen.

Durch die räumliche Zuordnung der Messwerte und Zustände lässt sich unmittelbar erkennen, welcher Raum beheizt wird, welche Temperatur dort herrscht und ob ein Fenster geöffnet ist.

### Raumtemperatur und Solltemperatur

Die Ist-Temperatur wird als Zahlenwert im jeweiligen Raum angezeigt. Je nach Temperaturquelle wird dazu entweder das Attribut `current_temperature` der Climate-Entität oder der Messwert eines externen Temperatursensors verwendet.

Die Solltemperatur wird über das Attribut `temperature` der Climate-Entität neben dem Heizungssymbol in Gelb (`#FFFF00`) dargestellt. Damit lässt sich die aktuelle Temperaturvorgabe von der gemessenen Raumtemperatur unterscheiden.

### Heizungszustand

Für die farbliche Darstellung wird ein separater Template-Sensor verwendet, beispielsweise `sensor.heizung_raum1_steuerung_anzeige` aus `raumklima_dashboard.yaml`.

Der Sensor wertet den Betriebsmodus und den gemeldeten Heizungszustand (`running_state`, ersatzweise `hvac_action`, wenn `running_state` nicht vorhanden ist) aus. Dadurch wird nicht lediglich angezeigt, ob die Heizung grundsätzlich eingeschaltet ist, sondern auch, ob der Thermostat aktuell Heizbedarf meldet.

| Zustand | Farbe | Bedeutung |
| :--- | :--- | :--- |
| `off` | Grau (`#A0A0A0`) | Heizungssteuerung oder Thermostat ausgeschaltet |
| `idle` | Blau (`#3498DB`) | Thermostat aktiv, aktuell kein Heizbedarf gemeldet |
| `heat` | Rot (`#FF0000`) | Thermostat meldet aktiven Heizbetrieb |
| `unknown` | Weiß (`#FFFFFF`) | Heizungszustand nicht eindeutig bestimmbar |

Bei global deaktivierter Heizungssteuerung werden die Heizungssymbole einschließlich ihrer Solltemperaturen ausgeblendet. Die Ist-Temperaturen bleiben sichtbar.

Die Anzeige gibt den gemeldeten Zustand des Thermostats wieder. Sie ist keine Messung des tatsächlichen Heizwasserdurchflusses oder des Brennerzustands der Gastherme.

### Fenster und Türen

Geöffnete Fenster und Türen werden im Grundriss rot (`#E74C3C`) hervorgehoben. Die Darstellung erfolgt anhand der zugeordneten Kontaktsensoren.

Eine Besonderheit ist das Fenster mit der installierten Midea Portasplit. Da dieses während der Installation geöffnet bleiben kann, würde eine direkte Anzeige des physischen Kontakts dauerhaft ein geöffnetes Fenster signalisieren.

Deshalb wird hierfür der Template-Binärsensor `binary_sensor.kontakt_fenster_raum2_gross_anzeige` verwendet. Er übernimmt den geöffneten Zustand des physischen Kontakts nur bei der Betriebsoption `Demontiert`. In allen anderen Betriebsoptionen meldet der Anzeigesensor `off`.

Die Anzeige beschreibt damit den für diese Konfiguration relevanten Fensterzustand und nicht in jedem Betriebsmodus die tatsächliche mechanische Fensterposition.

## Globale Heizungssteuerung

| Anzeige | Entität | Funktion |
| :--- | :--- | :--- |
| Heizung | `input_boolean.status_heizung` | Umschalten durch Antippen |
| Standard | `input_number.heizung_temperatur_standard` | Anzeige der Standardtemperatur |
| Abgesenkt | `input_number.heizung_temperatur_abgesenkt` | Anzeige der abgesenkten Temperatur |

Bei aktivierter Heizungssteuerung wird die Heizungs-Kachel gelb (`#F4D03F`) mit schwarzer Schrift dargestellt. Bei deaktivierter Steuerung bleibt der Hintergrund transparent.

Die Temperaturvorgaben dienen in dieser Ansicht der Übersicht. Die Tippaktion der entsprechenden Kacheln ist deaktiviert, sodass die Werte nicht versehentlich durch Antippen verändert werden. Die minimale Temperaturvorgabe wird in diesem Bereich nicht separat angezeigt.

## Midea Portasplit

Die Betriebsoption wird über `input_select.option_midea_portasplit` angezeigt. Durch Antippen der Kachel wird mit `input_select.select_next` zyklisch zur nächsten Option gewechselt.

Die farbliche Darstellung unterscheidet die gewählte Option von der tatsächlichen Betriebsfreigabe:

| Bedingung | Darstellung |
| :--- | :--- |
| Betriebsoption `Demontiert` | Grau (`#9E9E9E`) |
| Betriebsfreigabe aktiv (`input_boolean.status_midea_portasplit` ist `on`) | Gelb (`#F4D03F`) mit schwarzer Schrift |
| Sonstige Zustände | Transparenter Hintergrund |

Die graue Darstellung bei `Demontiert` hat bei der Hintergrundfarbe Vorrang.

Bei aktiver Betriebsfreigabe erscheinen zusätzlich die gemessene Innentemperatur (`sensor.klimaanlage_portasplit_innentemperatur`) und die berechnete Solltemperatur (`sensor.midea_portasplit_solltemperatur`).

Im Grundriss wird die Midea Portasplit durch ein Klimaanlagensymbol mit der berechneten Solltemperatur dargestellt. Bei aktiver Freigabe ist das Symbol rot. Die Anzeige wird ausgeblendet, wenn die globale Heizungssteuerung oder die Midea-Betriebsfreigabe deaktiviert ist.

Die Betriebsfreigabe ist nicht mit einer bestätigten Kompressoraktivität gleichzusetzen. Auch die berechnete Solltemperatur ist nicht zwingend der vom Gerät bestätigte Sollwert. Die Modusauswahl enthält bereits die Option `Kühlen`; daraus ergibt sich jedoch noch keine automatisierte Raumkühlung.

## Vergleich der Temperaturmessungen

Bei Verwendung externer Temperatursensoren dient diese Übersicht der Kontrolle der Temperaturübertragung an die Heizkörperthermostate. Dazu wird der aktuell gemessene Raumtemperaturwert mit dem im jeweiligen Heizkörperthermostat hinterlegten externen Temperaturwert verglichen.

Die Übersicht wird aus Markdown- und Tile-Karten aufgebaut. Für die anonymisierte Konfiguration genügt eine Beispielzeile für Raum 2.

| Spalte | Bedeutung | Beispiel |
| :--- | :--- | :--- |
| Raum | Aus dem Gerätenamen abgeleitete Raumbezeichnung | Raum 2 |
| Heizung | Externer Temperaturwert des Heizkörperthermostats | `number.heizung_raum2_external_temperature_input` |
| Thermostat | Aktueller Messwert des externen Temperatursensors | `sensor.thermostat_raum2_temperature` |
| Update | Letzte Aktualisierung der Entität des externen Temperaturwerts (`last_updated`) | `number.heizung_raum2_external_temperature_input` |

Abweichungen zwischen den beiden Temperaturwerten werden farblich hervorgehoben. Zusätzlich wird der letzte Aktualisierungszeitpunkt des externen Temperaturwerts am Heizkörperthermostat angezeigt.

Die Kombination aus farblicher Kennzeichnung und Aktualisierungszeitpunkt ermöglicht eine schnelle Erkennung von Temperaturabweichungen sowie möglichen Verzögerungen oder Störungen bei der Temperaturübertragung.

Bei einer erneuten Übertragung eines unveränderten Temperaturwerts muss sich der angezeigte Aktualisierungszeitpunkt nicht zwangsläufig ändern.

## Anwesenheitsübersicht

Die Anwesenheitsübersicht zeigt den Zustand der Anwesenheits-Helfer durch Haussymbole (`mdi:home`). Sie ermöglicht es, die anwesenheitsabhängige Raumklimasteuerung besser nachzuvollziehen.

| Zustand | Farbe |
| :--- | :--- |
| Anwesend | Grün (`#4CAF50`) |
| Nicht anwesend beziehungsweise kein aktiver Anwesenheitsstatus | Grau (`#9E9E9E`) |
| Home Office aktiv | Blau (`#3498DB`) |

Sofern für eine Person ein Home-Office-Status eingerichtet ist, hat dessen Anzeige Vorrang vor der normalen Anwesenheitsanzeige. Dadurch lässt sich zwischen einer regulären Anwesenheit und der Anwesenheit aufgrund einer Tätigkeit im Home Office unterscheiden.

Die Symbole dienen ausschließlich der Darstellung; die Tippaktionen sind deaktiviert.

Die Anwesenheitsübersicht zeigt die globalen Anwesenheits- und Home-Office-Helfer und nicht die individuell für jeden Raum berechnete Anwesenheit.

## Darstellung und Anpassung

Die Easy Floorplan Card übernimmt die räumliche Darstellung. Die zusätzlichen Tile- und Markdown-Karten werden mit `card-mod` optisch angepasst, beispielsweise durch transparente Hintergründe, entfernte Rahmen und zustandsabhängige Farben.

Für weitere Räume können die Grundrisselemente, Messwertanzeigen und der Heizungs-Anzeigesensor entsprechend ergänzt werden. Die anonymisierte Sensor-Konfiguration enthält bewusst nur ein Beispiel für den Heizungs-Anzeigesensor und den besonderen Fenster-Anzeigesensor.

## Funktionsprüfung

Nach Anpassungen der Ansicht sollten die Zuordnung der Messwerte, die Heizungsfarben, die Fensteranzeige in den unterschiedlichen Midea-Betriebsoptionen, die Sichtbarkeit der Solltemperaturen und die Anwesenheitsfarben geprüft werden. Auch die beiden Bedienaktionen für den globalen Heizungsstatus und die Midea-Betriebsoption sollten kontrolliert werden.

## 🔗 Verwendung & Verknüpfungen

- [Dashboard](../grundlagen/dashboard.md) – Übersicht aller Dashboard-Ansichten

---

[⬅️ Zurück zur Übersicht](../README.md)
