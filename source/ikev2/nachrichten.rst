
.. raw:: latex

   \clearpage

IKEv2 Nachrichten
=================

.. index:: Exchange
   see: Exchange; Nachrichten

.. index:: Request/Response
   see: Request/Response; Nachrichten

IKEv2 funktioniert über den paarweisen Austausch von Nachrichten.
Ein Paar von Nachrichten nennt man einen *Exchange*,
beziehungsweise ein *Request/Response* Paar.

.. index:: ! Initiator, ! Responder

Der Peer, der einen IKE_SA_INIT-Request sendet, wird *Initiator* genannt,
derjenige, welcher darauf antwortet, *Responder*.
Beim Rekeying der IKE-SA ist derjenige Initiator, der das
Rekeying veranlasst hat.
In den ausgetauschten IKE-Datagrammen
ist der Initiator am gesetzten Flag zu erkennen.

.. index:: Nachrichten; initiale

Die ersten beiden Exchanges sind IKE_SA_INIT und IKE_AUTH.
Sie bilden den initialen Nachrichtenaustausch, der im einfachsten Fall
ausreicht, um Daten mit IPsec zu sichern.

Der IKE_SA_INIT-Exchange verhandelt die kryptografischen Parameter
sowohl für IKE selbst als auch für die erste IPsec SA, er tauscht Nonces
aus und führt den Diffie-Hellman-Austausch durch.
Im Idealfall werden dabei nur zwei Datagramme gesendet
- eins in jeder Richtung.

.. topic:: Nonce

   .. index:: ! Nonce

   In der Kryptographie wird als "nonce" eine Zahl verstanden, die nur
   einmal verwendet wird.
   Mitunter ist die Sicherheit des kryptographischen Protokolls gefährdet,
   wenn die Nonce mehrfach verwendet wird.
   Nonces können durch Hochzählen einer Variablen gebildet werden
   oder aus Zufallszahlen,
   wenn die Wahrscheinlichkeit für doppelte Verwendung gering ist.

Der IKE_AUTH-Exchange authentisiert die vorherigen Nachrichten, tauscht
Identitäten und Zertifikate und etabliert die erste IPsec SA.

Alle nachfolgenden Exchanges sind kryptographisch geschützt und entweder
vom Typ CREATE_CHILD_SA oder INFORMATIONAL.

.. index:: ! Message ID

Jede Nachricht enthält eine 32-Bit große Message-ID (MID) als Teil des
festen IKE-Headers.
Diese Message-ID verwenden die Peers, um Request und Response einander
zuzuordnen und Wiederholungen von Nachrichten zu erkennen.
Eine wiederholt gesendete IKE-Nachricht muss die gleiche MID verwenden.

Die MID startet mit 0 beim IKE_SA_INIT-Requests des Initiators
und wird fortlaufend hochgezählt.
Beim Rekeying einer IKE-SA setzt der Initiator die MID erneut auf 0.

Der erste IKE-Request des Responders beginnt ebenfalls mit MID 0, so
dass zu einer IKE-SA gleichzeitig zwei MID-Nummernkreise existieren
können, einer für den nächsten Request, den ein Peer sendet und einer
für den nächsten Request den er erwartet.
Die beiden Nummernkreise kann man an den Flags des IKE-Headers
unterscheiden (siehe dazu auch Abschnitt :ref:`anhang/datagram-header:IKE Header`
bei den Datagramm-Headern im Anhang).

Allgemeine Fehlerregeln
-----------------------

Es gibt viele Fehlermöglichkeiten beim IKE-Austausch.
Eine allgemeine Regel ist,
dass ein Request,
der schlecht formatiert ist
oder aufgrund einer Policy nicht akzeptiert werden kann,
mit einer Notify-Payload beantwortet wird,
die auf den Fehler hinweist.
Ob ein Peer eine solche Benachrichtigung sendet, hängt davon ab, ob
bereits eine authentisierte IKE-SA existiert.

