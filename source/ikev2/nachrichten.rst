
IKEv2 Nachrichten
=================

.. index:: Exchange
   see: Exchange; Nachrichten

.. index:: Request/Response
   see: Request/Response; Nachrichten

Der gesamte Nachrichtenverkehr in IKEv2 erfolgt über den paarweisen
Austausch von Nachrichten.
Bei jedem Paar von Nachrichten spricht man von einem *Exchange*,
manchmal auch von einem *Request/Response* Paar.

.. index:: Nachrichten; initiale

Die ersten beiden Exchanges werden IKE_SA_INIT und IKE_AUTH genannt
und etablieren eine IKE SA, das heißt eine Security Association für
den nachfolgenden IKE-Nachrichtenverkehr. Alle nachfolgenden Exchanges
sind entweder vom Typ CREATE_CHILD_SA oder INFORMATIONAL.

Nachfolgend gehe ich auf alle vier Exchanges näher ein.

.. index:: ! IKE_SA_INIT
   single: Nachrichten; IKE_SA_INIT

IKE_SA_INIT
-----------

.. index:: ! IKE_AUTH
   single: Nachrichten; IKE_AUTH

IKE_AUTH
--------

.. index:: ! CREATE_CHILD_SA
   single: Nachrichten; CREATE_CHILD_SA

CREATE_CHILD_SA
---------------

.. index:: ! INFORMATIONAL
   single: Nachrichten; INFORMATIONAL

INFORMATIONAL
-------------

