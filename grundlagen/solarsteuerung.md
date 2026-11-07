# Solarsteuerung

Diese Dokumentation beschreibt das Gesamtkonzept und die Berechnungslogik der eigenen Home-Assistant-Solarsteuerung. Zwei **Zendure SolarFlow 800 Plus** mit jeweils einem **AB2000-Akkupack** decken den Hausverbrauch möglichst weitgehend aus PV- und gespeicherter Energie. Die Regelung berücksichtigt Netzleistung, Hausverbrauch, PV-Erzeugung, Batterie-SoC, wetterabhängige Mindest-SoC-Werte und einen kleinen gewünschten Netzbezug.

Die technische Einrichtung ist in den Komponenten-Dokumentationen beschrieben.

## Ausgangssituation und Entscheidung

Die beiden SolarFlow-Geräte besitzen jeweils eigene PV-Eingänge, einen Akku, eine AC-Ausgangsgrenze und einen einstellbaren Mindest-SoC. Da sich PV-Module, Ausrichtung und Verschattung unterscheiden, liefern sie nicht immer gleich viel Leistung.

Die feste **50:50-Aufteilung** des Zendure Managers berücksichtigt diese Unterschiede nicht ausreichend. Beispielsweise würden bei 400 W Gesamtbedarf beide Geräte je 200 W liefern, obwohl Zendure 1 gerade 400 W PV-Leistung und Zendure 2 nur 100 W erzeugt. Eine dynamische Aufteilung von **320 W zu 80 W** entspricht in diesem Fall besser der verfügbaren Leistung und vermeidet eine unnötige Belastung des zweiten Akkus.

Deshalb bleibt der **Zendure Manager ausgeschaltet**. Home Assistant berechnet die Ausgangsgrenzen für beide Geräte unabhängig, aber auf Basis des gemeinsamen Hausverbrauchs.

## Aufbau und Regelablauf

Die Steuerung verwendet:

- **Shelly 3EM:** Messung der Netzleistung auf drei Phasen.
- **Template-Sensoren und Helfer:** Hausverbrauch, AC-Bedarf, PV- und Batteriefreigabe, Leistungsanteile und Sollwerte.
- **Drei Automationen:** Leistungsanpassung, wetterabhängige Mindest-SoC-Berechnung und geräteweise Übernahme.
- **Stündliche Wetterprognose:** Bewölkung als einfacher Indikator für die gewünschte Batteriereserve.


```text
        Shelly 3EM                  Zendure 1 + 2
            |                            |
            | Netzleistung               | AC-Ist-Leistung
            |                            |
            +-------------+--------------+
                          v
                    Hausverbrauch
                          v
                    AC-Gesamtbedarf
                          |
    Zendure 1 + 2         |
        |                 |
        | PV + SoC        |
        |                 |
        v                 |
    Maximale AC-          |
    Leistung je Gerät     |
        |                 |
        v                 |
    Leistungsanteile      |
        |                 |
        +--------+--------+ 
                 v
         AC-Soll je Gerät
                 v
        Leistungsanpassung
                 v
        Zendure AC-Limits


        Wetterprognose
            v
        Geplanter Mindest-SoC
            |
            +--> Sofortige Berücksichtigung
            |    bei der Leistungsberechnung
            |
            +--> Spätere Übernahme
                in die Zendure-Geräte
```


Die Berechnung erfolgt in dieser Reihenfolge: Netzleistung → Hausverbrauch → Netzbezugs-Sollwert → AC-Gesamtbedarf → PV-Leistung → freigegebene Batterieleistung → maximale AC-Leistung → Leistungsanteile → begrenzte AC-Sollwerte → Übertragung.

## Netzleistung und Hausverbrauch

Der Shelly 3EM liefert die Leistung der drei Netzphasen. Ihre Summe ist die gesamte Netzleistung:

```text
Netzleistung gesamt = Phase A + Phase B + Phase C
```

`sensor.shelly_netzleistung_gesamt`

