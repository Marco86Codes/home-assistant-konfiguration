# Samba share

Diese Dokumentation beschreibt die Konfiguration der offiziellen Home-Assistant-App **Samba share**.

Die App stellt ausschließlich das Backup-Verzeichnis von Home Assistant im lokalen Netzwerk bereit. Dadurch kann der Windows-PC die von Home Assistant erstellten Backups abrufen.

## Verwendung

Samba share wird in dieser Installation ausschließlich für die zusätzliche Sicherung der Home-Assistant-Backups verwendet.

Freigegeben wird nur `backup`.

Andere Home-Assistant-Verzeichnisse werden nicht über Samba bereitgestellt.

## Installation

Verwendet wird die offizielle Home-Assistant-App **Samba share**.

Nach der Installation wurden folgende App-Einstellungen aktiviert:

| Einstellung | Konfiguration |
| --- | --- |
| Start bei Systemstart | Aktiviert |
| Watchdog | Aktiviert |
| Automatische Updates | Deaktiviert |

Automatische Updates sind deaktiviert, damit Aktualisierungen bewusst durchgeführt und anschließend auf Funktion geprüft werden können.

## Konfiguration

Benutzername und Passwort für den Zugriff auf die Freigabe werden direkt in der Konfiguration von **Samba share** festgelegt.

Verwendete Konfiguration:

| Einstellung | Konfiguration |
| --- | --- |
| Benutzername | separat angelegter Benutzer für Samba share |
| Passwort | separates zufällig erzeugtes Passwort |
| Workgroup | `WORKGROUP` |
| Freigabe | ausschließlich `backup` |
| Compatibility mode | Deaktiviert |
| Apple compatibility mode | Deaktiviert |
| NetBIOS over IP | Deaktiviert |
| Local master | Deaktiviert |
| Network discovery | Deaktiviert |
| Server signing | Standardeinstellung |
| Veto files | Standardeinstellung |

> [!WICHTIG]
> Änderungen im Reiter **Konfiguration** müssen über **Speichern** übernommen werden, bevor in einen anderen Reiter gewechselt oder die App gestartet wird. Ein einfacher Wechsel des Reiters übernimmt die vorgenommenen Änderungen nicht.

## Zugriff auf die Freigabe beschränken

Der Netzwerkzugriff auf Samba share ist über **Allowed Hosts** eingeschränkt.

Zugelassen sind ausschließlich die lokalen IPv4-Adressen der Netzwerkverbindungen des Windows-PCs, der die Backups übernimmt.

Da der PC sowohl über LAN als auch über WLAN mit dem lokalen Netzwerk verbunden werden kann, sind beide dafür vorgesehenen Adressen freigegeben.

Für die beteiligten Geräte werden in der Freebox feste DHCP-Zuweisungen verwendet. Dadurch bleiben die für die Zugriffsbeschränkung verwendeten lokalen Adressen konstant.

## Nützliche Links & Quellen

- [Home Assistant – Samba share](https://github.com/home-assistant/addons/tree/master/samba)

## 🔗 Verwendung & Verknüpfungen

- [Backups](../grundlagen/backups.md) – übergeordnete Backup-Strategie
- [Windows-Backup-Synchronisation](../externe-systeme/windows/backup-synchronisation.md) – automatisierter Abruf der bereitgestellten Backups
- [DHCP-Zuweisungen in der Freebox](../externe-systeme/freebox/dhcp-zuweisungen.md) – feste lokale Adressen für die Zugriffsbeschränkung

---

[⬅️ Zurück zur Übersicht](../README.md)
