
Fehlerursachen
==============

Falsche Crypto-Parameter
------------------------

Keine Verbindung
----------------

Eine recht häufiger Fehlerist, dass überhaupt keine
Netzverbindung besteht.
Das kann mehrere Ursachen haben.
Entweder ist die Leitung an irgendeiner Stelle unterbrochen, weil jemand
das Kabel unterbrochen hat, weil ein Gateway ausgefallen ist oder eine
Firewall den Datenverkehr unterbindet.
Auch bei Routingproblemen kommen die Datagramme nicht dort an, wo sie
hin sollen.

Ich erkenne eine unterbrochene Verbindung am sichersten mit einem
Paketmitschnitt.
In diesem kann ich nur Datagramme sehen, die von meiner Seite gesendet
werden aber keine Datagramme von der Seite hinter der Unterbrechung.
Zum Eingrenzen kann ich Ping und Traceroute verwenden, wenn ICMP in dem
betreffenden Netz uneingeschränkt für Diagnosezwecke funktioniert.

Fehlerhaftes Routing lässt sich manchmal mit Traceroute eingrenzen.

Allen diesen Ursachen gemeinsam ist, dass sie aus Sicht des
VPN-Administrators in die Kategorie externe Probleme fallen, ich kann
deren Lösung also oft delegieren.
Ich muss bei der Beauftragung lediglich angeben, welche
Datenverbindungen ich haben möchte.

Bei einer Unterbrechung zwischen den beiden VPN-Gateways ist das
einfach: ich will UDP Port 500 und Port 4500, ESP und vielleicht AH,
falls ich das überhaupt verwende.
Außerdem ICMP auf der ganzen Strecke zwischen den VPN-Gateways für
Path-MTU-Discovery, Traceroute und Ping.

Bei einer Unterbrechung zwischen meinem VPN-Gateway und den Endpunkten
auf meiner Seite möchte ich Ähnliches im Netz meiner Organisation.
Lediglich UDP Port 500, 4500 und ESP, AH brauche ich nicht.
Da die Endpunkte auf meiner Seite nicht mit dem VPN-Gateway
kommunizieren möchten, sondern mit den Endpunkten auf Peer-Seite muss
das Routing dorthin über das VPN-Gateway führen.

NAT
---

Path-MTU
--------

Inkompatibilität
----------------

