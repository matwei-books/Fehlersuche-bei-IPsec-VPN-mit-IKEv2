
Fehlerursachen
==============

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

Falsche Crypto-Parameter
------------------------

Die wohl häufigste Fehlerursache bei nicht funktionierenden VPN sind
verschiedene Crypto-Parameter auf den beiden VPN-Gateways.
Da diese meist im Vorfeld vereinbart werden, kann man durchaus von
falschen Parametern auf mindestens einer Seite sprechen.
Wurden die Parameter nicht im Vorfeld vereinbart, spriecht man besser
von verschiedenen Parametern.

Diese Fehler fallen in die Kategorie Fehlkonfiguration, das heißt für
die Behebung sind die VPN-Administratoren zuständig.
Können sie das nicht, zum Beispiel weil ein VPN-Gateway bestimmte
Parameter nicht unterstützt, müssen sie eskalieren und sich rechtzeitig
Hilfe holen oder andere Parameter aushandeln wenn bestimmte Parameter
nicht an ihrem Gateway einstellbar sind.

Falsche Crypto-Paramter können verschiedene Ausprägungen haben, zum
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
verwendet werden soll.
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
Dann bekomme ich den Inhalt der ausgetauschten Datagramme oft gut
erklärt, muss die relevanten Stellen dafür in großen Mengen Text suchen.

Falsche Parameter für IKE
.........................

Eine weitere Möglichkeit Crypto-Parameter falsch zu konfigurieren sind
die Parameter für die IKE-SA.
Auch diese kann ich recht einfach verifizieren.

Ich schaue nach den IKE-Crypto-Parametern wenn ich weiß, dass
grundsätzlich IKEv2-Datagramme in beiden Richtungen ausgetauscht werden,
aber dennoch keine IKE-SA zustande kommt.

Die Logs helfen mir bei diesem Problem je nach Software und Version des
VPN-Gateways sowie meiner Erfahrung damit mal mehr und mal weniger.
Aussageräftiger sind die Debugausgaben.

Zumindest grobe Fehler bei den konfigurierten Crypto-Parametern kann ich
in einem Paketmitschnitt am IKE_SA_INIT-Exchange erkennen, weil hier
sowohl alle in den Proposals vorgeschlagenen Kombinationen als auch die
vom Responder angenommene Kombination oder eben eine Fehlermeldung
unverschlüsselt vorliegen.
Sehe ich im Mitschnitt noch einen kompletten IKE_AUTH-Exchange, so kann
ich davon ausgehen, dass beide Peers die selben Crypto-Algorithmen für
IKE verwenden.

Scheitert IKE_AUTH, könnten Probleme mit dem PSK die Ursache sein der
generell Authentisierungsprobleme.
Da mit dem IKE_AUTH-Exchange auch die erste Child-SA (ESP oder AH)
verhandelt wird, kann das Problem auch an den Parametern für diese
liegen.

Leider kann ich Probleme bei IKE_AUTH in den meisten Fällen nicht mit
einem Paketmitschnitt erkennen, da hier schon die bei IKE_SA_INIT
ausgehandelte Verschlüsselung zur Anwendung kommt.
Lediglich von der Cisco ASA ist mir bekannt, dass sie Paketmitschnitte
(*type isakmp*) schreiben kann, die die entschlüsselten IKE-Datagramme
enthalten.

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

Fehlendes PFS auf einer Seite
.............................

Das Problem mit PFS, das auf einer Seite konfiguriert ist und auf der
anderen nicht, ist, dass das VPN mitunter zunächst funktioniert und das
Problem erst beim Rekeying offenbar wird.

Bei der im Rahmen von IKE_AUTH ausgehandelten Child-SA wird das
Schlüsselmaterial von IKE_SA_INIT verwendet, so dass hier eine
funktionsfähige Child-SA erzeugt werden kann.
Das Rekeying scheitert dann weil eine Seite den Schlüssel aus dem
letzten verwendeten Schlüssel ableiten will, wohingegen die andere
Seite einen neuen Schlüssel aushandeln will.

NAT
---

Eine weitere Fehlerursache, mit der ich gerade bei IPv4 sehr häufig
rechnen muss, ist Netzwerkadressumsetzung (NAT).

Immer wenn NAT ins Spiel kommt, habe ich latent ein
Verständigungsproblem, weil für dieselben Datenströme an verschiedenen
Stellen des Netzes unterschiedliche Adressen verwendet werden.
Schon allein diese Tatsache erschwert die Fehlersuche.

Generell unterscheide ich am VPN zwei Formen von NAT:

* *Externes NAT* meint in diesem Zusammenhang, dass die Adressen der
  Datagramme zwischen den VPN-Gateways verändert werden.

* *Internes NAT* meint die Modifizierung der Adressen der Datagramme,
  die durch das VPN gesendet werden.

Externes NAT
............

Bei IKEv1 stellte NAT zwischen den VPN-Gateways noch ein Problem dar,
dass nachträglich durch die Einführung von NAT-T mit der Kapselung der
IPsec-Datagramme in UDP gelöst wurde.

Bei IKEv2 sind entsprechende Mechanismen bereits im
IKE_SA_INIT-Austausch eingebaut, so dass die Peers erkennen können,
ob die Adressen ihrer Datagramme manipuliert werden und automatisch auf
UDP-Encapsulation umschalten.
Damit sollte es also keine größeren Probleme geben.
Ich muss lediglich dafür sorgen, dass sowohl UDP Port 500 als auch UDP
Port 4500 in der Firewall freigegeben sind.

Schwierig könnte es werden, wenn beide VPN-Gateways hinter NAT-Boxen
platziert sind.

