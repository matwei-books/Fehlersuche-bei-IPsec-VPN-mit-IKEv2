
.. _appendix-datagramm-header:

Datagramm-Header
================

Die genaue Kenntnis der Datagramm-Header und Strukturen ist mit
den bei Wireshark, tcpdump oder der Cisco ASA vorhandenen
Dissektoren nicht unbedingt nötig.
Mir hilft sie einerseits,
zu verstehen,
in welchem Datagramm ich welche Information wo erwarten kann,
und andererseits,
die Debugmeldungen zu interpretieren,
wenn ich bei einer Fehlersuche darauf zurückgreife.

.. index:: IKE, UDP
   single: Datagramm-Header; IKE

IKE Header
----------

IKE-Nachrichten verwenden UDP-Port 500 oder 4500.
Dabei werden die Informationen vom Beginn des Datagramms bis
einschließlich des UDP-Headers weitgehend ignoriert. Lediglich die
Quell- und Zieladressen und Quell- und Zielports werden für das
Antwort-Datagramm (Response) vertauscht.


.. index:: ! Non-ESP-Marker, NAT-T

UDP-Port 4500 kommt bei NAT-Traversal zur Anwendung.
In diesem Fall
werden zwischen den UDP- und den IKE-Header vier Oktetts mit dem Wert 0
eingefügt. Diese vier Oktetts - auch Non-ESP-Marker genannt - dienen
dazu, IKE-Nachrichten von IPsec-Datagrammen bei NAT-Traversal zu
unterscheiden.

:numref:`ipsec-ike-datagram` zeigt den den IKEv2-Header
ohne vorangehenden UDP-Header und Non-ESP-Marker.

.. raw:: latex

   \clearpage

.. figure:: /images/ipsec-ike-datagram.png
   :alt: IKEv2-Header aus RFC 7296, Abschnitt 3.1
   :name: ipsec-ike-datagram

   IKE Header

.. index:: Initiator, Responder, SA, SPI

Die Felder haben die folgende Bedeutung:

Initiator’s SPI (8 Oktetts):
  wird vom Initiator gewählt um eine IKE SA eindeutig zu identifizieren.
  Dieser Wert darf nicht Null sein.

Responder’s SPI (8 Oktetts):
  wird vom Responder gewählt um eine IKE SA eindeutig zu identifizieren.
  Dieser Wert muss
  im ersten Datagramm eines IKE_SA_INIT-Austauschs Null sein
  (auch, wenn diese Nachricht wiederholt wird).

Next Payload (1 Oktett):
  zeigt den Typ des Headers an, der diesem Header unmittelbar folgt.

Major Version (4 Bits):
  zeigt die Hauptversion des verwendeten IKE-Protokolls an.
  Anwendungen, die diese Version von IKE implementieren,
  müssen das Feld auf den Wert 2 setzen.
  Nachrichten mit einer größeren Versionsnummer müssen von Anwendungen,
  die nur Version 2 implementieren,
  ignoriert
  oder mit einer INVALID_MAJOR_VERSION-Nachricht zurückgewiesen werden.

Minor Version (4 Bits):
  zeigt die Unterversion des verwendeten Protokolls an.
  Anwendungen, die IKEv2 implementieren,
  müssen die Unterversion auf 0 setzen
  und in empfangenen Nachrichten ignorieren.

.. index:: IKE_SA_INIT, IKE_AUTH, CREATE_CHILD_SA, INFORMATIONAL

Exchange Type (1 Oktett):
  zeigt den Typ der Nachrichten an.
  Die erlaubten Werte nach RFC 7296 sind:

  =============== ====
  Exchange Typ    Wert
  =============== ====
  IKE_SA_INIT     34
  IKE_AUTH        35
  CREATE_CHILD_SA 36
  INFORMATIONAL   37
  =============== ====

  Die aktuell gültigen Werte finden sich bei der IANA :cite:`IKEv2parameters`.

.. index::
   single: Rekeying; Initiator-Flag

