
Paketmitschnitt
===============

Für mich ist ein Paketmitschnitt (Packet Capture) insbesondere bei
schwierigen Problemen oft die Ultima Ratio bei der Diagnose.
Zwar sind andere Hilfsmittel wie Logs, Debugausgaben oder
Diagnosewerkzeuge des VPN-Gateways oft anschaulicher und schneller zu
kontrollieren.
Aber gerade, wenn ich Zweifel daran habe, ob das was mir angezeigt wird,
auch das ist, was passiert, finde ich in einem Paketmitschnitt oft
Gewissheit in der einen oder anderen Richtung.

Dazu muss ich wissen, wie und wo ich einen Paketmitschnitt anfertige,
wie ich ihn auswerte und vor allem, welche Informationen ich ihm
entnehmen kann.

.. figure:: /images/vpn-packet-capture.png
   :name: vpn-packet-capture

   Packet Capture (PC) am VPN-Gateway

Als VPN-Administrator habe ich üblicherweise nur zwei Stellen, von denen
ich relativ leicht Paketmitschnitte bekommen kann, der entschlüsselten
Seite und der verschlüsselten Seite meines VPN-Gateways.
Wann ich auf welcher Seite den Datenverkehr mitschneide und auswerte
hängt von der Art des Problems ab.

In den meisten Fällen schneide ich den Datenverkehr auf der
entschlüsselten Seite (Inside, links in :numref:`vpn-packet-capture`) nur mit,
wenn ein VPN-Tunnel bereits aufgebaut ist und ich kontrollieren möchte,
ob Daten für alle vereinbarten IPsec-SA übertragen werden. Eine Ausnahme
ist ein VPN, das von meiner Seite zum Peer aufgebaut wird und sich nicht
automatisch aufbaut. In diesem Fall kontrolliere ich auf der
entschlüsselten Seite, ob der Traffic, der den Aufbau des VPNs auslösen
soll, überhaupt am VPN-Gateway ankommt.

An der verschlüsselten Seite (Outside, rechts in
:numref:`vpn-packet-capture`) schneide ich den Datenverkehr mit, wenn es
Probleme beim Aufbau des VPN oder einzelner Tunnel gibt. Da auf dieser
Seite überwiegend verschlüsselte Datagramme übertragen werden, kann ich
meist nicht viel zum Inhalt sagen, insbesondere bei den
IPsec-Datagrammen. Anhand der Payload, der Größe und der zeitlichen
Abfolge der Datagramme kann ich jedoch zumindest für IKEv2 bereits
einige Rückschlüsse ziehen.

Bei Cisco ASA Geräten ist es sogar möglich Pseudo-Paketmitschnitte zu
generieren, die den Inhalt der verschlüsselten IKE-Datagramme zeigen,
obwohl dieser normalerweise in einem Paketmitschnitt nicht zugänglich
ist. In allen anderen Fällen muss ich die Informationen aus dem
Mitschnitt mit Logs und Debuginformationen kombinieren.

Datenverkehr mitschneiden
-------------------------

Prinzipiell gibt es mehrere Möglichkeiten, den Datenverkehr
mitzuschneiden:

a) Ich schneide den interessanten Datenverkehr direkt auf dem
   VPN-Gateway mit.
b) Ich platziere einen Rechner zum Paketmitschnitt im Netzwerk und leite
   vom Switch aus den interessierenden Datenverkehr zu diesem Anschluss.
c) Ich platziere einen speziellen Stecker am Anschluss des VPN-Gateways,
   der sowohl den ankommenden als auch den abgehenden Datenverkehr an
   einen Rechner zur Aufzeichnung der Datagramme leitet.

Fall a) macht am wenigsten Umstände und ist am schnellsten aufgesetzt.
Ich muss hier aber bedenken, dass die zusätzliche CPU- und I/O-Last für
den Paketmitschnitt sich negativ auf die Performance des VPN-Gateways
auswirken kann. Habe ich bereits eine hohe Last, ist es möglich, dass
mir dadurch interessante Datagramme entgehen. Je nach verwendetem
VPN-Gateway kann es auch sein, dass ich nicht so gut filtern kann und
mehr Datagramme aufzeichnen muss, als ich möchte.

Im Fall b) muss ich den Fall bedenken, dass sowohl der gesendete als
auch der empfangene Datenverkehr auf den Ethernet-Port der Probe
geschickt wird. Ist das mehr, als auf einem Anschluss gesendet werden
kann, gehen mir dadurch Datagramme verloren. Ob das der Fall ist,
bekomme ich durch Monitoring der Switch-Ports heraus.

Fall c) ist am teuersten, kann mir dafür die Gewähr bieten, dass keine
Datagramme verloren gehen.

Paketmitschnitt auf dem VPN-Gateway
...................................

Will ich Datagramme direkt auf dem VPN-Gateway mitschneiden, muss ich
die nötigen Befehle kennen. Auf der Kommandozeile sind das 

bei Cisco ASA::

  capture nameOfCapture ...

bei Fortinet::

  diag sniff packet ...

bei Checkpoint, GeNUScreen, Linux- oder BSD-Firewalls mit VPN::

  tcpdump -w nameOfCaptureFile ...