Tritt ein Fehler beim Verarbeiten eines Response auf, ist die
allgemeine Regel, keine Fehlermeldung zurückzusenden, weil man dafür
einen Request verwenden müsste. Trotzdem sollte der Empfänger der
problematischen Response-Nachricht den IKE-Status aufräumen, zum
Beispiel in dem er einen Delete-Request sendet.

Weitere Hinweise zu den Fehlerregeln finden sich in Abschnitt 2.21 von
RFC7296 :cite:`RFC7296`.

.. index:: ! IKE_SA_INIT
   single: Nachrichten; IKE_SA_INIT

IKE_SA_INIT
-----------

:numref:`ike-sa-init-einfach` zeigt den einfachsten Fall für den
IKE_SA_INIT-Exchange.

.. figure:: /images/ike-sa-init.png
   :alt: Sequenzdiagramm für einfachen IKE_SA_INIT-Exchange
   :name: ike-sa-init-einfach

   Einfacher IKE_SA_INIT-Exchange

Dabei stehen die Abkürzungen für folgende Informationen:

*HDR*
  IKE Header
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

IKE_SA_INIT ist der einzige Austausch, der unverschlüsselt über das Netz geht
und in jedem Paketmitschnitt analysiert werden kann. Der Initiator kann
mehrere kryptographische Algorithmen für die IKE-SA vorschlagen, aus
denen der Responder eine auswählt.
Die Message-ID im IKE-Header ist auf beiden Seiten 0,
unabhängig davon,
wieviele Datagramme tatsächlich ausgetauscht werden.

Am Ende dieses Austauschs kann jede Seite einen Initialwert SKEYSEED
berechnen, von dem alle Schlüssel für diese IKE-SA abgeleitet werden.
Alle darauf folgenden Nachrichten sind verschlüsselt und in ihrer
Integrität gesichert.

Alle Fehler bei IKE_SA_INIT führen zum Scheitern dieses Austausches.
Einige Fehlermeldungen, wie COOKIE, INVALID_KE_PAYLOAD
oder INVALID_MAJOR_VERSION können jedoch zu einem nachfolgenden
erfolgreichen IKE_SA_INIT-Austausch führen. Da diese Fehlermeldungen
nicht authentisiert sind, sollte der Initiator nicht unmittelbar auf die
Fehlerbenachrichtigung reagieren, es sei denn, sie enthält einen der
oben genannten korrigierenden Hinweise.

.. index:: COOKIE

COOKIE
......

.. figure:: /images/ike-sa-init-cookie.png
   :alt: Sequenzdiagramm für IKE_SA_INIT-Exchange mit COOKIE
   :name: ike-sa-init-cookie

   IKE_SA_INIT-Exchange mit COOKIE

Zwei mögliche Attacken gegen IKE sind Erschöpfung der Ressourcen und
CPU-Überlastung bei denen das Ziel mit IKE_SA_INIT-Requests von
verschiedenen Adressen überflutet wird. Diese Attacken können weniger
effektiv gemacht werden, indem der Responder nur minimale CPU-Zeit
aufwendet und sich nur dann auf einen neuen SA festlegt, wenn er weiß,
dass der Initiator Datagramme empfangen kann.

Wenn ein Responder eine große Anzahl halboffener IKE-SA entdeckt,
sollte er auf IKE_SA_INIT-Requests mit einer COOKIE-Benachrichtigung
antworten. Wenn ein IKE_SA_INIT-Response eine COOKIE-Benachrichtigung
enthält, muss der Initiator den Request mit dem empfangenen
COOKIE als erster Payload wiederholen,
wobei er alle anderen Payloads unverändert lässt.

Im günstigsten Fall kann der Initiator nach vier Datagrammen
wie in :numref:`ike-sa-init-cookie` gezeigt
mit dem IKE_AUTH-Exchange fortfahren,
wenn er einen COOKIE-Response erhalten hat.

