
OSI Modell
==========

Vielleicht fühlt sich der eine oder die andere gelangweilt durch
so banale Dinge wie das OSI Modell für Netzwerke.
Fakt ist, dass ich erlebt habe, wie sich eine Fehlersuche über
mehrere Tage hinzog und es etwa zwanzig Stunden dauerte, bis überhaupt
jemand daran ging, das zugrundeliegende Netzwerkproblem zwischen den
beiden beteiligten VPN-Gateways anzugehen.
Das passierte weil ein grundlegender Zusammenhang, der sich aus dem
OSI-Modell ergibt, nicht beachtet wurde.
Doch der Reihe nach.

Wir betreuten neben vielen anderen auch das VPN zwischen zwei großen
IT-Dienstleistern, genaugenommen das VPN-Gateway eines der beiden
IT-Dienstleister, rund um die Uhr. An einem Freitagmorgen gegen 03:00 Uhr
fielen alle Verbindungen über dieses VPN aus. Natürlich waren auch wir
in die Fehlersuche involviert und ab 06:00 Uhr war der erste unserer
Kollegen über die gesamte Schicht mit diesem VPN beschäftigt. Da keine IKE-SA
zustande kamen und er auch keinen Traffic vom Peer sah, tippte dieser
Kollege schon zeitig auf Verbindungsprobleme. Dennoch passierte nichts
bezüglich dieser Verbindungsprobleme während seiner Schicht. Der Kollege
der nächsten Schicht ließ sich gar überreden, die Konfiguration von IKEv2
auf IKEv1 umzustellen "weil dieses ja bis vor ein paar Wochen
funktioniert hatte". Natürlich half das genausowenig, weil das
eigentliche Problem, die IP-Verbindung zwischen den VPN-Gateways (OSI
Ebene 3) nicht angegangen wurde. Erst dem Kollegen der dritten Schicht gelang es,
glaubhaft darzulegen, dass kein VPN funktionieren kann, solange keine
IP-Verbindung besteht und darum als erstes dieses Problem - und zwar
nicht von den VPN-Administratoren - zu lösen war. Am Ende musste jemand
noch das VPN auf IKEv2 zurückstellen. Doppelte Arbeit, die nicht den
kleinsten Nutzen brachte.

Das Erkennen des Problems wurde erschwert, weil beide VPN-Gateways
funktionierenden Kontakt zu etlichen anderen VPN-Peers hatten, während
das Problem bestand. Beide waren via PING und Traceroute von Dritten zu
erreichen, bekamen aber keinen Kontakt zueinander.

Beide Firmen verfügten über mehrere Internet-Peerings, unter anderem zu
demselben ISP. Natürlich lief die VPN-Verbindung über genau diesen ISP.
Und genau dort gingen die Datagramme verloren. Traceroute zeigte zwar
von beiden Seiten aus Router dieses ISP als letzten Hop an, aber leider
nicht die gleichen.

Weiterhin erschwerten die Systemlogs das Erkennen des
zugrundeliegenden Problems, weil beide VPN-Gateways Traffic für jeweils
den anderen Peer aus ihren Netzwerken bekamen und darum versuchten, die
VPN-Verbindung aufzubauen. Dadurch tauchte die Peer-IP-Adresse in den
Logs auf, was einige der weniger erfahrenen Administratoren dazu
brachte, plötzlich doch "Traffic vom Peer" zu sehen. Im Paketmitschnitt
war kein Traffic vom Peer zu sehen, sondern nur ausgehender Traffic.

.. index:: ! Open Systems Interconnections Modell
   see: OSI-Modell; Open Systems Interconnections Modell
.. _OSI-Modell:

An dieser Stelle unterbreche ich die Geschichte dieser Fehlersuche und
steige ein in das OSI-Modell, das *Open Systems Interconnections* Modell,
das nicht mehr ist, als ein Modell. Es gibt kein real existierendes
Protokoll und keine Software welche dieses Modell abbilden. Von daher
scheint das OSI-Modell auf den ersten Blick keinen direkten praktischen
Wert zu besitzen.

