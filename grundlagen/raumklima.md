# Raumklimasteuerung

Diese Dokumentation beschreibt das Gesamtkonzept und die Steuerungslogik der eigenen Home-Assistant-Raumklimasteuerung. Die Heizungssteuerung berücksichtigt Anwesenheit, Fenster- und Türkontakte, individuelle Zeitfenster sowie den Ladezustand der Zendure-Batterien beim Einsatz der Midea Portasplit.

Die Midea Portasplit wird derzeit zur Unterstützung der Heizung eingesetzt. Die Auswahl und Umschaltung in den Kühlmodus ist bereits vorhanden; eine automatisierte Raumkühlungsregelung ist noch nicht umgesetzt.

## Ausgangssituation und Ziel

Eine reine Zeitsteuerung berücksichtigt nicht, ob ein Raum tatsächlich benötigt wird. Eine ausschließlich anwesenheitsabhängige Steuerung würde dagegen beispielsweise morgens vor dem Verlassen des Hauses oder während des Home Office auch ungenutzte Räume aufheizen. Deshalb kombiniert die Raumklimasteuerung Zeitfenster mit einer raumbezogenen Anwesenheitsauswertung.

Ziel ist es, Wärme bedarfsgerecht bereitzustellen, unnötiges Heizen zu vermeiden und trotzdem rechtzeitig eine angenehme Raumtemperatur zu erreichen. Die Temperaturvorgaben werden zentral eingestellt; jeder Raum entscheidet anhand seiner eigenen Nutzungsbedingungen, welche Vorgabe anzuwenden ist. Zusätzlich kann die Midea Portasplit gespeicherte Solarenergie zum Heizen nutzen.

## Aufbau und Regelablauf

- **SONOFF TRVZB:** Heizkörperthermostate mit interner oder externer Temperaturmessung.
- **Temperatur- und Feuchtigkeitssensoren:** Erfassung des Raumklimas; externe Temperaturwerte können an die Heizkörperthermostate übertragen werden. Die Luftfeuchtigkeit ist keine Eingangsgröße der hier beschriebenen Heizungslogik.
- **Fenster- und Türkontakte:** Berücksichtigung geöffneter Kontakte.
- **Anwesenheits-Helfer:** Raumbezogene Auswertung der Anwesenheit und gegebenenfalls des Home-Office-Status.
- **Midea Portasplit:** Ergänzender Heizbetrieb mit SoC-abhängiger Freigabe und Solltemperatur.
- **Helfer, Template-Sensoren und Automationen:** Berechnung und Umsetzung der Steuerungszustände.

```text
  Anwesenheit + Kontakte + Zeitfenster + globale Helfer
                         |
                         v
             Raumbezogener Steuerungssensor
                         |
                         v
                  Heizungsautomation
                         |
                         v
               Heizkörperthermostat

  Zendure-SoC + Betriebsoption --> Midea-Modusautomation
                                          |
                                          v
                                   Midea-Freigabe
                                          |
                     +--------------------+-------------------+
                     v                                        v
           Raumbezogene Steuerung                Midea-Heizautomation
                                                              ^
                                          Dynamische Midea-Solltemperatur
```

## Helfer und Template-Sensoren

Die Helfer und Steuerungssensoren sind im Package `raumklima.yaml` zusammengefasst.

| Helfer | Funktion |
| --- | --- |
| `input_boolean.status_heizung` | Globale Heizungsfreigabe |
| `input_boolean.status_midea_portasplit` | Betriebsfreigabe der Portasplit |
| `input_number.heizung_temperatur_minimum` | Minimale Solltemperatur (0–15 °C) |
| `input_number.heizung_temperatur_abgesenkt` | Abgesenkte Solltemperatur (0–30 °C) |
| `input_number.heizung_temperatur_standard` | Standard-Solltemperatur (0–30 °C) |
| `input_select.option_midea_portasplit` | Kühlen, Heizen, Aus oder Demontiert |

Die Temperaturvorgaben sind in Schritten von 1 °C einstellbar. Die tatsächlichen Gerätegrenzen sind zusätzlich zu berücksichtigen.

