
IKEv2 Nachrichten
=================

.. todo:: Message-ID
   
   RFC7296: 2.2 Use of Sequence Numbers for Message ID

.. index:: Exchange
   see: Exchange; Nachrichten

.. index:: Request/Response
   see: Request/Response; Nachrichten

Der gesamte Nachrichtenverkehr in IKEv2 erfolgt über den paarweisen
Austausch von Nachrichten.
Bei jedem Paar von Nachrichten spricht man von einem *Exchange*,
manchmal auch von einem *Request/Response* Paar.

.. index:: Initiator, Responder

Der Peer, der IKE_SA_INIT-Request sendet wird *Initiator* genannt,
derjenige, welcher darauf antwort *Responder*.
Nach dem Rekeying der IKE-SA ist derjenige der Initiator, der das
Rekeying veranlasst hat.

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

.. index:: ! Message ID

Jede Nachricht enthält eine 32-Bit große Message-ID (MID) als Teil des
festen IKE-Headers.
Diese Message-ID wird verwendet um Requests und Responses einander
zuzuordnen und Nachrichtenwiederholungen zu erkennen. Wiederholungen
einer IKE-Nachricht müssen die gleiche MID verwenden.

Die MID beginnt mit 0 beim IKE_SA_INIT-Requests des Initiators und wird
fortlaufend hochgezählt.
Beim Rekeying einer IKE-SA wird die MID für die neue SA auf 0 gesetzt.

Der erste IKE-Request des Responders beginnt ebenfalls mit MID 0, so
dass zu einer IKE-SA gleichzeitig zwei MID-Nummernkreise existieren
können, einer für den nächsten Request, den ein Peer sendet und einer
für den nächsten Request den er erwartet.
Die beiden Nummernkreise kann man an den Flags des IKE-Headers
unterscheiden (siehe Abschnitt :ref:`anhang/datagram-header:IKE Header`
bei den Datagramm-Headern im Anhang).

Allgemeine Fehlerregeln
-----------------------

Es gibt viele Fehlermöglichkeiten beim IKE-Austausch.
Die allgemeine Regel ist, dass bei einem Request, der schlecht
formatiert ist oder aufgrund einer Policy nicht akzeptiert werden kann,
mit einer Notify-Payload beantwortet wird, die auf den Fehler hinweist.
Ob eine solche Benachrichtigung gesendet wird, hängt davon ab, ob eine
authentisierte IKE-SA existiert.

Wenn es einen Fehler beim Verarbeiten eines Response gibt, ist die
allgemeine Regel, keine Fehlermeldung zurückzusenden, weil man dafür
einen Request verwenden müsste. Trotzdem sollte der Empfänger der
problematischen Response-Nachricht den IKE-Status aufräumen, zum
Beispiel in dem er einen Delete-Request sendet.

Weitere Hinweise zu den Fehlerregeln finden sich in Abschnitt 2.21 von
:cite:`RFC7296`.

.. index:: ! IKE_SA_INIT
   single: Nachrichten; IKE_SA_INIT

IKE_SA_INIT
-----------

.. figure:: /images/ike-sa-init.png
   :alt: Sequenzdiagramm für einfachen IKE_SA_INIT-Exchange

   Einfacher IKE_SA_INIT-Exchange

Die Abkürzungen stehen für folgende Informationen

*HDR*
  IKE header
*SAi1*
  Sets von vorgeschlagenen kryptografischen Algorithmen
*SAr1*
  ausgewählte kryptografische Algorithmen
*KEi, KEr*
  Schlüsselmaterial für DH-Austausch
*Ni, Nr*
  Nonces (Number used once)
*CertReq*
  Zertifikatanforderung (optional)
*N(Cookie)*
  COOKIE

Das ist der einzige Austausch, der unverschlüsselt über das Netz geht
und in jedem Paketmitschnitt analysiert werden kann. Der Initiator kann
mehrere kryptographische Algorithmen für die IKE-SA vorschlagen, aus
denen der Responder eine auswählt. Die Message-ID im IKE-Header ist auf
beiden Seiten 0.

Am Ende dieses Austauschs kann jede Seite ein Maß namens SKEYSEED
berechnen, von dem alle Schlüssel für diese IKE-SA abgeleitet werden.
Alle darauf folgenden Nachrichten sind verschlüsselt und in ihrer
Integrität gesichert.

Alle Fehler beim IKE_SA_INIT-Austausch führen zum Scheitern des
Austausches. Einige Fehlermeldungen, wie COOKIE, INVALID_KE_PAYLOAD
oder INVALID_MAJOR_VERSION können jedoch zu einem nachfolgenden
erfolgreichen IKE_SA_INIT-Austausch führen. Da diese Fehlermeldungen
nicht authentisiert sind, sollte der Initiator es noch einige Zeit
versuchen, bevor er aufgibt. Dabei soll er nicht unmittelbar auf die
Fehlerbenachrichtigung reagieren, es sei denn sie enthält einen der
oben genannten korrigierenden Hinweise.

