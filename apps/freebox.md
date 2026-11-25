# Freebox

## Beschreibung

Die **Freebox-Integration** bindet den Freebox-Router in Home Assistant ein. Sie ermöglicht die Anzeige von Informationen zum Router und zu erkannten Geräten im lokalen Netzwerk.

Die Integration dient in dieser Installation der Einbindung ausgewählter, relevanter Netzwerkgeräte. Nicht benötigte Geräte sollen die Home-Assistant-Geräteübersicht nicht unnötig füllen.

## Installation

Die Freebox wird über die native Integration von Home Assistant eingerichtet.

1. **Einstellungen → Geräte & Dienste** öffnen.
2. Die Integration **Freebox** auswählen beziehungsweise hinzufügen.
3. Den Einrichtungsdialog abschließen und gegebenenfalls die erforderliche Autorisierung an der Freebox bestätigen.
4. Prüfen, ob die Freebox und die benötigten Geräte in Home Assistant verfügbar sind.

Eine zusätzliche Home-Assistant-App ist dafür nicht erforderlich.

## Konfiguration

### Automatische Aktivierung neuer Geräte

Die Option zur **automatischen Aktivierung neuer Geräte ist deaktiviert**.

Dadurch sollen neu erkannte Netzwerkgeräte nicht ohne bewusste Auswahl automatisch in Home Assistant aktiviert werden.

### Nicht relevante Geräte

Alle von der Integration gefundenen Geräte, die für die Home-Assistant-Installation nicht relevant sind, wurden **deaktiviert**.

Nur die benötigten Geräte bleiben aktiv. So bleibt die Geräteübersicht übersichtlich und es werden unnötige Entitäten vermieden.

Bei künftig neu erkannten Geräten wird ebenfalls geprüft, ob sie für Home Assistant benötigt werden. Nicht relevante Geräte bleiben deaktiviert.

## Verwendung

Die Integration wird zur Anzeige und Verwaltung der in Home Assistant benötigten Freebox- und Netzwerkgeräteinformationen eingesetzt.

Die Verwaltung der **festen DHCP-Zuweisungen** erfolgt weiterhin direkt in der Freebox. Die Freebox-Integration ersetzt diese Routerkonfiguration nicht.

## Funktionsprüfung

Nach der Einrichtung sollte geprüft werden, ob:

- die Freebox-Integration ohne Fehler geladen wird,
- die benötigten Geräte und Entitäten verfügbar sind,
- die automatische Aktivierung neuer Geräte deaktiviert bleibt,
- nicht relevante Geräte weiterhin deaktiviert sind.

## Nützliche Links & Quellen

- [Home Assistant – Freebox-Integration](https://www.home-assistant.io/integrations/freebox/) – offizielle Dokumentation der Integration

## 🔗 Verwendung & Verknüpfungen

- [Dashboard – Netzwerk](../grundlagen/dashboard_netzwerk.md) – Darstellung der Freebox-Informationen im Netzwerk-Dashboard
- [DHCP-Zuweisungen in der Freebox](../externe-systeme/freebox/dhcp-zuweisungen.md) – feste lokale IPv4-Adressen und deren Verwendung

---

[⬅️ Zurück zur Übersicht](../README.md)