Empfängt ein Responder einen IKE_SA_INIT-Request mit COOKIE, dessen Wert
nicht zu dem erwarteten passt, so behandelt er das Datagramm wie eines
ohne COOKIE und sendet einen neuen COOKIE-Response. Der Initiator sollte
die Anzahl der COOKIE-Requests begrenzen bevor er aufgibt. In diesem
Fall ist es möglich, dass die COOKIES bei der Übertragung modifiziert
wurden. Das kann man validieren, indem man die Datagramme auf beiden
Seiten mitschneidet und anschließend Bit für Bit vergleicht. Sind die
Datagramme auf beiden Seiten gleich, würde ich ein Problem bei der
Implementierung der Cookies auf der Seite des Responders vermuten
und den Support des Herstellers hinzuziehen.

.. index:: INVALID_KE_PAYLOAD

INVALID_KE_PAYLOAD
..................

.. figure:: /images/ike-sa-init-inv-ke.png
   :alt: Sequenzdiagramm für IKE_SA_INIT-Exchange mit INVALID_KE_PAYLOAD

   IKE_SA_INIT-Exchange mit INVALID_KE_PAYLOAD

Die Key-Exchange-Payload im IKE_SA_INIT-Request enthält den öffentlichen
Diffie-Hellman-Wert und die Diffie-Hellman-Gruppennummer.
Die Nummer der DH-Gruppe
muss in einem der gesendeten Proposals verwendet werden,
sie sollte der ersten Gruppe im ersten Proposal entsprechen.

Verwendet der Responder eine andere Diffie-Hellman-Gruppe
als die des gesendeten Schlüsselmaterials,
so sendet er eine INVALID_KE_PAYLOAD-Benachrichtigung zurück
und der Initiator wiederholt seinen Request
mit dem gewünschten Schlüsselmaterial.

Hier ergibt sich ein Twist, wenn der erste Austausch mit COOKIE
fehlschlug und der zweite mit INVALID_KE_PAYLOAD. Der Initiator muss
entscheiden, ob er den COOKIE beim dritten Versuch mitsendet oder nicht.

Sendet er den COOKIE nicht und der Responder erwartet den COOKIE, gibt
es eine Extra-Runde weil der Responder wieder mit COOKIE antwortet.
Sendet er den COOKIE und der Responder unterstützt das nicht (zum
Beispiel, weil er die Key-Exchange-Payload für die Cookie-Berechnung
verwendet hat), gibt es ebenfalls eine Extra-Runde.

Mehr Details zur Interaktion von COOKIE und INVALID_KE_PAYLOAD finden
sich in Abschnitt 2.6.1 von RFC7296.

Weitere Fehlermeldungen bei IKE_SA_INIT
.......................................

.. index:: INVALID_MAJOR_VERSION

INVALID_MAJOR_VERSION:
  Diese Nachrichten sollten nur auftreten, wenn ein Request mit einer
  Major-Version größer als 2 ankommt, was zum gegenwärtigen Zeitpunkt
  darauf hindeutet, dass etwas ernsthaft schief gegangen ist, da es zur
  Zeit noch keine IKE-Version größer als 2 gibt.

  Kommt ein Request mit Major-Version 1, ist beim Peer IKEv1 konfiguriert.
  Das kann man durch Nachfragen klären.

.. index:: INVALID_SYNTAX

INVALID_SYNTAX:
  RFC6989 :cite:`RFC6989` behandelt zusätzliche Diffie-Hellman-Tests für IKEv2.
  Abschnitt 2.5 dort beschreibt das Protokollverhalten
  und Abschnitt 5 listet die Tests auf,
  die bei verschiedenen DH-Gruppen gemacht werden.
  Diese Tests werden vom Responder ausgeführt,
  wenn der Initiator DH-Schlüsselmaterial sendet,
  das heißt bei IKE_SA_INIT beziehungsweise bei CREATE_CHILD_SA.

  Im Rahmen des IKE_SA_INIT-Austauschs kann der Responder
  entweder die Nachricht mit dem fehlerhaften DH-Material ignorieren
  oder eine INVALID_SYNTAX-Nachricht senden.

  Hinweise, ob es sich tatsächlich
  um einen fehlgeschlagenen Test nach RFC6989 handelt,
  finden sich im Log oder den Debug-Meldungen des Responders.

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
  IKE Header
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
  die Authentifizierungsdaten (siehe Abschnitt 2.15 in RFC7296)
