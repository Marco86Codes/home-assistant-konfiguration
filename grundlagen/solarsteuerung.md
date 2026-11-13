# Solarsteuerung

Diese Dokumentation beschreibt das Gesamtkonzept und die Berechnungslogik der eigenen Home-Assistant-Solarsteuerung. Zwei **Zendure SolarFlow 800 Plus** mit jeweils einem **AB2000-Akkupack** decken den Hausverbrauch möglichst weitgehend aus PV- und gespeicherter Energie. Die Regelung berücksichtigt Netzleistung, Hausverbrauch, PV-Erzeugung, Batterie-SoC, wetterabhängige Mindest-SoC-Werte und einen kleinen gewünschten Netzbezug.

Die technische Einrichtung ist in den Komponenten-Dokumentationen beschrieben.

## Ausgangssituation und Entscheidung

Die beiden SolarFlow-Geräte besitzen jeweils eigene PV-Eingänge, einen Akku, eine AC-Ausgangsgrenze und einen einstellbaren Mindest-SoC. Da sich PV-Module, Ausrichtung und Verschattung unterscheiden, liefern sie nicht immer gleich viel Leistung.

Die feste **50:50-Aufteilung** des Zendure Managers berücksichtigt weder die unterschiedlichen PV-Leistungen noch die nutzbaren Batteriereserven ausreichend. Die eigene Steuerung kombiniert beide Größen und berücksichtigt zusätzlich die SoC-Differenz, damit ein stärker geladener Akku bei Bedarf mehr Last übernimmt. Die Verteilung bleibt durch den AC-Bedarf und die jeweiligen Gerätegrenzen beschränkt.

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
    AC-Maxima und          |
    PV-/SoC-Gewichte      |
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


Die Berechnung erfolgt in dieser Reihenfolge: Netzleistung → Hausverbrauch → Netzbezugs-Sollwert → AC-Gesamtbedarf → PV-Leistung und Batterie-SoC → maximale AC-Leistung und PV-/Batteriegewichtung mit SoC-Ausgleich → Leistungsaufteilung mit Umverteilung bei Leistungsgrenzen → begrenzte AC-Sollwerte → Übertragung.

## Netzleistung und Hausverbrauch

Der Shelly 3EM liefert die Leistung der drei Netzphasen. Ihre Summe ist die gesamte Netzleistung:

```text
Netzleistung gesamt = Phase A + Phase B + Phase C
```

`sensor.shelly_netzleistung_gesamt`

Für die Anzeige im Dashboard wird zusätzlich der Sensor `sensor.shelly_netzleistung_gesamt_anzeige` verwendet. Er berechnet die Summe der drei Shelly-Phasenleistungen und rundet das Ergebnis auf ganze Watt (0 Nachkommastellen).

Der Anzeigesensor dient ausschließlich der Darstellung im Dashboard. Die Solarsteuerung verwendet weiterhin `sensor.shelly_netzleistung_gesamt` mit der ursprünglichen Messgenauigkeit.

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

Sensoren für die Summe der jeweils zwei PV-Eingänge: `sensor.zendure_1_pv_leistung`, `sensor.zendure_2_pv_leistung`. Für die maximale AC-Leistung werden zusätzlich die Gerätewerte `sensor.solarflow_800_plus_1_pv_power` und `sensor.solarflow_800_plus_2_pv_power` verwendet.

### Freigegebene Batterieleistung

Je Gerät werden rechnerisch **600 W zusätzliche Batterieleistung** freigegeben, solange der tatsächliche SoC **über** dem höheren Wert aus dem in Home Assistant geplanten und dem tatsächlich am Gerät eingestellten Mindest-SoC liegt. Bei gleichem oder niedrigerem SoC beträgt die Freigabe **0 W**.

```text
Batterie-SoC > max(geplanter Mindest-SoC, eingestellter Mindest-SoC) → 600 W
Batterie-SoC ≤ max(geplanter Mindest-SoC, eingestellter Mindest-SoC) →   0 W
```

Sensoren: `sensor.zendure_1_maximale_batterieleistung`, `sensor.zendure_2_maximale_batterieleistung`.

