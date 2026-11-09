# DHCP-Zuweisungen in der Freebox

Diese Dokumentation beschreibt die Verwendung fester DHCP-Zuweisungen in der Freebox und deren Bedeutung für die Home-Assistant-Installation.

## Grundlegende Konfiguration

Im lokalen Netzwerk werden für alle Geräte feste DHCP-Zuweisungen verwendet.

Die IP-Adressen werden weiterhin automatisch per DHCP vergeben. Durch die in der Freebox hinterlegte Reservierung erhält ein bekanntes Gerät jedoch dauerhaft dieselbe lokale IP-Adresse.

Die Verwaltung der lokalen IPv4-Adressen erfolgt dadurch zentral in der Freebox. Auf den einzelnen Geräten müssen keine statischen IPv4-Adressen manuell konfiguriert werden.

## Home Assistant

Auch das Home-Assistant-System erhält seine lokale IPv4-Adresse über DHCP.

Durch die feste DHCP-Zuweisung in der Freebox bleibt diese Adresse konstant.

Die feste lokale IPv4-Adresse wird unter anderem für die Windows-Backup-Synchronisation verwendet. Der Windows-PC greift darüber auf die von **Samba share** bereitgestellte Backup-Freigabe zu.

## Windows-PC

Für den Windows-PC werden ebenfalls feste DHCP-Zuweisungen verwendet.

Da der PC sowohl über LAN als auch über WLAN mit dem lokalen Netzwerk verbunden werden kann, werden beide Netzwerkverbindungen separat berücksichtigt.

Die dadurch konstanten lokalen IPv4-Adressen werden für die Zugriffsbeschränkung von **Samba share** verwendet.

Konkrete lokale IP-Adressen werden nicht im Repository dokumentiert, da sie ausschließlich für die jeweilige lokale Netzwerkkonfiguration relevant sind.

## 🔗 Verwendung & Verknüpfungen

- [Samba share](../../apps/samba-share.md) – verwendet die festen lokalen Adressen des Windows-PCs für die Zugriffsbeschränkung
- [Windows-Backup-Synchronisation](../windows/backup-synchronisation.md) – verwendet die feste lokale Adresse von Home Assistant für den Zugriff auf die Backup-Freigabe
- [Zendure](../../apps/zendure.md) – die feste lokale Adresse von Home Assistant für den Zugriff über MQTT

---

[⬅️ Zurück zur Übersicht](../../README.md)