*SAi2, SAr2*
  Proposals beziehungsweise Transforms für die erste Child-SA
*TSi, TSr*
  Traffic-Selektoren für die erste Child-SA

Der IKE_AUTH-Exchange erfolgt bereits verschlüsselt. Im Normalfall kann
ich in einem Paketmitschnitt nur aus äußeren Merkmalen schließen, ob
er erfolgreich war. Insbesondere, wenn anschließend ESP- oder
AH-Datagramme ausgetauscht werden, kann ich vermuten, dass der
IKE_AUTH-Austausch funktioniert hat. Eine Ausnahme sind Paketmitschnitte
vom Type ``isakmp`` bei Cisco ASA (siehe dazu den Abschnitt
:ref:`Paketmitschnitt auf dem VPN-Gateway`).

In den meisten Fällen reichen
zwei Datagramme für den IKE_AUTH-Austausch.
Wird hingegen EAP verwendet,
kann es mehrere IKE_AUTH-Exchanges geben,
bei denen dann die Message-ID hochgezählt wird.
Weitere Informationen zu EAP finden sich in RFC7296 Abschnitt 2.16.

Fehler beim IKE_AUTH-Exchange
.............................

.. index:: AUTHENTICATION_FAILED
   single: Fehlermeldung; AUTHENTICATION_FAILED

Jeder Fehler bei IKE_AUTH, der dazu führt, dass die Authentisierung
fehlschlägt, sollte zu einer *AUTHENTICATION_FAILED* Nachricht führen.
Tritt der Fehler beim Responder auf, so schickt dieser die Nachricht
im Response-Datagramm. Tritt der Fehler beim Initiator auf, kann er
*AUTHENTICATION_FAILED* in einem separaten INFORMATIONAL-Exchange
senden.

.. raw:: latex

   \clearpage

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

.. index:: UNSUPPORTED_CRITICAL_PAYLOAD
   single: Fehlermeldung; UNSUPPORTED_CRITICAL_PAYLOAD

.. index:: INVALID_SYNTAX
   single: Fehlermeldung; INVALID_SYNTAX

.. index:: AUTHENTICATION_FAILED
   single: Fehlermeldung; AUTHENTICATION_FAILED

Nur bei den folgenden drei Benachrichtigungen während eines
IKE_AUTH-Austausches beziehungsweise im unmittelbar folgenden
INFORMATIONAL-Austausch wird die IKE-SA nicht erzeugt:

* UNSUPPORTED_CRITICAL_PAYLOAD
* INVALID_SYNTAX
* AUTHENTICATION_FAILED

Falls nur das Erzeugen der ersten Child-SA während des IKE_AUTH-Austauschs
fehlschlägt, wird die IKE-SA trotzdem erzeugt. Die folgenden
Fehlermeldungen deuten darauf hin, dass nur das Erzeugen der Child-SA
fehlschlug und die IKE-SA angelegt wurde:

.. index:: NO_PROPOSAL_CHOSEN
   single: Fehlermeldung; NO_PROPOSAL_CHOSEN

.. index:: TS_UNACCEPTABLE
   single: Fehlermeldung; TS_UNACCEPTABLE

.. index:: SINGLE_PAIR_REQUIRED
   single: Fehlermeldung; SINGLE_PAIR_REQUIRED