Maßgeblich ist der höhere Wert aus **geplantem** und **tatsächlich eingestelltem** Mindest-SoC. So reagiert die Leistungsregelung unmittelbar auf eine neue Wetterprognose, ohne bereits vor der Übernahme eines niedrigeren Mindest-SoC Batterieleistung freizugeben.

## Maximale AC-Leistung je Zendure

Die maximal **freigegebene** AC-Leistung berücksichtigt die PV-Leistung, den Batteriezustand und eine dynamische PV-Reserve von **0 bis 100 %**. Diese Reserve wird für jedes Gerät getrennt berechnet.

| Bedingung | PV-Reserve | Maximale AC-Leistung |
|---|---|---|
| Batterie-SoC **unter** dem tatsächlich im Gerät eingestellten Mindest-SoC | 100 % | `0 W` |
| Batterie-SoC mindestens auf dem eingestellten, aber **unter** dem geplanten Mindest-SoC | `min((geplanter Mindest-SoC − Batterie-SoC) × 20 %, 100 %)` | `0 W` |
| Batterie-SoC **gleich** dem höheren Wert aus geplantem und eingestelltem Mindest-SoC | Abhängig vom geplanten Mindest-SoC | `0 W` |
| Batterie-SoC **über** dem höheren Wert aus geplantem und eingestelltem Mindest-SoC | 0 % | `min(PV + 600 W, 800 W)` |

Die Grenze beträgt **800 W je Gerät**. Pro Prozentpunkt unter dem geplanten Mindest-SoC werden **20 % der PV-Leistung reserviert**, höchstens 100 %. Solange eine PV-Reserve aktiv ist, wird keine zusätzliche Batterieleistung zur maximalen AC-Leistung addiert. Unterhalb des tatsächlich eingestellten Mindest-SoC beträgt die PV-Reserve unabhängig vom geplanten Wert **100 %**. Die maximale AC-Leistung beträgt grundsätzlich **0 W**, solange der Batterie-SoC nicht über dem höheren Wert aus geplantem und eingestelltem Mindest-SoC liegt.

### Statusanzeige der PV-Begrenzung

Zwei numerische Template-Sensoren berechnen die dynamische PV-Reserve für die Leistungsregelung:

- `sensor.zendure_1_pv_begrenzung` – PV-Reserve Zendure 1 in Prozent (0–100 %).
- `sensor.zendure_2_pv_begrenzung` – PV-Reserve Zendure 2 in Prozent (0–100 %).

Zwei separate Sensoren dienen ausschließlich der Statusanzeige im Dashboard:

| Sensor | Anzeige |
|---|---|
| `sensor.zendure_1_pv_begrenzung_anzeige` | `Inaktiv` bei 0 W tatsächlicher AC-Ausgangsleistung oder 0 % PV-Reserve; sonst `Aktiv: XX %` |
| `sensor.zendure_2_pv_begrenzung_anzeige` | `Inaktiv` bei 0 W tatsächlicher AC-Ausgangsleistung oder 0 % PV-Reserve; sonst `Aktiv: XX %` |

Die numerischen Sensoren steuern die Berechnung der maximal freigegebenen AC-Leistung. Die Anzeigesensoren beeinflussen die Regelung nicht. Eine angezeigte PV-Reserve bezeichnet keine bestätigte tatsächliche Akkuladeleistung.

| Beispiel je Gerät | PV | Batterie-SoC / geplant | Batteriefreigabe | Maximale AC-Leistung |
|---|---:|---:|---:|---:|
| Entladung erlaubt | 350 W | 45 % / 15 % | 600 W | 800 W |
| Mindest-SoC erreicht | 350 W | 15 % / 15 % | 0 W | 0 W |
| Mindest-SoC unterschritten | 350 W | 12 % / 15 % | 0 W | 0 W |

Die Beispiele setzen einen tatsächlich eingestellten Mindest-SoC von **10 %** voraus. Bei 12 % aktuellem und 15 % geplantem SoC beträgt die PV-Reserve **60 %**. Liegt der tatsächliche SoC dagegen unter dem eingestellten Geräteminimum, werden **100 %** reserviert.

