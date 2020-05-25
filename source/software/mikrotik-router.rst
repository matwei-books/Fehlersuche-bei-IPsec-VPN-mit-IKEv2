
.. raw:: latex

   \clearpage

MikroTik-Router
===============

.. index:: ! RouterOS

MikroTik-Router eignen sich,
um mal eben ein VPN aufzubauen
neben all den anderen Funktionen,
die sie im Netz übernehmen können.
Es gibt diese Router in den verschiedensten Größen,
als SOHO-Router, als Core-Router für größere Netzwerke und als virtuelle
Maschine in SDN-Umgebungen. Alle laufen mit RouterOS, einem auf Linux
aufsetzenden proprietären Betriebssystem.
Wenn damit jedoch mehr als ein oder zwei VPN
zu Peers anderer Hersteller aufgebaut werden sollen,
werden die Logs schnell unübersichtlich,
was die Fehlersuche erschwert.

MikroTik-Router können auf drei Arten konfiguriert werden:

* via CLI,
* via Web-Interface,
* via WinBox, einem MS-Windows-Programm.

Mit WinBox ist es möglich,
einen MikroTik-Router über die MAC-Adresse zu kontaktieren,
wenn er mit dem selben Netzsegment verbunden ist.
Dann brauch man die IP-Adressen nicht erst auf der Konsole einstellen
oder den Umweg über die Default-Adresse gehen.
Mit dem Windows-Emulator Wine konnte ich das leider nicht,
ansonsten funktioniert WinBox mit Wine auf einem Linux-Rechner.

Die Konfiguration läuft auf allen drei Wegen ähnlich ab.
Hier konzentriere ich mich auf das CLI,
dass ich über die Konsole oder SSH erreichen kann.

Grundsätzlich gibt man bei der Konfiguration im CLI
eine Kategorie, eine Aktion und nötigenfalls zusätzliche Parameter an.
Lässt man die Kategorie weg, so kommt automatisch die aktuelle zum Zuge.
Gibt man nur die Kategorie an und keine Aktion,
dann wird diese Kategorie zur aktuellen.
Nach dem Anmelden ist die aktuelle Kategorie '/'.

Durch Eingabe von einem oder zwei <TAB> werden mögliche Fortsetzungen
der aktuellen Kommandozeile angezeigt beziehungsweise teilweise
eingegebene Kategorien, Aktionen oder Parameter soweit ergänzt, wie sie
eindeutig sind.
Das funktioniert ähnlich der Kommandozeilenvervollständigung bei Cisco IOS.

Starten, Stoppen und Kontrollieren von VPN-Tunneln
--------------------------------------------------

Die aktuell aufgebauten Tunnel kann ich mit folgenden Befehlen ansehen::

  /ip ipsec remote-peers print
  /ip ipsec installed-sa print

Alternativ kann ich auch die verkürzte Schreibweise nehmen::

  /ip ipsec
  remote-peers print
  installed-sa print

Leider zeigt ``installed-sa print`` die Traffic-Selektoren der Child-SA
nicht an.
In der aktuellen Version kenne ich auch keinen Weg,
an diese Information zu kommen.
Als Workaround kann ich auf die Systemprotokolle zugreifen.
Doch auch diese zeigen nur die Traffic-Selektoren für Child-SA,
die vom Peer initiiert wurden.
Um die Traffic-Selektoren für Child-SA, die das Gerät selbst initiiert hat,
zu bekommen, muss ich das Debug-Log für IPsec einschalten.

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

Am schnellsten ist,
die Ausgabe von ``/log print`` in eine Textdatei umzuleiten.
Zum Beispiel, indem ich via SSH nur diesen Befehl aufrufe
und die SSH-Sitzung mit ``script`` protokolliere::

  script mikrotik.log
  ssh user@mikrotik /log print
  exit

Sind die interessanten Lognachrichten nicht im Hauptspeicher zu finden,
muss ich auf andere Art und Weise auf die Logs zugreifen.