| Netzleistung | Bedeutung |
|---|---|
| Positiv, z. B. +150 W | Netzbezug |
| Negativ, z. B. −80 W | Netzeinspeisung |
| 0 W | Ausgeglichene Nettoleistung |

Da die Zendure-Geräte bereits einen Teil des Hausverbrauchs decken können, wird ihre **tatsächlich gemessene** AC-Ausgangsleistung addiert, nicht die eingestellte Ausgangsgrenze:

```text
Hausverbrauch gesamt =
    Netzleistung gesamt
  + AC-Ist-Leistung Zendure 1
  + AC-Ist-Leistung Zendure 2
```

`sensor.hausverbrauch_gesamt`

**Beispiel:** 120 W Netzbezug + 250 W Zendure 1 + 150 W Zendure 2 = **520 W Hausverbrauch**.

## Dynamischer Netzbezugs-Sollwert

Die Steuerung strebt bewusst einen kleinen positiven Netzbezug statt exakt 0 W an. Diese Reserve soll unnötige Einspeisung bei Mess- und Regelschwankungen verringern.

`sensor.netzbezug_soll`

| Bedingung | Netzbezugs-Sollwert |
|---|---:|
| Beide geplanten Mindest-SoC-Werte = 10 % | 10 W |
| Andernfalls: durchschnittlicher Batterie-SoC ≤ 70 % | 30 W |
| Andernfalls: durchschnittlicher Batterie-SoC > 70 % bis 90 % | 20 W |
| Andernfalls: durchschnittlicher Batterie-SoC > 90 % | 10 W |

Die erste Bedingung hat Vorrang. Die Werte **10, 20 und 30 W** sind bewusst gewählte Regelparameter und keine technischen Gerätegrenzen. Bei größerer gewünschter Batteriereserve und niedrigem SoC wird etwas mehr Netzbezug zugelassen.

## Gesamter AC-Leistungsbedarf

Der gemeinsame AC-Bedarf ergibt sich aus dem Hausverbrauch abzüglich des gewünschten Netzbezugs:

```text
AC-Gesamtbedarf = max(0, min(Hausverbrauch − Netzbezugs-Sollwert, 900 W))
```

`sensor.zendure_gesamt_ac_leistungsbedarf`

Die Regelung fordert damit **mindestens 0 W und höchstens 900 W** an. Die Obergrenze ist bewusst konfiguriert und nicht mit der 800-W-Grenze eines einzelnen SolarFlow zu verwechseln.

| Hausverbrauch | Netzbezugs-Sollwert | AC-Gesamtbedarf |
|---:|---:|---:|
| 520 W | 10 W | 510 W |
| 8 W | 10 W | 0 W |
| 1.200 W | 10 W | 900 W |

Ein darüber hinausgehender Bedarf bleibt als Netzbezug bestehen, soweit keine anderen Energiequellen einspringen.

## Verfügbare PV- und Batterieleistung

### PV-Leistung

Jedes SolarFlow 800 Plus besitzt zwei PV-Eingänge. Ihre Leistungen werden **je Gerät getrennt** addiert, damit Unterschiede bei Modulen, Ausrichtung und Verschattung in die Verteilung eingehen.

```text
PV Zendure 1 = PV-Eingang 1 + PV-Eingang 2 von Zendure 1
PV Zendure 2 = PV-Eingang 1 + PV-Eingang 2 von Zendure 2
```

Sensoren: `sensor.zendure_1_pv_leistung`, `sensor.zendure_2_pv_leistung`.

### Freigegebene Batterieleistung

Je Gerät werden rechnerisch **600 W zusätzliche Batterieleistung** freigegeben, solange der tatsächliche SoC **über** dem in Home Assistant geplanten Mindest-SoC liegt. Bei gleichem oder niedrigerem SoC beträgt die Freigabe **0 W**.

```text
Batterie-SoC > geplanter Mindest-SoC → 600 W
Batterie-SoC ≤ geplanter Mindest-SoC →   0 W
```

