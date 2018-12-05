
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

Die Logs finde ich direkt auf der MikroTik mit dem Befehl::

  /log print

Ich kann hier auch filtern, bevorzuge aber die Arbeit mit Textwerkzeugen
auf dem eigenen Rechner.

Was protokolliert wird und wohin, bestimme ich mit den Befehlen der
Kategorie ``/system logging``.

Von diesen sind vor allem zwei wichtig:

``/system logging topics ...``:
  legt fest was protokolliert wird, mit welchem Level und in welchen
  Kanal.

``/system logging action ...``:
  definiert die Log-Kanäle, die ich nutzen kann (Hauptspeicher, Datei,
  Logserver, ...).

.. todo:: Befehle zur Log-Konfiguration bei MikroTik kontrollieren und ergänzen

Protokolliere ich in eine Datei, kann ich diese anschließend via SCP auf
meinen Rechner kopieren und dort auswerten. Das bietet sich zum Beispiel
an, wenn ich einen bereits konfigurierten Syslog-Server nicht mit
Debugmeldungen verunreinigen will.
Die Befehle dazu sind::

  /system/logging/action
  add action=file name=vpn.log ...
  /system logging topic
  add topics=ipsec,debug action=file

Sehen kann ich die Dateien auf dem Gerät in der Kategorie ``/file``::

  /file print

Um zum Syslog-Server mit Adresse a.b.c.d zu protokollieren, verwende
ich die folgenden Befehle::

  /system/logging/action
  add name=remote remote=a.b.c.d
  /system/logging
  add action=remote topics=...

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

