
Hilfsmittel
===========

Testlab
-------

Ein Testlab ist nicht nur für die Fehlersuche bei VPN nützlich,
sondern allgemein bei Problemen im Netzwerk
und vor allem auch zum Lernen und Testen von neuen Lösungen
bevor ich diese aktiv in Produktionsnetzen einsetze.
Damit kann ich ein Problem nachstellen,
oder wenn ich es nicht nachstellen kann,
gezielt nach den Unterschieden
zwischen der Problem- und der Testumgebung suchen
und darüber Hinweise für die Lösung bekommen.
Außerdem kann ich es für Schulungszwecke einsetzen,
um die theoretischen Erörterungen
mit praktischen Übungen anschaulich zu machen.

Ich kann das Testlab temporär aus vorhandener Hardware zusammenstecken
oder dauerhaft mit extra dafür angeschaffter Hardware.
Es gibt Simulationssoftware wie GNS3,
mit der ich viele Problemstellungen ohne die dafür im
Produktivnetz eingesetzte Hardware untersuchen kann.
Ich kann eine solche Netzwerk-Simulation auch mit Hardware ergänzen,
deren Funktionalität sich nicht simulieren lässt.

Generell bietet ein Testlab eine Menge Vorteile:

* Ich kann Probleme unabhängig vom Produktivnetz untersuchen,
  bin damit an keine zeitlichen Einschränkungen gebunden
  und kann den Lösungsraum experimentell untersuchen,
  was nichts anderes heißt,
  als dass ich verschiedene Lösungen ausprobieren kann,
  ohne Angst haben zu müssen,
  noch mehr kaputt zu machen.

* Ich kann die Komplexität eines Problems
  auf die minimale Anzahl von beteiligten Komponenten reduzieren,
  um mir damit seine Natur klar zu machen.
  Mit diesem reduzierten Problem ist es einfacher,
  Hilfe von anderen zu bekommen.

* Für die Nachfrage in öffentlichen Foren kann ich das Problem
  mit privaten Adressen reproduzieren,
  um mir das Modifizieren der Adressen
  beim Posten von Konfigurationen, Logs oder Mitschnitten zu ersparen.

* In einem Testlab kann ich Paketmitschnitte problemlos an verschiedenen
  Stellen des Netzwerks anfertigen.

* Und insbesondere eine Software-Simulation wie GNS3 kann ich sehr
  schnell an verschiedene Problemstellungen anpassen, so dass das
  Umschalten von einem Problem auf ein anderes in einem Bruchteil der
  Zeit gelingen kann.

Dem stehen einige Nachteile gegenüber:

* So benötige ich für ein Testlab zusätzliche Ressourcen,
  die zunächst einmal nicht produktiv genutzt werden können.
  Dieses Argument reduziert sich beim Einsatz einer Simulationssoftware
  auf den reservierten Plattenplatz und den benötigten RAM
  beziehungsweise die CPU-Leistung.
  Letzteres auch nur, wenn wirklich eine Simulation läuft.

* Ich habe in einem Testlab immer ein anderes Zeitverhalten als im
  Produktiv-Netz. Auch ist der Traffic im Testlab ein ganz anderer als
  im Produktivnetz und es ist nicht trivial, ähnliche Bedingungen für
  die Untersuchung von Lastproblemen herzustellen. Das heißt, bestimmte
  Problemklassen eignen sich schlechter für die Untersuchung im Testlab.

* Insbesondere bei Simulationen muss ich neben dem geänderten
  Zeitverhalten auch mit anderen MTU rechnen und deren Einfluß auf die
  Problemlösung berücksichtigen.

* Schließlich stehen mir für eine Software-Simulation
  manchmal nicht genau die Versionen zur Verfügung,
  die ich im Produktivnetz einsetzt habe.
  Das kann ich durch eine Kombination von echter Hardware und
  Software-Simulation kompensieren, wodurch wiederum die Kosten und der
  Aufwand für das Testlab steigen.

.. index:: GNS3

GNS3
....

Trotz der möglichen Nachteile empfehle ich ein Testlab mit GNS3
für die Untersuchung von Netzwerkproblemen,
für Proof-of-Concepts oder einfach nur zum Lernen.

Es gibt verschiedene Möglichkeiten, ein Testlab mit GNS3 einzurichten.

Ein Laptop mit geeigneter CPU und genügend RAM kann bereits ausreichen,
um viele Situationen nachzustellen. Da hier sowohl das Frontend als auch
der Host, auf dem die simulierten Geräte laufen, in einem Rechner
vereint sind, ist diese Lösung - einmal eingerichtet - am bequemsten
einzusetzen.
Über einen Netzwerkanschluss und VLANs kann ich diesen
Aufbau mit externer Hardware zu komplexen Setups erweitern.

Habe ich keinen Laptop übrig, kann ich das Backend mit den VM auch auf
einer vorhandenen virtuellen Umgebung laufen lassen.
Je nachdem, ob diese Umgebung in meinem Rechenzentrum
oder auf angemieteten Servern im Internet läuft,
kann ich auch hier vielleicht externe Hardware einbringen.