.. index:: INTERNAL_ADDRESS_FAILURE
   single: Fehlermeldung; INTERNAL_ADDRESS_FAILURE

.. index:: FAILED_CP_REQUIRED
   single: Fehlermeldung; FAILED_CP_REQUIRED

* NO_PROPOSAL_CHOSEN
* TS_UNACCEPTABLE
* SINGLE_PAIR_REQUIRED
* INTERNAL_ADDRESS_FAILURE
* FAILED_CP_REQUIRED

.. index:: ! CREATE_CHILD_SA
   single: Nachrichten; CREATE_CHILD_SA

CREATE_CHILD_SA
---------------

Der CREATE_CHILD_SA-Exchange wird zum Aushandeln zusätzlicher Child-SA
sowie zum Rekeying sowohl der IKE-SA als auch aller Child-SA verwendet.

Jeder der beiden Peers kann einen CREATE_CHILD_SA-Austausch initiieren,
so dass man unterscheiden muss zwischen dem Initiator der IKE-Sitzung,
der an den Flags im IKE-Header identifiziert werden kann und dem
Initiator des CREATE_CHILD_SA-Austausches, der den Request mit der
CREATE_CHILD_SA-Nachricht sendet. In diesem Abschnitt beziehen sich die
Begriffe Initiator und Responder auf den aktuellen
CREATE_CHILD_SA-Austausch.

.. index:: NO_ADDITIONAL_SAS
   single: Fehlermeldung; NO_ADDITIONAL_SAS

Es ist möglich, dass eine minimale Implementation keine weiteren außer
der bei IKE_AUTH ausgehandelten Child-SA erlaubt. In diesem Fall sendet
sie eine NO_ADDITIONAL_SAS-Benachrichtigung. Mit dieser Meldung kann
auch das Rekeying zurückgewiesen werden.

.. index:: INVALID_KE_PAYLOAD
   single: Fehlermeldung; INVALID_KE_PAYLOAD

Optional kann mit den CREATE_CHILD_SA-Nachrichten frisches
Schlüsselmaterial mit einer KE-Payload gesendet werden. In diesem Fall
muss mindestens eines der Proposals die DH-Gruppe des Schlüsselmaterials
enthalten. Wenn der Responder ein Proposal mit einer anderen DH-Gruppe
wählt, muss er die Nachricht mit der Fehlermeldung INVALID_KE_PAYLOAD
zurückweisen und die passende DH-Gruppe angeben.

Neue Child-SA mit CREATE_CHILD_SA erzeugen
..........................................

:numref:`create-child-sa-new-child-sa` zeigt den Austausch
für das Erzeugen einer neuen Child-SA.

.. figure:: /images/create-child-sa.png
   :alt: Sequenzdiagramm für CREATE_CHILD_SA-Exchange zum Erzeugen von
         Child-SA
   :name: create-child-sa-new-child-sa

   CREATE_CHILD_SA-Exchange zum Erzeugen von Child-SA

Der Initiator sendet SA-Vorschläge in der SA-Payload, eine Nonce in der
Ni-Payload, optional Schlüsselmaterial in der KEi-Payload und die
Traffic-Selektoren für die vorgeschlagene Child-SA in der TSi- und
TSr-Payload.

Der Responder antwortet mit der selben MID
und dem akzeptierten Vorschlag in der SA-Payload,
einer Nonce in der Nr-Payload,
einer DH-Payload und DH-Schlüsselmaterial in der KEr-Payload,
falls der Initiator ebenfalls Schlüsselmaterial gesendet hatte,
sowie der gewählten kryptographischen Suite,
die diese DH-Gruppe enthält.

Die vom Responder gesendeten Traffic-Selektoren in der TSi- und
TSr-Payload können eine Teilmenge der vorgeschlagenen Selektoren sein.

.. index:: ! USE_TRANSPORT_MODE, Transportmode

