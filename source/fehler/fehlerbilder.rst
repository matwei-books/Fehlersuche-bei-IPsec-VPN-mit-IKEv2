
Fehlerbilder
============

Kein VPN-Tunnel
---------------

Wenn ich Probleme mit einem VPN gemeldet bekomme,
ist einer der ersten Tests,
nachzuschauen,
ob ein Tunnel aufgebaut ist.
Damit will ich feststellen, ob überhaupt etwas funktioniert,
also die zweite Frage aus dem Entscheidungsbaum beantworten.

Sehe ich keinen Tunnel - das heißt keine IKE-SA für das betreffende VPN
- weiß ich, dass ich tiefer graben muss.

Dabei unterscheide ich,
zwischen permanenten VPN und On-Demand-VPN.
Letztere öffnen einen Tunnel nur,
wenn interessanter Traffic dafür da ist.
Bei beiden Arten von Tunneln teste ich,
ob ich sie von Hand aufbauen kann, wenn das möglich ist.

In den meisten Fällen sollte es möglich sein, einen VPN-Tunnel von
jedem Peer aus aufzubauen.
Bei On-Demand-Tunneln an Cisco ASA geht der Tunnel aber nur auf,
wenn interessanter Traffic auf der Inside ankommt.
Hier kann ich diesen Traffic mit dem Befehl ``packet-tracer`` simulieren.
Bei anderer Software und policy-basierten VPN kann ich mitunter
temporär eine Adresse aus dem lokalen Adressbereich des Tunnels
auf das VPN-Gateway legen
und den Traffic mit PING und eben dieser Quelladresse erzeugen.
Diese Adresse konfiguriere ich mit 32 beziehungsweise 128 Bit Netzmaske
um den restlichen Datenverkehr nicht zu stören.

Habe ich jedoch dynamisches NAT für den Traffic im Tunnel, so dass
mehrere Absenderadressen auf Peer-Seite auf eine Adresse bei mir
abgebildet werden, kann ich den Tunnel nicht von meiner Seite mit
dieser Methode öffnen, weil es keine eindeutige Zuordnung des von mir
erzeugten oder simulierten Traffics auf eine Adresse beim Peer gibt.
Um solche Situationen zu vermeiden, ist es besser,
solche Adressumsetzungen auf der Ursprungsseite vorzunehmen.

Kann ich den Tunnel von Hand aufbauen
und sehe anschließend IKE- und IPsec-SA,
kann ich mich der nächsten Frage im Entscheidungsbaum zuwenden
(Funktioniert alles?) und testen lassen,
ob Traffic zwischen den Endpunkten ausgetauscht werden kann.

.. index:: Outside

Interessant wird es, wenn sich der Tunnel nicht öffnen lässt.
Dann schaue ich als nächstes mit einem Paketmitschnitt auf der Outside,
ob ich überhaupt Traffic vom und zum Peer-VPN-Gateway sehe,
insbesondere IKE-Traffic - das heißt, UDP Port 500 oder 4500.
Sehe ich IKE-Traffic von beiden Peers und der Tunnel geht nicht auf,
muss ich die IKE-Verhandlungen analysieren.

Sehe ich nur den Traffic meines eigenen VPN-Gateways, handelt es sich
möglicherweise um ein Verbindungsproblem, das heißt ein externes
Problem, dass ich delegieren kann.
Um das auszuschließen,
bitte ich den Peer,
auf seiner Outside ebenfalls einen Paketmitschnitt zu machen
und nach Datagrammen von meinem VPN-Gateway Ausschau zu halten.

Insbesondere darf ich mich nicht dazu verleiten lassen, einen Fehler in
der VPN-Konfiguration zu suchen, wenn die IP-Verbindung zwischen den
Peers nicht funktioniert.
Nur ein Paketmitschnitt,
der Datagramme von beiden VPN-Gateways zeigt,
ist für mich ein objektives Kriterium.
Die Systemprotokolle können unerfahrene Administratoren
hier durchaus in die Irre führen.

Funktioniert die IP-Verbindung zwischen den VPN-Peers,
aber der Responder antwortet nicht auf Verbindungsversuche vom Peer,
dann ist die Fehlersuche auf der Seite des Responders einfacher.
Hier gilt es als nächstes,
die vom Peer bei IKE_SA_INIT gesendeten Parameter
mit der eigenen Konfiguration zu vergleichen.
Dazu reichen die Daten aus dem Paketmitschnitt.

