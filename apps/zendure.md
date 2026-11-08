# Zendure

## Beschreibung

Die Zendure Home Assistant Integration ermöglicht die Einbindung und Steuerung von Zendure-Geräten in Home Assistant.

Es werden zwei **Zendure SolarFlow 800 Plus** mit jeweils einem **AB2000-Akkupack** eingesetzt.

Die Integration stellt unter anderem folgende Informationen und Funktionen bereit:

- Batterieladestand (SoC)
- PV-Eingangsleistung
- Tatsächliche AC-Ausgangsleistung
- Batterielade- und Entladeleistung
- Einstellbare AC-Ausgangsgrenze
- Einstellbarer Mindest-SoC
- Gerätestatus und Diagnosewerte

Ausschlaggebend für die eigene Solarsteuerung war die feste **50:50-Leistungsaufteilung** der Zendure-App. Aufgrund unterschiedlich leistungsstarker PV-Module, verschiedener Ausrichtungen und standortbedingter Verschattung ist diese Aufteilung für die vorhandene Solaranlage nicht optimal.

Die beiden SolarFlow 800 Plus werden deshalb über eine **eigene Home-Assistant-Solarsteuerung** geregelt.

Dazu werden die Messwerte des Shelly 3EM, verschiedene Template-Sensoren sowie drei Automationen verwendet.

Der integrierte Zendure Manager wird für die Leistungsregelung nicht verwendet.

## Voraussetzungen

Folgende Komponenten müssen bereits eingerichtet sein:

- Mosquitto Broker
- Home-Assistant-Benutzer mit lokalem Zugang für Zendure MQTT
- Shelly 3EM mit berechnetem Sensor für die gesamte Netzleistung
- Beide SolarFlow 800 Plus in der Zendure-App erreichbar

> [!WICHTIG]
> Die Integration wird über den integrierten **Home Assistant Marketplace** installiert.

## Vorbereitung in der Zendure-App

### Geräte aus HEMS entfernen

Vor der Einbindung in Home Assistant wurden beide SolarFlow 800 Plus in der Zendure-App aus Zendure HEMS entfernt. Die Geräte bleiben weiterhin in der Zendure-App vorhanden.

### Zendure-Token ermitteln

1. **Zendure-App** öffnen.
2. **Profil** auswählen.
3. **Autorisierungs-Cloud-Schlüssel** öffnen.
4. Den angezeigten Token kopieren.

Der Token wird später bei der Einrichtung der Home-Assistant-Integration benötigt.

### MQTT-Benutzer anlegen

Für die Kommunikation wird ein separater Home-Assistant-Benutzer **ohne Administratorrechte** und **mit lokalem Zugang** verwendet.

Der Benutzer wird unter **Home Assistant → Einstellungen → Personen → Benutzer** angelegt.

### DHCP-Zuweisungen

Für die beiden SolarFlow 800 Plus und den Home-Assistant-Server werden feste DHCP-Zuweisungen in der Freebox verwendet. Dadurch bleiben die lokalen IPv4-Adressen konstant und können zuverlässig für die MQTT-Kommunikation und Netzwerkdiagnose genutzt werden.

### Lokale MQTT-Steuerung aktivieren

Dieser Schritt muss **für beide SolarFlow 800 Plus einzeln** durchgeführt werden.

1. In der **Zendure-App** das jeweilige Gerät öffnen.
2. **Einstellungen → MQTT** aufrufen.
3. **MQTT-Steuerung** aktivieren.
4. Folgende Verbindungsdaten eintragen:

| Einstellung | Wert |
|---|---|
| MQTT-Server | LAN-IP-Adresse des Home-Assistant-Servers |
| MQTT-Port | `1883` |
| MQTT-Benutzer | Separat angelegter Home-Assistant-Benutzer |
| MQTT-Passwort | Passwort des angelegten Benutzers |

5. Einstellungen speichern.
6. Den Vorgang beim zweiten SolarFlow 800 Plus wiederholen.

> [!WICHTIG]
> Als MQTT-Server muss eine im Heimnetz erreichbare IP-Adresse verwendet werden.
>
> Der interne Home-Assistant-Hostname `core-mosquitto` darf hier nicht verwendet werden, da die Zendure-Geräte diesen nicht auflösen können.