Sensoren: `sensor.zendure_1_maximale_ac_leistung`, `sensor.zendure_2_maximale_ac_leistung`.

Die beiden Maximalwerte werden bei der Leistungsaufteilung direkt addiert. Ein eigener Sensor für die Summe ist nicht mehr vorhanden.

## Dynamische Leistungsaufteilung und AC-Sollwerte

Die Aufteilung kombiniert die aktuelle PV-Leistung mit der nutzbaren Batterie-SoC-Reserve beider Geräte. Zusätzlich verschiebt ein SoC-Ausgleich die Last zugunsten des stärker geladenen Akkus. Die endgültige Verteilung berücksichtigt die maximal freigegebene AC-Leistung beider Geräte.

### Gemeinsame PV- und Batteriegewichtung

Für jedes Gerät gilt der höhere Wert aus geplantem und tatsächlich eingestelltem Mindest-SoC als **wirksamer Mindest-SoC**.

```text
Nutzbare SoC-Reserve = max(aktueller SoC − wirksamer Mindest-SoC, 0)
Batteriegewicht = nutzbare SoC-Reserve × 19,2
Gerätegewicht = Batteriegewicht + PV-Leistung
Gesamtgewicht = Gerätegewicht Zendure 1 + Gerätegewicht Zendure 2
```

Der Faktor 19,2 ergibt sich aus der nominellen Kapazität von 1,92 kWh (1.920 Wh) je AB2000-Akkupack. Ein Prozentpunkt Batterieladung entspricht damit rechnerisch 19,2 Wh.

Für die Leistungsaufteilung wird die nutzbare SoC-Reserve mit diesem Faktor multipliziert und zur aktuellen PV-Leistung addiert. Das Ergebnis dient als rechnerische Gewichtungsgröße und stellt keine physikalisch gemessene Energie oder unmittelbar verfügbare Leistung dar.

Der Sensor sensor.zendure_gesamt_energie bildet die Summe der Gewichte beider Geräte und rundet sie auf ganze Zahlen. Obwohl er in der YAML mit der Einheit W deklariert ist, wird er ausschließlich als Gewichtungsgröße verwendet.

### SoC-Ausgleich und Leistungsgrenzen

Zunächst wird das Grundgewicht von Zendure 1 aus seinem Gerätegewicht und dem Gesamtgewicht berechnet. Ist das Gesamtgewicht 0, gilt zunächst eine Aufteilung von 50:50.

```text
Grundanteil Zendure 1 = Gerätegewicht 1 / Gesamtgewicht
SoC-Ausgleich = (SoC Zendure 1 − SoC Zendure 2) × 0,01
Korrigierter Anteil Zendure 1 = begrenzen(Grundanteil + SoC-Ausgleich, 0, 1)
```

**Jeder Prozentpunkt SoC-Differenz verschiebt den Anteil um einen Prozentpunkt.** Hat Zendure 1 beispielsweise 11 Prozentpunkte mehr SoC, erhöht sich sein Anteil gegenüber der Grundgewichtung um 11 Prozentpunkte. Der Faktor ist ein gewählter Regelparameter und garantiert keinen sofortigen oder vollständigen SoC-Gleichstand.

Der zu verteilende Bedarf ist auf die Summe der beiden AC-Maximalwerte begrenzt:

```text
Ziel = min(AC-Gesamtbedarf, AC-Maximum 1 + AC-Maximum 2)

Leistung Zendure 1 = min(
    AC-Maximum 1,
    max(Ziel − AC-Maximum 2, Ziel × korrigierter Anteil 1)
)

Leistung Zendure 2 = Ziel − Leistung Zendure 1
```

Damit übernimmt ein Gerät innerhalb seines AC-Maximums den Anteil, den das andere nicht liefern kann. Ist die verfügbare Gesamtleistung geringer als der Bedarf, werden beide Gerätemaxima ausgeschöpft.

Die prozentualen Leistungsanteile beziehen sich auf die **tatsächlich zugewiesene AC-Gesamtleistung**. Ihre Summe beträgt daher **100 %**, sofern Leistung bereitgestellt werden kann. Ist keine Leistung verfügbar, betragen beide Anteile 0 %.

