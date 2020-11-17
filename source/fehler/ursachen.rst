
.. raw:: latex
   
   \newpage

Fehlerursachen
==============

Keine Verbindung
----------------

Eine recht häufiger Fehler ist,
dass überhaupt keine Netzwerkverbindung zwischen den VPN-Gateways besteht.
Das kann mehrere Ursachen haben.
Vielleicht ist die Leitung an einer Stelle unterbrochen,
weil jemand das Kabel getrennt hat,
weil ein Gateway ausgefallen ist
oder eine Firewall den Datenverkehr unterbindet.
Auch bei Routingproblemen kommen die Datagramme nicht dort an, wo sie
hin sollen.

Ich erkenne eine unterbrochene Verbindung am sichersten mit einem
Paketmitschnitt.
In diesem sehe ich nur Datagramme,
die von meiner Seite gesendet werden,
aber keine Datagramme von der Seite hinter der Unterbrechung.
Zum Eingrenzen kann ich Ping und Traceroute verwenden,
wenn ICMP in dem betroffenen Netz uneingeschränkt funktioniert.

Fehlerhaftes Routing lässt sich manchmal ebenfalls mit Traceroute eingrenzen.

Alle diese Ursachen haben gemeinsam, dass sie aus Sicht des
VPN-Administrators in die Kategorie externe Probleme fallen,
ich kann deren Lösung delegieren.
Bei der Beauftragung gebe ich an,
welche Datenverbindungen ich haben möchte
und natürlich alles,
was ich über das Problem herausgefunden habe,
um die Behebung zu beschleunigen.

.. index:: AH, ESP, ICMP

Bei einer Unterbrechung zwischen den beiden VPN-Gateways ist das
einfach: ich will UDP Port 500 und Port 4500, ESP und vielleicht AH,
falls ich das überhaupt verwende.
Außerdem ICMP auf der ganzen Strecke zwischen den VPN-Gateways für
Path-MTU-Discovery, Traceroute und Ping.

Bei einer Unterbrechung zwischen meinem VPN-Gateway und den Endpunkten
auf meiner Seite möchte ich Ähnliches im Netz meiner Organisation.
Lediglich UDP Port 500, 4500 und ESP beziehungsweise AH brauche ich nicht.
Da die Endpunkte auf meiner Seite
nicht nur mit dem VPN-Gateway kommunizieren möchten
sondern vor allem mit den Endpunkten auf Peer-Seite,
muss das Routing dorthin über das VPN-Gateway führen.

Falsche Crypto-Parameter
------------------------

Eine andere häufige Fehlerursache bei nicht funktionierenden VPN sind
verschiedene Crypto-Parameter auf den beiden VPN-Gateways.
Da diese meist im Vorfeld vereinbart werden, kann man durchaus von
falschen Parametern auf mindestens einer Seite sprechen.
Wurden die Parameter nicht im Vorfeld vereinbart, spricht man besser
von unterschiedlichen Parametern.

Diese Fehler fallen in die Kategorie Fehlkonfiguration, das heißt für
die Behebung sind die VPN-Administratoren zuständig.
Können sie das nicht, zum Beispiel weil ein VPN-Gateway bestimmte
Parameter nicht unterstützt,
müssen sie eskalieren und sich Hilfe holen
oder andere Parameter aushandeln wenn bestimmte Parameter
nicht an ihrem Gateway einstellbar sind.

Falsche Crypto-Parameter können verschiedene Ausprägungen haben, zum
Beispiel:

* falsche IKE-Version

* falsche Parameter für IKE

* falsche Parameter für Child-SA

* fehlendes PFS auf einer Seite

Falsche IKE-Version
...................

.. index:: INVALID_MAJOR_VERSION
   single: Fehlermeldung; INVALID_MAJOR_VERSION

Ich halte IKEv2 für die bessere Version, die generell für neue VPN
verwendet werden sollte.
Dennoch kann es Umstände geben, bei denen aus Gründen ein veraltetes
VPN-Gateway weiter betrieben werden muss und trotzdem ein neues VPN
dorthin eingerichtet werden soll.

Dann muss man das im Vorfeld klären.
Trotzdem habe ich erlebt, dass ein Netzwerkplaner, der für das
Aushandeln der Crypto-Parameter im Vorfeld zuständig war, mehrfach beim
Peer nachfragte, ob dessen VPN-Gateway IKEv2 und die ausgehandelten
Parameter unterstützte und jedesmal eine positive Antwort bekam.
Erst als ich bei der Inbetriebnahme darauf hinwies, dass das
Peer-Gateway nur IKEv1 sendete und unsere Anfragen mit IKEv2 nicht oder
mit INVALID_MAJOR_VERSION beantwortete, stellte der Peer fest, dass sein
VPN-Gateway kein IKEv2 kann.
Damit verzögerte sich die Inbetriebnahme, bis der Peer ein adäquates
VPN-Gateway besorgt und dessen Konfiguration gelernt hatte.

