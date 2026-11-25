# Button Card

Die **Button Card** (`custom:button-card`) ist eine benutzerdefinierte Dashboard-Karte für Home Assistant. Sie ermöglicht individuell gestaltete Schaltflächen mit zustandsabhängigen Symbolen, Farben und Aktionen.

## Installation

Die Installation erfolgt über **HACS**:

1. **HACS** in Home Assistant öffnen.
2. Nach **button-card** suchen.
3. **Button Card** auswählen und herunterladen.
4. Das Home-Assistant-Dashboard im Browser neu laden.

Die Karte steht anschließend in der Dashboard-Konfiguration unter dem Typ `custom:button-card` zur Verfügung.

## Funktionstest

Zum Prüfen der Installation kann eine einfache Karte mit einer vorhandenen Entität angelegt werden:

```yaml
type: custom:button-card
entity: sun.sun
name: Sonnenstand
show_state: true
```

Wird die Karte korrekt angezeigt, ist die Einbindung erfolgreich. Die Entität `sun.sun` dient nur als Beispiel.

## 🔗 Verwendung & Verknüpfungen

- [Dashboard](../grundlagen/dashboard.md) – allgemeiner Aufbau und verwendete Dashboard-Tools
- [Home Assistant – dashboard.yaml](../skripte/home-assistant/dashboard.yaml) – vollständige Dashboard-Konfiguration

## Nützliche Links & Quellen

- [Button Card – GitHub](https://github.com/custom-cards/button-card)
- [Button Card – Dokumentation](https://custom-cards.github.io/button-card/stable/)
- [Button Card – Installation](https://custom-cards.github.io/button-card/stable/installation/)

---

[⬅️ Zurück zur Übersicht](../README.md)
