
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

Path-MTU
--------

Inkompatibilität
----------------

