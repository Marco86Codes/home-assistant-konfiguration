
# Zendure

Diese Dokumentation beschreibt die Einrichtung und Konfiguration der **Zendure Home Assistant Integration**.

Es werden zwei **Zendure SolarFlow 800 Plus** mit jeweils einem **AB2000-Akkupack** eingesetzt.

Die Integration stellt unter anderem folgende Informationen und Funktionen bereit:

- Batterieladestand (SoC)
- PV-Eingangsleistung
- Tatsächliche AC-Ausgangsleistung
- Batterielade- und Entladeleistung
- Einstellbare AC-Ausgangsgrenze
- Einstellbarer Mindest-SoC
- Gerätestatus und Diagnosewerte

Die beiden SolarFlow-Geräte werden über eine eigene Home-Assistant-Solarsteuerung geregelt. Der integrierte **Zendure Manager** bleibt dafür ausgeschaltet.

## Voraussetzungen

Folgende Komponenten müssen bereits eingerichtet sein:

- **Mosquitto broker**
- Separater Home-Assistant-Benutzer für die MQTT-Kommunikation
- **Shelly 3EM** mit berechnetem Sensor für die gesamte Netzleistung
- Beide SolarFlow 800 Plus in der Zendure-App erreichbar

> [!WICHTIG]
> Die **Zendure Home Assistant Integration** wird über den integrierten **Home Assistant Marketplace** installiert.

## Vorbereitung in der Zendure-App

### Geräte aus HEMS entfernen

Vor der Einbindung in Home Assistant wurden beide SolarFlow 800 Plus in der Zendure-App aus **Zendure HEMS** entfernt.

Die Geräte bleiben weiterhin in der Zendure-App vorhanden.

### Zendure-Token ermitteln

1. **Zendure-App** öffnen.
2. **Profil** auswählen.
3. **Autorisierungs-Cloud-Schlüssel** öffnen.
4. Den angezeigten Token kopieren.

Der Token wird bei der Einrichtung der Home-Assistant-Integration benötigt.

### MQTT-Benutzer anlegen

Für die Kommunikation wird ein separater Home-Assistant-Benutzer ohne Administratorrechte verwendet.

Der Benutzer wird unter **Home Assistant → Einstellungen → Personen → Benutzer** angelegt.

### DHCP-Zuweisungen

Für beide SolarFlow 800 Plus und den Home-Assistant-Server werden feste DHCP-Zuweisungen in der Freebox verwendet.

Dadurch bleiben die lokalen IPv4-Adressen für die MQTT-Kommunikation und Netzwerkdiagnose konstant.

### Lokale MQTT-Steuerung aktivieren

Dieser Schritt muss für beide SolarFlow 800 Plus einzeln durchgeführt werden.

1. In der **Zendure-App** das jeweilige Gerät öffnen.
2. **Einstellungen → MQTT** aufrufen.
3. **MQTT-Steuerung** aktivieren.
4. Folgende Verbindungsdaten eintragen:

| Einstellung | Wert |
| --- | --- |
| MQTT-Server | Lokale IPv4-Adresse des Home-Assistant-Servers |
| MQTT-Port | `1883` |
| MQTT-Benutzer | Separat angelegter Home-Assistant-Benutzer |
| MQTT-Passwort | Passwort des angelegten Benutzers |

5. Einstellungen speichern.
6. Den Vorgang beim zweiten SolarFlow 800 Plus wiederholen.

> [!WICHTIG]
> Als MQTT-Server muss eine im Heimnetz erreichbare IP-Adresse verwendet werden. Der interne Home-Assistant-Hostname `core-mosquitto` darf hier nicht verwendet werden, da die Zendure-Geräte diesen nicht auflösen können.

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
| --- | --- |
| Zendure Token | Token aus der Zendure-App |
| P1 Sensor for smart matching | `sensor.shelly_netzleistung_gesamt` |
| Log MQTT communication | Deaktiviert |
| Use local MQTT | Aktiviert |

Der P1-Sensor liefert die gesamte Netzleistung des Shelly 3EM.

Die Auswahl des Sensors dient der Konfiguration der Integration. Die automatische Leistungsregelung über den **Zendure Manager** wird nicht verwendet.

### MQTT-Verbindung

