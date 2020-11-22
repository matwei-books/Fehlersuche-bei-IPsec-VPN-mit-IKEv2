
OSI Modell
==========

.. index:: ! OSI
   see: Open Systems Interconnections Modell; OSI
.. _OSI-Modell:

Das *Open Systems Interconnections* Modell ist nicht mehr als ein Modell.
Es gibt kein real existierendes Protokoll und keine Software
welche dieses Modell komplett abbilden.
Von daher scheint das OSI-Modell
auf den ersten Blick keinen direkten praktischen Wert zu besitzen.

Trotzdem gehe ich in jedem meiner Bücher mit Netzwerkthemen darauf ein.
Die Bedeutung des OSI-Modells liegt darin,
ein grundlegendes Verständnis
für das Zusammenspiel der real existierenden Protokolle zu entwickeln
und im besten Fall eigene Schlussfolgerungen,
die sich daraus ergeben,
ableiten zu können.

Das Modell selbst ist schnell erklärt.
Es besagt, dass die verschiedenen Funktionen, die für den Datenaustausch
zweier Systeme über ein Computernetzwerk nötig sind, auf sieben
übereinanderliegende Schichten verteilt werden können, von denen die
oberen Schichten auf die Dienste der unteren Schichten zurückgreifen, um
selbst wiederum Dienste für die darüber liegenden Schichten anzubieten.

.. raw:: latex

   \clearpage

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

Um wirklich nützlich zu sein,
brauche ich noch den Bezug zu real existierenden Protokollen,
mit denen ich in meiner täglichen Arbeit zu tun habe.

.. index:: DNS, HTTP, IP, LDAP, SMTP

Da finde ich

* Ethernet in den Schichten 1 und 2
* IPv4, IPv6 in der Schicht 3
* TCP, UDP in der Schicht 4
* DNS, HTTP, SMTP, LDAP in den Schichten 5, 6, und 7

Ein weiterer wichtiger Punkt beim OSI-Modell
ist die Austauschbarkeit der Protokolle der niedrigen Schichten,
wenn Sie die Aufgaben für höhere Dienste vergleichbar gut erfüllen.
So kann ich IP statt über Ethernet auch über Glasfaser, V24
oder andere Protokolle übertragen.
TCP und UDP laufen genauso gut über IPv4 wie über IPv6
und DNS kann ich über UDP und TCP nutzen.

.. index:: IPsec

Und IPsec, das Buch ist doch über IPsec?
Das stimmt.
IPsec habe ich hier noch nicht erwähnt,
weil es eine besondere Rolle einnimmt,
wie alle Tunnelprotokolle.

.. index:: IKE, NAT-T

IPsec bietet nach oben Dienste der Schicht 3 an,
wie IPv4 und IPv6.
Es nutzt selbst wiederum Dienste
der Schichten 3 (IPv4 oder IPv6 für AH und ESP)
und 4 (UDP für IKE und NAT-T).
Damit sollte klar sein,
dass IPsec selbst zwar einer speziellen Betrachtung bedarf,
sich bezüglich der Interaktion mit anderen Protokollen jedoch
nahtlos in das OSI-Modell einfügt.
Es bietet nach oben die gleichen Dienste an wie IP
und ist unten auf die Dienste von IP und UDP angewiesen.

.. raw:: latex

   \clearpage

.. admonition:: Wenn man das OSI-Modell außer Acht lässt

   Ein Beispiel dafür,
   was passieren kann,
   wenn man die Abhängigkeit der oberen Protokollschichten
   von den unteren
   außer Acht lässt,
   ist folgendes Problem,
   das uns mehrere Tage beschäftigte.

   Eines Tages war die VPN-Verbindung
   zwischen zwei weltweit agierenden Firmen unterbrochen,
   gemerkt hatten es zuerst die Nutzer des VPN.
   Von deren Verbindungen ausgehend
   kam man auf das nicht funktionierende VPN
   und die weitere Fehlersuche ging an uns,
   die VPN-Administratoren.

   Der Kollege der ersten Schicht bei uns,
   der an dem Problem arbeitete,
   tippte recht schnell auf ein Netzwerk-Problem
   zwischen den beiden VPN-Gateways.
   Leider konnte er niemanden überzeugen,
   sich um das Netzwerk-Problem,
   das in anderen Händen lag,
   zu kümmern.

   Der nächste Kollege ließ sich gar überreden,
   die VPN-Konfiguration zu IKEv1 zu ändern,
   "weil das vor ein paar Wochen noch funktioniert hatte".
   Möglicherweise war er von Logeinträgen irritiert,
   die die IP-Adresse des jeweils anderen VPN-Gateways zeigten.
   Das waren Logeinträge für die ausgehenden Verbindungsversuche
   und kein Beleg dafür,
   dass die Verbindung zwischen den VPN-Gateways funktionierte.

   Erst mit Paketmitschnitten,
   die auf beiden Seiten jeweils nur den lokalen Traffic anzeigten,
   und etwas Nachdruck
   konnten wir veranlassen,
   dass sich jemand
   um die IP-Verbindung zwischen den VPN-Gateways kümmert.

   Nachdem die IP-Verbindung zwischen den VPN-Gateways
   wiederhergestellt war,
   mussten wir noch die Änderung der Konfiguration zurücknehmen,
   bis alles wieder funktionierte.

   Dieser Vorfall zeigte,
   wie wichtig es ist,
   die Grundlagenthemen zu beherrschen.

   Das OSI-Modell hilft dabei, Abhängigkeiten zu verstehen,
   so dass man nicht auf halbem Wege
   bei der Fehlersuche stehen bleibt.

   Logeinträge können bei der Fehlersuche helfen,
   sie können genauso gut auch in die Irre leiten.

   Paketmitschnitte können helfen,
   zu "sehen" was wirklich im Netz passiert,
   wenn man weiß,
   wie sie zu interpretieren sind.