Die Berechnung von Zendure 2 verwendet den gerundeten Prozentanteil von Zendure 1. Dadurch sind kleine Rundungsabweichungen möglich. Bei 0 W Bedarf oder einer Summe der Gerätemaxima von 0 W werden beide Anteile auf 0 % gesetzt.

Sensoren: `sensor.zendure_1_leistungsanteil`, `sensor.zendure_2_leistungsanteil`.

Die endgültigen AC-Sollwerte werden aus den Anteilen an der zuteilbaren Gesamtleistung berechnet und zusätzlich je Gerät begrenzt:

```text
Zuteilbare Gesamtleistung = min(AC-Gesamtbedarf, AC-Maximum 1 + AC-Maximum 2)

AC-Soll Zendure 1 = min(Zuteilbare Gesamtleistung × Anteil 1 / 100, AC-Maximum 1)
AC-Soll Zendure 2 = min(Zuteilbare Gesamtleistung × Anteil 2 / 100, AC-Maximum 2)
```

Die AC-Sollwerte werden auf ganze Watt gerundet.

Sensoren: `sensor.zendure_1_ac_soll_leistung`, `sensor.zendure_2_ac_soll_leistung`.

### Berechnungsbeispiel

Bei **650 W Hausverbrauch** und **10 W Netzbezugs-Sollwert** beträgt der AC-Gesamtbedarf **640 W**. Beide Geräte haben einen wirksamen Mindest-SoC von 10 %.

| Eigenschaft | Zendure 1 | Zendure 2 |
|---|---:|---:|
| Batterie-SoC | 40 % | 35 % |
| PV-Leistung | 400 W | 100 W |
| Batteriegewicht | 576 | 480 |
| Gerätegewicht | 976 | 580 |
| Maximale AC-Leistung | 800 W | 700 W |
| Grundanteil | 62,72 % | 37,28 % |
| SoC-Ausgleich | +5 Prozentpunkte | −5 Prozentpunkte |
| Leistungsanteil | 67,72 % | 32,28 % |
| **AC-Soll-Leistung** | **433 W** | **207 W** |

Die gesamte Anforderung beträgt nach Rundung **640 W**. Beide Geräte bleiben unter ihrem jeweiligen AC-Maximum.

### Umverteilung bei begrenzter Geräteleistung

Bei **900 W AC-Gesamtbedarf** und einer gewichteten Zielverteilung von etwa 65 % zu 35 % kann Zendure 2 nur 200 W bereitstellen:

| Eigenschaft | Zendure 1 | Zendure 2 |
|---|---:|---:|
| Gewichtete Leistung ohne Begrenzung | 585 W | 315 W |
| Maximale AC-Leistung | 800 W | 200 W |
| **Zugewiesene AC-Leistung** | **700 W** | **200 W** |

Zendure 1 übernimmt die fehlenden 115 W, sodass der gesamte Bedarf von 900 W gedeckt werden kann.

### Unzureichende Gesamtleistung

| Eigenschaft | Zendure 1 | Zendure 2 |
|---|---:|---:|
| AC-Gesamtbedarf | 600 W | 600 W |
| Maximale AC-Leistung | 200 W | 100 W |
| **Leistungsanteil** | **66,67 %** | **33,33 %** |
| **AC-Soll-Leistung** | **200 W** | **100 W** |

Zusammen werden nur **300 W** angefordert. Die verbleibenden **300 W** müssen aus dem Netz oder anderen Quellen kommen.

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
| Sonnenaufgang | Heute, stündliche Prognosen von 08:00 bis 18:00 Uhr |
| Mittag (12:00 Uhr) | Heute, verbleibende stündliche Prognosen bis 18:00 Uhr |
| Zwei Stunden vor Sonnenuntergang | Morgen, stündliche Prognosen von 08:00 bis 18:00 Uhr |

Verwendet werden `weather.get_forecasts`, die Entität `weather.forecast_home`, der Prognosetyp `hourly` und das Feld `cloud_coverage`. Aus den passenden Stundenwerten wird die **durchschnittliche Bewölkung** gebildet. Nur bei einem Durchschnitt **über 75 %** wird ein geplanter Mindest-SoC von 15 % gewählt.