Im anschließenden Dialog wurden folgende Einstellungen vorgenommen:

| Einstellung | Wert |
| --- | --- |
| MQTT Server | Lokale IPv4-Adresse des Home-Assistant-Servers |
| MQTT Port | `1883` |
| MQTT User | Separat angelegter Home-Assistant-Benutzer |
| MQTT Password | Passwort des angelegten Benutzers |
| Automatically manage MQTT users | Deaktiviert |
| Wifi SSID | WLAN der Zendure-Geräte |
| Wifi Password | Zugehöriges WLAN-Passwort |

> [!WICHTIG]
> Die automatische MQTT-Benutzerverwaltung bleibt deaktiviert, da der Benutzer bereits manuell in Home Assistant angelegt wurde.

### Geräte

Nach erfolgreicher Einrichtung wurden folgende Geräte erkannt:

| Gerät | Bezeichnung |
| --- | --- |
| Zendure Manager | Zendure Manager |
| SolarFlow 800 Plus | SolarFlow 800 Plus 1 |
| SolarFlow 800 Plus | SolarFlow 800 Plus 2 |
| AB2000 | Akkupack von SolarFlow 1 |
| AB2000 | Akkupack von SolarFlow 2 |

Die beiden SolarFlow-Geräte wurden zur eindeutigen Unterscheidung mit den Nummern 1 und 2 bezeichnet.

### Sicherungsgruppe

Für beide SolarFlow 800 Plus wurde folgende Geräte-Sicherungsgruppe ausgewählt:

**max. 800 W / 1200 W laden**

Die Sicherungsgruppe legt Leistungsgrenzen innerhalb der Zendure-Integration fest.

Die Auswahl muss zur tatsächlichen elektrischen Installation passen und ist von der Leistungsbegrenzung durch die eigene Solarsteuerung zu unterscheiden.

### Verbindungsart

Bei beiden SolarFlow 800 Plus wurde die Verbindungsart **Cloud** beibehalten.

Die alternative Verbindungsart `zenSDK` wurde getestet, führte jedoch zu Verbindungsfehlern bei direkten HTTP-Anfragen an die Geräte und wird deshalb derzeit nicht verwendet.

Die lokale MQTT-Steuerung ist unabhängig davon in der Zendure-App aktiviert.

> [!HINWEIS]
> Die erfolgreiche lokale MQTT-Verbindung bestätigt nicht automatisch, dass sämtliche Messwerte und Steuerbefehle ausschließlich lokal übertragen werden.

## Einbindung in die Solarsteuerung

Die Integration stellt die benötigten Messwerte und einstellbaren Leistungsgrenzen für die eigene Home-Assistant-Solarsteuerung bereit.

### Verwendete Steuerungsentitäten

| Funktion | Zendure 1 | Zendure 2 |
| --- | --- | --- |
| Batterieladestand | `sensor.solarflow_800_plus_1_electric_level` | `sensor.solarflow_800_plus_2_electric_level` |
| Tatsächliche AC-Leistung | `sensor.solarflow_800_plus_1_output_home_power` | `sensor.solarflow_800_plus_2_output_home_power` |
| AC-Ausgangsgrenze | `number.solarflow_800_plus_1_output_limit` | `number.solarflow_800_plus_2_output_limit` |
| Mindest-SoC | `number.solarflow_800_plus_1_min_soc` | `number.solarflow_800_plus_2_min_soc` |

Die eigenen Template-Sensoren und Helfer sind in `solarsteuerung.yaml` definiert.

Für die Steuerung werden drei Automationen verwendet:

| Automation | Aufgabe |
| --- | --- |
| Zendure Leistungsanpassung | Überträgt die berechneten AC-Sollwerte an beide Geräte |
| Zendure Mindest-SoC Berechnung | Berechnet den geplanten Mindest-SoC anhand der Wetterprognose |
| Zendure Mindest-SoC Übernahme | Überträgt die geplanten Mindest-SoC-Werte an die Geräte |

Das Gesamtkonzept, die Berechnungslogik und das Regelverhalten sind in der zentralen Dokumentation der Solarsteuerung beschrieben.

## Funktionsprüfung

### MQTT-Verbindung

Nach der Einrichtung wurde das Protokoll des **Mosquitto broker** überprüft.

