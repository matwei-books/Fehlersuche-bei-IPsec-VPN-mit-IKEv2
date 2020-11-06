
# Fehlersuche bei IPsec-VPN mit IKEv2

Dieses Buch ist eine Erweiterung und Ergänzung einer Artikelreihe in der Zeitschrift [UpTimes](http://guug.de/uptimes/) und eines Workshops, den ich 2018 hielt.
Das Buch ist Work in progress, im Verzeichnis [source](source) sind die Quellen.

Half-managed IPsec-VPN ist wie ein Ochsenkarren mit Tieren aus verschiedenen Ställen und Treibern, die sich nicht kennen.
Der Vergleich hinkt, aber geht, sagte mein Vater oft.
IPsec-VPNs zwischen verschiedenen Organisationen werden häufig als half-managed VPN bezeichnet, nämlich wenn jede Organisation ihr eigenes Gateway und damit die eigene Seite des VPN administriert.
Oft haben beide Seiten Gateways von verschiedenen Herstellern, die mit unterschiedlicher Software laufen.
Die Administratoren wissen meist nur die Parameter die eingestellt werden sollen und stellen manchmal erst beim Einstellen fest, dass bestimmte Parameter nicht funktionieren.

Natürlich kann die Reise gut gehen, aber oft dauert es länger als gedacht, bis alles ineinander greift und zueinander passt.
Manchmal sind es nur einfache Verständigungsprobleme zwischen beiden Seiten, manchmal sind einige Einstellungen falsch konfiguriert, manchmal funktionieren bestimmte Dinge auch gar nicht auf einem VPN-Gateway.
In jedem Fall gilt es das Problem zu identifizieren und es dann zu lösen.

Dieses Buch soll ein Reisebegleiter sein und über die größten Klippen hinweg helfen.
Dazu vermittelt es die grundlegenden Zusammenhänge bei IPsec-VPN, zeigt mögliche Probleme auf und woran diese zu erkennen sind beziehungsweise, wie sie sich von ähnlichen Problemen unterscheiden lassen.
Es beschreibt Probleme, die einem funktionsfähigen IPsec-VPN entgegenstehen und Wege, die Probleme zu identifizieren, um sie zu lösen.

Dieses Werk ist lizensiert unter den Bedingungen der
[Creative Commons Namensnennung-Nicht kommerziell-Share Alike 4.0 International Public License][cc-by-nc-sa].

[![CC BY-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png