Die genaue Syntax der Befehle findet sich in der entsprechenden
Dokumentation.

Paketmitschnitt mit tcpdump
...........................

Bei den Fällen b) und c) kann ich im einfachsten Fall einen Rechner mit
ein oder zwei Netzwerkkarten und *tcpdump* verwenden. Aus diesem Grund
gehe ich hier auf die relevanten Optionen und Filtermöglichkeiten ein.

Ich verwende tcpdump am häufigsten mit diesen Optionen::

  tcpdump -n -U -i interfaceName -w fileName -s snapLen filterExpression

Diese haben die folgende Bedeutung:

-n                keine Adressen und Portnummern in Namen übersetzen
-U                Schreibpuffer nach jedem Datagramm leeren
-i interfaceName  Netzwerkschnittstelle, an der mitgeschnitten werden
                  soll
-w fileName       Dateiname für den Paketmitschnitt
-s snapLen        Maximalgröße jedes einzelnen mitgeschnittenen
                  Datagramms

Keine Adresssen und Portnummern zu übersetzen spart im einfachsten Fall
Zeit, insbesondere bei den Adressen erspare ich mir damit zusätzlichen
DNS-Datenverkehr.

Mit der Option ``-U`` will ich sicherstellen, dass jedes empfangene
Datagramm auch im Mitschnitt landet, insbesondere wenn tcpdump während
der Ausführung unterbrochen wird.

Die Optionen ``-i`` und ``-w`` sollten soweit klar sein.

Mit der Option ``-s`` beschränke ich einerseits den Platz, den der
Paketmitschnitt auf der Platte benötigt und andererseits - in geringem
Maße - die Zeit, die pro einzelnem Datagramm benötigt wird. Wieviel  vom
Datagramm ich für die Auswertung benötige, hängt vom Problem und den
mitgeschnittenen Protokollen ab.

Zusätzlich zu den oben genannten sind noch folgende weitere Optionen von
tcpdump für länger laufende Mitschnitte interessant:

-c count      maximale Anzahl von Datagrammen, die mitgeschnitten werden
-C fileSize   Maximalgröße der Datei für den Paketmitschnitt
-W fileCount  maximale Anzahl von Ausgabedateien

Die Option ``-c`` verwende ich, wenn ich zum Beispiel nur am Beginn
eines Datenaustauschs interessiert bin und der Mitschnitt von selbst
beendet werden soll.

Mit Option ``-C`` begrenze ich die Größe der Ausgabedatei. Bei Erreichen
dieser Größe schreib tcpdump in eine neue Datei. Alle Ausgabedateien
nach der ersten bekommen eine fortlaufende Nummer, beginnend mit 1,
angehängt.

Die Option ``-W`` zusammen mit ``-C`` sorgt dafür, dass tcpdump nach
Erreichen dieser Anzahl von Ausgabedateien diese vom Anfang her wieder
überschreibt, so dass ich eine Art rotierenden Puffer bekomme.
Rotierende Puffer verwende ich, wenn die mich interessierenden
Datagramme sich eher am Ende des Mitschnitts als am Anfang befinden.

Mit dem Ausdruck *filterExpression* begrenze ich die Datagramme, die im
Paketmitschnitt aufgezeichnet werden. Dabei kann ich diesen Ausdruck
direkt auf der Kommandozeile angeben - und muss dann die Klammern mit
Backslash vor der Auswertung durch die Shell schützen: ``\(``, ``\)``.
Oder ich schreibe den Filterausdruck in eine Datei und übergebe den
Dateinamen mit der Option ``-F``.

Der Filter ist abhängig von der Seite, auf der ich mitschneide.

Paketmitschnitt auf der entschlüsselten Seite
.............................................

Auf der entschlüsselten Seite (Inside) interessieren mich bei einem
Mitschnitt vor allem die Adressen der beteiligten Rechner, so wie sie
hier im Netz auftauchen. Dabei muss ich gegebenenfalls NAT beim
VPN-Gateway berücksichtigen. Sinnvolle Filterausdrücke dafür sind::

  host insideAddress and host addressAtPeer

  host insideAddress and net peerSideNet/mask

  net insideNet/mask and net peerSideNet/mask

  net insideNet/mask and host addressAtPeer

Bin ich nur an speziellen TCP- oder UDP-Ports interessiert, kann ich den
Filterausdruck damit ergänzen, zum Beispiel so::

  ... and udp and port 443

Vermute ich Netzwerkprobleme auf der Inside, muss ich zusätzlich noch
den ICMP-Datenverkehr aufnehmen. Da die relevanten ICMP-Datagramme von
jedem Router auf dem Weg zum Zielhost kommen können, kann ich den
ICMP-Datenverkehr nicht auf bestimmte Adressen beschränken, außer auf
die Adressen der Peer-Seite. Ein Filterausdruck dafür würde in etwa so
aussehen::

  host addressAtPeer and ( icmp or host insideAddress )

  host addressAtPeer and ( icmp or net insideNet/mask )

  net peerSideNet/mask and ( icmp or host insideAddress )

  net peerSideNet/mask and ( icmp or net insideNet/mask )

Paketmitschnitt auf der verschlüsselten Seite
.............................................

