
Paketmitschnitt
===============

Insbesondere bei schwierigen Problemen ist für mich ein Paketmitschnitt
(Packet Capture) oft die Ultima Ratio bei der Diagnose.
Zwar sind andere Hilfsmittel wie Logs, Debugausgaben oder
Diagnosewerkzeuge des VPN-Gateways oft anschaulicher und schneller zu
kontrollieren.
Aber gerade, wenn ich Zweifel daran habe, ob das was mir angezeigt wird,
auch das ist, was passiert, finde ich in einem Paketmitschnitt meist
Gewissheit in der einen oder anderen Richtung.

Dazu muss ich wissen, wie und wo ich einen Paketmitschnitt anfertige,
wie ich ihn auswerte und vor allem, welche Informationen ich ihm
entnehmen kann.

.. figure:: /images/vpn-packet-capture.png
   :name: vpn-packet-capture

   Packet Capture (PC) am VPN-Gateway

Als VPN-Administrator habe ich manchmal nur zwei Stellen, von denen
ich Paketmitschnitte bekommen kann, der entschlüsselten
Seite und der verschlüsselten Seite meines VPN-Gateways.
Wann ich auf welcher der beiden Seiten den Datenverkehr mitschneide und auswerte
hängt von der Art des Problems ab.

In den meisten Fällen schneide ich den Datenverkehr auf der
entschlüsselten Seite (Inside, links in :numref:`vpn-packet-capture`) nur mit,
wenn ein VPN-Tunnel bereits aufgebaut ist und ich kontrollieren möchte,
ob Daten für alle vereinbarten IPsec-SA übertragen werden. Eine Ausnahme
ist ein VPN, das von meiner Seite zum Peer aufgebaut wird und sich nicht
automatisch aufbaut. In diesem Fall kontrolliere ich zunächst auf der
entschlüsselten Seite, ob der Traffic überhaupt ankommt, der den Aufbau
des VPNs auslösen soll.

An der verschlüsselten Seite (Outside, rechts in
:numref:`vpn-packet-capture`) schneide ich den Datenverkehr mit, wenn es
Probleme beim Aufbau des VPN oder einzelner Tunnel gibt. Da auf dieser
Seite überwiegend verschlüsselte Datagramme übertragen werden, kann ich
meist nicht viel zum Inhalt sagen, insbesondere bei den
IPsec-Datagrammen. Anhand der Payload, der Größe und der zeitlichen
Abfolge der Datagramme kann ich jedoch zumindest für IKEv2 bereits
einige Rückschlüsse ziehen.

Bei Cisco ASA Geräten ist es möglich Pseudo-Paketmitschnitte generieren
zu lassen, die den Inhalt der verschlüsselten IKE-Datagramme zeigen,
obwohl dieser normalerweise in einem Paketmitschnitt nicht zugänglich
ist. In allen anderen Fällen muss ich die Informationen aus dem
Mitschnitt mit Logs und Debuginformationen kombinieren.

Datenverkehr mitschneiden
-------------------------

Prinzipiell habe ich mehrere Möglichkeiten, den Datenverkehr
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

Fall c) ist am teuersten, bietet mir dafür die Gewähr, dass keine
Datagramme verloren gehen.

.. _Paketmitschnitt auf dem VPN-Gateway:

Paketmitschnitt auf dem VPN-Gateway
...................................

Will ich Datagramme direkt auf dem VPN-Gateway mitschneiden, muss ich
die nötigen Befehle kennen. Auf der Kommandozeile sind das zum Beispiel

* bei Cisco ASA::

    capture nameOfCapture ...
    capture nameOfCapture type isakmp ...

  Der Typ ``isakmp`` bei der Cisco ASA ist
  insbesondere bei Mitschnitten der verschlüsselten Seite interessant,
  weil dann die ASA Pseudo-IP-Datagramme erzeugt und in den Mitschnitt
  einfügt, die den Inhalt der entschlüsselten IKE-Datagramme enthalten.
  Das erleichtert das Finden von Fehlkonfigurationen bei den
  IKE-Parametern.