Sensoren: `sensor.zendure_1_maximale_batterieleistung`, `sensor.zendure_2_maximale_batterieleistung`.

Der **geplante** Mindest-SoC ist entscheidend, auch wenn er noch nicht an Zendure übertragen wurde. So reagiert die Leistungsregelung unmittelbar auf eine neue Wetterprognose.

## Maximale AC-Leistung je Zendure

Die maximal **freigegebene** AC-Leistung berücksichtigt die PV-Leistung und den Batteriezustand. Unterhalb des geplanten Mindest-SoC soll ein Teil der PV-Erzeugung für das Wiederaufladen verfügbar bleiben.

| Tatsächlicher Batterie-SoC | Maximale AC-Leistung |
|---|---|
| **Über** geplantem Mindest-SoC | `min(PV + 600 W, 800 W)` |
| **Gleich** geplantem Mindest-SoC | `min(PV, 800 W)` |
| **Unter** geplantem Mindest-SoC | `min(PV × 0,5, 800 W)` |

Die Grenze beträgt **800 W je Gerät**. Unterhalb des geplanten Mindest-SoC werden nur **50 % der aktuellen PV-Leistung** für die AC-Ausgabe freigegeben; die übrige PV-Leistung soll vorrangig zum Laden des Akkus zur Verfügung stehen. Sobald der geplante Mindest-SoC erreicht ist, wird wieder die gesamte PV-Leistung berücksichtigt; erst **oberhalb** davon kommt die Batteriefreigabe hinzu.

| Beispiel je Gerät | PV | Batterie-SoC / geplant | Batteriefreigabe | Maximale AC-Leistung |
|---|---:|---:|---:|---:|
| Entladung erlaubt | 350 W | 45 % / 15 % | 600 W | 800 W |
| Mindest-SoC erreicht | 350 W | 15 % / 15 % | 0 W | 350 W |
| Mindest-SoC unterschritten | 350 W | 12 % / 15 % | 0 W | 175 W |

Sensoren: `sensor.zendure_1_maximale_ac_leistung`, `sensor.zendure_2_maximale_ac_leistung`.

Die Summe bildet die **gesamte maximal freigegebene AC-Leistung**:

```text
Gesamtmaximum = maximale AC-Leistung Zendure 1 + maximale AC-Leistung Zendure 2
```

`sensor.zendure_gesamt_maximale_ac_leistung`

## Dynamische Leistungsaufteilung und AC-Sollwerte

Die Verteilung erfolgt proportional zur maximal freigegebenen AC-Leistung, nicht nach einer festen 50:50-Quote:

```text
Anteil Zendure 1 = Maximum Zendure 1 / Gesamtmaximum × 100
Anteil Zendure 2 = Maximum Zendure 2 / Gesamtmaximum × 100
```

Sensoren: `sensor.zendure_1_leistungsanteil`, `sensor.zendure_2_leistungsanteil`.

**Beispiel:** Bei 600 W Maximum für Zendure 1 und 200 W für Zendure 2 ergeben sich **75 % zu 25 %**. Ändert sich die PV-Leistung oder erreicht eine Batterie ihren geplanten Mindest-SoC, ändern sich die Anteile automatisch. Ist das Gesamtmaximum 0 W, werden beide Anteile auf **0 %** gesetzt, um eine Division durch 0 zu vermeiden.

Die endgültigen AC-Sollwerte werden zusätzlich **je Gerät begrenzt**:

```text
AC-Soll Zendure 1 =
    min(AC-Gesamtbedarf × Anteil Zendure 1 / 100, Maximum Zendure 1)

AC-Soll Zendure 2 =
    min(AC-Gesamtbedarf × Anteil Zendure 2 / 100, Maximum Zendure 2)
```

Die Ergebnisse werden auf ganze Watt gerundet.

Sensoren: `sensor.zendure_1_ac_soll_leistung`, `sensor.zendure_2_ac_soll_leistung`.