Flags (1 Oktett):
  zeigt spezifische Optionen für diese Nachricht an.
  Die Bits haben folgende Bedeutung: |ipsec-ike-datagram-options|

  * R (Response) - Das Bit zeigt an, das es sich um eine Antwort auf
    eine Nachricht mit der gleichen MID handelt. Dieses Bit muss in
    allen Anfragenachrichten (Request) gelöscht und in den Antworten
    gesetzt sein.
  * V (Version) - Das Bit zeigt an, dass der Sender des Datagramms
    auch eine höhere Hauptversion von IKE verwenden kann.
    Implementationen von IKEv2 müssen dieses Bit beim Senden löschen
    und beim Empfangen ignorieren.
  * I (Initiator) - Dieses Bit muss in Nachrichten vom ursprünglichen
    Initiator der IKE SA gesetzt und in Nachrichten vom
    ursprünglichen Responder gelöscht sein. Es wird vom Empfänger
    verwendet, um zu bestimmen, welche der SPI-Oktetts von ihm
    erzeugt wurden. Dieses Bit kann sich beim Rekeying ändern,
    um anzuzeigen, wer das letzte Rekeying initiiert hat.

  Das heißt,
  aus den Flags kann ich erkennen,
  welcher Peer die IKE-Sitzung initiiert hat
  beziehungsweise nach einem Rekeying,
  welcher Peer das Rekeying veranlasst hat.

.. index:: MID
   see: Message-ID; MID

Message-ID (4 Oktetts, unsigned Integer):
  wird verwendet, um das
  erneute Übertragen von verlorenen Datagrammen zu steuern und die
  Anfragen und Antworten zuzuordnen. Die Message-ID (MID) ist
  wesentlich für die Sicherheit des Protokolls, weil sie hilft
  Replay-Attacken zu verhindern.

Length (4 Oktetts, unsigned Integer):
  Gesamtlänge der Nachricht (Header + Nutzlast) in Oktetts.

.. |ipsec-ike-datagram-options| image:: /images/ipsec-ike-datagram-options.png
   :scale: 40 %
   :align: middle
   
.. .. raw:: latex

   \clearpage

Generic Payload Header
----------------------

.. index:: Datagramm-Header; Generic Payload Header

.. index:: ! Payload

Bei der Beschreibung von Protokoll-Headern
bezeichnet eine Payload Attribute,
die in einem Protokoll-Element zusammengefasst sind
und denen ein Protokoll-Header vorangestellt ist.
Bei der Datenübertragung hingegen
sind mit Payload die Nutzdaten gemeint,
die zwischen zwei Partnern mit einem Protokoll übertragen werden.
Daher ist es wichtig den Kontext zu beachten,
in dem dieser Begriff verwendet wird.

Jede IKE-Payload beginnt mit einem generischen Header wie in
:numref:`ipsec-ike-datagram-gph` dessen Felder ich nachfolgend
erläutere. Die konkreten IKE-Parameter sind als Payload in den
Abschnitten 3.2 bis 3.16 von RFC 7296 :cite:`RFC7296` beschrieben.
Die aktuell gültigen Werte für alle IKEv2-Parameter
finden sich bei der IANA :cite:`IKEv2parameters`.

.. figure:: /images/ipsec-ike-datagram-gph.png
   :alt: IKEv2 Generic Payload Header aus RFC 7296, Abschnitt 3.2
   :name: ipsec-ike-datagram-gph

   IKEv2 Generic Payload Header aus RFC 7296

Next Payload (1 Oktett):
  identifiziert den Datentyp der nächsten Payload,
  bei der letzten ist dieses Feld 0.
  
  Damit können Payloads verkettet werden indem eine zusätzliche
  Payload an das Ende der Nachricht gehängt und vom bis dahin letzten
  Payload Header referenziert wird. Eine Ausnahme davon ist eine
  verschlüsselte Payload, die immer als letzte in der Kette eingefügt
  werden muss.

  Eine verschlüsselte Payload enthält selbst wiederum
  Datenstrukturen in Form von Payloads mit generischen Payload Headern.
  Hier verweist das Feld *Next Payload* auf den Typ
  der ersten enthaltenen Payload und das *Next Payload* Feld der
  letzten enthaltenen Payload ist 0.

  Payload-Typen 1-31 sollen auch in Zukunft nicht verwendet werden, so
  dass es keine Überschneidung mit IKEv1 gibt.

  Die Payload-Typen nach RFC 7296 (beschrieben in Abschnitt 3.2 bis 3.16)
  und RFC 7383 sind:

  .. index:: EAP, Nonce, SA

  ==================================== ======== =====
  Next Payload Type                    Notation Value
  ==================================== ======== =====
  No Next Payload                               0
  Security Association                 SA       33
  Key Exchange                         KE       34
  Identification - Initiator           IDi      35
  Identification - Responder           IDr      36
  Certificate                          CERT     37
  Certificate Request                  CERTREQ  38
  Authentication                       AUTH     39
  Nonce                                Ni, Nr   40
  Notify                               N        41
  Delete                               D        42
  Vendor ID                            V        43
  Traffic Selector - Initiator         TSi      44
  Traffic Selector - Responder         TSr      45
  Encrypted and Authenticated          SK       46
  Configuration                        CP       47
  Extensible Authentication            EAP      48
  Encrypted and Authenticated Fragment SKF      53
  ==================================== ======== =====
  
