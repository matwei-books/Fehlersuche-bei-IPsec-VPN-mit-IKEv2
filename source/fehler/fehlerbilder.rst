
Fehlerbilder
============

Kein VPN-Tunnel
---------------

Einer der ersten Tests, wenn ich Probleme mit einem VPN-Tunnel gemeldet
bekomme, ist nachzuschauen, ob überhaupt ein VPN-Tunnel aufgebaut ist.
Damit will ich feststellen, ob überhaupt etwas funktioniert, also die
zweite Frage im Entscheidungsbaum beantworten.

Sehe ich keinen Tunnel - das heißt keine IKE-SA für das betreffende VPN
- weiß ich, dass ich tiefer graben muss.

Dabei hilft mir, zu wissen, ob es sich um ein permanentes VPN oder ein
On-Demand-VPN handelt.
Letzteres öffnet einen Tunnel nur, wenn auch interessanter Traffic dafür
da ist.

Bei beiden Tunneln kann ich testen, ob ich einen Tunnel von Hand
aufbauen kann, wenn das möglich ist.

.. note::

   Normalerweise sollte es immer möglich sein, einen VPN-Tunnel von
   jedem Peer aus aufzubauen.
   Bei On-Demand-Tunneln zum Beispiel an Cisco ASA geht der Tunnel
   aber nur auf, wenn interessanter Traffic auf der Inside ankommt.
   Hier kann ich den interessanten Traffic mit dem Befehl
   ``packet-tracer`` simulieren, so dass der Tunnel aufgeht.

   Habe ich jedoch dynamisches NAT für den Traffic im Tunnel, so dass
   mehrere Absenderadressen auf Peer-Seite auf eine Adresse bei mir
   abgebildet werden, kann ich den Tunnel nicht von meiner Seite mit
   dieser Methode öffnen, weil es keine eindeutige Zuordnung des von mir
   erzeugten oder simulierten Traffics auf eine Adresse beim Peer gibt.
   Um solche Situationen zu vermeiden, ist es besser, derartige
   Adressumsetzungen im auf der Ursprungsseite vorzunehmen.

Kann ich den Tunnel von Hand aufbauen und sehe anschließend IKE- und
IPsec-SA, kann ich mich der nächsten Frage im Entscheidungsbaum zu
wenden (Funktioniert alles?) und testen lassen, ob Traffic zwischen den
Endpunkten der VPN-Verbindung ausgetauscht werden kann.

Interessant wird es, wenn sich der Tunnel nicht öffnen lässt.
Dann schaue ich als nächstes mit einem Packet-Sniffer auf der Outside,
ob ich überhaupt Traffic vom und zum Peer-VPN-Gateway sehe, insbesondere
IKE-Traffic - das heißt, UDP Port 500 und eventuell 4500.
Sehe ich IKE-Traffic von beiden Peers und der Tunnel geht nicht auf,
muss ich die IKE-Verhandlungen debuggen.

Sehe ich nur den Traffic meines eigenen VPN-Gateways, handelt es sich
möglicherweise um ein Verbindungsproblem, das heißt ein externes
Problem, dass ich delegieren kann.
Insbesondere darf ich mich nicht dazu verleiten lassen, einen Fehler in
der VPN-Konfiguration zu suchen, wenn die IP-Verbindung zwischen den
Peers nicht funktioniert.

Ein objektives Kriterium ist meist ein Paketmitschnitt der Datagramme
vom Peer-VPN-Gateway zeigt oder eben nicht.
Die Systemprotokolle können, insbesondere unerfahrene Administratoren,
hier durchaus in die Irre führen.