* bei Fortinet (siehe :cite:`FortinetPacketCaptureCLI`)::

    diag sniff packet ...

* bei Checkpoint, GeNUScreen, Linux- oder BSD-Firewalls mit VPN::

    tcpdump -w nameOfCaptureFile ...

* bei MikroTik::

    /tool sniffer set ...
    /tool sniffer start
    /tool sniffer stop

Die genaue Syntax der Befehle findet sich in der entsprechenden
Dokumentation.

Paketmitschnitt mit tcpdump
...........................

Bei den Fällen b) und c) kann ich im einfachsten Fall einen Rechner mit
ein oder zwei Netzwerkkarten und *tcpdump* verwenden. Darum gehe ich
hier kurz auf die relevanten Optionen und Filtermöglichkeiten ein.

Am häufigsten verwende ich tcpdump mit den folgenden Optionen::

  tcpdump -n -U -i interfaceName -w fileName -s snapLen filterExpression

-n
  keine Adressen und Portnummern in Namen übersetzen
-U
  Schreibpuffer nach jedem Datagramm leeren
-i interfaceName
  Netzwerkschnittstelle, an der mitgeschnitten werden soll
-w fileName
  Dateiname für den Paketmitschnitt
-s snapLen
  Maximalgröße jedes einzelnen mitgeschnittenen Datagramms

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

Neben den oben genannten verwende ich hin und wieder noch folgende
Optionen von tcpdump bei länger laufende Mitschnitten:

-c count      maximale Anzahl von Datagrammen, die mitgeschnitten werden
-C fileSize   Maximalgröße der Datei für den Paketmitschnitt
-W fileCount  maximale Anzahl von Ausgabedateien

Die Option ``-c`` verwende ich, wenn ich zum Beispiel nur am Beginn
eines Datenaustauschs interessiert bin und der Mitschnitt von selbst
beendet werden soll.

Mit Option ``-C`` begrenze ich die Größe der Ausgabedatei. Bei Erreichen
dieser Größe schreibt tcpdump in eine neue Datei. Alle Ausgabedateien
nach der ersten bekommen eine fortlaufende Nummer, beginnend mit 1,
angehängt.

Die Option ``-W`` zusammen mit ``-C`` sorgt dafür, dass tcpdump nach
Erreichen dieser Anzahl von Ausgabedateien diese vom Anfang her wieder
überschreibt, so dass ich eine Art rotierenden Puffer bekomme.
Rotierende Puffer verwende ich, wenn die interessanten
Datagramme sich eher am Ende des Mitschnitts als am Anfang befinden.

Mit dem Ausdruck *filterExpression* bestimme ich die Datagramme, die im
Paketmitschnitt aufgezeichnet werden. Dabei kann ich diesen Ausdruck
direkt auf der Kommandozeile angeben - und muss dann die Klammern mit
Backslash vor der Auswertung durch die Shell schützen: ``\(``, ``\)``.
Oder ich schreibe den Filterausdruck in eine Datei und übergebe den
Dateinamen mit der Option ``-F``.

Der Filter ist abhängig von der Seite, auf der ich mitschneide.

Paketmitschnitt auf der entschlüsselten Seite
.............................................

Auf der Inside interessieren mich bei einem
Mitschnitt vor allem die Adressen der beteiligten Rechner, so wie sie
hier im Netz auftauchen. Dabei muss ich gegebenenfalls NAT beim
VPN-Gateway berücksichtigen. Sinnvolle Filterausdrücke dafür sind::

  host insideAddress and host addressAtPeer

  host insideAddress and net peerSideNet/mask

  net insideNet/mask and net peerSideNet/mask

  net insideNet/mask and host addressAtPeer