**Wie stelle ich eine falsche IKE-Version fest?**
In manchen Fällen kann ich das Problem aus den Systemprotokollen
erkennen.
Der ultimative Nachweis ist ein Paketmitschnitt auf der Outside.
Im IKE-Header kann ich die Version erkennen.
Manchmal bekomme ich auch eine INFORMATIONAL-Nachricht, die die
unterstützte Version angibt.

Habe ich keine Möglichkeit für einen Paketmitschnitt, hilft es, den
Debuglevel zu erhöhen.
Dann bekomme ich den Inhalt der ausgetauschten Datagramme oft gut erklärt,
muss die relevanten Stellen dafür aber in großen Mengen Text suchen.

Falsche Parameter für IKE
.........................

Eine weitere Möglichkeit Crypto-Parameter falsch zu konfigurieren sind
die Parameter für die IKE-SA.
Auch diese kann ich recht einfach verifizieren.

Ich schaue nach den IKE-Crypto-Parametern wenn ich weiß, dass
grundsätzlich IKEv2-Datagramme in beiden Richtungen ausgetauscht werden,
aber dennoch keine IKE-SA zustande kommt.

Die Logs helfen mir bei diesem Problem,
je nach Software und Version des VPN-Gateways sowie meiner Erfahrung damit,
mal mehr und mal weniger.
Aussagekräftiger sind die Debugausgaben.

Zumindest grobe Fehler bei den konfigurierten Crypto-Parametern kann ich
in einem Paketmitschnitt am IKE_SA_INIT-Exchange erkennen, weil hier
sowohl alle in den Proposals vorgeschlagenen Kombinationen als auch die
vom Responder angenommene Kombination oder eben eine Fehlermeldung
unverschlüsselt vorliegen.
Sehe ich im Mitschnitt noch einen kompletten IKE_AUTH-Exchange, so kann
ich davon ausgehen, dass beide Peers die selben Crypto-Algorithmen für
IKE verwenden.

.. index:: IKE_AUTH

Scheitert IKE_AUTH, könnten Probleme mit dem PSK die Ursache sein
oder generell Probleme mit der gewählten Authentisierungsmethode.
Da mit dem IKE_AUTH-Exchange auch die erste Child-SA verhandelt wird,
kann das Problem auch an den Parametern für diese liegen.

Leider kann ich Probleme bei IKE_AUTH in den meisten Fällen nicht
mit einem Paketmitschnitt diagnostizieren,
da hier schon
die bei IKE_SA_INIT ausgehandelte Verschlüsselung zur Anwendung kommt.
Lediglich von der Cisco ASA ist mir bekannt, dass sie Paketmitschnitte
(*type isakmp*) schreiben kann, die die entschlüsselten IKE-Datagramme
enthalten.

.. index::
   single: Child-SA; falsche Parameter

Falsche Parameter für Child-SA
..............................

Bei falschen Parametern für Child-SA kann es sich um die
Crypto-Algorithmen handeln oder um die Traffic-Selektoren.
Diese Probleme sind am einfachsten beim Responder zu klären, da ich hier
die Parameter, die der Initiator gesendet hat, direkt mit den
konfigurierten vergleichen kann.

In den meisten Fällen werde ich auf Debug-Meldungen zurückgreifen
müssen, da die Logs dazu oft nicht eindeutig sind und ein
Paketmitschnitt nur bei wenigen VPN-Gateways die entschlüsselten
IKE-Datagramme enthält.

Eine spezielle Variante der falschen Parameter für Child-SA
ist eine unterschiedliche Interpretation der Traffic-Selektoren.
Prinzipiell erlaubt RFC44301 in Abschnitt 4.4.1.1
sowohl für die Remote IP Address als auch für die Local IP Adress
eine Liste von Adressbereichen.
Damit lassen sich einzelne Adressen, eine Liste von Adressen,
einzelne Adressbereiche sowie mehrere Adressbereiche
für beide Seiten in einer SA aushandeln.

Ein weiteres Problem mit falschen Parametern ist,
dass eine Seite Traffic mit einer SA sendet,
deren Traffic-Selektoren beim Empfänger nicht dazu passen.
Auf der Gegenseite werden die Datagramme dann verworfen.
Zumindest finden sich in diesem Fall auf der ankommenden Seite
eindeutige Hinweise in den Logs.
Die Abhilfe ist unterschiedlich, je nach Software.

.. index::
   single: PFS; fehlendes
   single: Child-SA; Rekeying

Fehlendes PFS auf einer Seite
.............................

Wenn PFS nur auf einer Seite konfiguriert ist und auf der anderen nicht,
funktioniert das VPN mitunter zunächst
und das Problem wird erst beim Rekeying offenbar.

Bei der im Rahmen von IKE_AUTH ausgehandelten Child-SA wird das
Schlüsselmaterial von IKE_SA_INIT verwendet, so dass hier eine
funktionsfähige Child-SA erzeugt werden kann.
Das Rekeying scheitert dann,
weil eine Seite den neuen Schlüssel aus dem verwendeten ableiten,
die andere Seite jedoch den neuen Schlüssel aushandeln will.