Critical (1 Bit):
   bezieht sich auf die aktuelle Payload und hat folgende Bedeutung:

  Der Sender muss das Feld auf 0 setzen, wenn der Empfänger die Payload
  überspringen soll, wenn er sie nicht versteht. Wenn der Empfänger die
  ganze Nachricht zurückweisen soll weil er sie nicht versteht, muss der
  Sender das Feld auf 1 setzen.

  Der Empfänger ignoriert das Feld, wenn er den Typcode der Payload
  versteht. Wenn er eine Payload ignoriert, geht er davon aus,
  dass die Felder *Next Payload* und *Payload Length* gültige Werte enthalten.

RESERVED (7 Bits):
  Müssen mit Wert 0 gesendet
  und beim Empfang einer Nachricht ignoriert werden.

Payload Length (2 Oktetts, unsigned Integer):
  Länge in Oktetts der aktuellen Payload inklusive des Payload Headers.

.. index:: ! SA-Payload
   see: Security Association Payload; SA-Payload

Security Association Payload
----------------------------

.. index:: IKE
   single: Datagramm-Header; Security Association Payload

Mit der Security Association Payload (SA-Payload) werden die Attribute einer SA ausgehandelt.
Sie kann mehrere Proposals enthalten.
Tut sie es, müssen diese vom bevorzugten zum unbeliebtesten Proposal sortiert sein.
Jedes Proposal enthält genau ein IPsec-Protokoll (IKE, ESP oder AH), jedes Protokoll kann mehrere Transforms enthalten und jedes Transform mehrere Attribute.
Proposals, Transforms und Attribute haben - wie die Payload selbst - ihre eigene Struktur mit variabler Länge.
Sie sind verschachtelt, so dass die Payload-Length einer SA den gesamten Umfang der Proposals, Transforms und Attribute umfasst.
Die Länge eines Proposals umfasst die Länge aller enthaltenen Transforms und Attribute.
Die Länge eines Transforms umfasst die Länge aller enthaltenen Attribute.
In RFC 7296 :cite:`RFC7296`, Abschnitt 3.3 ist die SA-Payload ausführlich
beschrieben.

.. figure:: /images/ipsec-sa-payload.png
   :alt: SA-Payload aus RFC 7296, Abschnitt 3.3
   :name: ipsec-sa-payload

   Security Association Payload

.. index:: Initiator

Die Proposals in der SA-Payload sind beginnend mit 1 durchnummeriert.
Ein Initiator kann sowohl Standard-Chiffren
als auch Authenticated-Encryption-Chiffren vorschlagen,
muss dann aber verschiedene Proposals verwenden,
da diese nicht im selben Proposal gemischt werden können.

.. index:: AH, ESP, ESN, PRF

Jede Proposal-Struktur wird gefolgt von einer oder mehreren Transform-Strukturen.
Deren Anzahl wird durch das Protokoll bestimmt.
AH hat im Allgemeinen zwei Transforms: Extended Sequence Numbers (ESN) und den Algorithmus zur Integritätsprüfung.
ESP hat im Allgemeinen drei: ESN, den Verschlüsselungsalgorithmus und den Algorithmus zur Integritätsprüfung.
Bei IKE sind es vier: eine Diffie-Hellman-Gruppe, ein Algorithmus zur Integritätsprüfung, ein PRF-Algorithmus und ein Verschlüsselungsalgorithmus.

.. index:: CBC, HMAC

Gibt es mehrere Transforms vom gleichen Typ, so gilt im Proposal die ODER-Verknüpfung der einzelnen Transforms.
Gibt es mehrere Transforms mit verschiedenem Typ, so gilt die UND-Verknüpfung der einzelnen Transforms.
Zum Beispiel bietet ein Proposal für ESP
mit 3DES, AES-CBC, HMAC_MD5 und HMAC_SHA
zwei Kandidaten mit Transform-Typ 1 (3DES, AES-CBC)
und zwei Kandidaten mit Transform-Typ 3 (HMAC_MD5, HMAC_SHA) an,
was effektiv vier möglichen Kombinationen dieser Algorithmen entspricht.
Will der Initiator nur eine Untermenge der vier Kombinationen anbieten,
muss er unter Umständen mehrere Proposals verwenden.