Beide SolarFlow 800 Plus haben sich erfolgreich mit dem separat angelegten Benutzer verbunden.

Im Mosquitto-Protokoll wurden für beide Geräte erfolgreiche Verbindungen auf Port `1883` bestätigt.

Beispielhafte Protokollmeldungen:

```text
New connection from <GERÄTE-IP>:<PORT> on port 1883.

New client connected from <GERÄTE-IP>:<PORT> as <CLIENT-ID> (...).
```

Damit ist die MQTT-Authentifizierung beider Geräte am lokalen Broker nachgewiesen.

### Messwerte und Gerätereport

Die beiden SolarFlow-Geräte haben JSON-Meldungen mit ihren Geräteeigenschaften geliefert.

Für die Steuerung sind insbesondere folgende Felder relevant:

| JSON-Feld | Bedeutung |
| --- | --- |
| `electricLevel` | Batterieladestand (SoC) |
| `solarInputPower` | PV-Eingangsleistung |
| `outputHomePower` | Tatsächliche AC-Ausgangsleistung |
| `outputLimit` | Eingestellte AC-Ausgangsgrenze |
| `minSoc` | Mindest-SoC |
| `inverseMaxPower` | Maximale Wechselrichterleistung |
| `packNum` | Anzahl erkannter Akkupacks |
| `packData` | Informationen zu den Akkupacks |

Die Felder und ihre Werte lassen sich anhand der empfangenen JSON-Meldungen überprüfen.

### Lokalen HTTP-Report prüfen

Für die Diagnose der lokalen HTTP-Schnittstelle kann folgende Adresse im Browser aufgerufen werden:

```text
http://<GERÄTE-IP>/properties/report
```

`<GERÄTE-IP>` steht für die lokale IPv4-Adresse des jeweiligen SolarFlow 800 Plus.

### Steuerung

Die Integration stellt für beide Geräte eine einstellbare AC-Ausgangsgrenze und einen einstellbaren Mindest-SoC bereit.

Die zugehörigen Entitäten wurden identifiziert und in die eigenen Home-Assistant-Automationen eingebunden.

Die automatische Leistungsanpassung und die wetterabhängige Mindest-SoC-Steuerung wurden im laufenden Betrieb erfolgreich getestet.

Der **Zendure Manager** bleibt auf **Aus**.

## Bekannte Einschränkungen

- Die Verbindungsart `zenSDK` führte zu HTTP-Verbindungsfehlern und wird derzeit nicht verwendet.
- Die wetterabhängige Steuerung ist von der Verfügbarkeit einer passenden stündlichen Wetterprognose abhängig.

## Nützliche Links & Quellen

- [Zendure Home Assistant – Installationsanleitung](https://github.com/Zendure/Zendure-HA/wiki/Installation)
- [Zendure Home Assistant Integration – GitHub](https://github.com/Zendure/Zendure-HA)

## 🔗 Verwendung & Verknüpfungen

- [DHCP-Zuweisungen in der Freebox](../externe-systeme/freebox/dhcp-zuweisungen.md) – feste lokale Adressen
- [Hardware & Geräte](../hardware.md) – Übersicht der eingesetzten Geräte
- [MQTT](mqtt.md) – Home-Assistant-Integration für die MQTT-Kommunikation
- [Mosquitto broker](mosquitto-broker.md) – verwendeter MQTT-Broker
- [Shelly](shelly.md) – Einrichtung der Netzleistungsmessung
- [Solarsteuerung](../grundlagen/solarsteuerung.md) – Gesamtkonzept und Berechnungslogik
- [Solarsteuerung – Sensoren und Helfer](../skripte/home-assistant/sensoren/solarsteuerung.yaml) – YAML-Konfiguration
- [Zendure – Leistungsanpassung](../skripte/home-assistant/automationen/zendure-leistungsanpassung.yaml) – Automation zur AC-Leistungsanpassung
- [Zendure – Mindest-SoC-Berechnung](../skripte/home-assistant/automationen/zendure-mindest-soc-berechnung.yaml) – wetterabhängige Berechnung
- [Zendure – Mindest-SoC-Übernahme](../skripte/home-assistant/automationen/zendure-mindest-soc-uebernahme.yaml) – Übernahme der geplanten Werte

---

[⬅️ Zurück zur Übersicht](../README.md)