Eine Möglichkeit ist, die Logs zu einem Syslog-Server zu senden
und dann bei diesem abholen.
Um zum Syslog-Server mit Adresse a.b.c.d zu protokollieren, verwende
ich die folgenden Befehle::

  /system logging action
  add name=remote remote=a.b.c.d

  /system logging
  add action=remote topics=...

Bei den Topics interessiert mich vor allem ``ipsec``.
Leider wird die Priorität, das heißt der Loglevel, ebenfalls über das
Attribut *topic* eingestellt.
Darum kombiniere ich ``ipsec`` immer mit den gewünschten Levels.

``topics=ipsec,!packet``
  lässt den Packet-Dump der Datagramme aus.
  Diesen will ich auf dem Syslog-Server nicht haben.

``topics=ipsec,debug,!packet``
  schalte ich ein, wenn ich Probleme mit einem VPN untersuche.

``topics=ipsec,!debug,!packet``
  habe ich im Normalbetrieb eingestellt.

Weiterhin kann ich die Logs in eine Datei schreiben lassen
und diese Datei via SCP für die Untersuchung abholen.
Die Befehle dazu sind::

  /system/logging/action
  add action=file name=vpn.log
  /system logging topic
  add action=file topics=ipsec,debug

Anschauen kann ich die Dateien mit dem Befehl::

  /file print

Von meinem Rechner aus hole ich sie mittels SCP wie folgt zur Analyse ab::

  scp user@mikrotik:vpn.log .

Paketmitschnitte
----------------

Auch Paketmitschnitte sind mit RouterOS möglich.
Diese konfiguriere, starte und beende ich unter ``/tool sniffer``.

Die aktuellen Einstellungen bekomme ich mit ``/tool sniffer print``.

Ich kann den Paketmitschnitt im Speicher halten oder in eine Datei
schreiben lassen, indem ich einen Dateiname vorgebe (``file-name``) und
gegebenenfalls die Größenbeschränkung (``file-limit``) modifiziere. Die
Datei finde ich mit ``/file print`` und kann sie mit SCP auf meinen
Rechner kopieren.
Bevor ich Limits ändere, schaue ich mit ``/system resource print`` nach,
wie viel Ressourcen (Hauptspeicher, Plattenplatz) ich zur Verfügung habe.

Es gibt etliche Filterattribute,
für die ich jeweils bis zu 16 Werte vorgeben kann.
Diese werden, je nach Einstellung von ``filter-operator-between-entries``,
mit UND oder ODER verknüpft.

Mit dem Befehl ``/tool sniffer packet`` kann ich
den Paketmitschnitt auch direkt auf dem Gerät anschauen.
Das ist bei einfachen Fragen oft ausreichend.

Mit dem Attribut ``memory-scroll`` kann ich einen dauerhaften Mitschnitt
bei beschränktem Speicherplatz einstellen.

Konfiguration analysieren
-------------------------

Die Konfiguration bekomme ich mit dem Befehl ``export`` in Textform.
Direkt in der Wurzel eingegeben (``/export``) bekomme ich die gesamte
Konfiguration, ich kann mich aber auch auf Teile beschränken, zum
Beispiel auf die IPsec-Konfiguration::

  /ip ipsec export

Für den Export der Konfiguration sind zwei Attribute wichtig:

``export terse``:
  zeigt die Kategorien in jeder Zeile. Damit ist diese Ausgabe besser
  für die Suche mit ``grep`` geeignet und ich kann die ganze Zeile
  einfacher in die Konfiguration einer anderen Maschine übernehmen.

``export detail``:
  zeigt auch Defaultwerte.
  Damit kann ich Missverständnisse ausräumen,
  die durch falsche Annahmen über die Defaults entstanden sind.

Besonderheiten
--------------

Verwendet man mehrere IPsec-SA mit unterschiedlichen Traffic-Selektoren,
sollte in der Policy ``level=unique`` konfiguriert werden,
damit der gesendete Traffic an die richtige IPsec-SA gesendet wird.
Wird das vergessen
und die Gegenstelle akzeptiert keinen Traffic für die falsche SA,
dann funktiioniert zwar ein Teil des VPN
- der, bei dem der Traffic-Selektor der SA passt -
aber nicht alles.