Ein Transform kann ein oder mehrere Attribute haben, zum Beispiel die Schlüssellänge bei einem Verschlüsselungsalgorithmus mit variabler Schlüssellänge.
Das Transform würde den Algorithmus spezifizieren und das Attribut die Schlüssellänge.
Ein Transform darf nicht mehrere Attribute vom gleichen Typ haben.
Um alternative Werte für ein Attribut vorzuschlagen, muss der Initiator mehrere Transforms vom gleichen Typ mit unterschiedlichen Attributen vorschlagen.

Die Semantik von Transforms und Attributen unterscheidet sich zwischen IKEv1 und IKEv2.
Bei IKEv1 konnte ein einzelnes Transform mehrere Algorithmen für ein Protokoll haben bei denen eines im Transform enthalten war und die anderen in den Attributen.

Der Payload-Typ für Security Associations - zu finden im IKE-Header
beziehungsweise im Feld *Next Payload* der vorhergehenden Payload - ist
33.

Proposal-Unterstrukturen
........................

Die erste Proposal-Unterstruktur folgt unmittelbar dem Header der SA-Payload.

.. figure:: /images/ipsec-sa-payload-proposal.png
   :alt: Proposal-Unterstruktur einer SA-Payload aus RFC 7296, Abschnitt 3.3.1
   :name: ipsec-sa-payload-proposal

   Proposal-Unterstruktur

.. raw:: latex

   \clearpage

:numref:`ipsec-sa-payload-proposal` zeigt eine Proposal-Unterstruktur
einer SA-Payload, deren Felder folgende Bedeutung haben.

Last Substruc (1 Oktett):
  Gibt an, ob dieses das letzte Proposal ist oder nicht.
  Das Feld hat den Wert 0, wenn es das letzte ist und den Wert 2, wenn
  es noch mehr Proposals gibt.

RESERVED (1 Oktett):
  Muss beim Senden auf 0 gesetzt und beim Empfang ignoriert werden

Proposal Length (2 Oktetts, unsigned integer):
  Die Länge dieses Proposals inklusive aller Transforms und Attribute.

Proposal Num (1 Oktett):
  Wenn Proposals gesendet werden, muss das erste die Nummer 1 haben und
  die Nummern aller folgenden müssen jeweils um 1 größer sein als die
  des vorhergehenden. Wenn ein Proposal angenommen wird,
  muss die zurückgesendete Nummer der des akzeptierten Proposals entsprechen.

.. index:: Protocol ID
   single: IKE; Protocol ID
   single: AH; Protocol ID
   single: ESP; Protocol ID

Protocol ID (1 Oktett):
  Spezifiziert das IPsec-Protokoll für das Proposal.

  Die Werte der folgenden Tabelle entsprechen dem Stand von RFC 7296.

  ======== ===========
  Protocol Protocol ID
  ======== ===========
  IKE                1
  AH                 2
  ESP                3
  ======== ===========

.. index:: SPI

SPI Size (1 Oktett):
  Bei einer initialen IKE-SA-Verhandlung muss das Feld 0 sein, es gilt
  der SPI des äußeren Headers. In folgenden Verhandlungen ist es gleich
  der Größe des SPI des entsprechenden Protokolls (8 für IKE, 4 für ESP
  und AH)

Num Transforms (1 Oktett):
  gibt die Anzahl der Transforms in diesem Proposal an.

SPI (variabel):
  Der SPI des Senders des Datagramms.
  Wenn das Feld *SPI Size* 0 ist, fehlt dieses Feld.

Transforms (variabel):
  eine oder mehrere Transform-Unterstrukturen.

Transform-Unterstruktur
.......................

Die erste Transform-Unterstruktur folgt unmittelbar
dem Feld SPI der zugehörigen Proposal-Unterstruktur.

.. figure:: /images/ipsec-sa-payload-transform.png
   :alt: Transform-Unterstruktur einer SA-Payload aus RFC 7296, Abschnitt 3.3.2
   :name: ipsec-sa-payload-transform

   Transform-Unterstruktur

Die Felder der Transform-Unterstruktur haben folgende Bedeutung.

Last Substruc (1 Oktett):
  Gibt an, ob das das letzte Transform ist.
  Das Feld hat den Wert 0, wenn es das letzte Transform ist und 3 sonst.

RESERVED (1 Oktett):
  Muss beim Senden auf 0 gesetzt und beim Empfang ignoriert werden

Transform Length:
  Die Länge der Transform-Unterstruktur in Oktetts inklusive Header und
  Attributes.