Die Wetter-Entität `weather.forecast_home` war bereits durch die Erstinstallation von Home Assistant vorhanden und musste nicht zusätzlich eingerichtet werden.

**Ablauf:** Prognose abrufen → passenden Zeitpunkt auswählen → Bewölkung prüfen → geplanten Mindest-SoC auf **10 % oder 15 %** setzen → Zeitpunkt der erfolgreichen Berechnung speichern → Übernahme-Automation aktivieren.

Die geplanten Werte stehen in:

- `input_number.zendure_1_neuer_min_soc`
- `input_number.zendure_2_neuer_min_soc`

Der Zeitpunkt der letzten erfolgreichen Berechnung steht in `input_datetime.zendure_letzte_min_soc_berechnung`.

Für die beiden Mindest-SoC-Helfer ist kein fester Initialwert definiert. Dadurch werden die zuletzt gespeicherten Werte nach einem Neustart von Home Assistant wiederhergestellt.

**Fehlt eine passende gültige Prognose**, wird die Berechnung abgebrochen: Die bisherigen geplanten Werte bleiben bestehen, und der Zeitstempel wird nicht aktualisiert.

## Geplanter und tatsächlich eingestellter Mindest-SoC

Die Steuerung unterscheidet bewusst zwischen:

- **Geplantem Mindest-SoC:** Von Home Assistant berechnete Grenze; wird **sofort** bei der Leistungsberechnung berücksichtigt.
- **Eingestelltem Mindest-SoC:** Tatsächlicher Grenzwert im Zendure-Gerät; wird erst übertragen, wenn die Übernahmebedingungen erfüllt sind.

Für die Freigabe der Batterie- und AC-Leistung ist immer der **höhere der beiden Mindest-SoC-Werte** maßgeblich.

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

**Beispiel 2:** Aktueller SoC **12 %**, bisheriges Minimum **10 %**, neues geplantes Minimum **15 %**. Die Geräteübernahme wartet. Die zusätzliche Batteriefreigabe und die maximale AC-Leistung betragen bereits **0 W**, da der aktuelle SoC unter dem höheren der beiden Mindest-SoC-Werte liegt. Die berechnete PV-Reserve beträgt weiterhin **60 %**. Sobald der Akku mindestens **15 %** erreicht, darf die Übertragung erfolgen.

### Sinkende Bewölkung: Mindest-SoC senken

**Beispiel:** Aktueller SoC **12 %**, bisheriges Minimum **15 %**, neues geplantes Minimum **10 %**. Solange am Gerät noch 15 % eingestellt sind, bleiben die Batterie- und AC-Leistung in Home Assistant auf **0 W** begrenzt. Die neue Grenze kann direkt an das Gerät übertragen werden. Erst nach der Übernahme des niedrigeren Mindest-SoC werden wieder **600 W Batterieleistung** freigegeben. Die Batterie darf anschließend bis zum geplanten Minimum von **10 %** zur AC-Ausgabe beitragen.

Die Übernahmebedingung ist für beide Richtungen gleich. Die besondere Wartezeit bei einer Erhöhung dient dazu, eine mögliche unerwünschte Netzladung zu vermeiden.

### Automatische Deaktivierung

Nach einem Automationsdurchlauf wird geprüft, ob **beide** eingestellten Mindest-SoC-Werte mit den geplanten Werten übereinstimmen. Ist das der Fall, deaktiviert sich die Übernahme-Automation selbst. Bei der nächsten erfolgreichen Wetterberechnung wird sie wieder aktiviert.

**Wichtig:** Das Aktivieren der Automation löst **keine sofortige Übernahme** aus. Die Prüfung erfolgt erst bei den konfigurierten **Batterieladestandsereignissen**; auch die abschließende Übereinstimmungsprüfung findet im Rahmen eines solchen Durchlaufs statt.

## Zusammenspiel der Regelstrategien

Die Wetterprognose beeinflusst die AC-Ausgabe **indirekt**: Sie ändert den geplanten Mindest-SoC. Dieser beeinflusst die Batteriefreigabe, die nutzbare Batterieladung für die Leistungsgewichtung und gegebenenfalls die dynamische PV-Reserve. Daraus folgen neue maximale AC-Leistungen, Leistungsanteile und AC-Sollwerte.