Die raumbezogenen Steuerungssensoren liefern einen numerischen Zustand; `sensor.midea_portasplit_solltemperatur` liefert dagegen direkt einen Temperaturwert.

## Raumbezogene Heizungslogik

Die Einstellungen am Anfang jedes Steuerungstemplates trennen die individuellen Nutzungsbedingungen eines Raumes von der gemeinsamen Entscheidungslogik. Dadurch lässt sich dieselbe Steuerung für unterschiedlich genutzte Räume einsetzen.

### Arbeits- und Wochenendtage

Nicht jeder Bewohner hat dieselben Arbeitszeiten oder freien Tage. Deshalb werden die Tage der Tagesabsenkung und die Tage mit einem späteren Ende der Nachtabsenkung unabhängig voneinander je Raum festgelegt.

| Einstellung | Bedeutung |
| --- | --- |
| `arbeitstage` | Tage, an denen die Morgen- und anwesenheitsabhängige Tagesabsenkung angewendet werden dürfen. Außerhalb dieser Tage entfällt diese Absenkung. |
| `wochenendtage` | Tage, an denen statt des regulären Endes der Nachtabsenkung das abweichende Ende verwendet wird. Maßgeblich ist der aktuelle Wochentag. |

Die Nummerierung entspricht `now().weekday()`: Montag = `0`, Dienstag = `1`, Mittwoch = `2`, Donnerstag = `3`, Freitag = `4`, Samstag = `5`, Sonntag = `6`. Beispielsweise steht `[0, 1, 2, 3, 4]` für Montag bis Freitag und `[5, 6]` für Samstag und Sonntag. Die Listen sind frei anpassbar und müssen nicht dem üblichen Arbeitswochenmodell entsprechen.

### Nachtabsenkung

Während der Nacht wird unabhängig von der Anwesenheit eine niedrigere Solltemperatur verwendet. Ein abweichendes Ende ermöglicht es, an freien Tagen später mit dem Aufheizen zu beginnen.

| Einstellung | Bedeutung |
| --- | --- |
| `nacht_start` | Beginn der Nachtabsenkung, beispielsweise `22` für 22:00 Uhr. |
| `nacht_ende` | Reguläres Ende der Nachtabsenkung, beispielsweise `5` für 05:00 Uhr. |
| `nacht_ende_wochenende` | Abweichendes Ende an den unter `wochenendtage` festgelegten Tagen, beispielsweise `8` für 08:00 Uhr. |

Das Template prüft die Uhrzeit über Mitternacht hinweg. Die Nachtabsenkung hat Vorrang vor der Morgen- und Tagesabsenkung.

### Morgenabsenkung

An Arbeitstagen werden vor dem Verlassen des Hauses häufig nur bestimmte Räume benötigt, beispielsweise Badezimmer und Schlafzimmer. Andere Räume müssen in dieser Zeit nicht auf die Standardtemperatur aufgeheizt werden, obwohl die Bewohner noch anwesend sind.

Mit `morgenabsenkung` lässt sich dieses Verhalten für jeden Raum separat festlegen:

| Einstellung | Bedeutung |
| --- | --- |
| `false` | Nach Ende der Nachtabsenkung wird bis zum Beginn der Tagesabsenkung die Standardtemperatur verwendet. Geeignet für Räume, die morgens benötigt werden. |
| `true` | Nach Ende der Nachtabsenkung bleibt die abgesenkte Temperatur bis zum Beginn der Tagesabsenkung unabhängig von der Anwesenheit aktiv. Geeignet für morgens nicht benötigte Räume. |

Die Morgenabsenkung gilt ausschließlich an den definierten `arbeitstage`. Sie verwendet dieselbe abgesenkte Solltemperatur wie die Nacht- und Tagesabsenkung, jedoch den Steuerungszustand 3 mit dessen Verzögerung.

### Tagesabsenkung und Anwesenheit