.. index:: AH, ESP

Transform Type (1 Oktett):
  Die Art des Transforms.
  Einige Transforms können optional sein.
  Wenn der Initiator ein optionales Transform weglassen will,
  sendet er es nicht im Proposal.
  Will der Initiator die Verwendung optional für den Responder machen,
  sendet er eine Transform-Unterstruktur mit Transform ID = 0.

  Die Werte der folgenden Tabelle entsprechen dem Stand von RFC 7296.

  .. index:: DH-Gruppe, ESN, PRF

  === ===============================  ==========================
  Typ Beschreibung                     Verwendet in
  === ===============================  ==========================
   1  Encryption Algorithm (ENCR)      IKE and ESP
   2  Pseudorandom Function (PRF)      IKE
   3  Integrity Algorithm (INTEG)      IKE*, AH, optional in ESP
   4  Diffie-Hellman Group (D-H)       IKE, optional in AH & ESP
   5  Extended Sequence Numbers (ESN)  AH and ESP
  === ===============================  ==========================

  (*) Das Aushandeln eines Integritätsalgorithmus (INTEG) ist
  verbindlich für die in RFC 7296 spezifizierten verschlüsselten
  Payloads. RFC 5282 :cite:`RFC5282` zum Beispiel spezifiziert zusätzliche
  Formate, die auf authentisierter Verschlüsselung beruhen und in denen
  kein separater Integritätsalgorithmus ausgehandelt wird.

Transform ID (2 Oktetts):
  Die spezifische Instanz des vorgeschlagenen
  beziehungsweise angenommenen Transform Type.

Für Transform-Typ 1 (Encryption Algorithm, ENCR)
sind die Transform-ID in nachfolgender Tabelle aufgelistet.
Die Werte entsprechen dem Stand von RFC 7296.

.. index:: CBC

============== ====== =============================
Name           Nummer Definiert in
============== ====== =============================
ENCR_DES_IV64  1      (UNSPECIFIED)
ENCR_DES       2      RFC 2405 :cite:`RFC2405`, :cite:`ANSI-X3.106`
ENCR_3DES      3      RFC 2451 :cite:`RFC2451`
ENCR_RC5       4      RFC 2451 :cite:`RFC2451`
ENCR_IDEA      5      RFC 2451 :cite:`RFC2451`, :cite:`IDEA`
ENCR_CAST      6      RFC 2451 :cite:`RFC2451`
ENCR_BLOWFISH  7      RFC 2451 :cite:`RFC2451`
ENCR_3IDEA     8      (UNSPECIFIED)
ENCR_DES_IV32  9      (UNSPECIFIED)
ENCR_NULL      11     RFC 2410 :cite:`RFC2410`
ENCR_AES_CBC   12     RFC 3602 :cite:`RFC3602`
ENCR_AES_CTR   13     RFC 3686 :cite:`RFC3686`
============== ====== =============================

.. raw:: latex

   \clearpage

.. index:: HMAC, PRF

Die Transform-ID für Transform-Typ 2
(Pseudorandom Function, PRF) mit Stand von RFC 7296
sind in folgender Tabelle aufgelistet.

============== ====== ==================================
Name           Nummer Definiert in
============== ====== ==================================
PRF_HMAC_MD5   1      RFC 2104 :cite:`RFC2104`, RFC1321 :cite:`RFC1321`
PRF_HMAC_SHA1  2      RFC 2104 :cite:`RFC2104`, :cite:`FIPS.180-4.2012`
PRF_HMAC_TIGER 3      (UNSPECIFIED)
============== ====== ==================================

Die Transform-ID für Transform-Typ 3 (Integrity Algorithm)
mit Stand von RFC 7296 listet die folgende Tabelle.

================= ====== =======================
Name              Nummer Definiert in
================= ====== =======================
NONE              0
AUTH_HMAC_MD5_96  1      RFC 2403 :cite:`RFC2403`
AUTH_HMAC_SHA1_96 2      RFC 2404 :cite:`RFC2404`
AUTH_DES_MAC      3      (UNSPECIFIED)
AUTH_KPDK_MD5     4      (UNSPECIFIED)
AUTH_AES_XCBC_96  5      RFC 3566 :cite:`RFC3566`
================= ====== =======================

.. index:: MODP

Für den Transform-Typ 4 (Diffie-Hellman-Gruppe) listet die folgende
Tabelle die Transform-ID mit Stand von RFC 7296.

