
Betriebsarten
=============

Es gibt zwei Arten von SA: Transport Mode SA und Tunnel Mode SA.
Zwischen zwei IPsec-Peers können beide Arten gleichzeitig vorkommen.
Da eine SA ihre Sicherheitsdienste aber immer nur für eine
Simplex-Verbindung, das heißt in einer Richtung, zur Verfügung stellt,
sollten die beiden SA, die zusammen eine vollständige Duplex-Verbindung
absichern, von der gleichen Art sein.

Üblicherweise werden die SA sowieso paarweise konfiguriert.
Es ist jedoch gut, im Hinterkopf zu behalten, dass immer zwei SA mit dem
gleichen Peer, Betriebsmodus und Traffic-Selektor existieren sollten.

Transportmodus
--------------

Im Transportmodus wird einfach nur der AH- beziehungsweise ESP-Header
zwischen den IP-Header und die IP-Nutzdaten geschoben sowie ein Trailer
für die Prüfsumme angehängt.
Damit ist der Overhead für IPsec hier geringer als beim Tunnelmodus und
es bleibt mehr Platz im Datagramm für die Nutzdaten.

Der Transportmodus eignet sich gut für die Absicherung des Traffics
zwischen zwei Hosts, weil es nur die außen sichtbaren
IP-Adressen gibt und diese zwingend zu den beiden IPsec-Peers gehören
müssen, damit der Traffic auch bei ihnen ankommt.

Zwischen zwei Security-Gateways, die IPsec-Dienste für ganze Netze
anbieten, kann ich SA im Transportmodus verwenden, wenn

* der direkte Traffic zwischen den Security-Gateways abgesichert werden
  soll,
* oder der abgesicherte Traffic selbst wiederum in IP getunnelten
  Traffic enthält, wie zum Beispiel IP-in-IP :cite:`RFC2003`,
  GRE :cite:`RFC2784` oder IPsec Transport Mode for dynamic Routing
  :cite:`RFC3884`.

Ein Nachteil von SA im Transportmodus mit getunneltem Traffic ist,
dass IPsec keine Zugriffskontrolle wie beim Tunnelmodus über die
Traffic-Selektoren ausüben kann.

Demgegenüber vereinfacht der Transportmodus mit getunneltem Traffic das
Monitoring der IPsec SA, weil der Monitoring Traffic zwingend über
dieselben zwei SA geht, wie der sonstige Traffic aller darüber
verbundenen Netze.

Tunnelmodus
-----------

Im Tunnelmodus wird das komplette Datagramm in einem IPsec-Datagramm
gekapselt, das innere Datagramm hat meist andere Adressen im IP-Header
als das äußere.

Diese Betriebsart eignet sich für LAN-zu-LAN-Kopplungen zwischen verschiedenen
Netzen oder für die Verbindung eines einzelnen Rechners zu einem oder
mehreren Netzwerken.

Insbesondere beim Koppeln mehrerer Netze pro Seite eines IPsec-VPN
brauche ich bei SA im Tunnelmodus mehrere Policies um die beteiligten
Netze mit Traffic-Selektoren abzubilden, was zu mehreren Paaren von SA
pro IPsec-Peer im Betrieb führt.

Das hat den Vorteil, dass IPsec den erlaubten Traffic mit den Policies
beschränken und dadurch nachfolgende Firewalls entlasten kann.

Bei der Fehlersuche habe ich hingegen bei einigen Implementationen
das Problem, die richtigen SA zu identifizieren.
Vor allem, wenn einige SA offensichtlich funktionieren, andere jedoch
nicht.

Der Monitoring-Traffic verwendet hier manchmal andere SA,
als der produktive Traffic.
Das kann dazu führen, dass das Monitoring ein Verbindungsproblem nicht
erkennt, das den produktiven Traffic stört, oder andersrum
einen Fehler meldet, der den Produktivbetrieb nicht stört.

Welche der beiden Betriebsarten für eine konkrete Situation geeigneter
ist, hängt von weiteren Faktoren ab, so dass ich keine allgemeingültige
Empfehlung geben kann.