Um für den Child-SA den Transportmodus zu vereinbaren, kann der Initiator die
Benachrichtigung USE_TRANSPORT_MODE in den Request einfügen. Falls der
Request akzeptiert wird, muss der Responder ebenfalls die Benachrichtigung
USE_TRANSPORT_MODE in die Antwort einfügen. Weist der Responder diese
Aufforderung zurück, wird der Child-SA im Tunnelmodus etabliert. Ist
das für den Initiator inakzeptabel, muss er die SA löschen.

Ein fehlgeschlagener Versuch, eine Child-SA zu erzeugen sollte nicht zum
Abbau der IKE-SA führen.

Rekeying von IKE-SA mit CREATE_CHILD_SA
.......................................

Sektion 2.18 in RFC7296 behandelt
das Rekeying von IKE-SA im Detail.
:numref:`create-child-sa-rekey-ike-sa` zeigt den Austausch
für das Rekeying der IKE-SA.

.. figure:: /images/create-child-sa-rekey-ike.png
   :alt: Sequenzdiagramm für CREATE_CHILD_SA-Exchange zum Rekeying von
         IKE
   :name: create-child-sa-rekey-ike-sa

   CREATE_CHILD_SA-Exchange zum Rekeying von IKE

Der Initiator sendet SA-Vorschläge in der SA-Payload, eine Nonce in Ni
und den Diffie-Hellman-Wert in der KEi-Payload.
Einen neuen Initiator-SPI stellt er im SPI-Feld der SA-Payload bereit.

Wenn ein Peer eine Aufforderung zum Rekeying erhält, sollte er keine
neuen CREATE_CHILD_SA-Exchanges für diesen IKE-SA mehr starten.

Der Responder antwortet mit der gleichen Message-ID mit dem akzeptierten
SA-Vorschlag in der SA-Payload, einer Nonce in Nr und dem
Diffie-Hellman-Wert in KEr, wenn die gewählte kryptographische Suite
diese DH-Gruppe enthält. Außerdem sendet er eine neue Responder-SPI in
der SA-Payload.

Rekeying von Child-SA mit CREATE_CHILD_SA
.........................................

:numref:`create-child-sa-rekey-child-sa` zeigt den Austausch
für das Rekeying von Child-SA.

.. figure:: /images/create-child-sa-rekey-child.png
   :alt: Sequenzdiagramm für CREATE_CHILD_SA-Exchange zum Rekeying von
         Child-SA
   :name: create-child-sa-rekey-child-sa

   CREATE_CHILD_SA-Exchange zum Rekeying von Child-SA

Der Initiator sendet SA-Vorschläge in der SA-Payload, eine Nonce in Ni,
optional einen Diffie-Hellman-Wert in KEi und die vorgeschlagenen
Traffic-Selektoren für die neue Child-SA in TSi und TSr.

.. index:: USE_TRANSPORT_MODE

Die Benachrichtigungen, die beim Erzeugen von Child-SA versendet wurden,
können ebenfalls beim Rekeying versendet werden. Üblicherweise sind das
die gleichen Benachrichtigungen wie beim originalen Austausch, zum
Beispiel wird beim Rekeying einer SA im Transportmodus die Benachrichtigung
USE_TRANSPORT_MODE verwendet.

.. index:: REKEY_SA

Die REKEY_SA-Benachrichtigung muss in einem CREATE_CHILD_SA-Austausch
enthalten sein, wenn dieser eine existierende ESP- oder AH-SA ersetzen
soll.
Das SPI-Feld dieser Notify-Payload identifiziert die zu ersetzende SA.
Das ist die SPI, die der Exchange-Initiator in ankommenden ESP- oder
AH-Datagrammen erwarten würde.
Das Feld Protokoll-ID der REKEY_SA-Benachrichtigung ist passend zum
Protokoll der ersetzten SA, zum Beispiel 3 für ESP oder 2 für AH.