=================== ======= =======================
Name                Nummer  Definiert in
=================== ======= =======================
NONE                0
768-bit MODP Group  1       Appendix B von RFC 7296
1024-bit MODP Group 2       Appendix B von RFC 7296
1536-bit MODP Group 5       RFC 3526 :cite:`RFC3526`
2048-bit MODP Group 14      RFC 3526 :cite:`RFC3526`
3072-bit MODP Group 15      RFC 3526 :cite:`RFC3526`
4096-bit MODP Group 16      RFC 3526 :cite:`RFC3526`
6144-bit MODP Group 17      RFC 3526 :cite:`RFC3526`
8192-bit MODP Group 18      RFC 3526 :cite:`RFC3526`
=================== ======= =======================

.. index:: PFS
   see: Perfect Forward Secrecy; PFS
   single: Child-SA; PFS

Obwohl ESP und AH einen Diffie-Hellman-Austausch nicht selbst enthalten,
kann dieser in IKE für die Child-SA ausgehandelt werden.
Damit wird Perfect Forward Secrecy (PFS)
für die Child-SA-Schlüssel gewährleistet.

.. index:: DH-Gruppe; Tests

Die aufgelisteten MODP Diffie-Hellman-Gruppen benötigen keine speziellen
Gültigkeitstests. Andere DH-Gruppen können zusätzliche Tests benötigen, um
sie sicher zu verwenden. Weitere Informationen zu diesem Thema finden sich
in RFC 6989 :cite:`RFC6989`.

.. index:: ESN

Die für Transform-Typ 5 (Extended Sequence Numbers) definierten
Transform-ID mit Stand von RFC 7296 sind in der folgenden Tabelle
gelistet.

============================ ======
Name                         Nummer
============================ ======
No Extended Sequence Numbers 0
Extended Sequence Numbers    1
============================ ======

Ein Initiator, der ESN unterstützt,
wird üblicherweise zwei ESN-Transforms verwenden,
mit den Werten "0" und "1" in seinen Proposals.
Ein Proposal, dass einen einzigen ESN-Transform mit dem Wert "1" enthält,
bedeutet,
dass die Verwendung von normalen (nicht erweiterten) Sequenznummern
nicht akzeptabel ist.

Seit der Veröffentlichung von RFC 4306, auf die sich alle in RFC 7296
gelisteten Transform-ID beziehen, wurden zahlreiche weitere
Transform-Typen definiert.
Details finden sich in der IANA Registry
"Internet Key Exchange Version 2 (IKEv2) Parameters" :cite:`IKEv2parameters`.

.. index:: ! Notify Payload

Notify Payload
--------------

.. index:: Datagramm-Header; Notify Payload

Mit der Notify Payload werden informelle Daten, wie Fehlerzustände
und Zustandsänderungen an den IKE-Peer gesendet. Sie kann in
Response-Nachrichten auftauchen, wo sie üblicherweise angibt, warum ein
Request abgelehnt wurde, oder in einem INFORMATIONAL-Exchange um einen
Fehler zu berichten, der nicht mit einem IKE-Request zusammenhängt, oder
in anderen Nachrichten um Fähigkeiten des Senders anzuzeigen oder die
Bedeutung eines Requests zu modifizieren.


.. figure:: /images/ipsec-ike-datagram-notify-payload.png
   :alt: Notify Payload aus RFC 7296, Abschnitt 3.10
   :name: ipsec-ike-datagram-notify-payload

   Notify Payload

:numref:`ipsec-ike-datagram-notify-payload` zeigt eine Notify Payload.
Die Felder haben folgende Bedeutung:

.. index:: INVALID_SELECTORS, REKEY_SA, CHILD_SA_NOT_FOUND, Protocol ID,
   single: Fehlermeldung; CHILD_SA_NOT_FOUND

.. index:: Child SA

Protocol ID (1 Oktett):
  Ist eine SPI angegeben,
  zeigt dieses Feld den Typ der SA an.
  Bezieht sich die Benachrichtigung auf keine SA,
  muss darin der Wert 0 gesendet werden
  und es muss beim Empfang ignoriert werden.
  
  Für Benachrichtigungen bezüglich Child-SA muss dieses Feld entweder
  den Wert 2 enthalten, um AH anzuzeigen oder den Wert 3 für ESP.
  Bei den in RFC 7296 definierten Benachrichtigungen ist der SPI nur mit
  INVALID_SELECTORS, REKEY_SA und CHILD_SA_NOT_FOUND eingeschlossen.
  Beim Rekeying von IKE SA sind keine Notification Payloads involviert.

.. index:: SPI

