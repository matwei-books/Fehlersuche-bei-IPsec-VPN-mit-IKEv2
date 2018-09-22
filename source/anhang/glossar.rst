
Glossar
=======

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

.. index:: ! Initiator

.. _Initiator:

Initiator:
  Derjenige der beiden Peers, der die aktive IKE-SA initiiert hat. Der
  Initiator setzt das entsprechende Bit in den Flags des
  IKE-Datagrammheaders.

  Am Anfang ist der Initiator derjenige, der den IKE_SA_INIT-Request
  gesendet hat. Nach dem Rekeying derjenige, der das letzte Rekeying
  initiiert hat.

.. index:: ! Responder

Responder:
  Derjenige der beiden Peers, der auf die Requests des Initiator_
  antwortet
