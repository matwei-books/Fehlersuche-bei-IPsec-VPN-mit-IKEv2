
Überblick
=========

IPsec bietet Schutz vor Ausspähung und Veränderung für IP-Traffic.
Die grundlegende Architektur für IPsec-konforme Systeme ist in RFC4301
beschrieben (siehe :cite:`RFC4301`).
Eine IPsec-Implementation kann in einem Host arbeiten, als Security
Gateway oder als unabhängiges Gerät.

.. index:: Security Policy Database
   see: SPD; Security Policy Database

.. index:: Security Association Database
   see: SAD; Security Association Database

Der Schutz, den IPsec bietet, hängt von den Anforderungen ab, die in einer
Security Policy Database (SPD) und einer Security Association Database
(SAD) festgelegt sind.
Dabei bestimmt die SPD, welcher Traffic geschützt wird und die SAD, wie
dieser Traffic geschützt werden soll.

.. index:: Peer Authorization Database
   see: PAD; Peer Authorization Database

Eine dritte Datenbank, die Peer Authorization Database (PAD) stellt die
Verbindung her zwischen der SPD und dem Internet Security Association
Management Protokol (ISAKMP).
IKEv2 ist eine konkrete Ausprägung von ISAKMP.

.. figure:: /images/ipsec-boundary.png
   :alt: Toplevel-Prozessmodell für IPsec
   :name: ipsec-boundary

   Toplevel-Prozessmodell für IPsec

IPsec schafft eine Grenze zwischen ungeschützten und geschützten
Schnittstellen.
Datagramme, die diese Grenze überqueren, sind den Regeln der SPD
unterworfen.
Allgemein werden die Datagramme bei IPsec entweder durch IPsec
geschützt (PROTECT), verworfen (DISCARD) oder sie dürfen den
IPsec-Schutz umgehen (BYPASS).

.. todo:: SPD näher erläutern (RFC4301 pp 19-34)
   
   Dabei auf Problem mit correlated SPD entries eingehen.

IPsec kann IP-Traffic zwischen einem Paar von Hosts (a),
zwischen zwei Security-Gateways (b) oder zwischen einem Host und einem
Security-Gateway (c) schützen. Ein konformer Host muss (a) und (b)
unterstützen, ein konformes Security-Gateway muss alle drei Formen
unterstützen.

In :numref:`ipsec-boundary` verweist *Unprotected* auf eine
Schnittstelle, die gemeinhin mit der Farbe schwarz und verschlüsselten
Daten assoziiert wird. *Protected* verweist dementsprechend auf die
Farbe rot und Klartext.
Eine IPsec-Implementation kann mehrere Schnittstellen auf jeder Seite
der Grenze unterstützen.

.. raw:: latex

   \newpage

IPsec setzt sich aus drei Protokollen zusammen:

.. index:: ! Internet Security Association and Key Management Protocol
   see: ISAKMP; Internet Security Association and Key Management Protocol

* *Internet Security Association and Key Management Protocol* (ISAKMP),
  ursprünglich beschrieben in RFC2408, das durch RFC4306 obsolet wurde,
  welches wiederum durch RFC5996 abgelöst wurde und dieses durch
  RFC7296. ISAKMP verwies bereits in RFC2408 auf IKE für den
  Schlüsselaustausch, RFC7296 beschreibt IKEv2 (siehe :cite:`RFC7296`).
  
  Die Aufgabe von ISAKMP ist das Aushandeln der kryptographischen Verfahren und
  Schlüssel für die Security Associations (SA).

.. index:: ! Authentication Header
   see: AH; Authentication Header

* *Authentication Header* (AH), beschrieben in RFC4302 (siehe
  :cite:`RFC4302`) ist ein Protokoll, dass zwar die Integrität der
  übertragenen Daten schützt, aber nicht deren Vertraulichkeit.
  Ich persönlich habe das Protokoll noch nicht in der Praxis
  vorgefunden.

.. index:: ! Encapsulating Security Protocol
   see: ESP; Encapsulating Security Protocol

* *Encapsulating Security Protocol* (ESP), beschrieben in RFC4303
  (siehe :cite:`RFC4303`) schützt sowohl die Vertraulichkeit als auch
  die Integrität der übertragenen Daten.

:numref:`ipsec-overview` zeigt die wichtigsten Komponenten von IPsec.

.. figure:: /images/ipsec-overview.png
   :alt: Übersichtsbild für IPsec
   :name: ipsec-overview

   Komponenten von IPsec

Alle drei Protokolle nutzen Security Associations (SA) um die
verwendeten kryptographischen Verfahren, Parameter und Schlüssel in
einer Security Association Database (SAD) abzulegen. Dabei gibt es sowohl
SA für die IKE-Sitzung, in der die Parameter ausgehandelt werden, als
auch für die durch IPsec geschützten Daten.

Die kryptografischen Algorithmen für IKE2 beschreibt :cite:`RFC4307`,
während :cite:`RFC4305` die Anforderungen an die Implementation von
kryptografischen Algorithmen für ESP und AH beschreibt.

Eine SA besteht aus einem oder mehreren Proposals die jeweils ein
Protokoll umfassen. Jedes dieser Protokolle enthält ein oder
mehrere Transforms, die ihrerseits einen kryptographischen Algorithmus
beschreiben. Ein Transform kann Attribute enthalten, falls das notwendig
ist, um den kryptographischen Algorithmus vollständig zu beschreiben.

In einem Datagramm wird die SA, an die der Empfänger das Datagramm
binden soll und in der er die nötigen Angaben zum Entschlüsseln findet,
durch einen *Security Parameter Index* (SPI) identifiziert.

Die Protokolle AH und ESP enthalten nur den für den Empfänger nötigen SPI
in ihrem Header. Im Datagramm-Header von IKE gibt es deren zwei, bei denen
der Empfänger den für ihn wichtigen SPI anhand seiner Rolle im
IKE-Datenaustausch (Initiator oder Responder) bestimmt.