SPI Size (1 Oktett):
  Länge in Oktetts des SPI, der durch die Protocol ID bestimmt wird. 0
  für die aktuelle IKE SA, 4 für AH oder ESP.

Notify Message Type (2 Oktetts):
  Gibt den Typ der Nachricht an.

SPI (variable Länge):
  Security Parameter Index

Notification Data (variable Länge):
  Status- oder Fehlerdaten, die zusätzlich zum Message Type gesendet
  werden. Die Werte für dieses Feld hängen vom Typ ab.

Der Payload-Typ für die Notify Payload ist 42.

Notify-Message-Typen
....................

Die folgenden beidenTabellen listen lediglich
die Namen der Nachrichten und ihren numerischen Wert.
Für Details verweise ich auf RFC 7296, Abschnitt 3.10.

.. index:: Fehlertyp

Werte von 0 - 16383 sind für das Melden von Fehlern vorgesehen.
Erhält eine IPsec-Implementierung eine Nachricht mit einem Fehlertypen,
den sie nicht versteht, muss sie annehmen, dass der zugehörige
Request vollständig fehlgeschlagen ist. Unbekannte Fehlertypen in einem
Request beziehungsweise unbekannte Statustypen in einem Request oder
Response müssen ignoriert und sollten protokolliert werden.

.. index:: UNSUPPORTED_CRITICAL_PAYLOAD, INVALID_IKE_SPI,
   INVALID_MAJOR_VERSION, INVALID_SYNTAX, INVALID_MESSAGE_ID,
   INVALID_SPI, NO_PROPOSAL_CHOSEN, INVALID_KE_PAYLOAD,
   AUTHENTICATION_FAILED, SINGLE_PAIR_REQUIRED, NO_ADDITIONAL_SAS,
   INTERNAL_ADDRESS_FAILURE, FAILED_CP_REQUIRED, TS_UNACCEPTABLE,
   INVALID_SELECTORS, TEMPORARY_FAILURE, CHILD_SA_NOT_FOUND

=============================== =====
NOTIFY Nachrichten: Fehlertypen Wert
=============================== =====
UNSUPPORTED_CRITICAL_PAYLOAD       1
INVALID_IKE_SPI                    4
INVALID_MAJOR_VERSION              5
INVALID_SYNTAX                     7
INVALID_MESSAGE_ID                 9
INVALID_SPI                       11
NO_PROPOSAL_CHOSEN                14
INVALID_KE_PAYLOAD                17
AUTHENTICATION_FAILED             24
SINGLE_PAIR_REQUIRED              34
NO_ADDITIONAL_SAS                 35
INTERNAL_ADDRESS_FAILURE          36
FAILED_CP_REQUIRED                37
TS_UNACCEPTABLE                   38
INVALID_SELECTORS                 39
TEMPORARY_FAILURE                 43
CHILD_SA_NOT_FOUND                44
=============================== =====

.. index:: COOKIE, HTTP_CERT_LOOKUP_SUPPORTED, REKEY_SA,
   USE_TRANSPORT_MODE, IKEV2_FRAGMENTATION_SUPPORTED

=============================== =====
NOTIFY Nachrichten: Statustypen  Wert
=============================== =====
INITIAL_CONTACT                 16384
SET_WINDOW_SIZE                 16385
ADDITIONAL_TS_POSSIBLE          16386
IPCOMP_SUPPORTED                16387
NAT_DETECTION_SOURCE_IP         16388
NAT_DETECTION_DESTINATION_IP    16389
COOKIE                          16390
USE_TRANSPORT_MODE              16391
HTTP_CERT_LOOKUP_SUPPORTED      16392
REKEY_SA                        16393
ESP_TFC_PADDING_NOT_SUPPORTED   16394
NON_FIRST_FRAGMENTS_ALSO        16395
IKEV2_FRAGMENTATION_SUPPORTED   16430
=============================== =====

Delete Payload
--------------

.. index:: ! Delete Payload

.. index:: Datagramm-Header; Delete Payload

Die Delete Payload enthält einen protokollspezifischen SA-Identifikator,
den der Sender aus seiner SAD entfernt hat, der somit nicht mehr gültig
ist. Ihr Payload-Type ist 42.

.. figure:: /images/ipsec-ike-datagram-delete-payload.png
   :alt: Delete Payload aus RFC 7296, Abschnitt 3.11
   :name: ipsec-ike-datagram-delete-payload

   Delete Payload

:numref:`ipsec-ike-datagram-delete-payload` zeigt
das Format der Delete Payload,
deren Felder folgende Bedeutung haben.