Der Responder antwortet mit dem akzeptierten Vorschlag in der
SA-Payload, einer Nonce in Nr und einem Diffie-Hellman-Wert in KEr,
falls KEi im Request enthalten war und die gewählte kryptografische
Suite diese Gruppe enthält.
Die Traffic-Selektoren im Response können eine Teilmenge dessen sein,
was der Initiator vorschlug.

Fehlermeldungen bei CREATE_CHILD_SA
...................................

.. index:: INVALID_SYNTAX

INVALID_SYNTAX:
  RFC6989 behandelt zusätzliche Diffie-Hellman-Tests für IKEv2.
  Abschnitt 2.5 dort beschreibt das Protokollverhalten
  und Abschnitt 5 listet die Tests auf,
  die bei verschiedenen DH-Gruppen gemacht werden.
  Diese Tests werden vom Responder ausgeführt,
  wenn der Initiator DH-Schlüsselmaterial sendet,
  das heißt bei IKE_SA_INIT beziehungsweise bei CREATE_CHILD_SA.

  Im Rahmen des CREATE_CHILD_SA-Austauschs
  sendet der Responder eine INVALID_SYNTAX-Nachricht
  bei einem fehlgeschlagenen Test.

  Hinweise, ob es sich tatsächlich
  um einen fehlgeschlagenen Test nach RFC6989 handelt,
  sollten im Log oder den Debug-Meldungen des Responders erkennbar sein.

.. index:: ! INFORMATIONAL
   single: Nachrichten; INFORMATIONAL

INFORMATIONAL
-------------

:numref:`informational-exchange` zeigt den Austausch
von INFORMATIONAL Nachrichten.

.. figure:: /images/informational.png
   :alt: Sequenzdiagramm für INFORMATIONAL-Exchange
   :name: informational-exchange

   INFORMATIONAL-Exchange

.. raw:: latex

   \clearpage

Die Abkürzungen stehen für folgende Informationen:

*HDR*
  IKE Header
*SK{...}*
  der Inhalt in geschweiften Klammern ist verschlüsselt
*N*
  keine, eine oder mehrere Benachrichtigungen
*D*
  keine, eine oder mehrere Löschaufforderungen
*CP*
  keine, eine oder mehrere Konfigurationsinformationen

Zum Senden von Steuernachrichten
bei Fehlerbedingungen oder bestimmten Ereignisse
dienen INFORMATIONAL-Nachrichten.
Diese dürfen erst nach dem initialen Austausch gesendet werden,
kryptografisch geschützt durch die ausgehandelten Schlüssel.

Die Nachrichten in einem INFORMATIONAL-Exchange enthalten keine, eine
oder mehrere Notification-, Delete- oder Configuration-Payloads. Der
Empfänger muss eine Antwort senden, ansonsten nimmt der Sender an, dass
die Nachricht verloren ging und wiederholt sie. Die Antwort kann eine
leere Nachricht sein. Auch die INFORMATIONAL-Anfrage kann leer sein. Auf
diese Art kann ein Peer den anderen befragen, ob er noch am Leben ist.

Die Verarbeitung eines INFORMATIONAL-Austauschs wird durch die
gesendeten Payloads bestimmt.

Eine SA löschen
...............

.. index:: AH, ESP

ESP- und AH-SA existieren immer paarweise, mit einer SA in jeder
Richtung. Wenn eine SA geschlossen wird, müssen immer beide SA des
Paares geschlossen (das heißt gelöscht) werden.
Jeder Endpunkt muss sein ankommende SA löschen und dem Peer erlauben,
dessen ankommende SA dieses Paares zu löschen.
Um eine SA zu löschen, sendet ein Peer eine INFORMATIONAL-Nachricht mit
einer oder mehreren Delete-Payloads, die die zu löschenden SA angeben.
Der Empfänger muss die angegebenen SA schließen.
Es werden niemals Delete-Payloads für beide Seiten einer SA in einer
INFORMATIONAL-Nachricht gesendet.
Wenn mehrere SA zur selben Zeit gelöscht werden sollen, sendet man
Delete-Payloads für die ankommende Hälfte der SA.