### Berechnungsbeispiel

Bei **650 W Hausverbrauch** und **10 W Netzbezugs-Sollwert** beträgt der AC-Gesamtbedarf **640 W**.

| Eigenschaft | Zendure 1 | Zendure 2 |
|---|---:|---:|
| PV-Leistung | 400 W | 100 W |
| Batteriefreigabe | 600 W | 0 W |
| Maximale AC-Leistung | 800 W | 100 W |
| Leistungsanteil | 88,89 % | 11,11 % |
| **AC-Soll-Leistung** | **569 W** | **71 W** |

Die gemeinsame Anforderung beträgt **640 W** und entspricht dem Bedarf. Die individuellen Maximalwerte werden nicht überschritten.

### Unzureichende Gesamtleistung

Wenn der Bedarf höher ist als die gesamte freigegebene Leistung, greifen die geräteweisen Begrenzungen:

| Eigenschaft | Zendure 1 | Zendure 2 |
|---|---:|---:|
| Maximale AC-Leistung | 200 W | 100 W |
| Leistungsanteil | 66,67 % | 33,33 % |
| Gesamtbedarf | 600 W | 600 W |
| Unbegrenzter rechnerischer Sollwert | 400 W | 200 W |
| **Begrenzter AC-Sollwert** | **200 W** | **100 W** |

Es werden zusammen nur **300 W** angefordert. Die fehlenden **300 W** müssen aus dem öffenlichen Netz kommen. Die maximalen AC-Leistungen dienen somit **sowohl der Gewichtung als auch der Begrenzung**.

## Automatische Leistungsanpassung

Die Automation **Zendure Leistungsanpassung** überträgt die berechneten AC-Sollwerte an die AC-Ausgangsgrenzen beider Geräte.

- Ausführung **alle fünf Sekunden** sowie zusätzlich bei gemessener **Netzeinspeisung** (Netzleistung < 0 W).
- Vergleich der beiden berechneten Sollwerte mit den eingestellten AC-Limits.
- Nur wenn **mindestens ein Wert abweicht**, werden **beide** Ausgangsgrenzen geschrieben.

Das vermeidet unnötige Schreibvorgänge. Beide Geräte werden gemeinsam angepasst, weil eine Leistungsänderung eines Geräts die Anteile beider Geräte beeinflussen kann.

Das **5-Sekunden-Intervall** sorgt außerdem für eine ruhigere Regelung. Dadurch wird nicht jede kurzfristige Leistungsabweichung sofort korrigiert, was häufige Anpassungen der Wechselrichter-Ausgangsleistung reduziert.

## Wetterabhängige Mindest-SoC-Strategie

Neben der Leistungsregelung legt eine Wetterprognose die gewünschte Batteriereserve fest: Bei stärkerer Bewölkung soll mehr Energie gespeichert bleiben; bei günstigerer Prognose darf mehr Energie verbraucht werden, damit Speicherkapazität für neue Solarproduktion frei wird.

| Bewölkungsprognose | Geplanter Mindest-SoC |
|---|---:|
| Bis einschließlich 75 % | 10 % |
| Mehr als 75 % | 15 % |

Beide Geräte erhalten denselben geplanten Wert, speichern und übernehmen ihn jedoch **getrennt**. Die Bewölkung ist ein einfacher Indikator, **keine exakte PV-Ertragsprognose**: Sonnenstand, Modulausrichtung und Verschattung beeinflussen die tatsächliche Produktion zusätzlich.

### Zeitpunkte und Wetterdaten

Die Automation **Zendure Mindest-SoC Berechnung** wertet dreimal täglich eine stündliche Wetterprognose aus:

| Auslösung | Ausgewertete Bewölkung |
|---|---|
| Sonnenaufgang | Heute, 12:00 Uhr |
| Mittag | Heute, 12:00 Uhr |
| Zwei Stunden vor Sonnenuntergang | Morgen, 12:00 Uhr |