Während der üblichen Abwesenheitszeiten soll nur geheizt werden, wenn der betreffende Raum für anwesende Personen relevant ist. Gleichzeitig soll die Heizung rechtzeitig vor der erwarteten Rückkehr wieder auf Standardtemperatur wechseln, ohne erst auf die tatsächliche Ankunft warten zu müssen.

| Einstellung | Bedeutung |
| --- | --- |
| `absenkung_start` | Beginn des anwesenheitsabhängigen Zeitfensters in ganzen Stunden. Ab diesem Zeitpunkt entscheidet die relevante Anwesenheit über Standard- oder abgesenkte Temperatur. |
| `absenkung_ende` | Ende des Zeitfensters (exklusive). Danach wird unabhängig von der Anwesenheit die Standardtemperatur verwendet, sofern keine vorrangige Bedingung greift. Der Zeitpunkt kann so gewählt werden, dass der Raum vor der erwarteten Rückkehr aufheizt. |
| `anwesend` | Logische Auswertung der für den Raum relevanten Anwesenheits-Helfer. Bei einer ODER-Verknüpfung genügt eine relevante anwesende Person, um die Tagesabsenkung zu verhindern. |

Die Anwesenheit im Haus ist nicht automatisch mit dem Wärmebedarf jedes Raumes gleichzusetzen. In gemeinsam genutzten Räumen können mehrere Personen berücksichtigt werden, in individuell genutzten Räumen nur die jeweiligen Nutzer. Der Home-Office-Status ermöglicht es zusätzlich, eine arbeitende Person für bestimmte Räume aus der Anwesenheitsauswertung auszunehmen, während sie für andere Räume weiterhin berücksichtigt werden kann.

#### Beispiel eines Arbeitstages

Die folgende Übersicht verdeutlicht das Zusammenspiel anhand identischer beispielhafter Zeitfenster (Nachtabsenkung 22–05 Uhr, Tagesabsenkung 08–15 Uhr).

| Zeitraum | Morgens benötigter Raum (`false`) | Morgens nicht benötigter Raum (`true`) |
| --- | --- | --- |
| 00:00–05:00 | Abgesenkt | Abgesenkt |
| 05:00–08:00 | Standard | Abgesenkt |
| 08:00–15:00 | Anwesenheitsabhängig | Anwesenheitsabhängig |
| 15:00–22:00 | Standard | Standard |
| 22:00–24:00 | Abgesenkt | Abgesenkt |

Die Übersicht zeigt die berechneten Temperaturvorgaben ohne Schaltverzögerungen. Sie setzt eine aktivierte Heizung, geschlossene relevante Kontakte und keine Midea-Freigabe voraus.

### Fenster- und Türkontakte

Beim Lüften soll der Heizkörper nicht versuchen, die durch den Luftaustausch sinkende Raumtemperatur durch zusätzliche Heizleistung auszugleichen. Deshalb wird bei geöffnetem Kontakt die minimale Solltemperatur verwendet, statt die reguläre Zeit- oder Anwesenheitssteuerung fortzusetzen.

Die Variable `fenster_offen` fasst die relevanten Kontakte zusammen. Über eine ODER-Verknüpfung können mehrere Fenster und Türen sowie Kontakte angrenzender Räume berücksichtigt werden.

Das Fenster mit der montierten Midea Portasplit stellt einen Sonderfall dar: Es kann installationsbedingt geöffnet sein, ohne dass dies als reguläres Lüften gewertet werden soll. Deshalb wird dieser Kontakt nur bei der Betriebsoption `Demontiert` berücksichtigt. Die übrigen Kontakte bleiben unabhängig davon wirksam.

### Berücksichtigung der Midea Portasplit

Wird ein Raum durch die Portasplit mitgeheizt, sollen die Heizkörper nicht gleichzeitig auf die reguläre Solltemperatur regeln. Die Variable `midea_heizt` ermöglicht daher eine Absenkung der zugeordneten Heizkörper auf die minimale Solltemperatur.

In Räumen ohne Midea-Unterstützung ist die Variable fest auf `false` gesetzt. In den zugeordneten Räumen wird `input_boolean.status_midea_portasplit` ausgewertet. Dieser Helfer signalisiert die Betriebsfreigabe, nicht die tatsächlich gemessene Heizleistung. Das Template prüft dabei nicht zusätzlich die Betriebsoption `Heizen`.