.. raw:: latex

   \clearpage

NAT
---

Eine weitere Fehlerursache, mit der ich gerade bei IPv4 sehr häufig
rechnen muss, ist Netzwerkadressumsetzung (NAT).

Immer wenn NAT ins Spiel kommt, habe ich latent ein
Verständigungsproblem, weil für dieselben Datenströme an verschiedenen
Stellen des Netzes unterschiedliche Adressen verwendet werden.
Schon allein diese Tatsache erschwert die Fehlersuche.

Generell unterscheide ich zwei Formen von NAT am VPN:

* *Externes NAT* meint in diesem Zusammenhang, dass die Adressen der
  Datagramme zwischen den VPN-Gateways verändert werden.

* *Internes NAT* meint die Modifizierung der Adressen der Datagramme,
  die durch das VPN gesendet werden.

Externes NAT
............

Bei IKEv1 stellte NAT zwischen den VPN-Gateways noch ein Problem dar,
dass erst nachträglich durch die Einführung von NAT-T
mit der Kapselung der IPsec-Datagramme in UDP gelöst wurde.

Bei IKEv2 sind entsprechende Mechanismen bereits im
IKE_SA_INIT-Austausch eingebaut, so dass die Peers erkennen können,
ob die Adressen ihrer Datagramme manipuliert werden und automatisch auf
UDP-Encapsulation umschalten.
Damit sollte es also keine größeren Probleme geben.
Ich muss lediglich dafür sorgen, dass sowohl UDP Port 500 als auch UDP
Port 4500 in der Firewall freigegeben sind.

Schwierig könnte es werden, wenn beide VPN-Gateways hinter NAT-Boxen
platziert sind.

NAT macht die Diagnose mit Paketmitschnitt etwas komplizierter,
weil sowohl IKE als auch ESP und AH das Protokoll UDP mit Port 4500 verwenden.
Um die VPN-Protokolle auseinander zu halten,
brauche ich einen speziellen Filter beim Paketmitschnitt.

.. index:: PCAP-Filter

Zum Beispiel bekomme ich mit dem folgenden PCAP-Filter bei tcpdump und
Wireshark nur die IKE-Datagramme.

.. code::

   udp and ( port 500 or ( port 4500 and udp[8:4] = 0 ) )

Bin ich hingegen am ESP-Traffic interessiert,
verwende ich folgenden Filter::

   esp or ( udp and port 4500 and udp[8:4] != 0 )

Bei einem VPN-Gateway mit mehreren Peers ergänze ich den Filter noch mit
der IP-Adresse des Peers.

Internes NAT
............

Probleme mit NAT werden mir vermutlich häufiger beim internen NAT
begegnen, das heißt bei der Umsetzung von Adressen der Datagramme, die
über das VPN transportiert werden.

Diese Probleme sind fast immer auf eine Fehlkonfiguration am VPN-Gateway
zurückzuführen, das heißt, wenn ich sie diagnostiziert habe, liegt es
meist auch an mir, sie zu beheben.

Leider bin ich bei IPv4 auf Grund der Knappheit der Adressen oft genug
gezwungen, in meinen organisationseigenen Netzen Adressen zu verwenden,
die über das Internet nicht zu mir geroutet werden.
Manche Organisationen verwenden dann beliebige öffentliche Adressen, die
anderen zugeteilt wurden, was ganz eigene Probleme mit sich bringt.
Aber auch wenn ich mit Adressen arbeite, die nach RFC1918 :cite:`RFC1918`
reserviert sind, muss ich oft genug auf NAT zurückgreifen.
Ich muss es immer dann verwenden,
wenn ich auf beiden Seiten des VPN überlappende Adressbereiche habe.

Ein anderer möglicher Grund für NAT ist, wenn das VPN-Gateway an
zentraler Stelle im Netz positioniert ist und ich allen Datenverkehr für
das VPN durch einfaches Routing dorthin schicken will.
Dann lege ich in meinem organisationsinternen Netz
allen Traffic für VPN auf einen bestimmten Adressbereich
und muss die daraus verwendeten Adressen
beim VPN-Gateway auf die Adressen bei den Peers abbilden.
Das betrifft die Zieladressen in allen Datagrammen, die von meiner
Organisation zum Peer gehen und die Absenderadressen aller Datagramme,
die vom Peer an meine Organisation gesendet werden.

Will oder muss ich hingegen die Adressen, die in meiner Organisation
verwendet werden, vor dem Peer verbergen, muss ich die Absenderadressen
aller Datagramme von uns zum Peer sowie die Zieladressen der Datagramme
vom Peer zu uns umsetzen.