Verwendet werden `weather.get_forecasts`, die Entität `weather.forecast_home`, der Prognosetyp `hourly` und das Feld `cloud_coverage`.

Die Wetter-Entität `weather.forecast_home` war bereits durch die Erstinstallation von Home Assistant vorhanden und musste nicht zusätzlich eingerichtet werden.

**Ablauf:** Prognose abrufen → passenden Zeitpunkt auswählen → Bewölkung prüfen → geplanten Mindest-SoC auf **10 % oder 15 %** setzen → Zeitpunkt der erfolgreichen Berechnung speichern → Übernahme-Automation aktivieren.

Die geplanten Werte stehen in:

- `input_number.zendure_1_neuer_min_soc`
- `input_number.zendure_2_neuer_min_soc`

Der Zeitpunkt der letzten erfolgreichen Berechnung steht in `input_datetime.zendure_letzte_min_soc_berechnung`.

**Fehlt eine passende gültige Prognose**, wird die Berechnung abgebrochen: Die bisherigen geplanten Werte bleiben bestehen, und der Zeitstempel wird nicht aktualisiert.

## Geplanter und tatsächlich eingestellter Mindest-SoC

Die Steuerung unterscheidet bewusst zwischen:

- **Geplantem Mindest-SoC:** Von Home Assistant berechnete Grenze; wirkt **sofort** auf Batteriefreigabe und maximale AC-Leistung.
- **Eingestelltem Mindest-SoC:** Tatsächlicher Grenzwert im Zendure-Gerät; wird erst übertragen, wenn die Übernahmebedingungen erfüllt sind.

Der Grund: Wird der geplante Mindest-SoC beispielsweise von **10 % auf 15 %** erhöht, während der Akku erst **12 %** erreicht hat, soll eine sofortige Änderung am Gerät keine unerwünschte Nachladung aus dem Stromnetz auslösen. Home Assistant berücksichtigt die höhere Reserve bereits, wartet mit der Geräteübernahme aber auf ausreichenden SoC.

## Mindest-SoC-Übernahme

Die Automation **Zendure Mindest-SoC Übernahme** prüft für jedes Gerät unabhängig:

```text
Geplanter Mindest-SoC ≠ eingestellter Mindest-SoC
UND
aktueller Batterie-SoC ≥ geplanter Mindest-SoC
```

Nur dann wird der geplante Wert an das betreffende Gerät übertragen. Unterschiedliche Akkuladestände verhindern somit nicht die Übernahme beim jeweils anderen Gerät.

### Steigende Bewölkung: Mindest-SoC erhöhen

**Beispiel 1:** Aktueller SoC **40 %**, bisheriges Minimum **10 %**, neues geplantes Minimum **15 %**. Die Übertragung ist zulässig; die Leistungsberechnung berücksichtigt die neue Grenze bereits.

**Beispiel 2:** Aktueller SoC **12 %**, bisheriges Minimum **10 %**, neues geplantes Minimum **15 %**. Die Geräteübernahme wartet. Die zusätzliche Batteriefreigabe ist bereits **0 W**, und die maximale AC-Leistung wird auf **50 % der PV-Leistung** begrenzt, damit der Akku vorrangig wieder aufladen kann. Sobald er mindestens **15 %** erreicht, darf die Übertragung erfolgen.

### Sinkende Bewölkung: Mindest-SoC senken

**Beispiel:** Aktueller SoC **12 %**, bisheriges Minimum **15 %**, neues geplantes Minimum **10 %**. Da der Akku über dem neuen geplanten Wert liegt, werden in Home Assistant wieder **600 W Batterieleistung** freigegeben. Die neue Grenze kann auch direkt an das Gerät übertragen werden. Die Batterie darf anschließend bis zum geplanten Minimum von **10 %** zur AC-Ausgabe beitragen.

Die Übernahmebedingung ist für beide Richtungen gleich. Die besondere Wartezeit bei einer Erhöhung dient dazu, eine mögliche unerwünschte Netzladung zu vermeiden.

