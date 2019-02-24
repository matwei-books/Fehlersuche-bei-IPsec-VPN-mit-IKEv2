
MikroTik-Router
===============

MikroTik-Router sind in den verschiedensten Größen erhältlich, als
SOHO-Router, als Core-Router für größere Netzwerke und als virtuelle
Maschine in SDN-Umgebungen. Alle laufen mit Router OS, einem auf Linux
aufsetzenden proprietären Betriebssystem.

Es gibt drei Möglichkeiten, sie zu konfigurieren:

* via CLI,
* via Web-Interface,
* via WinBox, einem MS-Windows-Programm, das mit Wine auch unter Linux
  läuft.

Mit WinBox ist es auch möglich, einen MikroTik-Router über die
MAC-Adresse zu kontaktieren, wenn er mit dem selben Netzsegment
verbunden ist. Mit Wine funktioniert das leider nicht.

Die Konfiguration läuft auf allen drei Wegen ähnlich ab, hier
konzentriere ich mich auf das CLI, dass ich über die Konsole oder SSH
erreichen kann.

Grundsätzlich gibt man bei der Konfiguration im CLI eine Kategorie, eine
Aktion und gegebenenfalls zusätzliche Parameter an. Wird die Kategorie
weggelassen, so kommt automatisch die aktuelle zum Zuge. Wird nur die
Kategorie angegeben und keine Aktion, dann wird diese Kategorie zur
aktuellen. Nach dem Anmelden ist die aktuelle Kategorie '/'.

Durch Eingabe von einem oder zwei <TAB> werden mögliche Fortsetzungen
der aktuellen Kommandozeile angezeigt beziehungsweise teilweise
eingegebene Kategorien, Aktionen oder Parameter soweit ergänzt, wie sie
eindeutig sind.
Das funktioniert ähnlich der Kommandozeilenvervollständigung bei Bash oder Cisco IOS.

Starten, Stoppen und Kontrollieren von VPN-Tunneln
--------------------------------------------------

Die aktuell aufgebauten Tunnel kann ich mit folgenden Befehlen ansehen::

  /ip ipsec remote-peers print
  /ip ipsec installed-sa print

Alternativ kann ich auch die verkürzte Schreibweise nehmen::

  /ip ipsec
  remote-peers print
  installed-sa print

Leider zeigt ``installed-sa print`` nicht die Traffic-Selektoren für die
Child-SA an.  In der aktuellen Version kenne ich auch keinen sauberen Weg,
an diese Information zu kommen.  Als Workaround kann ich auf die
Informationen aus den Systemlogs zugreifen. Doch auch diese zeigen nur
die Traffic-Selektoren für Child-SA, die vom Peer initiert wurden. Um die
Traffic-Selektoren für Child-SA, die das Gerät selbst initiiert hat, zu
bekommen, muss ich das Debug-Log für IPsec einschalten.

Um einen VPN-Tunnel zu beenden verwende ich die Befehle::

  /ip ipsec
  remote-peers kill-connections
  installed-sa flush

Systemlogs und Debug-Informationen
----------------------------------

Was auf der MikroTik protokolliert wird und wohin, bestimme ich mit
den Befehlen der Kategorie ``/system logging``.

Von diesen sind vor allem zwei wichtig:

``/system logging topics ...``:
  legt fest was protokolliert wird, mit welchem Level und in welchen
  Kanal.

``/system logging action ...``:
  definiert die Log-Kanäle, die ich nutzen kann (Hauptspeicher, Datei,
  Logserver, ...).

Die Logs, die sich im lokalen Speicher der MikroTik befinden, lese ich
mit dem Befehl::

  /log print

Ich kann hier filtern, bevorzuge aber meist die Arbeit mit
Textwerkzeugen auf dem eigenen Rechner.
Dafür habe ich mehrere Möglichkeiten.

Am schnellsten geht, die Ausgabe von ``/log print`` in eine Textdatei
umzuleiten. Zum Beispiel, indem ich via SSH nur diesen Befehl aufrufe
und die SSH-Sitzung zum Beispiel mit ``script`` protokolliere::

  script mikrotik.log
  ssh user@mikrotik /log print
  exit

