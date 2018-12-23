
Glossar
=======

AH:
  siehe :ref:`Authentication Header <AH>`

.. index:: ! Authentication Header
   see: AH; Authentication Header
.. _AH:

Authentication Header (AH):
  Der IP Authentication Header, beschrieben in RFC4302 (siehe
  :cite:`RFC4302`) bietet verbindungslos Integrität und Authentisierung
  des Absenders von Datagrammen sowie optional Anti-Replay-Schutz wenn
  eine IPsec-SA zwischen Sender und Empfänger besteht.

.. index:: ! Beifang

Beifang:
  *Als Beifang werden in der Fischerei diejenigen Fische und andere
  Meerestiere bezeichnet, die zwar mit dem Netz oder anderen
  Massenfanggeräten gefangen werden, nicht aber das eigentliche
  Fangziel des Fischens sind. [Wikipedia]*

  Im Rahmen der Fehlersuche bezeichne ich als Beifang die Informationen,
  die ich - mehr oder weniger - unvermeidlich mit sammle, die aber nicht
  zur Lösung des Problems beitragen. Das können unvermeidbare Datagramme
  im Paketmitschnitt sein, die sich nicht beim Mitschneiden ausfiltern
  lassen, oder Logzeilen beziehungsweise Debugzeilen, die zwar das
  untersuchte VPN betreffen, aber keinen nennenswerten Aussagewert für
  die Fehlersuche haben.

.. index:: ! Child-SA
   see: IPsec SA; Child-SA
.. _Child-SA:

Child-SA:
  Als Child-SA werden die Security Associations für AH oder ESP
  bezeichnet, die im Rahmen einer IKE-Sitzung ausgehandelt werden.
  Hin und wieder wird dafür auch die Bezeichnung IPsec-SA verwendet.

.. index:: CLI

CLI:
  Die Kommandozeile (englisch: command-line interface) ist eine
  Benutzerschnittstelle, die typischerweise im Textmodus arbeitet.
  Diese Schnittstelle hat den Vorteil - wenn Kopieren und Einfügen
  funktioniert - dass Änderungen sehr einfach vorbereitet und
  dokumentiert werden können.

.. index:: ! Encapsulating Security Payload
   see: ESP; Encapsulating Security Payload
.. _ESP:

Encapsulating Security Payload (ESP):
  ESP bietet die gleichen Dienste wie :ref:`AH <AH>` und zusätzlich
  Vertraulichkeit. Diese Dienste können zwischen zwei Hosts, zwei
  Security-Gateways (VPN-Gateways) oder zwischen einem Host und einem
  Security-Gateway eingesetzt werden.

ESP:
  siehe
  :ref:`Encapsulating Security Payload <ESP>`

.. index:: ! Flow

Flow:
  Jede paketbasierte Datenübertragung, zum Beispiel mit dem Internet
  Protokoll, basiert auf Datagrammen, einzelnen Dateneinheiten, die
  Nacheinander versendet werden.
  Wenn ich von einem Flow spreche, meine ich alle Datagramme, die zu
  eine einzelnen Kommunikationsbeziehung gehören. Das umfasst neben den
  Datagrammen, die von einer Seite zur anderen gesendet werden, als auch
  die zugehörigen Antwortpakete in der Gegenrichtung.

.. index:: GUI

GUI:
  Eine graphische Benutzeroberfläche (Graphical User Interface) macht
  eine Software mit grafischen Symbolen und Steuerelementen nutzbar.
  Gut gemacht ist sie manchmal intuitiv benutzbar und insbesondere für
  weniger häufig ausgeführte Operationen vorteilhaft.

  Ein Nachteil für die Problemanalyse ist, dass die Konfiguration oft
  über mehrere Bildschirmelemente verteilt ist, die durch eine manchmal
  umständliche Navigation nur nacheinander betrachtbar sind.

.. index:: ! Initiator

.. _Initiator:

Initiator:
  Derjenige der beiden Peers, der die aktive IKE-SA initiiert hat. Der
  Initiator setzt das entsprechende Bit in den Flags des
  IKE-Datagrammheaders.

  Am Anfang ist der Initiator derjenige, der den IKE_SA_INIT-Request
  gesendet hat. Nach dem Rekeying derjenige, der das letzte Rekeying
  initiiert hat.

.. index:: ! Inside

Inside:
  In diesem Buch meint Inside die Seite eines VPN-Gateways, wo die
  Datagramme unverschlüsselt übertragen werden, das heißt in den meisten
  Fällen die dem lokalen Netzwerk zugewandte Seite.

IKE:
  siehe :ref:`Internet Key Exchange Protocol <IKE>`

.. index:: Internet Key Exchange Protocol
   see: IKE; Internet Key Exchange Protocol
.. _IKE:

Internet Key Exchange Protocol:
  IKE ist eine Komponente von IPsec und zuständig für die gegenseitige
  Authentifizierung sowie das Aufbauen und Aufrechterhalten von
  :ref:`Security Associations <SA>`.

  Version 2 von IKE (IKEv2) ist in RFC7296 beschrieben (siehe
  :cite:`RFC7296`).

.. index:: Internet Security Assiociation and Key Management Protocol
   see: ISAKMP; Internet Security Assiociation and Key Management Protocol
.. _ISAKMP:

Internet Security Assiociation and Key Management Protocol (ISAKMP):
  ISAKMP wurde ursprünglich in RFC2408 beschrieben, welches durch RFC4306
  obsolet wurde, das wiederum durch RFC5996 abgelöst wurde und dieses
  durch RFC7296.
  
  ISAKMP verwies bereits in RFC2408 auf :ref:`IKE <IKE>` für den
  Schlüsselaustausch. RFC7296 beschreibt die momentan aktuelle Version
  IKEv2 (siehe :cite:`RFC7296`).

IPsec SA:
  siehe :ref:`Child-SA <Child-SA>`

ISAKMP:
  siehe
  :ref:`Internet Security Assiociation and Key Management Protocol <ISAKMP>`

.. index:: Maximum Segment Size
   see: MSS; Maximum Segment Size

Maximum Segment Size (MSS):
  Die Maximum Segment Size kennzeichnet bei TCP die maximale Anzahl von
  Bytes, die als Nutzdaten in einem Datagramm versendet werden können.
  Sie wird zu Beginn jeder TCP-Sitzung mit den ersten beiden Datagrammen
  in zusätzlichen TCP-Optionen ausgehandelt und gilt für jeweils eine
  TCP-Verbindung.

.. index:: Maximum Transmission Unit
   see: MTU; Maximum Transmission Unit

Maximum Transmission Unit (MTU):
  Die Maximum Transmission Unit gibt die maximale Paketgröße eines
  Datagramms der Vermittlungsschicht (OSI-Ebene 3, z.B. IPv4, IPv6) an,
  die in einem Netz der Sicherungsschicht (OSI-Ebene 2, z.B. Ethernet)
  übertragen werden kann ohne es zu fragmentieren.
  Sie gilt immer nur für ein Netzsegment.

.. index:: Message ID
   see: MID; Message ID
.. _MID:

Message ID:
  Jede IKE-Nachricht enthält eine Message-ID (MID) als Teil des festen
  IKE-Headers.
  Diese Message-ID wird verwendet um Requests und Responses einander
  zuzuordnen und Nachrichtenwiederholungen zu erkennen.

MID:
  siehe :ref:`Message ID <MID>`.
  
.. index:: MSS-Clamping

MSS-Clamping:
  Mittels MSS-Clamping kann ein Router oder Gateway künstlich die
  maximale Datagrammgröße einer TCP-Sitzung beschränken um zum Beispiel
  Path-MTU-Discovery unnötig zu machen, wenn die maximale MTU im Voraus
  bekannt ist.
  Dabei wird der Wert in der TCP-Option MSS in den ersten beiden
  Datagrammen der TCP-Sitzung vom Router oder Gateway reduziert.

.. index:: Netzsegment

Netzsegment:
  Ein Netzsegment ist ein Teilnetz mit zwei oder mehreren Geräten, die
  über das selbe Element der Sicherungsschicht (OSI-Ebene 2, z.B.
  Ethernet) verbunden sind.
  Bei der Übertragung eines Datagramms vom Sender zum Empfänger ist ein
  Netzsegment die Verbindung zwischen zwei Gateways, die das Datagramm
  weiter transportieren.

.. index:: Nonce

Nonce:
  In der Kryptographie wird als "nonce" eine Zahl verstanden, die nur
  einmal verwendet wird. Mitunter ist die Sicherheit des
  kryptographischen Protokolls gefährdet, wenn die Nonce mehrfach
  verwendet wird.

.. index:: OSI

OSI:
  Das OSI-Modell ist ein Referenz-Modell für Netzwerkprotokolle als
  Schichtenarchitektur mit 7 Schichten.
  Für die Fehlersuche bei VPN sind vor allem die Schichten
  2 (Sicherung, Data Link), 3 (Vermittlung, Network) und 4 (Transport)
  relevant.

.. index:: ! Outside

Outside:
  In diesem Buch meint Outside die Seite eines VPN-Gateways, wo die
  Datagramme verschlüsselt übertragen werden, das heißt in den meisten
  Fällen die dem Internet zugewandte Seite.

.. index:: Path-MTU
   see: PMTU; Path-MTU

Path-MTU:
  Die Path-MTU ist die kleinste MTU aller Netzsegmente auf dem Weg
  zwischen dem Sender eines Datagramms und dem Empfänger.

.. index:: Path-MTU-Discovery
   see: PMTU-Discovery; Path-MTU-Discovery