Bei den meisten VPN-Gateways reicht es für internes NAT aus, eine
Richtung und die Umsetzung für Quell- und/oder Zieladressen anzugeben
und die Gegenrichtung wird automatisch abgedeckt.
Trotzdem ist aus dem vorigen Absatz hoffentlich deutlich geworden, dass
NAT die Arbeit mit Rechnernetzen erheblich komplizierter macht.
Bei IPv6 lässt sich NAT im Moment noch vermeiden, wenn man konsequent
eindeutige Adressen verwendet, auch wenn diese nicht über das Internet
geroutet werden.

.. figure:: /images/nat.png
   :name: vpn-nat

   NAT bei VPN-Datenverkehr

Kommen wir nun zu den konkreten Problemen mit internem NAT,
die ich identifizieren und beheben kann.
Dabei hilft das Diagramm in :numref:`vpn-nat`, das aufzeigt, an welchen Stellen
die Datagramme welche Adressen haben können.
Dieses Diagramm kann auch bei Verständigungsproblemen mit dem Peer
während der Fehlersuche helfen.

Betrachte ich Datagramme zwischen den Endpunkten in den Netzwerken A und B,
dann können die Absender- und Zieladressen ein und desselben Datagramms
sich in den drei hervorgehobenen Bereichen voneinander unterscheiden.
Sind beide Seiten des VPN lediglich verschiedene Standorte ein und
derselben Organisation, dann werden die Adressen Aa, Av, Ab
beziehungsweise Ba, Bv und Bb vermutlich überall dieselben sein,
weil bei geschickter Planung der Netze kein NAT notwendig ist.

Komplizierter wird es, wenn das VPN die Netze zweier Organisationen
verbindet.
Da beide Netze dann unabhängig voneinander geplant sind, ist es durchaus
möglich, dass es zu Überschneidungen bei den Adressen auf beiden Seiten
kommt.
Insbesondere, wenn Adressen aus den in RFC1918 :cite:`RFC1918` genannten
Adressbereichen verwendet werden.
In diesem Fall müssen beide Seiten Adressbereiche finden, die zu ihrem
eigenen Netz und zum Netz des Peers passen.
Unterhält ein VPN-Gateway mehrere VPN zu unterschiedlichen Peers,
dann sollten für dieses Gateway die lokalen Adressen des Peers
sich von denen aller anderen Peers unterscheiden,
damit sie korrekt zugeordnet werden können.

Bei einem neu einzurichtenden VPN zu einem fremden Peer bestimme ich
zunächst die Anzahl der benötigten Adressen auf beiden Seiten und dann
die verfügbaren Adressen für die Traffic-Selektoren.
Dabei muss jede Seite die bereits bei anderen VPN auf dem gleichen
Gateway verwendeten Adressen vermeiden.
Habe ich mich mit dem Peer auf die im VPN verwendeten Traffic-Selektoren
geeinigt, muss ich die Adressen aus meinem Netz umsetzen, wenn sie vom
ausgehandelten Traffic-Selektor abweichen.
Der Peer muss das gleiche entsprechend auf seiner Seite tun.
Verwende ich ein zentrales VPN-Gateway mit festgelegtem Adressbereich,
der in meinen Netzen für alle VPN reserviert ist,
dann muss ich die Peer-Adressen des Traffic-Selektors umsetzen,
wenn diese nicht in dem reservierten Adressbereich liegen.

Somit kann es vorkommen, dass ich an meinem VPN-Gateway keine Adressen,
nur die lokalen Adressen, nur die Adressen des Peers oder beide Adressen
umsetzen muss.
Für den Peer gilt das gleiche auf seiner Seite.
Das muss ich wissen und gegebenenfalls bei der Fehlersuche
berücksichtigen.

.. index:: ESP

Wichtig ist insbesondere bei policy-based VPN, dass die Adressen der
Datagramme, die verschlüsselt im ESP-Tunnel gesendet werden, genau zu
den für die Child-SA ausgehandelten Traffic-Selektoren passen.
Einige VPN-Gateways nehmen das nicht so genau, während andere
VPN-Gateways die erfolgreich entschlüsselten Datagramme dann verwerfen,
weil die Adressen nicht zu den Traffic-Selektoren passen.
Einen Hinweis darauf finde ich meist in den Logs.

Ein weiteres Problem sind umfassende NAT-Regeln, die vor den
spezifischen Regeln für ein einzelnes VPN greifen,
insbesondere, wenn Objekte statt Adressen verwendet werden. 
Diese Regeln können die zum Tunnel gesendeten Datagramme so verändern,
dass sie entweder nicht mehr zur Policy des VPN passen
und gar nicht verschlüsselt werden
oder sie passen nicht zu den Traffic-Selektoren
und werden vom anderen VPN-Gateway verworfen.

Dieser Fall lässt sich leichter identifizieren, wenn ich für die
Diagnose der NAT-Regeln auf die Adressen in Textform zugreifen kann,
oder - falls das nicht geht -
wenn ich die Adressen in allen Objektnamen kodiert habe.

Um das Problem zu verdeutlichen, nehmen wir an, dass in den NAT-Regeln
zwei Objekte verwendet werden:

* Object_A mit Adresse a.b.0.0/16
* Object_B mit Adresse a.b.c.d/32

Vermute ich Probleme mit der Adressumsetzung von Object_B, dann finde
ich die Regeln mit Object_A nicht, wenn ich es nicht schon vorher kenne
und weiß, dass es Probleme mit diesem geben kann.
Kann ich jedoch in den NAT-Regeln mit den Adressen suchen, dann such ich
der Reihe nach mit diesen Mustern:

* a.b.c.d
* a.b.c
* a.b
* a
* 0.0.0.0

Zwar werde ich immer mehr Regeln betrachten müssen, aber trotzdem nicht
alle.

Bei NAT-Regeln kommt es auf die Reihenfolge an, das heißt, ich muss
immer nur die Regeln betrachten, die vor derjenigen für das betroffene
VPN stehen.
Und natürlich muss diese Regel korrekt sein, darum schaue ich sie als
allererstes an.

Diese Probleme mögen vielleicht etwas weit hergeholt erscheinen,
sie sind mir jedoch sämtlich schon bei der Arbeit mit VPN begegnet.

In einem Fall sollte zu einem Peer ein VPN eingerichtet werden, bei dem
für den Peer extra ein Adressbereich (/24) ausgewählt worden war, der
bisher nicht verwendet wurde.
In den Traffic-Selektoren verwendeten wir genau diesen Adressbereich, so
dass kein NAT notwendig war.
Um so größer war unser Erstaunen, als wir beim Testlauf sahen, dass für
den Traffic zu diesem VPN die Adressen trotzdem umgesetzt wurden, darum
nicht mehr zur Policy passten und nicht über das VPN gesendet wurden.
Bei der Untersuchung der NAT-Regeln mit den Adressen fanden wir recht
schnell eine NAT-Regel für einen /22-Netzbereich
in dem das neue VPN das vierte /24-Subnet belegte.
Von den in der NAT-Regel abgedeckten Adressen waren aber nur das erste
und das dritte /24-Subnet wirklich verwendet worden und die NAT-Regel
nur aus Bequemlichkeit auf /22 gelegt, um nicht mehrere NAT-Regeln bzw.
NAT-Regeln mit mehreren Bereichen anlegen zu müssen.

Bei der Vorbereitung eines Workshops wiederum habe ich es geschafft,
dass ein VPN-Gateway den Return-Traffic
zu verschlüsselt über das VPN angekommenen Daten
unverschlüsselt mit nur halb umgesetzten Adressen zurückschickte.
Ursache war eine übriggebliebene globale NAT-Regel.

Path-MTU
--------

Eine zu geringe MTU auf dem Weg der Datagramme vom Sender zum Empfänger
kann schon bei der einfachen Datenübertragung Probleme verursachen.
Bei einem VPN wächst die Anzahl der potentiellen Fehlerquellen.

Worum geht es?

.. index:: Maximum Transmission Unit
   see: MTU; Maximum Transmission Unit

In jedem Netzsegment ist die maximale Größe eines Datagramms, dass in
einem Stück übertragen werden kann, begrenzt.
Als Maß für diese Obergrenze wird die Maximum Transmission Unit (MTU)
verwendet, die angibt, wieviel Oktetts ein Endgerät oder ein Gateway für
ein Datagramm der OSI-Ebene 3 (IPv4 oder IPv6) zur Verfügung stehen.
Das sind bei Ethernet 1500 Bytes, mit Jumbo-Frames auch mehr.
Bei PPP gehen davon 8 Bytes für die Verwaltungsinformationen drauf,
so dass bei einem Internetanschluss mit PPPoE nur noch 1492 Byte für das
IP-Protokoll zur Verfügung stehen.
Eine Aufstellung gängiger Größen für die MTU
findet sich in RFC1191 (:cite:`RFC1191`).

Die MTU bezieht sich immer auf direkt angeschlossene Netzsegmente.
Auf dem Weg vom Empfänger zum Ziel passiert ein Datagramm oft mehrere
Netzsegmente, die eine unterschiedliche MTU aufweisen können.
Für diese Strecke ist die Path-MTU (PMTU) die geringste MTU aller
Netzsegmente, die ein Datagramm durchquert.

Jedes Endgerät und jedes Gateway kann nur die MTU der direkt
angeschlossenen Netzsegmente kennen.
Die PMTU kann hingegen für verschiedene Datenströme eines Endgerätes
unterschiedlich sein, sie ist daher eine Merkmal jedes einzelnen Flows
und muss für diesen ermittelt werden.

.. topic:: Flow

   .. index:: ! Flow

   Jede paketbasierte Datenübertragung,
   zum Beispiel mit dem Internet Protokoll,
   basiert auf Datagrammen,
   einzelnen Dateneinheiten,
   die nacheinander versendet werden.
   Wenn ich hier von einem Flow spreche,
   meine ich alle Datagramme,
   die zu einer einzelnen Kommunikationsbeziehung gehören.
   Das umfasst neben den Datagrammen,
   die von einer Seite zur anderen gesendet werden,
   auch die zugehörigen Antwortpakete in der Gegenrichtung.