## Installation

1. In Home Assistant **Einstellungen → Marketplace** öffnen.
2. Nach **Zendure Home Assistant Integration** suchen.
3. Die Integration aus dem Repository `Zendure/Zendure-HA` auswählen.
4. Die Integration installieren.
5. Home Assistant neu starten, falls dies verlangt wird.
6. Unter **Einstellungen → Geräte & Dienste** die Zendure-Integration hinzufügen.

## Konfiguration

### Zendure-Konto und Sensor

Bei der Einrichtung wurden folgende Einstellungen vorgenommen:

| Einstellung | Wert |
|---|---|
| Zendure Token | Token aus der Zendure-App |
| P1 Sensor for smart matching | `sensor.shelly_netzleistung_gesamt` |
| Log MQTT communication | Deaktiviert |
| Use local MQTT | Aktiviert |

Der P1-Sensor liefert die gesamte Netzleistung des Shelly 3EM. Die Auswahl des Sensors dient der Konfiguration der Integration. Die automatische Leistungsregelung über den Zendure Manager wird nicht verwendet.

### MQTT-Verbindung

Im anschließenden Dialog wurden folgende Einstellungen vorgenommen:

| Einstellung | Wert |
|---|---|
| MQTT Server | LAN-IP-Adresse des Home-Assistant-Servers |
| MQTT Port | `1883` |
| MQTT User | Separat angelegter Home-Assistant-Benutzer |
| MQTT Password | Passwort des angelegten Benutzers |
| Automatically manage MQTT users | Deaktiviert |
| Wifi SSID | WLAN, mit dem die Zendure-Geräte verbunden sind |
| Wifi Password | Zugehöriges WLAN-Passwort |

> [!WICHTIG]
> Die automatische MQTT-Benutzerverwaltung bleibt deaktiviert, da der Benutzer bereits manuell in Home Assistant angelegt wurde.

### Geräte

Nach erfolgreicher Einrichtung wurden folgende Geräte erkannt:

| Gerät | Bezeichnung |
|---|---|
| Zendure Manager | Zendure Manager |
| SolarFlow 800 Plus | SolarFlow 800 Plus 1 |
| SolarFlow 800 Plus | SolarFlow 800 Plus 2 |
| AB2000 | Akkupack von SolarFlow 1 |
| AB2000 | Akkupack von SolarFlow 2 |

Die beiden SolarFlow-Geräte wurden zur eindeutigen Unterscheidung mit den Nummern 1 und 2 bezeichnet.

### Sicherungsgruppe

Für beide SolarFlow 800 Plus wurde folgende Geräte-Sicherungsgruppe ausgewählt:

**max. 800 W / 1200 W laden**

Die Sicherungsgruppe legt Leistungsgrenzen innerhalb der Zendure-Integration fest. Die Auswahl muss zur tatsächlichen elektrischen Installation passen und ist von der Leistungsbegrenzung durch die eigene Solarsteuerung zu unterscheiden.

### Verbindungsart

Bei beiden SolarFlow 800 Plus wurde die Verbindungsart **Cloud** beibehalten.

Die alternative Verbindungsart `zenSDK` wurde getestet, führte jedoch zu Verbindungsfehlern bei direkten HTTP-Anfragen an die Geräte. Deshalb wird `zenSDK` derzeit nicht verwendet.

Die lokale MQTT-Steuerung ist unabhängig davon in der Zendure-App aktiviert.

> [!HINWEIS]
> Die erfolgreiche lokale MQTT-Verbindung bestätigt nicht automatisch, dass sämtliche Messwerte und Steuerbefehle ausschließlich lokal übertragen werden.

## Solarsteuerung über Home Assistant

### Aufbau

Die Steuerung erfolgt über eigene Home-Assistant-Template-Sensoren und Automationen.

Als Grundlage dienen:

- Die gesamte Netzleistung des Shelly 3EM
- Die tatsächliche AC-Ausgangsleistung beider Zendure
- Die PV-Eingangsleistung beider Zendure
- Der jeweilige Batterieladestand
- Der geplante Mindest-SoC beider Zendure
- Eine stündliche Wettervorhersage