Bin ich nur an speziellen TCP- oder UDP-Ports interessiert, kann ich den
Filterausdruck damit ergänzen, zum Beispiel so::

  ... and tcp and port 443

Vermute ich Netzwerkprobleme auf der Inside, muss ich zusätzlich noch
den ICMP-Datenverkehr aufnehmen. Da die relevanten ICMP-Datagramme von
jedem Router auf dem Weg zum Zielhost kommen können, kann ich den
ICMP-Datenverkehr nicht einfach auf bestimmte Absenderadressen beschränken.
Ein Filterausdruck dafür könnte in etwa so aussehen::

  host addressAtPeer and ( icmp or host insideAddress )

  host addressAtPeer and ( icmp or net insideNet/mask )

  net peerSideNet/mask and ( icmp or host insideAddress )

  net peerSideNet/mask and ( icmp or net insideNet/mask )

Paketmitschnitt auf der verschlüsselten Seite
.............................................

Auf der Outside bin ich im Allgemeinen nur an der IP-Adresse des
Peer-VPN-Gateways interessiert. Normalerweise sollten alle Datagramme
hier entweder als Sender oder Empfänger die Adressse meines
VPN-Gateways haben. Darum filtere ich in erster Linie auf die
Adresse des Peer-Gateways. Lediglich, wenn ich Netzwerkprobleme zwischen
den beiden VPN-Gateways vermute, filtere ich zusätzlich auf ICMP wie bei
Inside-Traffic.

Der einfachste Filterausdruck auf der verschlüsselten Seite ist::

  host peerAddress

wobei *peerAddress* für die IP-Addresse des VPN-Gateways beim Peer
steht. Mit diesem Filter bekomme ich sowohl IKE- als auch IPsec-Traffic.
In den meisten Fällen bin ich nur am IKE-Traffic interessiert, bei
Problemen mit dem Aufbau des VPN ist das jedoch egal, da dann
noch kein ESP-Traffic vorkommt.

Vermute ich Netzwerkprobleme zwischen den beiden VPN-Gateways, so muss
ich zusätzlich ICMP-Traffic mitschneiden. Der Filterausdruck dafür kann
dann so aussehen::

  ICMP or host peerAddress

Dabei bekomme ich allerdings auch ICMP-Traffic, der sich auf andere VPNs
bezieht. Das muss ich dann bei der Auswertung berücksichtigen.

Interessant wird es, wenn ich nur IKE- oder nur ESP-Traffic
mitschneiden möchte. IKE-Traffic ist üblicherweise UDP mit Port 500.
Dafür kann ich den Filter wie folgt ergänzen::

  ... and udp and port 500

Liegt eines der beiden Gateways hinter einer NAT-Box, so dass
NAT-Traversal verwendet wird, wird es komplizierter::

  ... and udp and ( port 500 or port 4500 and udp[8:4] = 0 )

.. index:: Non-ESP-Marker

Der Ausdruck ``udp[8:4] = 0`` bezeichnet den Non-ESP-Marker, mit dem ich bei
NAT-T IKE-Traffic von ESP unterscheiden kann. Will ich den
gesamten IKE-Traffic, so muss ich sowohl UDP-Port 500 als auch 4500
mitschneiden, da bei NAT-T der Wechsel von Port 500 zu 4500 mit dem
IKE_AUTH-Exchange erfolgt.

Bei den meisten Problemen bin ich eher am IKE-Traffic als an ESP
interessiert. Wenn ich jedoch Replay- oder MTU-Probleme vermute, kann es
sinnvoll nur den ESP-Traffic zu beobachten.
Dafür kann ich die folgende Ergänzung verwenden::

  ... and esp

beziehungsweise bei NAT-T::

  ... and udp and port 4500 and udp[8:4] != 0

Welchen der beiden Ausdrücke ich nehmen muss, kann ich erkennen, indem
ich kurz sämtlichen UDP-Traffic zwischen beiden Peers mitschneide und
nachschaue, ob UDP-Port 4500 im Mitschnitt vorkommt.