Normalerweise werden INFORMATIONAL-Nachrichten mit Delete-Payloads
beantwortet mit Delete-Payloads für die andere Richtung.
Wenn zufälligerweise beide Peers zur gleichen Zeit entscheiden ein Paar
von SA zu schließen und sich die Requests kreuzen, ist es möglich, dass
die Responses keine Delete-Payloads enthalten.

Ähnlich den ESP- und AH-SA werden auch IKE-SA mit Delete-Payloads
geschlossen, wobei noch verbliebene Child-SA ebenfalls geschlossen
werden.
Die Antwort auf einen Request, der eine IKE-SA löscht, ist eine leere
INFORMATIONAL-Nachricht.

Halb geschlossene ESP- oder AH-Verbindungen sind regelwidrig.
Ein Peer kann ankommende Daten für eine halb geschlossene SA ablehnen und
darf nicht einseitig eine SA schließen und die andere Hälfte des Paares
weiter verwenden.
Gibt es halb geschlossene ESP- oder AH-Verbindungen,
kann ein Peer die zugehörige IKE-SA schließen
und anschließend eine neue IKE-SA mit den nötigen Child-SA erzeugen.

INFORMATIONAL-Nachrichten außerhalb von IKE-SA
..............................................

Es gibt Fälle, in denen ein Knoten Datagramme erhält, die er nicht
verarbeiten kann, bei denen er seinen Peer aber darüber unterrichten
will:

* Wenn ein ESP- oder AH-Datagramm mit unbekannter SPI ankommt
* Wenn ein verschlüsseltes IKE-Datagramm mit unbekannter SPI ankommt.
* Wenn ein IKE-Datagramm mit einer höheren Version ankommt, als die
  aktuell verwendete Software unterstützt.

.. index:: INVALID_SPI
   single: Fehlermeldung; INVALID_SPI

Im ersten Fall kann der Empfänger,
wenn er eine aktive IKE-SA mit dem Sender unterhält,
über diese eine INVALID_SPI-Benachrichtigung
für das empfangene Datagramm in einem INFORMATIONAL-Exchange senden.
Die Benachrichtigungsdaten enthalten dann die unbekannte SPI.

Existiert keine aktive IKE-SA mit dem Sender,
kann der Empfänger eine INFORMATIONAL-Nachricht
ohne kryptografischen Schutz an den Absender schicken,
wobei er die Adressen und eventuell Portnummern (bei NAT-T)
des angekommenen Datagramms nimmt
und jeweils Absender und Empfänger vertauscht.
Der Empfänger der INFORMATIONAL-Nachricht
sollte diese nur als Hinweis ansehen, dass etwas schiefgegangen ist.
Auf keinen
Fall darf der Empfänger der INFORMATIONAL-Nachricht auf diese antworten.
Diese Nachricht wird wie folgt konstruiert: da der Empfänger keine SPI
für diese Nachricht hat, sind sowohl 0 als auch zufällige Werte für die
Initiator-SPI akzeptabel, das Initiator-Flag wird auf 1 gesetzt, das
Response-Flag auf 0.

.. index:: INVALID_IKE_SPI, INVALID_MAJOR_VERSION
   single: Fehlermeldung; INVALID_IKE_SPI
   single: Fehlermeldung; INVALID_MAJOR_VERSION

Im zweiten und dritten Fall wird die Nachricht
immer ohne kryptografischen Schutz gesendet
und enthält entweder eine INVALID_IKE_SPI-
oder INVALID_MAJOR_VERSION-Benachrichtigung
ohne weitere Daten.
Die Nachricht ist eine Antwort und wird dahin gesendet,
woher sie kam, mit den gleichen IKE-SPI wobei Message-ID und
Exchange-Typ aus dem Request kopiert werden.
Das Response-Flag wird auf 1 gesetzt.