Die erforderlichen Template-Sensoren und Helfer sind zentral in der Datei `solarsteuerung.yaml` definiert.


### Sensoren und Helfer

Die Solarsteuerung verwendet Template-Sensoren zur Berechnung des Hausverbrauchs, des Leistungsbedarfs und der dynamischen Leistungsaufteilung zwischen beiden Zendure-Geräten.

#### Netzleistung und Leistungsbedarf

| Sensor | Berechnung und Zweck |
|---|---|
| `sensor.shelly_netzleistung_gesamt` | Summiert die Netzleistung aller drei Shelly-Phasen. Positive Werte bedeuten Netzbezug, negative Werte Netzeinspeisung. |
| `sensor.hausverbrauch_gesamt` | Addiert die Netzleistung und die tatsächliche AC-Ausgangsleistung beider Zendure. Ermittelt daraus den gesamten Hausverbrauch. |
| `sensor.netzbezug_soll` | Legt abhängig vom durchschnittlichen Batterie-SoC einen Netzbezugs-Sollwert von 10, 20 oder 30 W fest. Sind beide geplanten Mindest-SoC-Werte auf 10 %, beträgt der Sollwert immer 10 W. |
| `sensor.zendure_gesamt_ac_leistungsbedarf` | Berechnet den Hausverbrauch abzüglich des Netzbezugs-Sollwerts. Das Ergebnis wird auf 0 bis 900 W begrenzt. |

#### PV- und Batterieleistung

| Sensor | Berechnung und Zweck |
|---|---|
| `sensor.zendure_1_pv_leistung` | Summiert die Leistung beider PV-Eingänge von Zendure 1. |
| `sensor.zendure_1_pv_begrenzung` | Zeigt `aktiv: 50 %`, wenn der SoC von Zendure 1 unter dem geplanten Mindest-SoC liegt; andernfalls `Inaktiv`. |
| `sensor.zendure_2_pv_leistung` | Summiert die Leistung beider PV-Eingänge von Zendure 2. |
| `sensor.zendure_2_pv_begrenzung` | Zeigt `aktiv: 50 %`, wenn der SoC von Zendure 2 unter dem geplanten Mindest-SoC liegt; andernfalls `Inaktiv`. |
| `sensor.zendure_1_maximale_batterieleistung` | Gibt 600 W frei, wenn der Batterie-SoC von Zendure 1 über dem geplanten Mindest-SoC liegt. Andernfalls 0 W. |
| `sensor.zendure_2_maximale_batterieleistung` | Gibt 600 W frei, wenn der Batterie-SoC von Zendure 2 über dem geplanten Mindest-SoC liegt. Andernfalls 0 W. |
| `sensor.zendure_1_maximale_ac_leistung` | Berechnet die maximal freigegebene AC-Leistung von Zendure 1. Oberhalb des geplanten Mindest-SoC werden PV- und Batterieleistung addiert, bei genau erreichtem Mindest-SoC nur die PV-Leistung berücksichtigt und unterhalb des Mindest-SoC die PV-Leistung auf 50 % reduziert. Maximal 800 W. |
| `sensor.zendure_2_maximale_ac_leistung` | Berechnet die maximal freigegebene AC-Leistung von Zendure 2. Oberhalb des geplanten Mindest-SoC werden PV- und Batterieleistung addiert, bei genau erreichtem Mindest-SoC nur die PV-Leistung berücksichtigt und unterhalb des Mindest-SoC die PV-Leistung auf 50 % reduziert. Maximal 800 W. |
| `sensor.zendure_gesamt_maximale_ac_leistung` | Summiert die maximal verfügbare AC-Leistung beider Zendure. |

#### Dynamische Leistungsaufteilung