Kann ich das VPN aufbauen,
suche ich nach dem interessanten Traffic auf der Inside.
Sehe ich diesen Traffic nicht, dann muss ich mich um die Verbindung vom
VPN-Gateway zum Endpunkt im internen Netz kümmern beziehungsweise die
betreffenden Administratoren ins Boot holen.

VPN-Tunnel aber kein Traffic
----------------------------

Habe ich mich davon überzeugt,
dass  IKE- und IPsec-SA zum Peer aufgebaut werden,
schaue ich als nächstes,
ob Daten durch die zugehörigen Tunnel gehen,
das heißt, ob die Traffic-Counter hochzählen.
Stehen die Counter einige Zeit nach dem Einrichten der IPsec SA immer
noch auf 0, muss ich nachschauen, woran es liegt.

Dazu ist es nützlich, zu wissen, welche Seite die Verbindungen durch den
Tunnel aufbaut, das heißt bei TCP, welche Seite das erste Datagramm mit
SYN-Flag sendet.
Auf dieser Seite schaue ich zuerst nach.

.. index:: Outside

Kommt dieser Traffic vom Peer, schaue ich zunächst mit einem
Paketmitschnitt auf der Outside, ob außer den IKE-Datagrammen für den
Aufbau und die Pflege des Tunnels auch ESP- oder AH-Datagramme
auftauchen.
Sehe ich diese Datagramme nicht, kann ich das Problem delegieren und den
Peer bitten, den entsprechenden Traffic zu schicken.

Sehe ich hingegen ESP- oder AH-Datagramme, kann ich auf der Inside
nachschauen, ob entsprechender Traffic herauskommt.
Das würde allerdings nicht dem aktuellen Fehlerbild entsprechen, weil
dann auch der Traffic-Counter mit Sicherheit hochzählen würde.

Kommt verschlüsselter Traffic auf der Outside an, ohne dass auf der
Inside entsprechende Datagramme hinausgehen, muss ich auf meinem
VPN-Gateway suchen, wo die Datagramme bleiben.

Eine mögliche Ursache ist, dass der SPI der ankommenden Datagramme auf
eine IPsec-SA verweist, die auf meinem VPN-Gateway nicht vorhanden ist,
so dass die Datagramme nicht entschlüsselt werden können.
In diesem Fall würde ich vermutlich
eine passende Meldung in den Logs finden
und im Paketmitschnitt eventuell INFORMATIONAL-Nachrichten,
die nicht als Paar (Request und Response) auftreten.

Ein andere mögliche Ursache ist, dass die IP-Adressen der Datagramme,
die verschlüsselt ankommen, nicht zu den Traffic-Selektoren der
betreffenden IPsec-SA passen.
In diesem Fall verwerfen etliche VPN-Gateways die Datagramme
und schreiben eine entsprechende Meldung in das Systemlog,
die mich auf dieses Problem hinweist.

Finde ich keine Erklärung,
warum der verschlüsselt ankommende Traffic mein VPN-Gateway
nicht auf der anderen Seite verlässt,
wird es Zeit,
das Problem zu Eskalieren
und mir Hilfe zu holen.

.. index:: Inside

Erwarte ich hingegen das erste Datagramm,
dass die Verbindung aufbaut,
auf der Inside,
prüfe ich zuerst dort mit einem Paketmitschnitt,
ob es auch wirklich ankommt.
Kommt es nicht, handelt es sich um
ein - aus meiner Sicht - externes Problem,
dass ich delegieren kann,
wenn ich nicht selbst auch für das interne Netz zuständig bin.

Sehe ich den Traffic auf der Inside ankommen, aber keinen adäquaten
verschlüsselten Traffic auf der Outside abgehen, muss ich die
Konfiguration meines VPN-Gateways noch einmal genau prüfen.

.. raw:: latex

   \clearpage