## Heizungssteuerung

### Berechnung des Steuerungszustands

Die Bedingungen werden in der folgenden Reihenfolge geprüft. Die erste zutreffende Bedingung bestimmt den Zustand.

| Priorität | Zustand | Bedeutung | Solltemperatur / Modus | Verzögerung |
| ---: | ---: | --- | --- | --- |
| 1 | 0 | Globale Heizung deaktiviert | `off` | Keine |
| 2 | 1 | Fenster oder Tür geöffnet | Minimum / `heat` | 2 Minuten |
| 3 | 5 | Midea-Betriebsfreigabe im zugeordneten Raum | Minimum / `heat` | 2 Minuten |
| 4 | 2 | Nachtabsenkung | Abgesenkt / `heat` | Keine |
| 5 | 3 | Morgen- oder Tagesabsenkung | Abgesenkt / `heat` | 10 Minuten |
| 6 | 4 | Standardbetrieb | Standard / `heat` | 2 Minuten |

Die Reihenfolge stellt sicher, dass die globale Abschaltung und die Lüftung Vorrang haben. Anschließend wird die alternative Wärmeversorgung durch die Portasplit berücksichtigt. Erst danach entscheiden die zeit- und anwesenheitsabhängigen Bedingungen über den Wärmebedarf.

### Umsetzung am Heizkörperthermostat

Die Heizungsautomation reagiert auf Änderungen des Steuerungssensors sowie auf einen Home-Assistant-Neustart. Nach einer vorgesehenen Verzögerung wird der Zustand erneut geprüft, bevor die Betriebsart und Solltemperatur gesetzt werden. Durch `mode: restart` wird bei einer erneuten Auslösung ein noch laufender Ablauf abgebrochen. Die Verzögerungen verhindern, dass kurze Kontakt- oder Anwesenheitsänderungen unmittelbar zu einer neuen Temperaturvorgabe führen; die globale Abschaltung und Nachtabsenkung werden dagegen ohne Wartezeit umgesetzt.

Bei nicht numerisch lesbaren Temperaturvorgaben verwendet die Heizungsautomation Rückfallwerte von 5 °C (Minimum), 20 °C (abgesenkt) und 22 °C (Standard). Ein nicht zuordenbarer Steuerungszustand löst keine der sechs Aktionsfolgen aus.

### Geräteeinstellungen der Heizkörperthermostate

Nach einem Firmware-Update der Heizkörperthermostate können die Geräteeinstellungen auf ihre Standardwerte zurückgesetzt werden. Die Automationen überwachen deshalb die relevanten Einstellungen und stellen bei Abweichungen die gewünschte Gerätekonfiguration automatisch wieder her.

Dadurch müssen die individuellen Einstellungen nach einem Update nicht erneut manuell vorgenommen werden. Die Automationen reagieren auf Änderungen der überwachten Einstellungen, einen Home-Assistant-Neustart sowie eine regelmäßige zeitgesteuerte Überprüfung.

| Einstellung | Interne Temperaturmessung | Externe Temperaturmessung |
| --- | --- | --- |
| Kindersicherung | Aktiviert | Aktiviert |
| Smart Temperature Control | Deaktiviert | Deaktiviert |
| Temperaturkalibrierung (Beispiel) | −1,4 °C | −1,6 °C |
| Temperature Accuracy | −0,4 °C | −0,4 °C |
| Valve Closing Degree (Beispiel) | 95 % | 90 % |
| Temperaturquelle | `local_temperature` | `remote_temperature` |
| Regelmäßige Überprüfung | Stündlich | Alle 5 Minuten |


Die Temperaturquelle bestimmt, ob der Thermostat seine eigene Messung oder einen externen Raumtemperaturwert verwendet. Eine externe Messung ermöglicht eine Temperaturerfassung abseits des Heizkörpers, wo dessen unmittelbare Wärme die Messung beeinflussen kann.

