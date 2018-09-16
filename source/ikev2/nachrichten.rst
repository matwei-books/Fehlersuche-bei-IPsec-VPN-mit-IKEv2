
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

Die ersten beiden Exchanges sind IKE_SA_INIT und IKE_AUTH.
Sie bilden den initialen Nachrichtenaustausch, der im einfachsten Fall
ausreichend ist, um Daten mit IPsec zu sichern.

Der IKE_SA_INIT-Exchange verhandelt die kryptografischen Parameter
sowohl für IKE selbst als auch für die erste IPsec SA, er tauscht Nonces
aus und führt den Diffie-Hellman-Austausch durch. Im Idealfall werden
dabei nur zwei Datagramme - zwei in jeder Richtung - gesendet.

Der IKE_AUTH-Exchange authentisiert die vorherigen Nachrichten, tauscht
Identitäten und Zertifikate und etabliert die erste IPsec SA.

Alle nachfolgenden Exchanges sind kryptographisch geschützt und entweder
vom Typ CREATE_CHILD_SA oder INFORMATIONAL.

Im folgenden gehe ich auf alle vier Exchanges näher ein.

.. index:: ! IKE_SA_INIT
   single: Nachrichten; IKE_SA_INIT

IKE_SA_INIT
-----------

.. image:: /images/ike-sa-init.png

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