Dabei muss ich auch eventuell vorhandene Adressumsetzungen berücksichtigen.
In einem konkreten Fall war das VPN-Gateway gleichzeitig
auch Default-Gateway für ein kleines Netz und verbarg die internen
Adressen durch Masquerading hinter einer externen Adresse.
Das VPN sollte das interne Netz hingegen direkt, das heißt ohne NAT mit
einem anderen Netz verbinden.
Durch das Masquerading passte die Absenderadresse der Datagramme
nicht mehr zur Policy
und die Datagramme wurden direkt und unverschlüsselt nach außen gesendet
anstatt durch das VPN.
Das hatte ich erst bemerkt,
als ich nicht mehr nur verschlüsseltem Traffic auf der Outside suchte,
sondern zusätzlich den originalen Traffik von der Inside.
Diesen fand ich dann mit den durch NAT umgesetzten Adressen.

Auch alte, nicht mehr verwendete Policies können ein VPN stören.
Einmal hatte ich eine Policy für ein VPN,
dass ersetzt werden sollte,
noch nicht deaktiviert.
Der Traffic sollte über ein geroutetes Interface in einem anderen VPN gehen
und kam auch darüber an,
passierte aber nicht das VPN-Gateway.
In diesem Fall reklamierte die alte Policy den Traffic für sich.
Da das zur alten Policy gehörende VPN aber nicht aufgebaut war,
verwarf das VPN-Gateway den Traffic.
Nach dem Deaktivieren der alten Policy funktionierte die Verbindung sofort.

.. index:: Inside

Bei der Cisco ASA kann ich den Traffic, der auf der Inside ankommen soll,
mit dem Befehl ``packet-tracer`` simulieren, und bekomme dann die einzelnen
Phasen angezeigt, die ein Datagramm von Inside nach Outside durchläuft.
Auch diese können einen Hinweis auf die Stelle geben,
an der ich genauer hinschauen sollte.

.. index:: grep, less

Generell ist es von Vorteil, wenn mir die VPN-Konfiguration zur Prüfung
als Text vorliegt, weil ich darin mit einem guten Editor oder auch schon
mit dem Pager *less* sehr gut navigieren kann und interessante Stellen
schnell finde.
Auch eine Suche mit *grep* fördert oft interessante Erkenntnisse aus
einer Konfiguration in Textform zutage.

Finde ich trotz allem keinen Hinweis, warum der Traffic nicht durch das
VPN-Gateway geht, muss ich mir Hilfe holen und das Problem eskalieren.

Traffic nur in einer Richtung
-----------------------------

Sehe ich IKE- und Child-SA mit Traffic, wobei der Traffic-Counter nur in
einer Richtung hochzählt, kann ich in den meisten Fällen davon ausgehen,
dass die VPN-Konfiguration in Ordnung ist.

Trotzdem muss ich mich vergewissern,
dass gezählter ankommender Traffic auch wirklich mein VPN-Gateway verlässt.
Das heißt,
ich schaue mit einem Paketmitschnitt auf der Inside oder Outside nach,
ob ich dort Klartext- oder verschlüsselte Datagramme
in der passenden Anzahl abgehen sehe.
Bei dieser Gelegenheit sehe ich auch, ob auf der gleichen Seite
passende Datagramme in der Gegenrichtung ankommen.

Kommen keine Datagramme in der Gegenrichtung an,
kann ich das Problem delegieren,
es liegt in der Richtung,
aus der diese Datagramme kommen müssten.

Sehe ich allerdings Datagramme in der Gegenrichtung, muss ich mein
VPN-Gateway untersuchen.
Dazu muss ich den Debug-Level soweit hochdrehen, bis Hinweise auf die
ankommenden Datagramme ausgegeben werden.
Das erzeugt im Allgemeinen sehr viel Text, den ich mit einem guten
Editor, mit *less* oder mit im Laufe der Zeit entstandenen Skripten
auswerten kann.

Kommen die Datagramme verschlüsselt vom VPN-Peer,
kann ich nachschauen,
ob ich eine zum Datagramm passende SA in der SAD finde.
Die SA, die ich suche, steht als SPI vorn im ESP- oder AH-Header.

.. index:: ACL

Kommen die Datagramme auf der Inside, kann ich die Konfiguration nach
ACL, NAT- und Firewall-Regeln absuchen, die die Adressen des Datagramms
umfassen und dabei immer größere Netzmasken betrachten. Finde ich
mehrere Regeln, muss ich die Reihenfolge betrachten,
in der diese Regeln wirksam werden.