Path-MTU-Discovery:
  Path-MTU-Discovery ist ein Verfahren, um die Path-MTU einer Verbindung
  zu bestimmen.
  Es funktioniert im wesentlichen so, dass der Sender verbietet, ein
  Datagramm zu fragmentieren und das erste Gateway, dass das Datagramm
  nicht ohne es zu fragmentieren weitersenden kann, in einer
  Fehlermeldung die MTU des nächsten Netzsegments mitteilt.

  Muss die maximale Datagrammgröße durch die Path-MTU-Discovery
  reduziert werden, geht das immer mit Paketverlusten einher, so dass
  die verloren gegangenen Daten vom Sender mit kleineren Datagrammen
  wiederholt werden müssen.
  Aus diesem Grund reduzieren VPN-Gateways mit MSS-Clamping automatisch
  die Datagrammgröße für TCP-Verbindungen.

.. index:: Payload

Payload:
  Bei der Datenübertragung bezeichnet Payload die Nutzdaten, die mit
  einem Protokoll zwischen zwei Partnern übertragen werden.

  Bei der Beschreibung von Protokoll-Headern, hier insbesondere der
  IKE-Header bezeichnet der Begriff Payload die Attribute, die in
  einem größeren Protokoll-Element zusammengefasst sind und und denen
  ein Protokoll-Subheader vorangestellt ist.

.. index:: Proposal

Proposal:
  Bei IKE ist ein Proposal ein Vorschlag für einen Satz von Algorithmen,
  den die eine Seite (Initiator) der anderen unterbreitet und die von
  der Gegenseite (Responder) angenommen wird oder nicht.
  Oft sendet der Initiator mehrere Proposals in seiner Anfrage, aus
  denen der Responder eines auswählt.

.. index:: QoS

QoS:
  Quality-of-Service umfasst verschiedene Massnahmen, um den
  Datendurchsatz durch ein Netzwerk zu optimieren.
  Zu diesen Maßnahmen zählt unter anderem das Umsortieren der
  Reihenfolge, in der Datagramme gesendet werden, sowie das Verwerfen
  von Datagrammen.

.. index:: ! Responder

Responder:
  Derjenige der beiden Peers, der auf die Requests des Initiator_
  antwortet

SA:
  siehe :ref:`Security Association <SA>`.

.. index:: SAD

SAD:
  In der Security Association Database werden die SA verwaltet. Diese
  bestimmen wie der im VPN übertragene Traffic verschlüsselt werden
  soll. Wenn ein IKE-, ESP- oder AH-Datagramm empfangen wird, findet der
  Empfänger die zur Entschlüsselung notwendigen Angaben in der SAD. Der
  Sender hingegen schaut in der SAD nach, wie er ein Datagramm für den
  Peer verschlüsseln muss.

  Im Gegensatz zur SPD ändert sich die SAD sehr häufig, mit jeder
  neuen SA, die ausgehandelt und jeder alten SA, die gelöscht wird.

.. index:: ! Security Association
   see: SA; Security Association
.. _SA:

Security Association (SA):
  Eine einseitige logische Verbindung, die für Sicherheitszwecke erzeugt
  wurde. Sämtlicher Datenverkehr, der durch eine SA geht, erfährt die
  gleiche Sicherheitsbehandlung. In IPsec werden SA durch die
  Protokolle AH, ESP beziehungsweise ESP implementiert. Zustandsdaten
  der einzelnen SA werden in der SA Database gespeichert.

  Die konkreten kryptographischen Algorithmen mit den eventuell nötigen
  Parametern werden in einer SA durch :ref:`Transforms <Transform>`
  beschrieben.

.. index:: ! Security Parameters Index
   see: SPI; Security Parameters Index
.. _SPI:

Security Parameters Index (SPI):
  Ein beliebiger 32-Bit-Wert, der vom Empfänger eines Datagramms benutzt
  wird, um die SA zu identifizieren an die das Datagramm gebunden werden
  soll. Ein SPI hat nur lokale Bedeutung, die vom Empfänger des
  Datagramms definiert wird.

  AH- und ESP-Datagramme enthalten jeweils einen SPI. IKE-Datagramme
  enthalten zwei SPI, hier muss der Empfänger eines Datagramms anhand
  seiner Rolle im IKE-Datenaustausch entscheiden, welcher für ihn gültig
  ist. Für Details siehe Abschnitt
  :ref:`anhang/datagram-header:IKE Header` im Anhang.

.. index:: SPD

SPD:
  In der Security Policy Database ist hinterlegt, welcher Traffic
  verschlüsselt werden soll. Sie umfasst die Peer-Gateways, die
  Access-Control-Listen, die die erlaubten Traffic-Selektoren bestimmen
  und die erlaubten Verschlüsselungsverfahren.

  Im Gegensatz zur SAD sind die Einträge in der SPD eher statisch.

SPI:
  siehe
  :ref:`Security Parameters Index <SPI>`.

.. index:: Transform
.. _Transform:

Transform:
  Ein Transform beschreibt genau einen kryptographischen Algorithmus in
  einer :ref:`Security Association <SA>`.