### Beispiel: Geplanten Mindest-SoC von 10 % auf 15 % erhöhen

Die Batterie-SoCs und PV-Leistungen bleiben im Beispiel unverändert; der tatsächlich eingestellte Mindest-SoC beträgt jeweils 10 %.

| Eigenschaft | Zendure 1 | Zendure 2 |
|---|---:|---:|
| Batterie-SoC | 12 % | 20 % |
| PV-Leistung | 100 W | 200 W |
| **AC-Maximum bei geplantem Mindest-SoC 10 %** | **700 W** | **800 W** |
| **AC-Maximum bei geplantem Mindest-SoC 15 %** | **0 W** | **800 W** |

Bei einem AC-Gesamtbedarf von **600 W** ergibt sich bei 10 % geplantem Mindest-SoC ein Gerätegewicht von 138,4 für Zendure 1 und 392 für Zendure 2. Nach dem SoC-Ausgleich von −8 Prozentpunkten erhält Zendure 1 ungefähr **18,09 %** und Zendure 2 **81,91 %** des Bedarfs.

Nach der Erhöhung auf 15 % liegt Zendure 1 mit 12 % SoC unter dem neuen geplanten Minimum. Trotz einer berechneten PV-Reserve von 60 % beträgt seine maximale AC-Leistung 0 W. Zendure 2 übernimmt bei ausreichendem Gerätemaximum den gesamten Bedarf. Die neue Grenze wirkt sofort, auch wenn sie noch nicht an Zendure 1 übertragen wurde.

## Besonderheiten der gewählten Steuerung

Die wesentlichen Entscheidungen sind:

- **Keine feste 50:50-Aufteilung:** Die aktuelle PV-Leistung und die nutzbare SoC-Reserve bestimmen gemeinsam die Gewichtung; ein zusätzlicher SoC-Ausgleich berücksichtigt unterschiedliche Batteriestände. Erreicht ein Gerät seine maximale AC-Leistung, wird der verbleibende Bedarf auf das andere Gerät umverteilt, soweit dessen Leistungsgrenze dies erlaubt.
- **Getrennte Batteriebewertung:** Ein Akku kann geschützt werden, während der andere weiter Leistung liefert.
- **Gemeinsamer Hausverbrauch:** Grundlage ist die Summe aus Netzleistung und beiden AC-Ist-Leistungen.
- **Kleiner positiver Netzbezugs-Sollwert:** 10, 20 oder 30 W dienen als Regelreserve.
- **Gesamtbedarf auf 900 W begrenzt:** Die eigene Steuerung fordert nicht mehr an.
- **Wetterabhängige Reserve:** Geplanter Mindest-SoC von 10 oder 15 %.
- **Dynamische PV-Reserve von 0 bis 100 %:** Unter geplantem Mindest-SoC wird pro Prozentpunkt 20 % PV-Leistung reserviert; unter dem tatsächlich eingestellten Geräteminimum 100 %.
- **Geräteweise Begrenzung der AC-Sollwerte:** Kein Sollwert über dem rechnerisch freigegebenen Gerätemaximum.
- **Geplanter und eingestellter Mindest-SoC getrennt:** Neue Reserven wirken sofort auf die Leistungsberechnung; die Geräteübernahme kann warten.
- **Unabhängige Mindest-SoC-Übernahme:** Unterschiedliche Akkuladestände werden einzeln geprüft.

## Regelverhalten im laufenden Betrieb

Bei steigender Hauslast erhöht sich der AC-Gesamtbedarf bis zur 900-W-Grenze; bei sinkender Last reduziert er sich. Änderungen der PV-Leistung, der nutzbaren SoC-Reserve und der SoC-Differenz beeinflussen die prozentuale Gewichtung. Die maximal freigegebenen AC-Leistungen begrenzen die Zuteilung. Kann ein Gerät seinen gewichteten Anteil nicht vollständig liefern, übernimmt das andere die Differenz, soweit dessen Leistungsgrenze dies erlaubt.