VPN funktioniert, aber Dateitransfer nicht
------------------------------------------

Ein Problem, dass eher selten auftritt,
bei dem es beim ersten mal vielleicht etwas Mühe macht,
die Ursache zu erkennen, ist das folgende:
Beim Test des VPNs "funktioniert" scheinbar alles, alle Child-SA gehen
auf, die Testverbindungen zu den Endsystemen funktionieren.
Trotzdem melden die Anwender, dass manchmal oder immer bei bestimmten
Aktionen die Verbindung hängt oder gar abbricht.

Schaut man sich die Verbindungen im Paketmitschnitt an, sieht
oberflächlich alles in Ordnung aus.

Tatsächlich unterscheiden sich die Captures in einem wesentlichen Punkt,
abhängig davon,
auf welcher Seite man die Datagramme mitschneidet.
Auf einer Seite gehen große Datagramme in das VPN hinein,
werden aber vom Peer nicht beantwortet.
Beim Peer kommen eben diese großen Datagramme nicht an,
nicht einmal verschlüsselt auf der Outside.

Der eine oder andere wird sich jetzt vielleicht denken, worum es geht.
Das Problem in dieser Situation ist oft,
dass den VPN-Administratoren beider Seiten
zunächst nur einer dieser beiden Paketmitschnitte zur Verfügung steht.
Am ehesten kommt man auf die richtige Idee,
wenn man dann den Mitschnitt mit dem großen Datagramm hat.

Das Problem ist,
dass die Path-MTU zwischen beiden Gateways zu klein ist
für die großen Datagramme,
so dass diese nicht beim anderen Peer ankommen.
An einer Stelle im Netz zwischen den beiden VPN-Gateways
ist die MTU kleiner als unmittelbar an den Geräten selbst.

.. index:: ICMP

Normalerweise würde Path-MTU-Discovery das Problem entschärfen.
Wenn diese nicht funktioniert,
kommen folgende Ursachen in Betracht:

1. Die ICMP-Fehlermeldungen gelangen nicht zum VPN-Gateway, das die
   großen Datagramme sendet.

   Das kann ich mit einem Paketmitschnitt an der Outside überprüfen,
   indem ich nach ICMP-Datagrammen vom Typ 3, Code 4
   (Fragmentierung nötig, Don’t Fragment aber gesetzt) filtere.

2. Die ICMP-Fehlermeldungen kommen an der Outside an,
   aber das VPN-Gateway übersetzt sie nicht
   für den Datenstrom auf der Inside.

   Das kann ich mit einem Paketmitschnitt an der Inside auf die gleiche
   Art wie in Punkt 1. überprüfen.

3. Das VPN-Gateway setzt die ICMP-Nachrichten um, aber diese kommen
   nicht beim Endgerät an.

   Das kann ich mit einem Paketmitschnitt am Endgerät verifizieren.

4. Die Host-Firewall des Endgerätes verwirft die ICMP-Nachrichten.

   Das kann ich durch temporäres Abschalten der Host-Firewall
   verifizieren.
   
Am passiven Ende des VPNs, also auf der Seite, wo die großen Datagramme
nicht ankommen, kann ich nicht viel machen.
Da aber jede der beiden Seiten prinzipiell große Datagramme senden kann,
kann ich obige Prüfungen auch hier vornehmen, wenn ich große Datagramme
(zum Beispiel mit PING) in das VPN sende.

Auf der aktiven Seite prüfe ich die vier genannten Punkte,
um Path-MTU-Discovery wieder gangbar zu machen,
wenn das möglich ist.

Bei Punkt 1 kann ich nur etwas machen, wenn ich Einfluß auf die Stelle
nehmen kann, an der die ICMP-Datagramme verworfen oder gar nicht erst
generiert werden.
Verworfen werden sie meist von einem Paketfilter, den ein übereifriger
unerfahrener Administrator zu eng eingestellt hat.
Hier habe ich manchmal die Chance, Einfluss zu nehmen, wenn der
Paketfilter meiner Organisation gehört.
Generiert werden die ICMP-Nachrichten üblicherweise von dem Router oder
Gateway, an dessen abgehendem Interface die MTU kleiner ist als das
angekommene Datagramm.
Dieses Gateway lässt sich eventuell mit Traceroute und Ping ermitteln.

