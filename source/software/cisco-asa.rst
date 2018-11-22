
Cisco ASA
=========

Die Cisco ASA (Adaptive Security Appliance) bietet verschiedene Interfaces
zur Konfiguration:

* die Kommandozeile, die derjenigen in Cisco-Routern und Switches
  ähnelt,

* den ASDM (Adaptive Security Device Manager), einer Java-Anwendung die
  direkt auf dem Gerät abgelegt ist,

* den CSM (Cisco Security Manager), mit dem mehrere ASA verwaltet werden
  können.

Jede dieser Schnittstellen hat ihre Vor- und Nachteile.
Ich bevorzuge für die Extraktion der relevanten Konfiguration und für
schnelle Zustandsabfragen die Kommandozeile.
Für den Echtzeitzugriff auf die Systemlogs bietet der ASDM gute
Filtermöglichkeiten.
Wenn es gilt, ähnliche Konfigurationen auf verschiedenen Geräten
konsistent zu halten, kann der CSM seine Vorteile ausspielen.

Bei den nachfolgenden Betrachtungen gehe ich auf die
Kommandozeilenbefehle ein, für die ich meist höhere Rechte benötige.
Das heißt, nach dem Anmelden gebe ich ``enable`` ein, falls mein Zugang
nicht von sich aus höhere Rechte besitzt.
Generell können alle Kommandozeilenbefehle und deren Optionen so weit
gekürzt werden, wie sie eindeutig sind. Mit dem Fragezeichen oder dem
Tabulator kann ich jederzeit eine kurze Hilfe bekommen, welche Eingaben
als nächstes möglich sind.

Muss ich die Konfiguration ändern, kann ich das mit einem der folgenden
äquivalenten Befehle::

  configure terminal
  conf t

Ich beende die Konfiguration mit ``end`` und sichere sie mit dem Befehl
``write memory`` (kurz ``wr``).

Systemlogs und Debug-Informationen
----------------------------------

.. todo:: Quelle für Informationen in die Referenzen

   z.B.: https://www.cisco.com/c/en/us/td/docs/security/asa/asa82/configuration/guide/config/monitor_syslog.html

Möchte ich die Systemlogs in der Konsole oder SSH-Sitzung sehen, gebe
ich einen der folgenden Befehle ein::

   terminal monitor
   term mon

Um die Systemlogs und Debug-Informationen zu einem Logserver zu
schicken, muss ich in die Konfiguration ändern::

   conf t
   logging enable
   logging trap $level
   logging host $interface $address [ ... ]

Hierbei steht $level für eine der folgenden Prioritäten:

===== =============
Level Schlüsselwort
===== =============
  0   emergency
  1   alert
  2   critical
  3   error
  4   warning
  5   notification
  6   informational
  7   debugging
===== =============

Mit $interface gebe ich die Schnittstelle an, zu der die Logs rausgehen,
mit $address die Adresse des Syslogservers.
Wenn nötig kann ich weitere Informationen zum Logserver bereitstellen,
siehe dazu die entsprechende Dokumentation.

Um überhaupt auf ASDM oder (SSH-)Konsole zu loggen, konfiguriere ich
zusätzlich die folgenden Befehle::

  logging asdm $level
  logging console $level

Dann kann ich in der jeweiligen Sitzung auf die Logs zugreifen.
Auf der Konsole kann ich die Ausgabe mit den folgenden Befehlen
steuern::

  term monitor
  no term monitor

Der Befehl ``show logging`` zeigt die aktuellen Einstellungen.

Für das Debugging sieht es ähnlich aus.
Um Debug-Ausgaben zum Syslog-Server zu senden, konfiguriere ich
zusätzlich zur Konfiguration für die Logs::

  logging debug-trace
  logging trap debugging

Interaktiv steuere ich das Debugging von IPsec mit den folgenden
Befehlen::

  debug crypto condition peer $address
  debug crypto ikev2 protokol $dlevel
  debug crypto ikev2 platform $dlevel
  undebug all

Der erste Befehl schränkt das Debugging auf einen Peer ein und ist
dringend geboten, wenn mehr als ein Peer aktiv ist.
Mit $address gebe ich die Adresse des Peers an, an dem ich interessiert
bin.
Der Parameter $dlevel bestimmt die Granularität der Debugmeldung und
liegt zwischen 1 und 255.
Mit ``undebug all`` schalte ich das Debugging ab, wenn ich alle
benötigten Informationen habe.