| Sensor | Berechnung und Zweck |
|---|---|
| `sensor.zendure_1_leistungsanteil` | Berechnet den prozentualen Anteil von Zendure 1 an der gesamten verfügbaren AC-Leistung. |
| `sensor.zendure_2_leistungsanteil` | Berechnet den prozentualen Anteil von Zendure 2 an der gesamten verfügbaren AC-Leistung. |
| `sensor.zendure_1_ac_soll_leistung` | Berechnet den anteiligen AC-Leistungsbedarf von Zendure 1 und begrenzt ihn auf die maximal freigegebene AC-Leistung dieses Geräts. |
| `sensor.zendure_2_ac_soll_leistung` | Berechnet den anteiligen AC-Leistungsbedarf von Zendure 2 und begrenzt ihn auf die maximal freigegebene AC-Leistung dieses Geräts. |

#### Batterieladestand und Helfer

| Entität | Berechnung und Zweck |
|---|---|
| `sensor.zendure_gesamt_soc_durchschnitt` | Berechnet den durchschnittlichen Batterieladestand beider Zendure. |
| `input_number.zendure_1_neuer_min_soc` | Speichert den wetterabhängig geplanten Mindest-SoC für Zendure 1. |
| `input_number.zendure_2_neuer_min_soc` | Speichert den wetterabhängig geplanten Mindest-SoC für Zendure 2. |
| `input_datetime.zendure_letzte_min_soc_berechnung` | Speichert den Zeitpunkt der letzten erfolgreichen Mindest-SoC-Berechnung. |

Die geplanten Mindest-SoC-Werte werden bereits bei der Berechnung der verfügbaren Batterieleistung berücksichtigt, unabhängig davon, ob sie bereits an die Zendure-Geräte übertragen wurden.

Die beiden PV-Begrenzungs-Sensoren dienen der **Statusanzeige**. Sie vergleichen jeweils den aktuellen Batterie-SoC mit dem geplanten Mindest-SoC (`input_number.zendure_1_neuer_min_soc` beziehungsweise `input_number.zendure_2_neuer_min_soc`). Unterhalb des Grenzwerts zeigen sie `aktiv: 50 %`, bei gleichem oder höherem SoC `Inaktiv`. Die tatsächliche Begrenzung der AC-Freigabe erfolgt weiterhin über die Sensoren für die maximale AC-Leistung.


### Automationen

Für die Steuerung werden drei Automationen verwendet.

**Zendure Leistungsanpassung**

Die standardmäßige 50:50-Leistungsaufteilung der Zendure-App berücksichtigt die unterschiedlichen Bedingungen der beiden Solaranlagen nicht ausreichend. Durch verschieden leistungsstarke PV-Module, unterschiedliche Ausrichtungen und standortbedingte Verschattung steht beiden SolarFlow-Geräten nicht immer dieselbe Leistung zur Verfügung.

Die eigene Home-Assistant-Steuerung ersetzt diese feste Aufteilung durch eine **dynamische, prozentuale Leistungsverteilung**.

Dabei werden folgende Faktoren berücksichtigt:

- Die aktuell verfügbare PV-Leistung jedes SolarFlow-Geräts
- Der jeweilige Batterieladestand (SoC)
- Der geplante Mindest-SoC beider Batterien
- Der gesamte AC-Leistungsbedarf des Hauses
- Der dynamische Netzbezugs-Sollwert

Aus der verfügbaren PV-Leistung und der abhängig vom Batterieladestand nutzbaren Batterieleistung wird zunächst die maximal freigegebene AC-Leistung jedes Geräts ermittelt.

Liegt der Batterieladestand unter dem geplanten Mindest-SoC, werden nur 50 % der aktuellen PV-Leistung für die AC-Ausgabe freigegeben. Die verbleibende PV-Leistung soll vorrangig zum Wiederaufladen der Batterie zur Verfügung stehen.

Anschließend werden die prozentualen Leistungsanteile berechnet und der gesamte AC-Leistungsbedarf entsprechend auf beide SolarFlow 800 Plus verteilt. Die jeweiligen AC-Soll-Leistungen werden dabei auf die zuvor berechneten maximal freigegebenen AC-Leistungen begrenzt.

Die Automation überprüft regelmäßig, ob die eingestellten AC-Ausgangsgrenzen von den berechneten Soll-Werten abweichen, und passt diese bei Bedarf an.

Dadurch wird die Leistungsaufteilung automatisch an die unterschiedlichen Erzeugungsbedingungen und Batterieladestände angepasst, anstatt beide Geräte unabhängig von ihrer verfügbaren Leistung gleichmäßig zu belasten.