Erreicht ein Akku den höheren Wert aus geplantem und tatsächlich eingestelltem Mindest-SoC, entfallen sowohl die zusätzliche Batteriefreigabe als auch die maximale AC-Leistung. Beide betragen dann **0 W**. Die dynamische PV-Reserve wird weiterhin berechnet, führt jedoch erst bei ausreichendem Batterie-SoC zu einer AC-Freigabe. Der andere Zendure kann entsprechend mehr übernehmen, soweit dessen eigenes Maximum und der gemeinsame Bedarf dies zulassen.

Parallel kann die Wetterberechnung die geplanten Mindest-SoC-Werte ändern und so unmittelbar neue AC-Sollwerte auslösen.

## Fehlerverhalten und Grenzen

| Situation | Verhalten beziehungsweise Grenze |
|---|---|
| Fehlende gültige Wetterprognose | Berechnung wird abgebrochen; bisherige geplante Werte bleiben erhalten. |
| Unterschiedliche Batterieladestände | Die Leistungsgewichtung berücksichtigt einen zusätzlichen SoC-Ausgleich; Freigabe und Mindest-SoC-Übernahme erfolgen je Gerät unabhängig. |
| Beide AC-Maximalwerte = 0 W | Beide Leistungsanteile und AC-Sollwerte werden 0. |
| Hausverbrauch über der Regelgrenze | Der gemeinsame AC-Bedarf bleibt auf 900 W begrenzt. |
| Verfügbare AC-Leistung unter dem Bedarf | Beide AC-Sollwerte werden auf ihre Gerätemaxima begrenzt; Restbedarf bleibt für Netz oder andere Quellen. |
| Geplanter Mindest-SoC noch nicht erreichbar | Die Übernahme wartet, die neue Grenze gilt aber bereits für die Leistungsberechnung. |
| Dynamische PV-Reserve | Die tatsächliche Akkuladung hängt vom internen Geräteverhalten ab. PV-Schwankungen können bis zur nächsten Leistungsanpassung (regulär spätestens nach 5 Sekunden) zu einer kurzfristigen Batterieentladung führen. |
| Bewölkungsprognose | Keine vollständige Ertragsprognose unter Einbeziehung aller Module, Ausrichtungen und Verschattungen. |

Die tatsächlich bereitgestellte AC-Leistung hängt weiterhin von den Betriebsbedingungen und geräteseitigen Grenzen ab.

## Funktionsprüfung

Die Solarsteuerung ist eingerichtet und wurde im laufenden Betrieb erfolgreich getestet. Die dynamische Aufteilung berücksichtigt die unterschiedlichen PV-Leistungen und Batterie-SoCs; die wetterabhängige Mindest-SoC-Berechnung und die geräteweise Übernahme sind Bestandteil der Steuerung. Der **Zendure Manager bleibt ausgeschaltet**.

Die dynamische PV-Reserve und die Begrenzung der AC-Sollwerte sollten zusätzlich im laufenden Betrieb beobachtet werden. Die bisherige Funktion bestätigt nicht automatisch alle Sonderfälle.

MQTT-Verbindung, Gerätekommunikation und technische Einrichtung sind in der Zendure-Dokumentation beschrieben.

## Nützliche Links & Quellen

- [Home Assistant Automationen – Grundlagen](https://www.home-assistant.io/docs/automation/)
- [Home Assistant Automationen – Wettervorhersagen abrufen](https://www.home-assistant.io/actions/weather.get_forecasts/)
- [Home Assistant Integration – Wetter](https://www.home-assistant.io/integrations/weather/)
- [Home Assistant Sensoren – Template-Integration](https://www.home-assistant.io/integrations/template/)

## 🔗 Verwendung & Verknüpfungen

- [Shelly](../apps/shelly.md) – Netzleistungsmessung als Grundlage der Solarsteuerung
- [Solarsteuerung – Template-Sensoren](../skripte/home-assistant/sensoren/solarsteuerung.yaml) – YAML-Konfiguration der Sensoren und Berechnungslogik
- [Zendure](../apps/zendure.md) – Einrichtung der SolarFlow-Geräte, Template-Sensoren, Helfer und Automationen

---

[⬅️ Zurück zur Übersicht](../README.md)