Die ersten und letzten Zeilen schneide ich ab von der Datei
*mikrotik.log* und kann diese in aller Ruhe untersuchen.

Sind die interessanten Lognachrichten schlecht im Hauptspeicher zu
finden, weil dieser vielleicht nicht so viele Nachrichten fassen kann,
muss ich auf andere Art auf die Logs zugreifen.

Eine andere Möglichkeit ist, die Logs zu einem Syslog-Server zu senden
und dann bei diesem abzuholen.
Um zum Syslog-Server mit Adresse a.b.c.d zu protokollieren, verwende
ich die folgenden Befehle::

  /system logging action
  add name=remote remote=a.b.c.d

  /system logging
  add action=remote topics=...

Bei den Topics interessiert mich vor allem ``ipsec``.
Leider wird die Priorität, das heißt der Loglevel, ebenfalls über das
Attribut *topic* eingestellt.
Darum kombiniere ich ``ipsec`` meist mit den gewünschten Levels.

``topics=ipsec,!packet``
  lässt den Packet-Dump der Datagramme aus.
  Diesen will ich auf dem Syslog-Server sowieso nicht haben.

``topics=ipsec,debug,!packet``
  schalte ich ein, wenn ich Probleme mit einem VPN untersuche.

``topics=ipsec,!debug,!packet``
  habe ich im Normalbetrieb eingestellt.

Schließlich kann ich die Logs in eine Datei schreiben lassen und diese
Datei zum Beispiel via SCP für die Untersuchung abzuholen.
Die Befehle dazu sind::

  /system/logging/action
  add action=file name=vpn.log
  /system logging topic
  add action=file topics=ipsec,debug

Sehen kann ich die Dateien auf dem Gerät in der Kategorie ``/file``::

  /file print

Von meinem Rechner aus kann ich sie zum Beispiel mittels SCP zur
Analyse abholen::

  scp user@mikrotik:vpn.log .

Paketmitschnitte
----------------

Auch Paketmitschnitte sind möglich.
Diese konfiguriere, starte und beende ich unter ``/tool sniffer``.

Die aktuellen Einstellungen bekomme ich mit ``/tool sniffer print``.

Ich kann den Paketmitschnitt im Speicher halten oder in eine Datei
schreiben lassen, indem ich einen Dateiname vorgebe (``file-name``) und
gegebenenfalls die Größenbeschränkung (``file-limit``) modifiziere. Die
Datei finde ich mit ``/file print`` und kann sie mit SCP auf meinen
Rechner kopieren.

Es gibt etliche Filterattribute, für die ich jeweils bis zu 16 Werte
vorgeben kann.

Mit dem Befehl ``/tool sniffer packet`` kann ich mir den Paketmitschnitt
auch direkt auf dem Gerät anschauen. Das ist bei einfachen Fragen oft
ausreichend.

Mit dem Attribut ``memory-scroll`` kann ich einen dauerhaften Mitschnitt
bei beschränktem Speicherplatz einstellen.

Bevor ich Limits verstelle, schaue ich mit ``/system resource print``
nach, wie viel Ressourcen (Hauptspeicher, Plattenplatz) ich überhaupt
zur Verfügung habe.

Konfiguration analysieren
-------------------------

Die Konfiguration bekomme ich mit dem Befehl ``export`` in Textform.
Direkt in der Wurzel eingegeben (``/export``) bekomme ich die gesamte
Konfiguration, ich kann mich aber auch auf Teile beschränken, zum
Beispiel auf die IPsec-Konfiguration::

  /ip ipsec export

Zwei Attribute für den Export der Konfiguration sind wichtig:

``export terse``:
  zeigt die Kategorien in jeder Zeile. Damit ist diese Ausgabe besser
  für die Suche mit grep geeignet und ich kann die ganze Zeile
  einfacher in die Konfiguration einer anderen Maschine übernehmen.

``export detail``:
  zeigt auch die Defaultwerte. Damit können eventuelle
  Missverständnisse, die durch falsche Annahmen über die Defaults
  enstanden sind, ausgeräumt werden.

