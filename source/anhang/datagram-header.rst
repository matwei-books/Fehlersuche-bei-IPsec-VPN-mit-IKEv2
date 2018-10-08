
Datagramm-Header
================

.. index:: Datagramm-Header; IKE

IKE Header
----------

IKE-Nachrichten verwenden UDP-Port 500 oder 4500.

Dabei werden die Informationen vom Beginn des Datagramms bis
einschließlich des UDP-Headers weitgehend ignoriert. Lediglich die
Quell- und Zieladressen und Quell- und Zielports werden für das
Antwort-Datagramm (Response) vertauscht.

.. index:: ! Non-ESP-Marker

UDP-Port 4500 wird nur bei NAT-Traversal verwendet. In diesem Fall
werden zwischen den UDP- und den IKE-Header vier Oktetts mit dem Wert 0
eingefügt. Diese vier Oktetts - auch Non-ESP-Marker genannt - dienen
dazu, IKE-Nachrichten von IPsec-Datagrammen bei NAT-Traversal zu
unterscheiden.

.. figure:: /images/ipsec-ike-datagram.png
   :alt: IKEv2-Header aus RFC 7269, Abschnitt 3.1
   :name: ipsec-ike-datagram

   IKE Header

* Initiator’s SPI (8 Oktetts) - wird vom Initiator gewählt
  um eine IKE SA eindeutig zu identifizieren. Dieser Wert darf nicht
  Null sein.
* Responder’s SPI (8 Oktetts) - wird vom Responder gewählt um
  eine IKE SA eindeutig zu identifizieren. Dieser Wert muss im ersten
  Datagramm eines IKE_SA_INIT-Austauschs Null sein (auch, wenn diese
  Nachricht wiederholt wird).
* Next Payload (1 Oktett) - zeigt den Typ des Headers an, der diesem
  Header unmittelbar folgt.
* Major Version (4 Bits) - zeigt die Hauptversion des verwendeten
  IKE-Protokolls an. Anwendungen, die diese Version von IKE
  implementieren, müssen das Feld auf den Wert 2 setzen. Nachrichten
  mit einer größeren Versionsnummer mussen von Anwendungen, die
  Version 2 implementieren ignoriert oder mit einer
  INVALID_MAJOR_VERSION-Nachricht zurückgewiesen werden.
* Minor Version (4 Bits) - zeigt die Unterversion des verwendeten
  Protokolls an. Anwendungen, die IKEv2 implementieren, müssen die
  Unterversion auf 0 setzen und in empfangenen Nachrichten
  ignorieren.
* Exchange Type (1 Oktett) - zeigt den Nachrichtentyp an. Die
  erlaubten Werte nach RFC 7296 sind:

  =============== ====
  Exchange Typ    Wert
  =============== ====
  IKE_SA_INIT     34
  IKE_AUTH        35
  CREATE_CHILD_SA 36
  INFORMATIONAL   37
  =============== ====

  Die aktuell gültigen Werte finden sich in :cite:`IKEv2parameters`.
* Flags (1 Oktett) - zeigt spezifische Optionen für diese Nachricht
  an. Die Bits haben folgende Bedeutung: |ipsec-ike-datagram-options|

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
    verwendet, um zu bestimmen, welches der acht SPI-Oktetts von ihm
    erzeugt wurden. Dieses Bit ändert sich beim Rekeying um
    anzuzeigen, wer das letzte Rekeying initiert hat.

* Message ID (4 Oktetts, unsigned Integer) - wird verwendet, um das
  erneute Übertragen von verlorenen Datagrammen zu steuern und die
  Anfragen und Antworten zuzuordnen. Die Message ID (MID) ist
  wesentlich für die Sicherheit des Protokolls, weil sie
  Replay-Attacken verhindert.
* Length (4 Oktetts, unsigned Integer) - Gesamtlänge der Nachricht
  (Header + Nutzlast) in Oktetts.

.. |ipsec-ike-datagram-options| image:: /images/ipsec-ike-datagram-options.png
   :scale: 40 %
   :align: middle
   
