
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

Bei den nachfolgenden Diagrammen werden folgende Abkürzungen verwendet:

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

Der IKE_AUTH-Exchange erfolgt bereits verschlüsselt. Im Normalfall kann
ich in einem Paketmitschnitt nur aus äußeren Merkmalen schließen, ob
er erfolgreich war. Insbesondere, wenn anschließend ESP- oder
AH-Datagramme ausgetauscht werden, kann ich vermuten, dass der
IKE_AUTH-Austausch funktioniert hat. Eine Ausnahme sind Paketmitschnitte
vom Type ``isakmp`` bei Cisco ASA (siehe dazu
:ref:`Paketmitschnitt auf dem VPN-Gateway`).

.. index:: ! CREATE_CHILD_SA
   single: Nachrichten; CREATE_CHILD_SA

CREATE_CHILD_SA
---------------

.. index:: ! INFORMATIONAL
   single: Nachrichten; INFORMATIONAL

INFORMATIONAL
-------------