Diese schauen wir uns nun an.

.. index:: COOKIE

COOKIE
......

.. figure:: /images/ike-sa-init-cookie.png
   :alt: Sequenzdiagramm für IKE_SA_INIT-Exchange mit COOKIE

   IKE_SA_INIT-Exchange mit COOKIE

Zwei erwartete Attacken gegen IKE sind Zustandserschöpfung und
CPU-Überlastung bei denen das Ziel mit IKE_SA_INIT-Requests von
verschiedenen Adressen überflutet wird. Diese Attacken können weniger
effektiv gemacht werden, indem der Responder nur minimale CPU-Zeit
aufwendet und sich nur dann auf einen neuen SA festlegt, wenn er weiß,
dass der Initiator Datagramme an die angegebene Absenderadresse
empfangen kann.

Wenn ein Responder eine große Anzahl halboffener IKE-SAs entdeckt,
sollte er auf IKE_SA_INIT-Requests mit einer COOKIE-Benachrichtigung
antworten. Wenn ein IKE_SA_INIT-Response eine COOKIE-Benachrichtigung
enthält, muss der Initiator den Request wiederholen mit dem empfangenen
COOKIE als erster Payload und allen anderen Payloads unverändert.

Im günstigsten Fall kann der Initiator nach vier Datagrammen mit dem
IKE_AUTH-Exchange fortfahren wenn er einen COOKIE-Response erhalten hat.

Empfängt ein Responder einen IKE_SA_INIT-Request mit COOKIE, dessen Wert
nicht zu dem erwarteten passt, so behandelt er das Datagramm wie eines
ohne COOKIE und sendet einen neuen COOKIE-Response. Der Initiator sollte
die Anzahl der COOKIE-Requests begrenzen bevor er aufgibt. In diesem
Fall ist es möglich, dass die COOKIES bei der Übertragung modifiziert
wurden. Das kann man validieren, indem man die Datagramme auf beiden
Seiten mitschneidet und anschließden Bit für Bit vergleicht. Sind die
Datagramme auf beiden Seiten gleich, würde ich ein Problem bei der
Implementierung der Cookies auf Responderseite vermuten.

.. index:: INVALID_KE_PAYLOAD

INVALID_KE_PAYLOAD
..................

.. figure:: /images/ike-sa-init-inv-ke.png
   :alt: Sequenzdiagramm für IKE_SA_INIT-Exchange mit INVALID_KE_PAYLOAD

   IKE_SA_INIT-Exchange mit INVALID_KE_PAYLOAD

Die Key-Exchange-Payload im IKE_SA_INIT-Request enthält den öffentlichen
Diffie-Hellman-Wert und die Diffie-Hellman-Gruppennummer. Die
Gruppennummer muss in einem der gesendeten Proposals verwendet werden,
sie sollte der ersten Gruppe im ersten Proposol entsprechen.

Sollte der Responder eine andere Diffie-Hellman-Gruppe als die des im
Request gesendeten Schlüsselmaterials verwenden wollen, so sendet er
eine INVALID_KE_PAYLOAD-Benachrichtigung zurück und der Initiator
wiederholt seinen Request mit dem gewünschten Schlüsselmaterial.

Hier ergibt sich ein Twist, wenn der erste Austausch mit COOKIE
fehlschlug und der zweite mit INVALID_KE_PAYLOAD. Der Initiator muss
entscheiden, ob er den COOKIE beim dritten Versuch mitsendet oder nicht.

Sendet er den COOKIE nicht und der Responder erwartet den COOKIE, gibt
es eine Extra-Runde weil der Responder wieder mit COOKIE antwortet.
Sendet er den COOKIE und der Responder unterstützt das nicht (zum
Beispiel, weil er die Key-Exchange-Payload für die Cookie-Berechnung
verwendet hat), gibt es ebenfalls eine Extra-Runde.

Mehr Details zur Interaktion von COOKIE und INVALID_KE_PAYLOAD findet
sich in Abschnitt 2.6.1 von :cite:`RFC7296`.

.. index:: INVALID_MAJOR_VERSION

INVALID_MAJOR_VERSION
.....................

Diese Nachrichten sollten nur auftreten, wenn ein Request mit einer
Major-Version größer als 2 ankommt, was zum gegenwärtigen Zeitpunkt
darauf hindeutet, dass etwas ernsthaft schief gegangen ist weil es im
Moment noch keine IKE-Version größer als 2 gibt.

.. index:: ! IKE_AUTH
   single: Nachrichten; IKE_AUTH

IKE_AUTH
--------

