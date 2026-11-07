# Hardware & Geräte

Diese Übersicht enthält die in Home Assistant eingebundene Hardware und deren Einbindungsart.

## Namensschema

Für eingebundene Geräte wird ein einheitliches Namensschema verwendet:

`Gerätetyp_Kategorie_Raum_Unterscheidung`

Nicht benötigte Bestandteile können entfallen, sofern der Gerätename weiterhin eindeutig und verständlich bleibt.

Beispiele:

- `Kontakt_Fenster_Eltern_klein`
- `Kontakt_Fenster_Eltern_gross`
- `Vibration_Garage`
- `Temperatur_Wohnzimmer`

> [!WICHTIG]
> Gerätename und Entitäts-ID sind unterschiedliche Bezeichnungen.
>
> Die endgültige Benennung eines neuen Geräts sollte unmittelbar nach dessen Einrichtung und vor der Verwendung seiner Entitäten in Automationen, Skripten oder Dashboards erfolgen.
>
> Änderungen an Gerätenamen werden zwischen Home Assistant und der jeweiligen App nicht immer automatisch übernommen. In diesem Fall muss die Benennung gegebenenfalls an beiden Stellen angepasst werden.

Anschließend werden die Entitäten des Geräts geprüft. Über das jeweilige Gerät in Home Assistant können ihre Entitäts-IDs bei Bedarf mit der Funktion **Entitäts-IDs neu erstellen** angepasst werden. Die Entitäts-IDs sollen sich am festgelegten Gerätenamen orientieren und dadurch eindeutig zugeordnet werden können.


Werden Entitäts-IDs erst später geändert, können bereits vorhandene Automationen, Skripte, Dashboards oder andere Verknüpfungen auf die bisherigen Entitäts-IDs verweisen und dadurch nicht mehr wie vorgesehen funktionieren.

Anpassungen an Geräte- und Entitätsnamen werden über das jeweilige Gerät in Home Assistant vorgenommen.

## Eingebundene Hardware

Die Hardware ist alphabetisch nach Hersteller und anschließend nach Modell sortiert.

| Hersteller | Modell | Gerätetyp | Einrichtungsart |
|---|---|---|---|
| Aqara | MCCGQ11LM | Tür-/Fenstersensor | [Zigbee2MQTT](apps/zigbee2mqtt.md) |
| Shelly | 3EM | 3-Phasen-Energiezähler | [Shelly](apps/shelly.md) |
| Sonoff | S60ZBTPF | Zigbee-Steckdose | [Zigbee2MQTT](apps/zigbee2mqtt.md) |
| Zendure | AB2000 | Batteriespeicher | [Zendure](apps/zendure.md) |
| Zendure | SolarFlow 800 Plus | Wechselrichter mit Speicheranbindung | [Zendure](apps/zendure.md) |

---

[⬅️ Zurück zur Übersicht](README.md)