.. index:: Path-MTU-Discovery, ICMP

Wie die Path-MTU ermittelt wird,
ist in RFC1191 beschrieben.
IPv4 verwendet hierfür das DF-Bit des IP-Headers und ICMP-Datagramme vom
Typ 3 (Destination Unreachable), Subtyp 4 (Fragmentierung nötig, Don’t
Fragment aber gesetzt).
IPv6-Datagramme dürfen per Definition nicht fragmentiert werden, darum
ist hier kein DF-Bit im IP-Header notwendig.
Für die Signalisierung einer zu geringen MTU
werden bei IPv6 ICMPv6-Datagramme vom Typ 2 (Packet Too Big) verwendet.

Damit PMTU-Discovery überhaupt funktioniert,
müssen die Gateways
die entsprechenden ICMP- beziehungsweise ICMPv6-Nachrichten generieren
und die Firewalls unterwegs müssen sie durchlassen.

Bei einem VPN gibt es im Prinzip drei Stellen, an denen die Path-MTU zu
klein sein kann:

* vor dem eigenen VPN-Gateway,
* zwischen den VPN-Gateways,
* hinter dem VPN-Gateway des Peers.

Jede Position bringt ihre eigenen Probleme mit sich.

Ist die MTU eines Netzsegments vor dem eigenen VPN-Gateway zu gering,
greifen die oben beschriebenen Mechanismen und der IP-Stack des
sendenden Rechners sollte sich automatisch darauf einstellen.
Gehen die zur PMTU-Discovery benötigten Datagramme verloren, oder werden
gar nicht erst gesendet, ist das kein Problem für den VPN-Administrator
sondern für die Administratoren der Firewalls beziehungsweise Netze.


Durch den Overhead der IPsec-Protokolle
sinkt die PMTU gegenüber der MTU in den Netzen,
über die das VPN läuft, erheblich.
Dieser Effekt wird von den VPN-Gateways bereits berücksichtigt, indem
sie den Protokoll-Overhead von der MTU des abgehenden Interfaces abziehen.
Bei TCP-Verbindungen setzen die VPN-Gateways MSS-Clamping ein, damit zu
große Datagramme gar nicht erst gesendet werden.
Allerdings beziehen sich die VPN-Gateways dabei immer auf die MTU des
Netzsegments, an dem sie angeschlossen sind.
Ist auf dem Weg zwischen den beiden VPN-Gateways die PMTU geringer, so
gehen die Fehlernachrichten an das sendende VPN-Gateway und nicht an den
Sender des im VPN transportierten Datagramms.

Da mit den ICMP-Nachrichten auch immer der Anfang des verursachenden
Datagramms an das sendende VPN-Gateway geschickt wird, kann dieses
anhand der SPI und der Sequenznummer prinzipiell den ursprünglichen
Datenstrom bestimmen und eine angepasste ICMP-Nachricht für den
ursprünglichen Sender generieren.

Prinzipiell heißt nicht immer, sondern nur unter bestimmten
Voraussetzungen.
Damit das funktioniert, muss

* das sendende VPN-Gateway diese Funktionalität unterstützen,
* diese Funktion in der Konfiguration aktiviert sein,
* die notwendige Information, um ein geeignetes ICMP-Datagramm für den
  Absender zu generieren, noch vorhanden sind.
  Das heißt, die betreffende SA muss noch aktiv sein.
  Auch dann wird die ICMP-Nachricht an den Sender
  erst beim nächsten großen Datagramm generiert,
  wenn dessen Größe die für die SA notierte MTU überschreitet.

Ist die MTU eines Segments hinter dem VPN-Gateway des Peers zu gering,
gibt es bei policy-based VPN mitunter das Problem,
dass die Absenderadresse der ICMP-Nachricht nicht in der Policy steht
und damit die Rückmeldung bereits beim VPN verworfen wird
und PMTU-Discovery nicht funktioniert.
RFC4301 (:cite:`RFC4301`) diskutiert dieses Problem in Abschnitt 6.2
"Processing Protected Transit ICMP Error Messages".
Ob und wie das umgesetzt ist,
hängt von der konkreten Implementierung ab.

Bei route-based VPN tritt dieses Problem nicht auf, wenn die
begleitenden Firewall-Regeln die benötigten ICMP-Nachrichten durch
lassen.
Zum Glück ist die MTU der Netzsegmente hinter dem VPN
selten geringer als die MTU des VPN,
so dass dieser Fall wohl kaum in der Praxis vorkommen wird.

Grundsätzlich merke ich mir,
dass ich mich bei einem VPN nicht darauf verlassen kann,
dass PMTU-Discovery funktioniert.
Habe ich diese,
mit Hilfe von Paketmitschnitten
oder durch Kenntnis der Netztopologie
als Ursache des Problems identifiziert,
muss ich unter Umständen andere Wege suchen,
um das Problem zu umgehen.