Protocol ID (1 Oktett):
  1 für IKE, 2 für AH oder 3 für ESP.

.. index:: SPI

SPI Size (1 Oktett):
  Länge in Oktetts des SPI, der durch die Protocol ID bestimmt wird. 0
  für IKE, 4 für AH oder ESP.

Num of SPIs (2 Oktetts, Integer):
  Anzahl der SPIs in dieser Payload.

Security Parameter Index(es) (variable Länge):
  Identifiziert die Security Associations, die gelöscht werden sollen.
  Die Länge dieses Feldes ergibt sich aus den Feldern *SPI Size* und
  *Num of SPIs*.

.. index:: INFORMATIONAL

Eine Delete Payload kann mehrere SPI enthalten,
jedoch müssen alle für das gleiche Protokoll (IKE, ESP oder AH) sein.
Verschiedene Protokolle
dürfen nicht in einer Delete Payload gemischt werden. Es ist jedoch
möglich, mehrere Delete Payloads in einem INFORMATIONAL Exchange zu
senden von denen jede Payload SPIs für ein anderes Protokoll
kennzeichnet.

.. index::
   single: Child-SA; Löschen
   single: IKE-SA; Löschen

Die Löschung einer IKE-SA wird durch die Protokoll-ID 1 angezeigt,
ohne SPI.
Das Löschen von Child-SA
wird durch die entsprechende Protokoll-ID angezeigt,
zusammen mit den SPI,
welche der Sender der Delete Payload
für ankommende ESP- oder AH-Datagramme erwarten würde.

ESP-Datagramm
-------------

.. index:: Datagramm-Header; ESP

:numref:`ipsec-esp-datagram` zeigt den Aufbau eines ESP-Datagramms.
Der äußere Header, welcher ihm unmittelbar voran geht,
enthält den Wert 50 in seinem Protokollfeld (IPv4)
beziehungsweise Next-Header-Feld (IPv6, Extensions).

Das Datagramm beginnt mit einem ESP-Header,
bestehend aus zwei 4-Byte-großen Feldern,
denen die verschlüsselten Nutzlastdaten folgen.
Diesen wiederum folgt das Padding,
dessen Länge sowie das Next-Header-Feld. Das abschließende Feld mit dem
Integrity-Check-Wert ist optional.

.. figure:: /images/ipsec-esp-datagram.png
   :alt: Toplevel-Format eines ESP-Datagramms aus RFC 4303, Abschnitt 2
   :name: ipsec-esp-datagram

   ESP-Datagramm

Die Struktur der Nutzlastdaten ist abhängig vom gewählten
Verschlüsselungsalgorithmus und dessen Modus.

Der explizite ESP-Trailer besteht aus dem Padding, dessen Länge und dem
Next-Header-Feld. Die Integritäts-Check-Daten zählen zum impliziten
ESP-Trailer.

Der Schutz der Integrität des Datagramms umfasst den SPI, die Sequenznummer,
die Nutzlastdaten und den ESP-Trailer (explizit und implizit).

Wenn die Vertraulichkeit des Datagramms geschützt wird, besteht der
verschlüsselte Teil aus den Nutzlastdaten und dem expliziten ESP-Trailer.

.. index:: ESN

Bei der Nutzung von ESN werden nur die niederwertigen 32 Bit der
64-bitigen Sequenznummer im ESP-Header des Datagramms übermittelt. Die
höherwertigen Bits werden beim Sender und Empfänger im entsprechenden
Zähler mitgeführt und gehen in die Integritätsberechnung ein.

.. index:: Transportmodus, Tunnelmodus

Im Transportmodus wird der ESP-Header nach dem IP-Header und vor dem
Header der nächsten Protokollschicht eingefügt.

Im Tunnelmodus wird der ESP-Header vor dem gekapselten IP-Datagramm
eingefügt.

.. index:: NAT-T, Non-ESP-Marker, SPI, UDP

Bei NAT-Traversal (NAT-T) wird das gesamte ESP-Datagramm als Nutzlast in
einem UDP-Datagramm transportiert. Dabei ist der Zielport des
UDP-Datagramms in der einen Richtung 4500 und in der anderen Richtung
der Port, auf den die NAT-Box den Absenderport beim ersten IKE-Datagramm
umgesetzt hat. Die ESP-Datagramme unterscheiden sich von IKE-Datagrammen
dadurch, dass mindestens ein Bit der ersten vier Oktetts (SPI) nach dem
UDP-Header gesetzt ist während der Non-ESP-Marker aus vier Oktetts mit
dem Wert 0 besteht.


