
Theoretische Grundlagen
=======================

OSI Modell
----------

Es mag sein, dass der eine oder die andere sich gelangweilt fühlt durch
so banale Dinge wie das OSI Modell für Netzwerke.

Fakt ist, dass ich einmal erlebt habe, wie sich eine Fehlersuche über
mehrere Tage hinzog und es etwa zwanzig Stunden dauerte, bis überhaupt
jemand daran ging das Netzwerkproblem zwischen den beiden VPN-Gateways
anzugehen. Doch der Reihe nach.

Wir betreuten neben vielen anderen auch das VPN zwischen zwei großen
IT-Dienstleistern, genaugenommen das VPN-Gateways eines der beiden
IT-Dienstleister rund um die Uhr. An einem Freitagmorgen gegen 03:00 Uhr
fielen alle Verbindungen über dieses VPN aus. Natürlich wurden auch wir
in die Fehlersuche involviert und ab 05:00 Uhr war der erste unserer
Kollegen rund um die Uhr damit beschäftigt. Da keine IKE-SA
zustandekamen und er auch keinen Traffic vom Peer sah, tippte dieser
Kollege schon zeitig auf Verbindungsprobleme. Dennoch passierte so gut
wie nichts während der acht Stunden seiner Schicht bezüglich dieses Problems. Der Kollege
der nächsten Schicht ließ sich überreden, die Konfiguration von IKEv2
auf IKEv1 umzustellen "weil dieses ja bis vor ein paar Wochen
funktioniert hatte". Natürlich half das genausowenig, weil das
eigentliche Problem, die IP-Verbindung zwischen den VPN-Gateways (OSI
Ebene 3) nicht angegangen wurde. Erst dem dritten Kollegen gelang es,
glaubhaft darzulegen, dass da kein VPN funktionieren kann, solange keine
IP-Verbindung besteht und daher als erstes dieses Problem - und zwar
nicht von den VPN-Administratoren - zu lösen war. Am Ende musste das VPN
noch auf IKEv2 zurückgestellt werden, doppelte Arbeit, die nicht den
kleinsten Nutzen brachte.

Was das Erkennen des Problems erschwerte, war dass beide VPN-Gateways
funktionierenden Kontakt zu etlichen anderen VPN-Peers hatten, während
das Problem bestand. Beide waren via PING und Traceroute von Dritten zu
erreichen, bekamen aber keinen Kontakt zueinander.
Beide Peers verfügten über mehrere Internet-Peerings, unter anderem zu
demselben ISP. Natürlich lief die VPN-Verbindung über
genau diesen ISP, mit dem sie beide einen Vertrag hatten. Und genau bei
diesem ISP gingen die Datagramme verloren, Traceroute zeigte zwar auf
beiden Seiten Router dieses ISP als letzten Hop an, aber leider nicht
die gleichen. Weiterhin erschwerten die Systemlogs das Erkennen des
zugrundeliegenden Problems, weil beide VPN-Gateways Traffic für jeweils
den anderen Peer aus ihren Netzwerken bekamen und darum versuchten, die
VPN-Verbindung aufzubauen. Dadurch tauchte die Peer-IP-Adresse in den
Logs auf, dass einige der weniger erfahrenen Administratoren dazu
brachte, plötzlich doch "Traffic vom Peer" zu sehen. Im Packet-Capture
war kein Traffic vom Peer zu sehen, sondern nur ausgehender Traffic.