NAT macht die Diagnose mit Paketmitschnitt etwas komplizierter, weil
sowohl IKE als auch ESP und AH UDP Port 4500 verwenden.
Um diese Protokolle auseinander zu halten, brauche ich einen speziellen
Filter beim Paketmitschnitt.

.. index:: PCAP-Filter

Zum Beispiel bekomme ich mit dem folgenden PCAP-Filter bei tcpdump und
Wireshark die IKE-Datagramme.

.. code::

   proto udp and ( port 500 or ( port 4500 and udp[8:4] = 0 ) )

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

Leider bin ich bei IPv4 auf Grund der Adressenknappheit oft genug
gezwungen, in meinen organisationseigenen Netzen Adressen zu verwenden,
die über das Internet nicht zu mir geroutet werden.
Manche Organisationen verwenden dann beliebige öffentliche Adressen, die
anderen zugeteilt wurden, was ganz eigene Probleme mit sich bringt.
Aber auch wenn ich mit Adressen, die nach RFC1918 :cite:`RFC1918`
reserviert sind, arbeite, muss ich oft genug auf NAT zurückgreifen.
Ich muss NAT immer dann verwenden, wenn auf beiden Seiten des VPNs
überlappende Adressbereiche verwendet werden.

Ein anderer möglicher Grund für NAT ist, wenn das VPN-Gateway an
zentraler Stelle im Netz positioniert ist und ich allen Datenverkehr für
das VPN durch einfaches Routing dorthin schicken will.
Dann lege ich in meinem organisationsinternen Netz allen Traffic für
VPNs auf einen bestimmten Adressbereich und muss die daraus verwendeten
Adressen beim VPN-Gateway auf die Adressen bei den Peers abbilden.
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

Das war das Vorgeplänkel zu internem NAT, kommen wir nun zu konkreten
Problemen damit, die ich identifizieren und beheben kann.
Dabei hilft uns das folgende Diagramm, das aufzeigt, an welchen Stellen
die Datagramme welche Adressen haben können.

.. todo:: Diagramm mit den NAT-Adressen

Dieses Diagramm kann auch bei Verständigungsproblemen mit dem Peer
während der Fehlersuche helfen.

Wichtig ist insbesondere bei policy-based VPN, dass die Adressen der
Datagramme, die verschlüsselt im ESP-Tunnel gesendet werden, genau zu
den für die Child-SA ausgehandelten Traffic-Selektoren passen.
Einige VPN-Gateways nehmen das nicht so genau, während andere
VPN-Gateways die erfolgreich entschlüsselten Datagramme dann verwerfen,
weil die Adressen nicht zu den Traffic-Selektoren passen.
Einen Hinweis darauf finde ich meist in den Logs.
Beheben muss dieses Problem der Administrator des sendenden
VPN-Gateways.

Ein weiteres Problem sind umfassende NAT-Regeln, die vor den
spezifischen Regeln für ein einzelnes VPN greifen, insbesondere, wenn
Objekten statt Adressen verwendet werden. 
Diese Regeln können die zum Tunnel gesendeten Datagramme so verändern,
dass sie entweder nicht mehr zur Policy des VPN passen und gar nicht
verschlüsselt versendet werden oder sie passen nicht zu den
Traffic-Selektoren und werden vom anderen VPN-Gateway verworfen.

Dieser Fall lässt sich leichter identifizieren, wenn ich für die
Diagnose der NAT-Regeln auf die Adressen in Textform zugreifen kann,
oder - falls das nicht geht - wenn ich die Adressen konsequent in allen
Objektnamen kodiert habe.

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
* a.b.c.
* a.b.
* a.
* 0.0.0.0

Zwar werde ich immer mehr Regeln betrachten müssen, aber trotzdem nicht
alle.

Bei NAT-Regeln kommt es auf die Reihenfolge an, das heißt, ich muss
immer nur die Regeln betrachten, die vor derjenigen für das betroffene
VPN stehen.
Und natürlich muss diese Regel korrekt sein, darum schaue ich sie als
allererstes an.

Diese Problem mögen vielleicht etwas weit hergeholt erscheinen, sie sind
mir sämtlich schon bei der Arbeit mit VPNs begegnet.

In einem Fall sollte zu einem Peer ein VPN eingerichtet werden, bei dem
für den Peer extra ein Adressbereich (/24) ausgewählt worden war, der
bisher nicht verwendet wurde.
In den Traffic-Selektoren verwendeten wir genau diesen Adressbereich, so
dass kein NAT notwendig war.
Um so größer war unser Erstaunen, als wir beim Testlauf sahen, dass für
den Traffic zu diesem VPN die Adressen trotzdem umgesetzt wurden, darum
nicht mehr zur Policy passten und nicht über das VPN gesendet wurden.
Bei der Untersuchung der NAT-Regeln mit den Adressen fanden wir recht
schnell eine NAT-Regel für einen /22-Netzbereich in dem das neue VPN das
vierte Subnet belegte.
Von den in der NAT-Regel abgedeckten Adressen waren aber nur das erste
und das dritte /24-Subnet wirklich verwendet worden und die NAT-Regel
nur aus Bequemlichkeit auf /22 gelegt, um nicht mehrere NAT-Regeln bzw.
NAT-Regeln mit mehreren Bereichen anlegen zu müssen.

Bei der Vorbereitung eines Workshops habe ich es geschafft, dass ein
VPN-Gateway den Return-Traffic zu verschlüsselt über das VPN
angekommenen Daten unverschlüsselt mit nur halb umgesetzten Adressen
zurückging.
Ursache war eine übriggebliebenen globale NAT-Regel.

Path-MTU
--------

Inkompatibilität
----------------