.. note::

   Ich war persönlich in einen Fall involviert, der bereits vor meiner
   Schicht begann und erst nach meiner Schicht gelöst war.
   Die beteiligten Peers hatten mehrere VPN zu unterschiedlichen
   Adressen, so dass die Administratoren erfahren genug sein sollten, um
   das eigentliche Problem zu erkennen.

   Allerdings kam ihnen in die Quere, dass auf beiden Seiten etliche
   andere VPNs funktionierten und nur dieses eine nicht, so dass
   zunächst jeder von einem Problem auf der anderen Seite ausging.

   Im Paketmitschnitt war jeweils nur der abgehende Traffic zum Peer zu
   sehen, aber kein ankommender. Ein Ping oder Traceroute von dritter
   Stelle aus funktionierte hingegen für beide Peer-VPN-Gateways.

   Schließlich konnten wir einen Netzwerkadministrator überzeugen, sich
   der Sache anzunehmen. Dieser hatte Zugriff auf die VPN-Logs und
   meldete zwischendurch, dass es doch funktionieren würde, weil er
   Traffic in den Logs sah.

   Was passiert war, war dass der Netzadministrator routinemäßig die
   Logs nach den beteiligten IP-Adressan absuchte und fündig wurde, weil
   unser VPN-Gateway jeden Verbindungsversuch protokollierte und dabei
   eben die Peer-Adresse in das Log schrieb.

   Nachdem wir ihm das erklärt hatten, fand er die tatsächliche Ursache.
   Beide Unternehmen hatten mehrere ISP für ihre Internetanschlüsse,
   und es gab einen ISP der eine Verbindung zu beiden Peers hatte.
   Diesen ISP nutzten beide Peers für dieses VPN und genau im Netz
   dieses ISP liefen die Datagramme für den jeweils anderen Peer ins
   Leere.

   Die schnelle Lösung war, den VPN-Traffic nicht über diesen ISP zu
   schicken und irgendwann hatte dieser auch sein Netz wieder in Ordnung
   gebracht.

Kann ich das VPN öffnen, suche ich nach dem interessanten Traffic für
das VPN auf der Inside.
Sehe ich diesen Traffic nicht, dann muss ich mich um die Verbindung vom
VPN-Gateway zum Endpunkt im internen Netz kümmern beziehungsweise die
betreffenden Administratoren in's Boot holen.

VPN-Tunnel aber kein Traffic
----------------------------

Habe ich mich davon überzeugt, dass  IKE- und IPsec-SA (für ESP oder AH)
zum Peer aufgebaut werden, schaue ich als nächstes ob durch die
zugehörigen Tunnel auch Daten ausgetauscht werden, das heißt, ob die
Traffic-Counter hochzählen.

Stehen die Counter einige Zeit nach dem Einrichten der IPsec SA immer
noch auf 0, muss ich nachschauen, woran es liegt.

Dazu ist es nützlich, zu wissen, welche Seite die Verbindungen durch den
Tunnel aufbaut, das heißt bei TCP das erste Datagramm mit SYN-Flag
sendet. Auf dieser Seite schaue ich zuerst nach.

Kommt dieser interessante Traffic vom Peer, schaue ich mit einem
Packet-Capture auf der Outside, ob außer den IKE-Datagrammen für den
Aufbau und die Pflege des Tunnels auch ESP- oder AH-Datagramme
auftauchen.
Sehe ich diese Datagramme nicht, kann ich das Problem delegieren und den
Peer bitten, den entsprechenden Traffic zu schicken.

Sehe ich hingegen ESP- oder AH-Datagramme, kann ich auf der Inside
nachschauen, ob entsprechender unverschlüsselter Traffic herauskommt.
Das würde allerdings nicht dem aktuellen Fehlerbild entsprechen, weil
dann auch der Traffic-Counter mit Sicherheit hochzählen würde.

Kommt verschlüsselter Traffic auf der Outside an, ohne dass auf der
Inside entsprechende Datagramme hinausgehen, muss ich auf meinem
VPN-Gateway suchen, wo die Datagramme bleiben.

Eine mögliche Ursache ist, dass der SPI der ankommenden Datagramme auf
eine IPsec-SA verweist, die auf meinem VPN-Gateway nicht vorhanden ist,
so dass die Datagramme nicht entschlüsselt werden können.
In diesem Fall würde ich vermutlich eine entsprechende Meldung in den
Logs finden und im Packet-Capture eventuell IKE-Datagramme mit
INFORMATIONAL-Nachrichten, die nicht als Paar (Request und Response)
auftreten.

Ein andere mögliche Ursache ist, dass die IP-Adressen der Datagramme,
die verschlüsselt ankommen, nicht zu den Traffic-Selektoren der
betreffenden IPsec-SA passen.
In diesem Fall verwerfen etliche VPN-Gateways (z.B. Cisco ASA) die
Datagramme und schreiben einen entsprechende Meldung in das Systemlog.

Traffic nur in einer Richtung
-----------------------------