Der IKE_AUTH-Exchange ist der zweite Nachrichtenaustausch einer
IKEv2-Sitzung und hat die Message-ID 1. In diesem Austausch
authentisieren sich die beiden VPN-Peers und bauen die erste und
manchmal einzige ESP- oder AH-SA auf.

.. figure:: /images/ike-auth.png
   :alt: Sequenzdiagramm für IKE_AUTH-Exchange

   IKE_AUTH-Exchange

Die Abkürzungen stehen für folgende Informationen:

*HDR*
  IKE header
*SK{...}*
  der Inhalt in geschweiften Klammern ist verschlüsselt
*IDi, IDr*
  die Identität von Initiator und Responder
*Cert*
  Zertifikate, falls vom Peer angefordert, wenn mehrere Zertifikate
  gesendet werden, muss das erste den öffentlichen Schlüssel für das
  betreffende AUTH-Feld enthalten
*CertReq*
  Zertifikatanforderung (optional)
*AUTH*
  die Authentifizierungsdaten (siehe Abschnitt 2.15 in :cite:`RFC7296`)
*SAi2, SAr2*
  Proposals beziehungsweise Transforms für die erste Child-SA
*TSi, TSr*
  Traffic-Selektoren für die erste Child-SA

Der IKE_AUTH-Exchange erfolgt bereits verschlüsselt. Im Normalfall kann
ich in einem Paketmitschnitt nur aus äußeren Merkmalen schließen, ob
er erfolgreich war. Insbesondere, wenn anschließend ESP- oder
AH-Datagramme ausgetauscht werden, kann ich vermuten, dass der
IKE_AUTH-Austausch funktioniert hat. Eine Ausnahme sind Paketmitschnitte
vom Type ``isakmp`` bei Cisco ASA (siehe dazu
:ref:`Paketmitschnitt auf dem VPN-Gateway`).

In den meisten Fällen reichen zwei Datagramme für den
IKE_AUTH-Austausch. Wird hingegen EAP verwendet, kann es mehrere
IKE_AUTH-Exchanges geben, bei denen dann die Message-ID hochgezählt
wird. Weitere Informationen zu EAP finden sich in :cite:`RFC7296`
Abschnitt 2.16.

Fehler beim IKE_AUTH-Exchange
.............................

Jeder Fehler bei IKE_AUTH, der dazu führt, dass die Authentisierung
fehlschlägt, sollte zu einer *AUTHENTICATION_FAILED* Nachricht führen.
Tritt der Fehler beim Responder auf, so schickt er die Nachricht im
Response-Datagramm. Tritt der Fehler beim Initiator auf, kann er die
*AUTHENTICATION_FAILED* in einem separaten INFORMATIONAL-Exchange
senden.

Ist die Authentisierung erfolgreich, wird die IKE-SA aufgebaut. Jedoch
kann das Erzeugen der Child-SA oder die Anforderung von
Konfigurationsinformationen immer noch fehlschlagen. Das führt nicht
automatisch dazu, dass die IKE-SA gelöscht wird. Insbesondere der
Responder kann alle für die Authentisierung nötigen Informationen
zusammen mit der Fehlermeldung für den angehängten Austausch
(NO_PROPOSAL_CHOSEN, FAILED_CP_REQUIRED, ...) senden. Der Initiator darf
deswegen nicht die Authentisierung scheitern lassen. Jedoch ist es
möglich, dass der Initiator anschließend die IKE-SA mit einer
DELETE-Nachricht löscht.

Nur bei den folgenden drei Benachrichtigungen während eines
IKE_AUTH-Austausches beziehungsweise im unmittelbar folgenden
INFORMATIONAL-Austausch wird die IKE-SA nicht erzeugt:

* UNSUPPORTED_CRITICAL_PAYLOAD,
* INVALID_SYNTAX,
* AUTHENTICATION_FAILED.

Falls nur das Erzeugen der ersten Child-SA während des IKE_AUTH-Austauschs
fehlschlägt, wird die IKE-SA trotzdem wie üblich erzeugt. Die folgenden
Fehlermeldungen deuten darauf hin, dass nur das Erzeugen der Child-SA
fehlschlug und die IKE-SA trotzdem angelegt wurde:

* NO_PROPOSAL_CHOSEN
* TS_UNACCEPTABLE
* SINGLE_PAIR_REQUIRED
* INTERNAL_ADDRESS_FAILURE
* FAILED_CP_REQUIRED

.. index:: ! CREATE_CHILD_SA
   single: Nachrichten; CREATE_CHILD_SA

CREATE_CHILD_SA
---------------

Der CREATE_CHILD_SA-Exchange wird zum Aushandeln neuer Child-SA
zusätzlich zu der bei IKE_AUTH ausgehandelten sowie zum Rekeying sowohl
der IKE-SA als auch aller Child-SA verwendet.