**Zendure Mindest-SoC Berechnung**

Berechnet den geplanten Mindest-SoC beider Zendure anhand der Bewölkungsprognose.

Die Berechnung erfolgt zu Sonnenaufgang, mittags und zwei Stunden vor Sonnenuntergang. Bei einer Bewölkungsprognose von mehr als 75 % wird ein Mindest-SoC von 15 % vorgesehen, andernfalls 10 %.

Nach erfolgreicher Berechnung wird der Zeitstempel aktualisiert und die Übernahme-Automation aktiviert.

**Zendure Mindest-SoC Übernahme**

Überträgt den geplanten Mindest-SoC unabhängig für beide Zendure.

Der neu berechnete Mindest-SoC wird bereits vor der Übertragung an die Geräte als **Referenz für die Batterieentladung** verwendet.

Dabei werden zwei Situationen berücksichtigt:

- **Steigende Bewölkung:** Wird der geplante Mindest-SoC angehoben, wird die Entnahme aus der jeweiligen Batterie bereits beim neuen Grenzwert begrenzt. Dadurch bleibt eine größere Energiereserve erhalten.
- **Sinkende Bewölkung:** Wird der geplante Mindest-SoC gesenkt, darf die Batterie weiter entladen werden. Dadurch wird zusätzliche gespeicherte Energie genutzt und gleichzeitig mehr Speicherkapazität für die erwartete höhere Solarproduktion freigegeben.

Die tatsächliche Übertragung an Zendure erfolgt nur, wenn sich der geplante Wert vom eingestellten Mindest-SoC unterscheidet und der aktuelle Batterieladestand mindestens dem geplanten Wert entspricht.

Damit wird verhindert, dass eine Anhebung des Mindest-SoC bei zu niedrigem Batterieladestand eine Nachladung aus dem öffentlichen Stromnetz auslöst. Stattdessen soll die Batterie den neuen Mindest-SoC zunächst durch **Solarenergie** erreichen.

Bei einer Senkung des Mindest-SoC aufgrund einer günstigeren Solarprognose wird der neue Wert direkt an Zendure übertragen, sofern der aktuelle Batterieladestand mindestens dem neuen Mindest-SoC entspricht.

Dadurch kann die Batterie stärker entladen werden. Die zusätzlich freigegebene Speicherkapazität steht anschließend für die erwartete höhere Solarproduktion zur Verfügung.

Sobald beide Zendure den geplanten Mindest-SoC übernommen haben oder bereits entsprechend eingestellt sind, deaktiviert sich die Automation automatisch.

### Verwendete Steuerungsentitäten

| Funktion | Zendure 1 | Zendure 2 |
|---|---|---|
| Batterieladestand | `sensor.solarflow_800_plus_1_electric_level` | `sensor.solarflow_800_plus_2_electric_level` |
| Tatsächliche AC-Leistung | `sensor.solarflow_800_plus_1_output_home_power` | `sensor.solarflow_800_plus_2_output_home_power` |
| AC-Ausgangsgrenze | `number.solarflow_800_plus_1_output_limit` | `number.solarflow_800_plus_2_output_limit` |
| Mindest-SoC | `number.solarflow_800_plus_1_min_soc` | `number.solarflow_800_plus_2_min_soc` |

Die Berechnungslogik, die dynamische Leistungsaufteilung und die wetterabhängige Mindest-SoC-Strategie sind ausführlich in der zentralen Dokumentation der Solarsteuerung beschrieben.

## Funktionsprüfung

### MQTT-Verbindung

Nach der Einrichtung wurde das Protokoll des Mosquitto-Brokers überprüft.

Beide SolarFlow 800 Plus haben sich erfolgreich mit dem separat angelegten Benutzer verbunden. Im Mosquitto-Protokoll wurden für beide Geräte erfolgreiche Verbindungen auf Port `1883` bestätigt.

Erkennbar sind diese beispielsweise an folgenden Meldungen:

```text
New connection from <GERÄTE-IP>:<PORT> on port 1883.
New client connected from <GERÄTE-IP>:<PORT> as <CLIENT-ID> (...).
```