Für einen Workshop hatte ich das GNS3-Backend
auf einem Einplatinenrechner (PC Engines APU)
mit genügend RAM und CPU-Leistung installiert
und nur das Frontend auf meinem Laptop.

Zum Einrichten folgt man am besten einem der vorhandenen Tutorials [#]_.
Auf dem Laptop habe ich dafür die Installation für Ubuntu herangezogen.
Für das Einrichten auf PC Engines APU
habe ich zunächst Ubuntu LTS Server installiert
und anschließend darauf die Cloud-Lösung von GNS3.
Auf dem Laptop reicht die Bedienoberfläche.

.. [#]  https://docs.gns3.com/


Bei dieser sowie bei der Cloud-Lösung muss ich darauf achten,
dass Front- und Backend immer die gleiche Software-Version haben.
Bei der kompletten Installation auf einem Laptop
sind diese automatisch auf dem gleichen Stand.

Es kann einige Probleme beim Betrieb von GNS3 geben, die sich umgehen
lassen, wenn man sie kennt.

.. index:: VNC

Bei den Konsolen von Geräten,
die mit VNC für die Konsole arbeiten,
ließen sich einige essentielle Zeichen nicht eingeben.
In diesem Fall half es, auf eine andere VNC-Viewer-Software zu wechseln.
Ist es möglich, die simulierten Geräte auf eine serielle Konsole
einzustellen, so bevorzuge ich diese,
weil dann Cut&Paste meist uneingeschränkt funktioniert.

GNS3-Simulationen interagieren via Cloud mit externen Netzen.
In einfachen Cloud-Devices
stehen die Network-Interfaces des Backend-Hosts zur Verfügung,
bei einer NAT-Cloud funktionieren nur ausgehende Verbindungen
weil alle Zugriffe auf externe Netze
hinter der Schnittstellen-Adresse verborgen sind.

Obwohl ich von GNS3-Projekten aus über die Netzwerk-Interfaces
Zugriff auf alle angeschlossenen externen Netze bekommen kann,
erreiche ich den Host selbst darüber nicht.
Dafür muss ich ein TAP-Device einrichten
und kann über dieses dann vom Host aus
mit den simulierten Geräten interagieren.
Das ist insbesondere dann wichtig,
wenn GNS3 komplett auf einem Laptop läuft und ich von diesem
beispielsweise das Web-Interface
eines der simulierten Geräte ansprechen will.

Für komplexe Simulationen mit externen Geräten verwende ich VLANs,
wobei der Ethernet-Schnittstelle,
die von der GNS3-Cloud verwendet wird, ein Trunk zugewiesen wird.
Auf einem simulierten Switch in GNS3 kann ich die VLANs trennen.

Obwohl oder gerade weil es sehr einfach ist,
an den Verbindungen zwischen den simulierten Geräten
in GNS3 Paketmitschnitte aufzunehmen, muss ich vorsichtig sein,
wenn ich den Traffic an dem Interface mitschneiden will, über das das
Frontend auf das Backend zugreift.
Wenn ich hier keinen simulierten Switch dazwischenschalte,
bekomme ich den Steuerungsverkehr von GNS3 in den Mitschnitt,
so dass ich über den Mitschnitt das Backend lahm lege,
wenn ich die Daten zu Wireshark ausleite.
Ein Switch in der Simulation trennt die Steuerdaten von
den Datagrammen an denen ich interessiert bin.

Sonde zum Injizieren von Traffic
--------------------------------

Ob ein VPN funktioniert, sieht man am besten, wenn Traffic durchgeht.
Und genau hier liegt das Problem für viele VPN-Administratoren in
größeren Netzwerkumgebungen. Sie kommen oft nicht an die Geräte heran,
die miteinander kommunizieren sollen.

Manchmal besteht die Möglichkeit, über Fernzugriff auf den Rechnern der
Anwender nach dem Rechten zu schauen.
Aber auch das reißt die Anwender aus ihrer täglichen Arbeit
und erfordert entsprechende Koordination.

Bei Cisco ASA habe ich die Möglichkeit, mit dem Befehl ``packet-tracer``
die benötigten Datagramme zu simulieren und damit auch den Aufbau des
VPN und der benötigten Child-SA zu initiieren. Allerdings wird dabei
nicht wirklich ein Datagramm hinausgeschickt, so dass ich nicht die
komplette Verbindung zum Zielrechner auf Peer-Seite testen kann.

Eine andere Möglichkeit, die sich unabhängig vom VPN-Gateway anbietet,
ist eine Sonde, die den Traffic im Netzwerk injizieren kann.
Gemeint ist ein Rechner im internen Netz meines VPN-Gateways, der in der
Lage ist, den gewünschten Traffic zu erzeugen.
Das kann ein kleiner Einplatinenrechner sein,
eine virtuelle Maschine oder ein gerade nicht benötigter Rechner.
Wichtig ist, dass auf ihm eine
geeignete Software zum Injizieren von Datagrammen installiert ist.

Ich kann damit allerdings nur Traffic testen, der aus meinem Netz zum
Netz der Peers geht und die Antworten darauf auswerten.
Für Tests in der anderen Richtung
muss der Peer den benötigten Traffic erzeugen.

Wenn ich den Test-Traffic nicht an einer Stelle einspeise,
an der der Traffic von der originalen Quelle entlangkommt,
werde ich die Antwort der Gegenseite nicht an der Sonde empfangen.
Ich muss auf Paketmitschnitte zurückgreifen,
um zu sehen, ob die richtige Antwort vom VPN zurückkommt.
Paketmitschnitte zählen aber sowieso zum Handwerkszeug
beim Netzwerk-Debugging,
Abschnitt :ref:`sect-paketmitschnitt` geht näher darauf ein.

Bei TCP-Tests werde ich zusätzlich zur Antwort aus dem VPN
vielleicht TCP-Reset-Datagramme vom echten Rechner
mit der getesteten Quell-Adresse sehen.
Das ist eine normale Reaktion.

Welche Software ist nun geeignet?

.. index:: hping3

Ich empfehle *hping3*.
Zwar lassen sich die meisten Datagramme auch mit anderen Programmen erzeugen,
doch kenne ich keines,
mit dem sich eine derartige Vielfalt von Datagrammen erzeugen lässt.
Für die Testzwecke komme ich meist mit den folgenden Optionen aus:

``-n, --numeric``:
  kein Versuch, symbolische Namen für Hostadressen aufzulösen.

``-q, --quiet``:
  es wird nichts ausgegeben außer der Zusammenfassung beim Starten und
  am Ende.

``-I $if, --interface $if``:
  gibt die Netzwerkschnittstelle ($if) vor, an der das Datagramm
  gesendet wird.

``-0, --rawip``:
  Damit sendet hping3 IP-Datagramme mit den Daten, die mit der Option
  ``--sign`` oder ``--file`` angegeben wurden.

``-1, --icmp``:
  Damit sendet hping3 ICMP-Echo-Requests. Andere Typen/Codes können mit
  ``--icmptype`` und ``--icmpcode`` spezifiziert werden.

``-2, --udp``:
  Damit sendet hping3 UDP-Datagramme an den Port 0 des Zielrechners.
  Mit ``--baseport``, ``--destport`` und ``--keep``
  kann ich die UDP-Einstellungen modifizieren.

``-a $host, --spoof $host``:
  gibt eine gefälschte Absenderadresse für das gesendete Datagramm vor.

``-H $proto, --ipproto``:
  setzt das IP-Protokoll bei Option ``-0``.

``-y, --dontfrag``:
  setzt das Don't-Fragment-IP-Flag, kann zum Testen der Path-MTU
  verwendet werden.

``--icmp*``:
  Verschiedene Optionen zum Spezifizieren der ICMP-Datagramme
  bei Verwendung von ``-1``.

``--s $port, --baseport $port``:
  setzt den Quellport des ersten Datagramms. Hping3 erhöht die
  Nummer des Quellports bei jedem Datagramm um 1, wenn nicht zusätzlich die
  Option ``--keep`` angegeben wird.

``-p $port, --destport $port``:
  setzt den Zielport (Default ist 0).

``--keep``:
  behält den angegebenen Quellport bei.

``-S, --syn``:
  setzt das SYN-Flag bei TCP.

``--tcp-mss $mss``:
  aktiviert die TCP-MSS-Option und setzt sie auf den Wert $mss.

``-d $size, --data $size``:
  gibt die Größe der Daten nach dem Protokoll-Header vor.

``-E $fname, --file $fname``:
  sendet den Inhalt der Datei $fname als Daten.

``-e $sign, --sign $sign``:
  füllt die ersten Bytes des Datenbereichs im Datagramm mit $sign.

Per Default sendet hping3 TCP-Datagramme. Um UDP-, ICMP- oder andere
IP-Datagramme zu senden, muss ich eine der Optionen ``-2``, ``-1`` oder
``-0`` verwenden.

Ich teste generell mit einem Datagramm, dass ich zur Peer-Seite schicke
und schaue im Paketmitschnitt nach, ob die Antwort meinen Erwartungen
entspricht.

Mit TCP ist das einfach.
Weil die ersten Datagramme immer gleich aussehen,
brauche ich nur die Adressen und Ports variieren.
In meinem Test-Datagramm sind nur das SYN-Flag und einige Optionen,
wie z.B. die MSS gesetzt.
Der Aufruf für hping3 sieht wie folgt aus::

   hping3 -a $saddr -p $dport -S --tcp-mss 1460 $daddr

Bei UDP-Protokollen ist es schwieriger,
weil hier der Inhalt
der Datagramme je nach Protokoll unterschiedlich aussehen muss.
Für einige Protokolle kann ich ein mitgeschnittenes Datagramm nehmen
und daraus eine Signatur für das mit hping3 gesendete Datagramm bauen.

Wenn auch das nicht geht, kann ich auf ein Anwenderprogramm
(z.B. ``host`` für DNS oder ``ntpdate`` für NTP) zurückgreifen
und die Quell-Adresse mit Netfilter modifizieren.
Dazu brauche ich umfangreiche Kenntnisse des Paketfilters
und der Adressumsetzung auf dem Sondenrechner.