Bei Punkt 2 muss ich vielleicht die Konfiguration meines VPN-Gateways
ändern oder eine neuere Software-Version einspielen.
Gegebenenfalls muss ich mich beim Hersteller erkundigen.
Prinzipiell ist es möglich,
aus dem mit der ICMP-Fehlermeldung gesendeten Anfang des Datagramms
die zugehörige SA zu ermitteln,
die Parameter dieser SA anzupassen
und beim nächsten großen Datagramm
eine ICMP-Fehlermeldung für den Sender auf der Inside zu generieren.
Allerdings unterstützt das nicht jede IPsec-Software in jeder Version
und manchmal ist das Feature auch deaktiviert.

Ich muss beim Überprüfen immer im Hinterkopf behalten,
dass die ICMP-Fehlermeldung auf der Inside
erst nach dem zweiten großen Datagramm kommt,
weil das erste bereits weg ist,
bevor die Parameter der SA angepasst werden.

Punkt 3 behandele ich ähnlich wie Punkt 1,
hier habe ich vielleicht eher eine Chance,
Einfluss auf die Konfiguration des betreffenden Paketfilters zu nehmen.

Bei Punkt 4 gehört eine geeignete Ausnahmeregel auf die Host-Firewall.

.. topic:: Smart MTU Black Hole Detection

   .. index:: ICMP Black Hole

   RFC4821 schlägt einen Mechanismus vor,
   mit dem ICMP Black Holes,
   also das Problem der fehlenden ICMP-Benachrichtigungen,
   entdeckt und die MTU intelligent herabgesetzt werden kann.

   Dieser RFC ist von 2007
   und moderne Betriebssysteme sollten das können.
   Manchmal muss das Verfahren jedoch erst am Endgerät aktiviert werden.

.. raw:: latex
   
   \newpage

.. index:: ! MSS-Clamping

Kann ich Path-MTU-Discovery nicht reparieren, bleiben mir noch zwei
Möglichkeiten:

a) Für TCP-Verbindungen kann ich mit MSS-Clamping die maximale
   Größe der Datagramme beschränken.

   Das VPN-Gateway macht sowieso automatisch MSS-Clamping um den
   Protokoll-Overhead für IPsec zu berücksichtigen.
   Diesen automatisch eingestellten Wert müsste ich per Konfiguration
   noch kleiner machen.

b) An den Endgeräten kann ich die MTU des entsprechenden
   Netzwerk-Interfaces reduzieren.
   Das wirkt sich allerdings auf alle Datenübertragungen des Endgerätes
   aus und sollte nur als allerletztes Mittel verwendet werden.

Beide Möglichkeiten führen auch für andere Verbindungen zu einem
ungünstigeren Verhältnis von Nutzdaten zu Protokoll-Overhead.

.. topic:: MSS-Clamping

   MSS-Clamping ist ein Verfahren,
   um die maximale Datagrammgröße einer Verbindung einzuschränken,
   indem es der Gegenseite eine geringere Maximum Segment Size übermittelt.
   MSS-Clamping funktioniert nur für TCP
   und muss für jede einzelne Verbindung
   bei deren Start angewendet werden.

   .. index:: ! Maximum Segment Size
      see: MSS; Maximum Segment Size

   Die Maximum Segment Size ist ein Parameter
   bei den optionalen Feldern im TCP-Header,
   der die maximale Anzahl von Bytes angibt,
   die ein Computer in einem einzelnen TCP-Segment,
   das heißt in einem Datagramm,
   empfangen kann.
   Diese Option wird beim Aufbau der TCP-Verbindung gesendet
   und ist für die gesamte Verbindung gültig.

   In den ersten beiden Datagrammen der TCP-Sitzung
   wird das Feld MSS vom Router oder Gateway reduziert,
   so dass die beteiligten Rechner keine Datagramme
   mit einer Nutzlast größer als die angegebene MSS senden.
   Dabei wird die MSS auf den Wert der kleinsten MTU
   abzüglich der Größe von IP- und TCP-Header gesetzt.
   VPN-Gateways ziehen zusätzlich den Overhead
   für die Verschlüsselung ab.