Der beste Weg wäre, das Segment mit der niedrigen MTU durch ein anderes
zu ersetzen.
Das gelingt jedoch nicht, wenn ich keine Kontrolle über dieses Segment
habe oder wenn mir die Mittel fehlen.

.. index:: Flow

Der nächste Gedanke wäre, am VPN-Gateway die MTU entsprechend zu
reduzieren, so dass dieses automatisch mit niedrigeren Werten arbeitet.
Das beeinflusst dann allerdings alle VPN dieses Gateways und die
Effizienz der Datenübertragung leidet für alle Flows, die dieses VPN
passieren.

.. index:: MSS-Clamping

Bei TCP kann ich, wenn die VPN-Software es zulässt,
mit MSS-Clamping die Größe der Datagramme von vornherein beschränken.
Auch das betrifft wiederum alle Datenströme, wenn ich MSS-Clamping nicht
auf einzelne Verbindungen beschränken kann.

Schließlich kann ich die MTU des sendenden Rechners per Konfiguration
reduzieren.
Das würde die Effizienz aller Datenübertragungen,
die an diesem Rechner über dieses Interface gehen,
beeinträchtigen.
Kann ich den Datenverkehr mit und ohne VPN
an diesem Rechner auf verschiedene Interfaces aufteilen,
wären allerdings nur die VPN-Verbindungen betroffen.

Inkompatibilität
----------------

Eine weitere mögliche Fehlerursache sind Inkompatibilitäten
zwischen verschiedenen IPsec-Implementierungen.
Es ist mir nicht möglich, diese erschöpfend in einem Buch zu behandeln.
In den meisten Fällen lassen sie sich darauf zurückführen,
dass bestimmte Funktionalitäten manchmal gar nicht
oder nur teilweise implementiert wurden.
Dabei gibt es nicht nur Unterschiede von Software zu Software, sondern
auch von Version zu Version der gleichen Software.
Oft werden verschiedene Geräte vom gleichen Hersteller unterschiedlich
konfiguriert und haben verschiedene Features implementiert.

Im einfachsten Fall kann es sein, dass bestimmte Crypto-Parameter
einfach nicht funktionieren.
Ich persönlich habe verschiedentlich Probleme mit SHA384 bei bestimmten
Versionen von Checkpoint erlebt.

In anderen Fällen kann es sein, dass bestimmte Parameter zwar
prinzipiell funktionieren, aber nicht an jeder Stelle der Konfiguration.
Als konkretes Beispiel ist mir hier ein VPN zu einer Gegenstelle
erinnerlich, dass in einer Richtung problemlos aufgebaut werden konnte,
in der anderen Richtung nicht mal IKE.
Nach längerem Debugging und Rückfragen bei den Herstellern erwies sich
als Ursache, dass die eine Seite die vereinbarten Parameter für IKE erst
im neunten Proposal des IKE_SA_INIT-Requests sendete, die andere Seite
aber nur acht Proposals auswertete und darum nicht die erwarteten
Parameter fand.

Insbesondere, wenn man VPN-Gateways mit vielen Peers betreibt,
ist der VPN-Administrator gut beraten,
seine im Laufe der Zeit gemachten Erfahrungen
in einer Wissensdatenbank festzuhalten und diese regelmäßig zu ergänzen.
Im einfachsten Fall können das eine oder mehrere Textdateien sein, die
sich schnell durchsuchen lassen.
Aber auch ein Spreadsheet oder eine spezielle Software für die
Wissensdatenbank kann geeignet sein.
Wichtig ist die regelmäßige Pflege und die Konsultation der Datenbank
vor dem Einrichten von neuen VPN.

Policy-based VPN versus route-based VPN
---------------------------------------

Der grundlegende Unterschied zwischen diesen beiden Ausprägungen von VPN
ist, dass bei route-based VPN ein virtuelles Netzwerkinterface auf jedem
VPN-Gateway angelegt wird, das mit dem des Peers verbunden ist.
Diese beiden Interfaces terminieren jeweils
auf einer IP-Adresse der VPN-Gateways
und genau für diese beiden Adressen brauche ich nur eine einzige Child-SA.
Bei policy-based VPN gibt es dieses virtuelle Netzwerkinterface nicht.

.. index:: Transportmodus

Prinzipiell kann ich die virtuellen Netzwerkschnittstellen
mit nichtöffentlichen Adressen des VPN-Gateways terminieren.
Bei der Verwendung von öffentlichen Adressen
kann ich jedoch das VPN im Transportmodus betreiben
und ein paar Byte Overhead pro Datagramm sparen.

.. index:: GRE

Diese Einsparung kann allerdings zu Problemen führen,
wenn der Tunnel nicht aufgebaut ist
und keine Firewall-Regel unverschlüsselten Datenverkehr sperrt.
In solchen Fällen habe ich unverschlüsselten GRE-Traffic
beim Peer ankommen sehen
und bevorzuge darum nichtöffentliche Adressen und Tunnelmodus
als zusätzliche Sicherheit.