Damit ist die MQTT-Authentifizierung beider Geräte am lokalen Broker nachgewiesen.

### Messwerte und Gerätereport

Die beiden SolarFlow-Geräte haben JSON-Meldungen mit ihren Geräteeigenschaften geliefert.

Für die Solarsteuerung sind insbesondere folgende Felder relevant:

| JSON-Feld | Bedeutung |
|---|---|
| `electricLevel` | Batterieladestand (SoC) |
| `solarInputPower` | PV-Eingangsleistung |
| `outputHomePower` | Tatsächliche AC-Ausgangsleistung |
| `outputLimit` | Eingestellte AC-Ausgangsgrenze |
| `minSoc` | Mindest-SoC |
| `inverseMaxPower` | Maximale Wechselrichterleistung |
| `packNum` | Anzahl erkannter Akkupacks |
| `packData` | Informationen zu den Akkupacks |

Die Felder und ihre Werte lassen sich anhand der empfangenen JSON-Meldungen überprüfen.

#### Lokalen HTTP-Report prüfen

Für die Diagnose der lokalen HTTP-Schnittstelle kann folgende Adresse im Browser aufgerufen werden:

```text
http://<GERÄTE-IP>/properties/report
```

`<GERÄTE-IP>` wird durch die lokale IP-Adresse des jeweiligen SolarFlow 800 Plus ersetzt. Die Adresse muss von einem Gerät im selben Heimnetz aufgerufen werden.

### Steuerung

Die Integration stellt für beide Geräte eine einstellbare AC-Ausgangsgrenze und einen einstellbaren Mindest-SoC bereit.

Die zugehörigen Entitäten wurden identifiziert und in die eigenen Home-Assistant-Automationen eingebunden.

Die automatische Leistungsanpassung und die wetterabhängige Mindest-SoC-Steuerung sind eingerichtet und seit mehreren Tagen erfolgreich im laufenden Betrieb getestet.

Die Leistungsaufteilung erfolgt dynamisch anhand der verfügbaren PV-Leistung, der Batterieladestände und des berechneten AC-Leistungsbedarfs.

Der **Zendure Manager bleibt auf „Aus“**.

## Bekannte Einschränkungen

- Die Verbindungsart `zenSDK` führte zu HTTP-Verbindungsfehlern und wird derzeit nicht verwendet.
- Die wetterabhängige Mindest-SoC-Berechnung ist von der Verfügbarkeit einer passenden stündlichen Wetterprognose abhängig.

## Nützliche Links & Quellen

- [Solarsteuerung – Sensoren und Helfer](../../skripte/home-assistant/sensors/solarsteuerung.yaml)
- [Zendure Home Assistant Installationsanleitung](https://github.com/Zendure/Zendure-HA/wiki/Installation)
- [Zendure Home Assistant Integration – GitHub](https://github.com/Zendure/Zendure-HA)
- [Zendure – Leistungsanpassung](../../skripte/home-assistant/automationen/zendure-leistungsanpassung.yaml)
- [Zendure – Mindest-SoC-Berechnung](../../skripte/home-assistant/automationen/zendure-mindest-soc-berechnung.yaml)
- [Zendure – Mindest-SoC-Übernahme](../../skripte/home-assistant/automationen/zendure-mindest-soc-uebernahme.yaml)

## 🔗 Verwendung & Verknüpfungen

- [DHCP-Zuweisungen in der Freebox](../externe-systeme/freebox/dhcp-zuweisungen.md) – feste lokale Adressen
- [MQTT](mqtt.md) – Home-Assistant-Integration für MQTT
- [Hardware & Geräte](../hardware.md) – Übersicht der eingesetzten Geräte und ihrer Einbindungsart
- [Shelly](shelly.md) – Netzleistungsmessung als Grundlage der Solarsteuerung
- [Solarsteuerung](../grundlagen/solarsteuerung.md) – Gesamtkonzept, Berechnungslogik, dynamische Leistungsaufteilung und wetterabhängige Mindest-SoC-Strategie

---

- [⬅️ Zurück zur Übersicht](README.md)
