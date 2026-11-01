# Samba share

Diese Dokumentation beschreibt die Konfiguration der offiziellen Home-Assistant-App **Samba share**.

Die App stellt ausschließlich das Backup-Verzeichnis von Home Assistant im lokalen Netzwerk bereit. Dadurch kann der Windows-PC die von Home Assistant erstellten Backups abrufen.

## Verwendung

Samba share wird in dieser Installation ausschließlich für die zusätzliche Sicherung der Home-Assistant-Backups verwendet.

Freigegeben wird nur `backup`.

Andere Home-Assistant-Verzeichnisse werden nicht über Samba bereitgestellt.

Der Windows-PC greift direkt über die lokale IPv4-Adresse von Home Assistant auf die Freigabe `\\<HOME-ASSISTANT-IP>\backup` zu.

Eine dauerhaft eingebundene Netzwerkfreigabe beziehungsweise ein Netzlaufwerk wird dafür nicht benötigt.

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

Für Samba share wird ein eigenes Benutzerkonto verwendet.

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

## Windows-Anmeldeinformationen

Die Zugangsdaten für Samba share werden im **Windows-Anmeldeinformationsmanager** gespeichert.

Als Netzwerkadresse wird die lokale IPv4-Adresse von Home Assistant verwendet.

Der dazugehörige Samba-Benutzername sowie das zugehörige Samba-Passwort werden ebenfalls im Windows-Anmeldeinformationsmanager gespeichert.

Dadurch kann Windows auf die Samba-Freigabe zugreifen, ohne dass Benutzername oder Passwort im PowerShell-Skript hinterlegt werden müssen.

## Zugriff über die IP-Adresse

Für die automatisierte Sicherung wird bewusst die lokale IPv4-Adresse von Home Assistant verwendet.

Der Zugriff über den Hostnamen `\\homeassistant` funktionierte in der verwendeten Netzwerkkonfiguration nicht zuverlässig beziehungsweise nicht wie erwartet.

Die konkrete Ursache wurde nicht weiter untersucht, da der Zugriff über die feste lokale IPv4-Adresse zuverlässig funktioniert und die Adresse über eine feste DHCP-Zuweisung in der Freebox konstant gehalten wird.

## Nützliche Links & Quellen

- [Home Assistant – Samba share](https://github.com/home-assistant/addons/tree/master/samba)

## 🔗 Verwendung & Verknüpfungen

- [Backups](../grundlagen/backups.md) – übergeordnete Backup-Strategie
- [Windows-Backup-Synchronisation](../externe-systeme/windows/backup-synchronisation.md) – automatisierter Abruf der bereitgestellten Backups
- [DHCP-Zuweisungen in der Freebox](../externe-systeme/freebox/dhcp-zuweisungen.md) – feste lokale Adressen für die Zugriffsbeschränkung

---

[⬅️ Zurück zur Übersicht](../README.md)