Trotzdem gehe ich in jedem meiner Bücher mit Netzwerkthemen darauf ein,
weil die Bedeutung des OSI-Modells darin liegt, ein grundlegendes
Verständnis für das Zusammenspiel der real existierenden Protokolle zu
entwickeln und im besten Fall eigene Schlussfolgerungen, die sich daraus
ergeben, ableiten zu können.

Das Modell selbst ist schnell erklärt.
Es besagt, dass die verschiedenen Funktionen, die für den Datenaustausch
zweier Systeme über ein Computernetzwerk nötig sind, auf sieben
übereinanderliegende Schichten verteilt werden können, von denen die
oberen Schichten auf die Dienste der unteren Schichten zurückgreifen, um
selbst wiederum Dienste für die darüber liegenden Schichten anzubieten.

Die sieben Schichten des OSI-Modells sind:

 ======= ====================== =====================
 Schicht deutsche Bezeichnung   englische Bezeichnung
 ======= ====================== =====================
    7    Anwendungsschicht      application layer
    6    Darstellungsschicht    presentation layer
    5    Sitzungsschicht        session layer
    4    Transportschicht       transport layer
    3    Vermittlungsschicht    network layer
    2    Sicherungsschicht      link layer
    1    Bitübertragungsschicht physical layer
 ======= ====================== =====================

Das ist schön und gut und lässt sich vielleicht noch auswendig lernen.
Um wirklich nützlich zu sein, brauche ich noch den Bezug zu real
existierenden Protokollen, mit denen ich in meiner täglichen Arbeit zu
tun habe.

Da finde ich

* Ethernet in den Schichten 1 und 2
* IPv4, IPv6 in der Schicht 3
* TCP, UDP in der Schicht 4
* DNS, HTTP, SMTP, LDAP in den Schichten 5, 6, und 7

Ein weiterer wichtiger Punkt ist die Austauschbarkeit der Protokolle der
niedrigen Schichten, wenn Sie die Aufgaben für höhere Dienste
vergleichbar gut erfüllen. So kann ich IP statt über Ethernet auch über
Glasfaser, V24 oder andere Protokolle übertragen. TCP und UDP laufen
genauso gut über IPv4 wie über IPv6 und DNS kann ich über UDP und TCP
nutzen.

Und IPsec, das Buch ist doch über IPsec, oder?
Das stimmt, IPsec habe ich hier noch nicht erwähnt, weil es eine
besondere Rolle einnimmt, wie alle Tunnelprotokolle.

IPsec bietet nach oben Dienste der Schicht 3 an, wie IPv4 und IPv6.
Es nutzt dazu jedoch Dienste der Schichten 3 (IPv4 oder IPv6 für AH und ESP)
und 4 (UDP für IKE und NAT-T).
Damit wird klar, dass IPsec selbst zwar einer speziellen Betrachtung
bedarf, sich bezüglich der Interaktion mit anderen Protokollen jedoch
nahtlos in das OSI-Modell einfügt und nach oben die gleichen Dienste
anbietet wie IP und nach unten auf die Dienste von IP und UDP angewiesen
ist.

Kommen wir nun auf das eingangs erwähnte Problem zwischen den beiden
VPN-Peers zurück, so sollte klar sein, dass das VPN nicht funktionieren
und auch nicht bezüglich seiner Funktion überprüft werden konnte,
solange keine IP-Verbindung zwischen den Peers bestand.

Und den Nachweis, dass da keine IP-Verbindung bestand, konnten wir nicht
anhand der Logs führen, sondern nur mit einem Paketmitschnitt, welcher
uns auf beiden Seiten nur abgehende aber keine ankommenden Datagramme
zeigte.
Womit ich auch schon beim nächsten Grundlagenthema, dem Paketmitschnitt
angekommen bin.

