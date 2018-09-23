
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

.. index:: ! Initiator

.. _Initiator:

Initiator:
  Derjenige der beiden Peers, der die aktive IKE-SA initiiert hat. Der
  Initiator setzt das entsprechende Bit in den Flags des
  IKE-Datagrammheaders.

  Am Anfang ist der Initiator derjenige, der den IKE_SA_INIT-Request
  gesendet hat. Nach dem Rekeying derjenige, der das letzte Rekeying
  initiiert hat.

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

ISAKMP:
  siehe
  :ref:`Internet Security Assiociation and Key Management Protocol <ISAKMP>`

.. index:: ! Responder

Responder:
  Derjenige der beiden Peers, der auf die Requests des Initiator_
  antwortet

SA:
  siehe :ref:`Security Association <SA>`.

.. index:: ! Security Association
   see: SA; Security Association
.. _SA:

Security Association (SA):
  Eine einseitige logische Verbindung, die für Sicherheitszwecke erzeugt
  wurde. Sämtlicher Datenverkehr, der durch eine SA geht, erfährt die
  gleiche Sicherheitsbehandlung. In IPsec werden SA durch die
  Protokolle AH, ESP beziehungsweise ESP implementiert. Zustandsdaten
  der einzelnen SA werden in der SA Database gespeichert.

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

SPI:
  siehe
  :ref:`Security Parameters Index <SPI>`.