Jeder der beiden Peers kann einen CREATE_CHILD_SA-Austausch initiieren,
so dass man unterscheiden muss zwischen dem Initiator der IKE-Sitzung,
der an den Flags im IKE-Header identifiziert werden kann und dem
Initiator des CREATE_CHILD_SA-Austausches, der den Request mit der
CREATE_CHILD_SA-Nachricht sendet. In diesem Abschnitt beziehen sich die
Begriffe Initiator und Responder auf den jeweiligen
CREATE_CHILD_SA-Austausch.

.. index:: NO_ADDITIONAL_SAS
   single: Fehlermeldung; NO_ADDITIONAL_SAS

Es ist möglich, dass eine minimale Implementation keine weiteren außer
der bei IKE_AUTH ausgehandelten Child-SA erlaubt. In diesem Fall sendet
sie eine NO_ADDITIONAL_SAS-Benachrichtigung. Mit dieser Meldung kann
auch das Rekeying zurückgewiesen werden.

.. index:: INVALID_KE_PAYLOAD
   single: Fehlermeldung; INVALID_KE_PAYLOAD

Optional können mit den CREATE_CHILD_SA-Nachrichten frisches
Schlüsselmaterial mit einer KE-Payload gesendet werden. In diesem Fall
muss mindestens eines der Proposals die DH-Gruppe des Schlüsselmaterials
enthalten. Wenn der Responder ein Proposal mit einer anderen DH-Gruppe
wählt, muss er die Nachricht mit der Fehlermeldung INVALID_KE_PAYLOAD
zurückweisen und die passende DH-Gruppe angeben.

Neue Child-SA mit CREATE_CHILD_SA erzeugen
..........................................

.. todo:: Sequenzdiagramm für CREATE_CHILD_SA (RFC 7296, S. 14ff)

Der Initiator sendet SA-Vorschläge in der SA-Payload, eine Nonce in der
Ni-Payload, optional Schlüsselmaterial in der KEi-Payload und die
Traffic-Selektoren für die vorgeschlagene Child-SA in der TSi- und
TSr-Payload.

Der Responder antwortet (mit der selben MID) mit dem akzeptierten
Vorschlag in der SA-Payload einer Nonce in der Nr-Payload eine
DH-Payload, DH-Schlüsselmaterial in der KEr-Payload falls der Initiator
ebenfalls Schlüsselmaterial gesendet hatte und der gewählten
kryptographischen Suite, die diese DH-Gruppe enthält.

Die Traffic-Selektoren in der TSi- und TSr-Payload können eine Teilmenge
der vorgeschlagenen Traffic-Selektoren sein.

.. index:: USE_TRANSPORT_MODE, Transportmode

Um für den Child-SA Transportmode zu vereinbaren, kann der Initiator die
Benachrichtigung USE_TRANSPORT_MODE in den Request einfügen. Falls der
Request akzeptiert wird, muss der Responder ebenfalls die Benachrichtigung
USE_TRANSPORT_MODE in die Antwort einfügen. Falls der Responder diese
Aufforderung zurückweist, wird der Child-SA im Tunnelmode etabliert. Ist
das für den Initiator unakzeptabel, muss er den SA löschen.

Ein fehlgeschlagener Versuch, eine Child-SA zu erzeugen sollte nicht zum
Abbau der IKE-SA führen.

Rekeying von IKE-SA mit CREATE_CHILD_SA
.......................................

.. todo:: Sequenzdiagramm zum Rekeying von IKE-SA (RFC 7296 S.16)

Der Initiator sendet SA-Vorschläge in der SA-Payload, eine Nonce in Ni
und den Diffie-Hellman-Wert in der KEi-Payload. Eine neue Initiator-SPI
stellt er im SPI-Feld der SA-Payload bereit.

Wenn ein Peer eine Aufforderung zum Rekeying erhält, sollte er keine
neuen CREATE_CHILD_SA-Exchanges für diesen IKE-SA mehr starten.

Der Responder antwortet mit der gleichen Message-ID mit dem akzeptierten
SA-Vorschlag in der SA-Payload, einer Nonce in Nr und dem
Diffie-Hellman-Wert in KEr, wenn die gewählte kryptographische Suite
diese DH-Gruppe enthält. Außerdem sendet er eine neue Responder-SPI in
der SA-Payload.

Sektion 2.18 in RFC7296 (:cite:`RFC7296`) behandelt das Rekeying von
IKE-SA im Detail.

Rekeying von Child-SA mit CREATE_CHILD_SA
.........................................

.. todo:: Rekeying von Child-SA (RFC 7296 S.16)

.. index:: ! INFORMATIONAL
   single: Nachrichten; INFORMATIONAL

INFORMATIONAL
-------------