### Automatische Deaktivierung

Nach einem Automationsdurchlauf wird geprüft, ob **beide** eingestellten Mindest-SoC-Werte mit den geplanten Werten übereinstimmen. Ist das der Fall, deaktiviert sich die Übernahme-Automation selbst. Bei der nächsten erfolgreichen Wetterberechnung wird sie wieder aktiviert.

**Wichtig:** Das Aktivieren der Automation löst **keine sofortige Übernahme** aus. Die Prüfung erfolgt erst bei den konfigurierten **Batterieladestandsereignissen**; auch die abschließende Übereinstimmungsprüfung findet im Rahmen eines solchen Durchlaufs statt.

## Zusammenspiel der Regelstrategien

Die Wetterprognose beeinflusst die AC-Ausgabe **indirekt**: Sie ändert den geplanten Mindest-SoC. Dieser beeinflusst die Batteriefreigabe und gegebenenfalls die 50-%-PV-Regel; daraus folgen neue maximale AC-Leistungen, Leistungsanteile und AC-Sollwerte.

### Beispiel: Geplanten Mindest-SoC von 10 % auf 15 % erhöhen

Die Batterie-SoCs und PV-Leistungen bleiben im Beispiel unverändert:

| Eigenschaft | Zendure 1 | Zendure 2 |
|---|---:|---:|
| Batterie-SoC | 12 % | 50 % |
| PV-Leistung | 100 W | 200 W |
| **Maximum bei geplantem Mindest-SoC 10 %** | **700 W** | **800 W** |
| Anteil bei 10 % | 46,67 % | 53,33 % |
| **Maximum bei geplantem Mindest-SoC 15 %** | **50 W** | **800 W** |
| Anteil bei 15 % | 5,88 % | 94,12 % |

Vor der Änderung stehen rechnerisch **1.500 W** zur Verfügung, danach **850 W**. Zendure 1 liegt mit 12 % SoC unter dem neuen geplanten Minimum und erhält daher nur **50 % seiner 100 W PV-Leistung** als AC-Freigabe. Zendure 2 darf weiterhin PV- und Batterieleistung beitragen. Die Aufteilung verschiebt sich entsprechend.

## Besonderheiten der gewählten Steuerung

Die wesentlichen Entscheidungen sind:

- **Keine feste 50:50-Aufteilung:** Jeder Zendure erhält einen Anteil entsprechend seiner eigenen freigegebenen Leistung.
- **Getrennte Batteriebewertung:** Ein Akku kann geschützt werden, während der andere weiter Leistung liefert.
- **Gemeinsamer Hausverbrauch:** Grundlage ist die Summe aus Netzleistung und beiden AC-Ist-Leistungen.
- **Kleiner positiver Netzbezugs-Sollwert:** 10, 20 oder 30 W dienen als Regelreserve.
- **Gesamtbedarf auf 900 W begrenzt:** Die eigene Steuerung fordert nicht mehr an.
- **Wetterabhängige Reserve:** Geplanter Mindest-SoC von 10 oder 15 %.
- **50-%-PV-Freigabe unter geplantem Mindest-SoC:** Ein Teil der Solarenergie soll für die Akkuladung verfügbar bleiben.
- **Geräteweise Begrenzung der AC-Sollwerte:** Kein Sollwert über dem rechnerisch freigegebenen Gerätemaximum.
- **Geplanter und eingestellter Mindest-SoC getrennt:** Neue Reserven wirken sofort auf die Leistungsberechnung; die Geräteübernahme kann warten.
- **Unabhängige Mindest-SoC-Übernahme:** Unterschiedliche Akkuladestände werden einzeln geprüft.

## Regelverhalten im laufenden Betrieb

Bei steigender Hauslast erhöht sich der AC-Gesamtbedarf bis zur 900-W-Grenze; bei sinkender Last reduziert er sich. Änderungen der PV-Leistung oder der Batterieladestände verändern die freigegebenen Leistungen und damit die prozentuale Aufteilung.

