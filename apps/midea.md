# Midea

Diese Dokumentation beschreibt die Einbindung der **Midea Portasplit** in Home Assistant über die integrierte **Midea-Integration**.

Die Portasplit war bereits über die **Smart Home App** auf dem Smartphone eingerichtet und mit dem WLAN verbunden. Anschließend wurde sie in Home Assistant eingebunden.

## Voraussetzungen

- Die Midea Portasplit ist eingeschaltet und mit dem Heimnetzwerk verbunden.
- Das Gerät ist in der **Smart Home App** auf dem Smartphone eingerichtet.
- Home Assistant kann das Gerät über das lokale Netzwerk erreichen.
- Die Zugangsdaten des für die Smart Home App verwendeten Kontos sind verfügbar.

## Installation und Einrichtung

1. In Home Assistant **Einstellungen → Geräte & Dienste** öffnen.
2. **Integration hinzufügen** auswählen und nach **Midea** suchen.
3. Falls das Gerät nicht automatisch erkannt wird, die manuelle Gerätesuche verwenden.
4. Bei **Geräte suchen** die IP-Adresse der Portasplit eingeben und mit **OK** bestätigen. Alternativ kann die automatische Suche verwendet werden.
5. Unter **Ein entdecktes Gerät auswählen** das als **Air Conditioner** erkannte Gerät auswählen.
6. Bei **Authentifizierung** die Option **Anmeldedaten deines Kontos** auswählen.
7. Die Zugangsdaten des bereits in der Smart Home App verwendeten Kontos eingeben.
8. Als Cloud-Server **Smart Home** auswählen und die Einrichtung abschließen.

## Verwendung für die Raumklimasteuerung

Die Midea Portasplit ist Bestandteil der automatisierten Raumklimasteuerung und wird ergänzend zu den vorhandenen Heizkörpern zur Wärmeversorgung eingesetzt.

Die Integration ermöglicht die Steuerung des Betriebsmodus und der Solltemperatur sowie die Auswertung der verfügbaren Geräteinformationen.

Im Heizbetrieb wird die Midea Portasplit abhängig vom Ladezustand der Batteriespeicher betrieben. Dadurch kann gespeicherte Solarenergie gezielt zur Wärmeversorgung genutzt werden.

Die Steuerung der Heizkörperthermostate in den betroffenen Räumen berücksichtigt dabei die Betriebsfreigabe der Midea Portasplit, um eine unnötige parallele Wärmeversorgung zu vermeiden.

Eine automatisierte Raumkühlung ist derzeit noch nicht umgesetzt.

## Nützliche Links & Quellen

- [Midea – offizielle Home-Assistant-Integration](https://www.home-assistant.io/integrations/midea)

## 🔗 Verwendung & Verknüpfungen

- [Raumklimasteuerung](../grundlagen/raumklima.md) – Verwendung der Midea Portasplit innerhalb der Raumklimasteuerung

---

[⬅️ Zurück zur Übersicht](../README.md)
