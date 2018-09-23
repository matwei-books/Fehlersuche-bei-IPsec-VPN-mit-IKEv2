
Überblick
=========

Die grundlegende Architektur für IPsec-konforme Systeme ist in RFC4301
beschrieben (siehe :cite:`RFC4301`), :numref:`ipsec-overview` zeigt die
wichtigsten Komponenten von IPsec.

.. figure:: /images/ipsec-overview.png
   :alt: Übersichtsbild für IPsec
   :name: ipsec-overview

IPsec setzt sich zusammen aus drei Protokollen:

* *Internet Security Association and Key Management Protocol* (ISAKMP),
  ursprünglich beschrieben in RFC2408, das durch RFC4306 obsolet wurde,
  welches wiederum durch RFC5996 abgelöst wurde und dieses durch
  RFC7296. ISAKMP verwies bereits in RFC2408 auf IKE für den
  Schlüsselaustausch, RFC7296 beschreibt IKEv2 (siehe :cite:`RFC7296`).
  
  Seine Aufgabe ist das Aushandeln der kryptographischen Verfahren und
  Schlüssel für die Security Associations (SA).

* *Authentication Header* (AH), beschrieben in RFC4302 (siehe
  :cite:`RFC4302`) ist ein Protokoll, dass zwar die Integrität der
  übertragenen Daten schützt, aber nicht deren Vertraulichkeit.

  Ich persönlich habe das Protokoll noch nicht in der Praxis
  vorgefunden.

* *Encapsulationg Security Protocol* (ESP), beschrieben in RFC4303
  (siehe :cite:`RFC4303`) schützt sowohl die Vertraulichkeit als auch
  die Integrität der übertragenen Daten.

Alle drei Protokolle nutzen Security Associations (SA) um die
verwendeten kryptographischen Verfahren, Parameter und Schlüssel in
einer Security Association Database (SAD) abzulegen. Dabei gibt es sowohl
SA für die IKE-Sitzung, in der die Parameter ausgehandelt werden als
auch für die durch IPsec geschützten Daten.

Eine SA besteht aus einer oder mehreren Proposals die jeweils ein
Protokoll umfassen. Jedes dieser Protokolle enthält eine oder
mehrere Transforms, die ihrerseits einen kryptographischen Algorithmus
beschreiben. Ein Transform kann Attribute enthalten falls das notwendig
ist, um den kryptographischen Algorithmus komplett zu beschreiben.

In einem Datagramm wird die SA, an die der Empfänger das Datagramm
binden soll und in der er die nötigen Angaben zum Entschlüsseln findet,
durch einen *Security Parameter Index* (SPI) identifiziert.

Die Protokolle AH und ESP enthalten nur den für den Empfänger nötigen SPI
in ihrem Header. Im Datagramm-Header von IKE gibt es zwei SPI bei denen
der Empfänger den für ihn wichtigen anhand seiner Rolle im
IKE-Datenaustausch (Initiator oder Responder) bestimmt.