Bei externer Temperaturmessung wird zusätzlich der numerische Messwert des externen Sensors an `number.heizung_raum2_external_temperature_input` übertragen. Auch mehrere Thermostate können denselben externen Sensor verwenden. Die Temperaturkalibrierung ist individuell an die jeweiligen Geräte und deren Einbausituation anzupassen.

#### Anpassung des Ventilschließgrads (Valve Closing Degree)

Das Gebäude verfügt über eine ältere Gasheizung, deren Heizwasser über die vorhandenen Heizkörper verteilt wird.

Der Ventilschließgrad (`valve_closing_degree`) der Heizkörperthermostate wurde bewusst auf 90 beziehungsweise 95 % begrenzt. Dadurch sollen die Heizkörperventile auch nach Erreichen der Solltemperatur nicht vollständig schließen, sondern eine geringe Restöffnung beibehalten.

Ziel dieser Einstellung ist es, bei laufender Heizwasserumwälzung einen gewissen Wasserdurchfluss weiterhin zu ermöglichen. Dadurch können die Heizkörper eine geringe Restwärme abgeben und kühlen während des laufenden Heizbetriebs weniger stark aus.

Gleichzeitig soll verhindert werden, dass durch das gleichzeitige vollständige Schließen mehrerer Heizkörperventile die Wärmeabnahme des Heizsystems zu stark reduziert wird.

Insbesondere bei älteren Gasheizungen kann eine zu geringe Wärmeabnahme dazu führen, dass die Vorlauftemperatur bei bestehender Wärmeanforderung schnell ansteigt und der Brenner in kurzen Abständen aus- und wieder eingeschaltet wird (Takten).

Die Begrenzung des Ventilschließgrads soll diesem Verhalten entgegenwirken und einen gleichmäßigeren Heizbetrieb unterstützen.

> [!HINWEIS]
> Die gewählten Einstellungen sind auf die vorhandene Heizungsanlage abgestimmt. Der prozentuale Ventilschließgrad entspricht nicht unmittelbar dem tatsächlichen Wasserdurchfluss. Die geeigneten Werte hängen von den verwendeten Ventilen, der hydraulischen Auslegung und dem Verhalten der Heizungsanlage ab.

### Globale Heizungsfreigabe und Temperaturvorgaben

Beim Einschalten der globalen Heizungsfreigabe werden die Automationen mit dem Label `heizung` aktiviert und nach einer Minute ausgelöst. Beim Ausschalten werden sie nach einer Minute deaktiviert und laufende Aktionen gestoppt. Die Wartezeit ermöglicht den Heizungsautomationen zunächst die Umsetzung des Zustands 0.

Änderungen der zentralen Temperaturvorgaben lösen die zugeordneten Raumheizungsautomationen erneut aus. Die Automation enthält zusätzlich eine Midea-Temperaturaktualisierung unter der vorhandenen Gerätebedingung `switch.is_off`.

## Midea Portasplit im Heizbetrieb

### Betriebsoption und Batteriefreigabe

Die Portasplit soll bevorzugt mit verfügbarer gespeicherter Solarenergie heizen. Die SoC-Grenzen begrenzen deshalb die Betriebsfreigabe, damit die Batterien nicht allein durch diesen zusätzlichen Verbraucher weiter entladen werden. Der Ladezustand dient als Freigabekriterium; er ist kein Nachweis dafür, dass die Portasplit ausschließlich mit Solarstrom versorgt wird.

Die Modusautomation wertet die gewählte Betriebsoption und `sensor.zendure_gesamt_soc_durchschnitt` aus. Sie reagiert auf Änderungen des SoC, auf eine seit zehn Sekunden bestehende Änderung der Betriebsoption und auf einen Home-Assistant-Neustart.

| Durchschnittlicher Batterie-SoC | Verhalten bei Heizen oder Kühlen |
| --- | --- |
| Unter 40 % | Betriebsfreigabe aus |
| 40 bis einschließlich 50 % | Bisherige Freigabe beibehalten |
| Über 50 % | Betriebsfreigabe ein |
| Ungültiger Wert | Betriebsfreigabe aus |