.. .. raw:: latex

   \clearpage

Generic Payload Header
----------------------

Jede IKE-Nutzlast beginnt mit einem generischen Header wie in
:numref:`ipsec-ike-datagram-gph` dessen Felder ich nachfolgend
erläutere. Die konkreten IKE-Parameter sind als Nutzlast in den
Abschnitten 3.2 bis 3.16 von :cite:`RFC7296` beschrieben.

.. figure:: /images/ipsec-ike-datagram-gph.png
   :alt: IKEv2 Generic Payload Header aus RFC 7296, Abschnitt 3.2
   :name: ipsec-ike-datagram-gph

   IKEv2 Generic Payload Header aus RFC 7296

* Next Payload (1 Oktett) - identifiziert den Datentyp der nächsten
  Nutzlast. Bei der letzten Nutzlast in der Nachricht ist dieses Feld 0.
  
  Damit können Nutzlasten verkettet werden indem eine zusätzliche
  Nutzlast an das Ende der Nachricht gehängt und vom bis dahin letzten
  Payload Header referenziert wird. Eine Ausnahme davon ist eine
  verschlüsselte Nutzlast, die immer als letzte in der Kette eingefügt
  werden muss.

  Eine verschlüsselte Nutzlast enthält selbst Datenstrukturen in Form
  von Nutzlasten mit generischen Payload Headern. Bei einer
  verschlüsselten Nutzlast verweist das Feld *Next Payload* auf den Typ
  der ersten enthaltenen Nutzlast und das *Next Payload* Feld der
  letzten enthaltenen Nutzlast ist 0.

  Die Nutzlasttypen nach RFC 7296 (Details: Abschnitt 3.2 bis 3.16) sind:

  ============================ ======== =====
  Next Payload Type            Notation Value
  ============================ ======== =====
  No Next Payload                       0
  Security Association         SA       33
  Key Exchange                 KE       34
  Identification - Initiator   IDi      35
  Identification - Responder   IDr      36
  Certificate                  CERT     37
  Certificate Request          CERTREQ  38
  Authentication               AUTH     39
  Nonce                        Ni, Nr   40
  Notify                       N        41
  Delete                       D        42
  Vendor ID                    V        43
  Traffic Selector - Initiator TSi      44
  Traffic Selector - Responder TSr      45
  Encrypted and Authenticated  SK       46
  Configuration                CP       47
  Extensible Authentication    EAP      48
  ============================ ======== =====

  Die aktuell gültigen Werte finden sich in :cite:`IKEv2parameters`.

  Nutzlasttypen 1-31 sollen auch in Zukunft nicht verwendet werden, so
  dass es keine Überschneidung mit IKEv1 gibt.
  
* Critical (1 bit) - bezieht sich auf die aktuelle Nutzlast und hat
  folgende Bedeutung:

  Der Sender muss das Feld auf 0 setzen, wenn der Empfänger die Nutzlast
  überspringen soll, wenn er sie nicht versteht. Wenn der Empfänger die
  ganze Nachricht zurückweisen soll weil er sie nicht versteht, muss der
  Sender das Feld auf 1 setzen.

  Der Empfänger ignoriert das Feld, wenn er den Typcode der Nutzlast
  versteht. Wenn er eine Nutzlast ignoriert, geht er davon aus, dass das
  *Next Payload* und das *Payload Length* Feld gültige Werte enthalten.

* RESERVED (7 bits) - Müssen mit Wert 0 gesendet und beim Empfang einer
  Nachricht ignoriert werden.

* Payload Length (2 Oktetts, unsigned Integer) - Länge in Oktetts der
  aktuellen Nutzlast inklusive des Payload Headers.

.. index:: ! Security Association Payload
   see: SA-Payload; Security Association Payload

Security Association Payload
----------------------------

Die SA-Payload ist in :cite:`RFC7296`, Abschnitt 3.3 ausführlich
beschrieben.

.. todo:: SA-Payload