Erreicht ein Akku seinen geplanten Mindest-SoC, entfällt die zusätzliche Batteriefreigabe. **Unterschreitet** er die geplante Grenze, sinkt seine maximale AC-Leistung auf **50 % der PV-Leistung**. Der andere Zendure kann entsprechend mehr übernehmen, soweit dessen eigenes Maximum und der gemeinsame Bedarf dies zulassen.

Parallel kann die Wetterberechnung die geplanten Mindest-SoC-Werte ändern und so unmittelbar neue AC-Sollwerte auslösen.

## Fehlerverhalten und Grenzen

| Situation | Verhalten beziehungsweise Grenze |
|---|---|
| Fehlende gültige Wetterprognose | Berechnung wird abgebrochen; bisherige geplante Werte bleiben erhalten. |
| Unterschiedliche Batterieladestände | Freigabe und Mindest-SoC-Übernahme erfolgen je Gerät unabhängig. |
| Beide AC-Maximalwerte = 0 W | Beide Leistungsanteile und AC-Sollwerte werden 0. |
| Hausverbrauch über der Regelgrenze | Der gemeinsame AC-Bedarf bleibt auf 900 W begrenzt. |
| Verfügbare AC-Leistung unter dem Bedarf | Beide AC-Sollwerte werden auf ihre Gerätemaxima begrenzt; Restbedarf bleibt für Netz oder andere Quellen. |
| Geplanter Mindest-SoC noch nicht erreichbar | Die Übernahme wartet, die neue Grenze gilt aber bereits für die Leistungsberechnung. |
| 50-%-PV-Reserve | Die tatsächliche Akkuladung hängt vom internen Geräteverhalten ab. PV-Schwankungen können bis zur nächsten Leistungsanpassung (regulär spätestens nach 5 Sekunden) zu einer kurzfristigen Batterieentladung führen. |
| Bewölkungsprognose | Keine vollständige Ertragsprognose unter Einbeziehung aller Module, Ausrichtungen und Verschattungen. |

Die tatsächlich bereitgestellte AC-Leistung hängt weiterhin von den Betriebsbedingungen und geräteseitigen Grenzen ab.

## Funktionsprüfung

Die Solarsteuerung ist eingerichtet und wurde im laufenden Betrieb erfolgreich getestet. Die dynamische Aufteilung berücksichtigt die unterschiedlichen PV-Leistungen und Batterie-SoCs; die wetterabhängige Mindest-SoC-Berechnung und die geräteweise Übernahme sind Bestandteil der Steuerung. Der **Zendure Manager bleibt ausgeschaltet**.

Die neu ergänzte 50-%-PV-Regel und die Begrenzung der AC-Sollwerte sollten zusätzlich im laufenden Betrieb beobachtet werden. Die bisherige Funktion bestätigt nicht automatisch alle Sonderfälle.

MQTT-Verbindung, Gerätekommunikation und technische Einrichtung sind in der Zendure-Dokumentation beschrieben.

## Nützliche Links & Quellen

- [Home Assistant Automationen – Grundlagen](https://www.home-assistant.io/docs/automation/)
- [Home Assistant Automationen – Wettervorhersagen abrufen](https://www.home-assistant.io/actions/weather.get_forecasts/)
- [Home Assistant Integration – Wetter](https://www.home-assistant.io/integrations/weather/)
- [Home Assistant Sensoren – Template-Integration](https://www.home-assistant.io/integrations/template/)

## 🔗 Verwendung & Verknüpfungen

- [Shelly](../integrationen/shelly.md) – Netzleistungsmessung als Grundlage der Solarsteuerung
- [Zendure](../integrationen/zendure.md) – Einrichtung der SolarFlow-Geräte, Template-Sensoren, Helfer und Automationen

---

[⬅️ Zurück zur Übersicht](../README.md)