Die Hysterese verhindert häufiges Umschalten im Bereich zwischen den beiden Grenzwerten. Bei `Aus` oder `Demontiert` wird das Gerät unabhängig vom SoC ausgeschaltet. Die Modusautomation ist nicht an `status_heizung` gekoppelt.

Bei freigegebenem Heizbetrieb werden die Heizmodus-Automationen aktiviert und ausgelöst. Die Betriebsoption `Kühlen` schaltet bereits in den Kühlmodus um, enthält aber noch keine eigenständige automatisierte Kühlungsregelung.

### Dynamische Solltemperatur

Bei hohem Ladezustand wird die verfügbare Energie genutzt, um tagsüber eine höhere Raumtemperatur anzustreben. Dadurch kann Wärme bereits bei guter Energiereserve bereitgestellt werden. Nachts hat dagegen die abgesenkte Temperatur Vorrang. Der Sollwert wird unabhängig von den raumbezogenen Anwesenheits- und Tagesabsenkungsbedingungen berechnet.

| Batterie-SoC | Temperaturbonus |
| --- | ---: |
| Über 90 % | +4 °C |
| Über 80 bis einschließlich 90 % | +3 °C |
| Über 70 bis einschließlich 80 % | +2 °C |
| Über 60 bis einschließlich 70 % | +1 °C |
| Bis einschließlich 60 % | 0 °C |

Die Solltemperatur ist auf maximal 25 °C begrenzt. Während der Nachtabsenkung wird stattdessen die abgesenkte Temperatur ohne SoC-Bonus verwendet, ebenfalls begrenzt auf 25 °C. Bei ungültigem SoC verwendet die Berechnung 0 %, bei ungültigen Temperaturvorgaben 21 °C (Standard) beziehungsweise 19 °C (abgesenkt).

Die Midea-Heizautomation überträgt die berechnete Solltemperatur bei Änderung des Sensors oder Einschalten der Midea-Freigabe, sofern die Betriebsoption `Heizen`, die Freigabe aktiv und der Sollwert numerisch gültig ist.

## Labels

Für die zentrale Aktivierung und Deaktivierung zusammengehöriger Automationen werden Home-Assistant-Labels verwendet.

Dadurch müssen die einzelnen Automationen innerhalb der globalen Status- und Modusautomationen nicht separat hinterlegt werden. Wird beispielsweise die Heizungssteuerung um einen weiteren Raum erweitert, genügt es, der neuen Raumheizungsautomation das entsprechende Label zuzuordnen.

Für die labelbasierte Steuerung sind die folgenden Label-IDs vorgesehen:

| Label-ID | Verwendung |
| :--- | :--- |
| `heizung` | Gruppierung der Raumheizungsautomationen zur gemeinsamen Aktivierung und Deaktivierung über den globalen Heizungsstatus |
| `midea_portasplit_heizung` | Aktivierung und Deaktivierung der Midea-Heizautomation in Abhängigkeit vom gewählten Betriebsmodus |
| `midea_portasplit_kuhlung` | Für eine spätere automatisierte Kühlungsregelung vorgesehen; bereits in der Modusautomation berücksichtigt |

Die globalen Status- und Modusautomationen dürfen nicht selbst den von ihnen geschalteten Automationsgruppen angehören. Dadurch bleiben sie auch bei deaktivierter Heizungssteuerung beziehungsweise deaktivierter Midea Portasplit ausführbar und können die zugehörigen Automationen bei Bedarf wieder aktivieren.

Die Labels müssen in Home Assistant angelegt und den entsprechenden Automationen zugeordnet werden. Die YAML-Beispiele enthalten diese Zuordnungen nicht.

## Dashboard-Anzeige

Das separate Package `raumklima_dashboard.yaml` bereitet den gemeldeten Heizungszustand (`off`, `heat`, `idle`, `unknown`) und den besonderen Fensterkontakt der Portasplit für die Darstellung auf. Diese Anzeigesensoren steuern keine Geräte. Sie sind von den numerischen Steuerungssensoren zu unterscheiden.

