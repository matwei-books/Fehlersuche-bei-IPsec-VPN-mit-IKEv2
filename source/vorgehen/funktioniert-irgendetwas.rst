
Funktioniert irgendetwas?
=========================

Diese Frage gibt mir Hinweise, was ich bei der Fehlersuche zunächst
ignorieren kann, und worauf ich mein Hauptaugenmerk richte. Dabei ist
dieses irgendetwas nicht zufällig aus dem Lostopf gezogen, sondern
zielgerichtet ausgewählt, um den Fehler möglichst schnell einzugrenzen.

Ein VPN ist, wie der Name schon sagt, ein Netzwerk und dass dieses
funktioniert kann ich implizit schließen, wenn mir eine Verbindung
angezeigt wird. Konkret frage ich als darum erstes:

-  Gibt es ISAKMP und IPsec Security Associations?

Ganz sicher kann ich sein, wenn mir nicht nur die Security Associations
(SA) angezeigt werden, sondern auch Traffic in beiden Richtungen.

Die Antwort darauf kann ich bei den meisten VPN-Gateways sehr einfach
bekommen und bei einer positiven Antwort erspare ich mir sehr viele
Untersuchungen. Außerdem sehe ich oft, ob Daten gesendet werden und kann
die Fehlersuche entsprechend ausrichten.

Sehe ich hingegen keine ISAKMP bzw. IPsec SA, muss ich mir Gedanken
machen, ob überhaupt Traffic ankommt, für den die SA konfiguriert
wurden. Hierzu ist es hilfreich, zu wissen, ob der Datenverkehr von
meiner Seite des Netzes ausgeht, oder von der Seite des Peers.

Im ersten Fall schaue ich nach, ob unverschlüsselter Traffic am VPN
Gateway ankommt, der an das Netz des Peers gerichtet ist, im zweiten
Fall, ob IKE-Traffic auf der externen Seite meines VPN-Gateways ankommt.
Das heißt, ich suche nach Datenverkehr, der den Aufbau eines VPN-Tunnels
auslöst. Gibt es diesen Datenverkehr nicht, muss ich nicht nach einem
Fehler in meinem VPN-Gateway zu suchen.

Diese Überlegungen gelten jedoch nur für On-Demand-VPN, die nur
aufgebaut werden, wenn Traffic dafür ankommt und nach einer gewissen
Zeit ohne Datenverkehr abgebaut werden. Bei ständig aufgebauten - zum
Beispiel route-based - VPN müssen die zugehörigen SA immer zu sehen
sein, auch wenn kein Traffic für den Tunnel da ist.

Sehe ich ankommenden unverschlüsselten Datenverkehr von innen oder
IKE-Daten von außen, muss ich untersuchen, warum der Tunnel nicht
aufgebaut wird.

Kommt der Traffic von meiner Seite, frage ich, ob mein VPN-Gateway
zumindest versucht, einen Tunnel aufzubauen und welche Antworten es vom
Peer bekommt.

Kommt der Traffic vom Peer, schaue ich mir die Parameter an, mit denen
sein VPN-Gateway versucht, den Tunnel aufzubauen und vergleiche sie mit
meiner Konfiguration.

Ich frage dabei immer detaillierter nach, bis ich zum Kern des Problems
komme. Dabei behebe ich entdeckte Fehler bis ich schließlich Daten mit
mindestens einer IPsec SA verschlüsselt übertragen kann. Erst dann kann
ich zur nächsten grundlegenden Frage übergehen.

