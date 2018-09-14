
Betriebsarten
=============

Transportmodus
--------------

Im Transportmodus wird einfach nur der AH- beziehungsweise ESP-Header
zwischen den IP-Header und die IP-Nutzdaten geschoben sowie ein Trailer
für die Prüfsumme angehängt.

Diese Betriebsart ist vorzugsweise für die direkte durch IPsec gesicherte
Kommunikation zwischen zwei Rechnern geeignet.

Tunnelmodus
-----------

Im Tunnelmodus wird das komplette Datagramm in einem IPsec-Datagramm
gekapselt, das innere Datagramm hat meist andere Adressen im IP-Header
als das äußere.

Diese Betriebsart wird für LAN-zu-LAN-Kopplungen zwischen verschiedenen
Netzen oder für die Verbindung eines einzelnen Rechners zu einem oder
mehreren Netzwerken verwendet.