Paketmitschnitte auswerten
--------------------------

Am schnellsten geht die Auswertung des Paketmitschnitts direkt auf der
Kommandozeile des Gerätes, wo er angefertigt wurde.

* Bei Cisco ASA::

    show capture nameOfCapture ...

* Bei Fortinet habe ich die Ausgabe direkt in der SSH-Sitzung, in der ich
  den Paketmitschnitt gestartet habe.

* Bei allen Geräten mit tcpdump::

    tcpdump -n -r nameOfCaptureFile ...

* Bei MikroTik::

    /tool sniffer packet print ...

Bequemer ist die Auswertung mit *Wireshark*, einem grafischen
Netzwerk-Sniffer, der umfangreiche Möglichkeiten zur Analyse eines
Mitschnitts bietet. Dafür muss ich die Datei mit dem Mitschnitt erstmal
auf meinen Rechner kopieren.

* Bei Cisco ASA benötige ich einen TFTP-Server um die PCAP-Datei zu
  kopieren::

    copy /pcap capture:nameOfCapture tftp://adress/nameOfCapture.pcap

* Bei Fortinet kann ich den Mitschnitt kopieren, wenn ich ihn in der
  grafischen Benutzeroberfläche gestartet habe (siehe
  :cite:`FortinetPacketCaptureGUI`).

* Bei den Geräten, die tcpdump verwenden, und bei MikroTik kann ich die Datei
  oft mit *scp* kopieren.

Auswertung mit tcpdump
......................

Bei der Auswertung eines Paketmitschnitts mit tcpdump verwende ich meist
den Pager *less* um in der Ausgabe bequem zu navigieren::

  tcpdump -n -r fileName [optionen] | less

Außer den Optionen ``-n`` um Adressauflösungen zu vermeiden und ``-r``
um die Datei mit dem Mitschnitt anzugeben, verwende ich je nach Bedarf
noch die folgenden Optionen:

-e   zeigt den link-level Header an,

     Diese Option verwende ich nur, wenn ich Zweifel habe, zu welchem
     Next-Hop das Datagramm gesendet wird, beziehungsweise von welchem es
     kam.

-#   zeigt eine fortlaufende Nummer vor den Datagrammen an,

     Diese Option hilft mir, ein bestimmtes Datagramm bei späteren
     Untersuchungen wiederzufinden.

-v   zeigt mehr dekodierte Informationen zu dem Datagramm an,

     Die Option ``-v`` kann ich mehrfach, bis zu dreimal, angeben um noch
     mehr Informationen aus dem Datagramm zu erhalten.

-X
-XX  zeigt den Inhalt des Datagramms in Hex und ASCII an,

     Mit zwei ``X`` wird der Link-Level-Header zusätzlich ausgegeben,
     mit einem ``X`` beginnt die Ausgabe beim IP-Header.

Auswertung mit Wireshark
........................

.. figure:: /images/wireshark-datagram-http.png
   :alt: Paketmitschnitt mit Wireshark

   Paketmitschnitt mit Wireshark

Der Bildschirm ist bei Wireshark in drei Bereiche geteilt, von denen
einer die Liste der mitgeschnittenen Datagramme enthält, einer die
Informationen über das aktuell in der Liste markierte Datagramm
und der unterste den Inhalt dieses Datagramms in Hex und ASCII.

Über den drei Bereichen ist ein Eingabefeld für einen Anzeigefilter,
mit dem ich die im obersten Bereich angezeigte Liste reduzieren kann.

Beim Einstieg in die Analyse eines Mitschnitts helfen mir zunächst die
Menüpunkte *Analyse* und *Statistics* in der Menüleiste.
Dahinter verbergen sich Auswertungen, die gerade bei umfangreichen
Mitschnitten helfen können, die interessanten Pakete schnell zu finden.