## Verhalten bei Neustart und Nichtverfügbarkeit

| Situation | Verhalten |
| --- | --- |
| Home-Assistant-Neustart | Raumheizungs-, Geräteeinstellungs- und Midea-Modusautomationen besitzen einen Neustart-Auslöser, sofern die jeweilige Automation aktiviert ist. |
| Fensterkontakt nicht verfügbar | Wird nicht als geöffnet gewertet. |
| Anwesenheits-Helfer nicht verfügbar | Ein nicht verfügbarer Helfer erfüllt die Prüfung auf `on` nicht. |
| Externer Temperaturwert ungültig | Keine Übertragung dieses Werts an das Thermostat. |

## Verwendung der YAML-Beispiele

> [!WICHTIG]
> Die YAML-Dateien enthalten anonymisierte, reduzierte Beispiele und nicht die vollständige produktive Konfiguration. Raum 1 zeigt die Steuerung ohne Midea Portasplit, Raum 2 die Steuerung mit Midea-Berücksichtigung.
>
> Entitäten, Geräte-ID, Zeitfenster, Temperaturkalibrierung und Label-Zuordnungen sind an die eigene Installation anzupassen.

Die Heizungsautomation für Raum 1 ist für Raum 2 und weitere Räume entsprechend zu duplizieren. Dabei sind Alias, Entitäts-IDs und die Liste der Zielautomationen in der globalen Temperaturaktualisierung anzupassen. Der Heizungs-Anzeigesensor kann nach demselben Prinzip ergänzt werden. Die beiden Packages werden über die vorhandene Package-Einbindung geladen.

## 🔗 Verwendung & Verknüpfungen

- [Home-Assistant-Konfiguration](konfiguration.md) – Einbindung der Packages
- [Anwesenheitserkennung](anwesenheitserkennung.md) – Grundlage der anwesenheitsabhängigen Steuerung
- [Solarsteuerung](solarsteuerung.md) – Batterie-SoC als Grundlage der Midea-Freigabe und Solltemperatur
- [Integration Midea](../apps/midea.md) – Einbindung der Portasplit
- [Zigbee2MQTT](../apps/zigbee2mqtt.md) – Einbindung der Zigbee-Geräte
- [Raumklima – Sensoren und Helfer](../skripte/home-assistant/sensoren/raumklima.yaml) – Steuerungslogik
- [Raumklima – Dashboard-Sensoren](../skripte/home-assistant/sensoren/raumklima_dashboard.yaml) – Aufbereitung der Anzeigewerte
- [Dashboard](dashboard.md) – Aufbau der Dashboard-Ansichten

### Automationen

- [Heizung Raum 1](../skripte/home-assistant/automationen/heizung-raum1.yaml) – Beispiel einer raumbezogenen Heizungssteuerung
- [Heizung – Geräteeinstellungen intern](../skripte/home-assistant/automationen/heizung-geraeteeinstellungen-intern.yaml) – Thermostatkonfiguration bei interner Temperaturmessung
- [Heizung – Geräteeinstellungen extern](../skripte/home-assistant/automationen/heizung-geraeteeinstellungen-extern.yaml) – Thermostatkonfiguration bei externer Temperaturmessung
- [Heizung – Temperaturvorgaben aktualisieren](../skripte/home-assistant/automationen/heizung-temperaturvorgaben-aktualisieren.yaml) – Aktualisierung bei geänderten Solltemperaturen
- [Heizung – Statuswechsel](../skripte/home-assistant/automationen/heizung-statuswechsel.yaml) – Globale Aktivierung und Deaktivierung der Heizungssteuerung
- [Midea Portasplit – Heizbetrieb](../skripte/home-assistant/automationen/midea-portasplit-heizbetrieb.yaml) – Übertragung der dynamischen Solltemperatur
- [Midea Portasplit – Modus](../skripte/home-assistant/automationen/midea-portasplit-modus.yaml) – Betriebsmodus und SoC-abhängige Betriebsfreigabe


---

[⬅️ Zurück zur Übersicht](../README.md)