.. index:: GRE-Interface
.. index:: PPTP

Als virtuelle Netzwerkschnittstelle kann ich ein GRE-Interface nehmen,
wie in RFC2784 :cite:`RFC2784` beschrieben
oder PPTP (RFC2637 :cite:`RFC2637`).

Sind die GRE-Interfaces eingerichtet
und durch IPsec geschützt miteinander verbunden,
bekommen sie je eine Adresse in einem beliebigen Transfer-Netz.
Dieses dient nur dem Routing des abgehenden Datenverkehrs.
Auf der ankommenden Seite muss der Traffic durch Firewall-Regeln
reguliert werden.

Beim policy-based VPN wird jedem Tunnel zwischen zwei Netzwerken eine
eigene Child-SA bei den Peers zugeordnet.
Auf der sendenden Seite wird nicht über die Zieladressen sondern über
die IPsec-Policies entschieden, ob der Traffic verschlüsselt wird und
mit welchen SA.
Auf der empfangenden Seite kümmert sich die IPsec-Implementierung darum,
dass nur erlaubter Traffic über das VPN kommt.
Ich benötige hier keine GRE-Interfaces.
Dafür bin ich gezwungen, das VPN im Tunnel-Modus zu konfigurieren.

Aus dem vorgenannten ergibt sich, dass route-based VPN inkompatibel zu
policy-based VPN sind.
Zwar können auf demselben Gateway beide Arten von VPN betrieben werden,
für einen konkreten Tunnel müssen beide Peers jedoch dieselbe Art verwenden.

Auch muss ich aufpassen,
wenn ich ein VPN von policy-basiert auf route-basiert umstelle.
In einem konkreten Fall hatte ich die Policy für das
alte policy-basierte VPN noch nicht deaktiviert. Auf der Gegenstelle war
das VPN schon deaktiviert, so dass kein Traffic mehr darüber lief.
Allerdings reklamierte die alte Policy den passenden Traffic
des neuen route-basierten VPN für den alten Tunnel
und verwarf die Datagramme,
weil dieser nicht aktiv war.

Anti-Replay-Check-Probleme
--------------------------

Mitunter finden sich in den Logs Hinweise auf fehlgeschlagene
Anti-Replay-Checks.
Diese bedeuten, dass das zugehörige Datagramm vom Empfänger ohne weitere
Bearbeitung verworfen wurde.
Treten diese Meldungen häufiger auf, ist es an der Zeit, ihnen
nachzugehen.
Im Internet findet sich eine anschauliche Erläuterung unter
:cite:`Cisco-116858`, auch wenn diese die Sicht von Cisco
und den Umgang mit dem Problem auf deren Geräten beschreibt.

Anti-Replay-Checks sind ein wichtiges Sicherheitsmerkmal von IPsec.
Sie nutzen die in jedem ESP- oder AH-Header mitgesendete Sequenznummer.
Das empfangende VPN-Gateway führt in einem gleitenden Fenster Buch,
welche Datagramme jeder SA bereits verarbeitet wurden und welche Nummern
erwartet werden.
Der Hauptzweck der Sequenznummer und des gleitenden Fensters ist der
Schutz vor Replay-Attacken, bei denen Datagramme in böser Absicht
mehrfach gesendet werden.
Leider gibt es neben Attacken auf das VPN auch noch andere Gründe, wegen
denen der Anti-Replay-Check fehlschlagen kann:

* Datagramme können während der Übertragung umsortiert werden und somit
  in falscher Reihenfolge eintreffen.

* Durch QoS-Funktionen beim sendenden VPN-Gateway können die Datagramme
  bereits hier so umsortiert werden,
  dass Datagramme aus dem gleitenden Fenster herausfallen.

* Die Bearbeitungszeit von Datagrammen kann sich so stark unterscheiden,
  dass große Datagramme aus dem gleitenden Fenster heraus sind, bevor
  sie komplett verarbeitet wurden.

Diese Probleme werden durch hohe Bandbreite und dementsprechend viele
Datagramme, die in kurzer Zeit hintereinander eintreffen, noch
verschärft.

Habe ich ein Problem mit Anti-Replay-Checks, muss ich die verworfenen
Datagramme anhand der Log-Nachrichten identifizieren und mit einem
gleichzeitig laufenden Paketmitschnitt verifizieren, ob es sich um eine
Replay-Attacke handelt oder eine andere Ursache in Frage kommt.
Zum Beispiel eine der oben genannten.
Je nach ermittelter Ursache muss ich entsprechende Maßnahmen ergreifen.

Wird das Problem vor allem durch starken Traffic verschärft, kann ich in
Erwägung ziehen, dass gleitende Fenster zu vergrößern.
Dafür benötigt das VPN-Gateway mehr Speicher, so dass ich mich vor
diesem Schritt genau mit der aktuellen Auslastung des Geräts vertraut
machen muss und am besten den Hersteller zu Rate ziehe.

