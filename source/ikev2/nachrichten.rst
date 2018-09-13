
IKEv2 Nachrichten
=================

Der gesamte Nachrichtenverkehr in IKEv2 erfolgt über den paarweisen
Austausch von Nachrichten.
Bei jedem Paar von Nachrichten spricht man von einem *Exchange*,
manchmal auch von einem *Request/Response* Paar.

Die ersten beiden Exchanges werden IKE_SA_INIT und IKE_AUTH genannt
und etablieren eine IKE SA, das heißt eine Security Association für
den nachfolgenden IKE-Nachrichtenverkehr. Alle nachfolgenden Exchanges
sind entweder vom Typ CREATE_CHILD_SA oder INFORMATIONAL.

Nachfolgend gehe ich auf alle vier Exchanges näher ein.

IKE_SA_INIT
-----------

IKE_AUTH
--------

CREATE_CHILD_SA
---------------

INFORMATIONAL
-------------

