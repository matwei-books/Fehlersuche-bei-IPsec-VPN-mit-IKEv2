
.. index::
   single: Child-SA; Modus

Betriebsarten
=============

Es gibt zwei Arten von Child-SA: Transport Mode SA und Tunnel Mode SA.
Zwischen zwei IPsec-Peers können beide Arten gleichzeitig vorkommen.
Da eine SA ihre Dienste aber immer nur für eine Simplex-Verbindung,
das heißt in einer Richtung, zur Verfügung stellt,
sollten die beiden SA, die zusammen eine vollständige Duplex-Verbindung
absichern, von der gleichen Art sein.

Üblicherweise werden die SA sowieso paarweise konfiguriert.
Es ist jedoch gut, im Hinterkopf zu behalten, dass immer zwei SA mit dem
gleichen Peer, Betriebsmodus und Traffic-Selektor existieren sollten.

.. index:: ! Transportmodus

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

.. index:: GRE

* oder der abgesicherte Traffic selbst wiederum in IP getunnelten
  Traffic enthält, wie zum Beispiel IP-in-IP :cite:`RFC2003`,
  GRE :cite:`RFC2784` oder IPsec Transport Mode for dynamic Routing
  :cite:`RFC3884`.

Der Transportmodus mit getunneltem Traffic vereinfacht
das Monitoring der IPsec SA,
weil der Monitoring Traffic zwingend über dieselben zwei SA geht,
wie der sonstige Traffic aller darüber verbundenen Netze.
Damit ist das Monitoring von einem Ausfall dieser SA
genauso betroffen wie der produktive Traffic.

Ein Nachteil von SA im Transportmodus mit getunneltem Traffic ist,
dass IPsec keine Zugriffskontrolle wie beim Tunnelmodus über die
Traffic-Selektoren ausüben kann.

.. index:: NAT

Weiterhin kann ich den Transportmodus nicht verwenden,
wenn der ungeschützte Traffic über eine NAT-Box läuft
und seine Adressen manipuliert werden.

Schließlich gibt es noch ein Problem beim Transport-Modus,
dass eigentlich durch die Firewall abgefangen werden sollte.
Solange noch keine IPsec-SA für den Traffic ausgehandelt ist,
kann dieser ungeschützt im schwarzen Netz gesendet werden,
wenn der Paketfilter ungeschützten Traffic
an diesem Interface nicht explizit sperrt.
Leider ist das nicht nur eine theoretische Möglichkeit.
Ich habe derartigen Traffic bei bestimmten Geräten bereits gesehen
als die IPsec-SA deaktiviert war.

.. index:: ! Tunnelmodus

Tunnelmodus
-----------

Im Tunnelmodus wird das komplette Datagramm in einem IPsec-Datagramm
gekapselt, das innere Datagramm hat meist andere Adressen im IP-Header
als das äußere.

.. index:: L2L

Diese Betriebsart eignet sich für L2L-Kopplungen zwischen verschiedenen
Netzen oder für die Verbindung eines einzelnen Rechners zu einem oder
mehreren Netzwerken.

Insbesondere beim Koppeln mehrerer Netze pro Seite eines IPsec-VPN
brauche ich bei SA im Tunnelmodus mehrere Policies um die beteiligten
Netze mit Traffic-Selektoren abzubilden, was zu mehreren Paaren von SA
pro IPsec-Peer im Betrieb führt.

Das hat den Vorteil, dass IPsec den erlaubten Traffic mit den Policies
beschränken und dadurch nachfolgende Firewalls entlasten kann.

.. raw:: latex

   \clearpage

Um den Traffic von mehreren nicht überlappenden Netzwerken
auf einer oder beiden Seiten durch IPsec zu schützen,
werden meist mehrere Child-SA,
jeweils eine für jedes der Netze,
ausgehandelt.

Das bringt bei einigen Implementationen das Problem,
die richtigen Child-SA bei der Fehlersuche zu identifizieren.
Vor allem, wenn einige von diesen offensichtlich funktionieren,
andere jedoch nicht.

Der Monitoring-Traffic verwendet in diesem Fall mitunter andere SA,
als der produktive Traffic.
Das kann dazu führen, dass das Monitoring ein Verbindungsproblem nicht
erkennt, das den produktiven Traffic stört, oder andersherum
einen Fehler meldet, der den Produktivbetrieb nicht stört.

Prinzipiell erlaubt IPsec verschiedene Netze in den Traffic-Selektoren
der SPD und somit für die Child-SA.
Ob und wie das umgesetzt ist,
hängt jedoch von der jeweiligen Implementation ab.

