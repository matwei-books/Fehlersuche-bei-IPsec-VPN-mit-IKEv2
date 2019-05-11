
Arbeit mit Textdateien
======================

Eine grundlegende Fähigkeit bei der Fehlersuche ist der souveräne Umgang
mit großen Mengen Text. Leider vermisse ich diese Fähigkeit bei einigen
meiner Kollegen, vor allem bei denen, die sich schwer tun mit komplexen
Fehlersuchen.

Kann ich souverän mit Text umgehen, so hilft mir das bei der Auswertung
der Logs und der Debugausgaben sowie bei der Analyse von
Konfigurationsdateien, wenn diese als Text vorliegen.

.. note::
   Zwar höre ich immer wieder von Log-Software, die den Umgang mit den
   Logs doch so gut unterstützen kann und so viele Filtermöglichkeiten
   bietet oder gar Nachrichten korrellieren kann.

   Fakt ist, dass ich noch von keinem dieser Programme, dass ich bisher
   erleben durfte, bessere Ergebnisse als bei einer Auswertung mit
   Textwerkzeugen bekommen habe. Was mir allerdings jedesmal verloren
   ging, war Zeit für die umständliche Bedienung der graphischen
   Benutzeroberfläche mit der das Programm daher kommt.

   Ganz abgesehen von den Macken die manche unausgereifte Software hat.

   In einem Fall änderten wir unseren Workflow so ab, dass wir alle
   interessanten Logzeilen nach Excel exportieren, in Excel genau die
   Spalte, die die Logzeilen enthielt, als CSV exportierten und dann mit
   den üblichen Textwerkzeugen weiter arbeiteten. Damit waren wir immer
   noch schneller als die ganze Untersuchung in QRadar zu machen. Kein
   Grund zum Aufatmen bei Splunk, Prolog und Co., keines von diesen ist
   besser.

   Ein Kollege, der bei einer Fehlersuche stundenlang mit einem
   derartigen Tool Logs untersuchte und dabei nicht davon abließ, sein
   Tool zu preisen, brachte das Problem damit unbewusst auf den Punkt.
   Man kann mit diesen Tools relativ schnell die Ursache eines Problems
   finden, *wenn man weiß, wonach man suchen muss*.
   
   Bei komplizierten Problemen habe ich diesen Luxus jedoch nicht oft
   und weiß meist erst hinterher, wonach ich hätte suchen sollen.
   Dann kommt es während der Untersuchung darauf an, dass ich schnell
   in großen Texten navigieren kann sowie schnell Text selektieren,
   reduzieren und extrahieren kann. Und in manchen Fällen brauche ich
   einen rudimentären Parser für semistrukturierten Text wie
   Konfigurationsdateien.

Darum arbeite ich am liebsten mit

less
    um mir einen Überblick zu verschaffen und schnell im Text zu
    navigieren,

grep
    um Text zu selektieren und zu reduzieren, manchmal auch um Text zu
    finden,

diff und wdiff
    um ähnliche Texte zu vergleichen und kleine Unterschiede zu finden,

awk oder perl
    um Text zu extrahieren oder um halbstrukturierten Text zu parsen,
    zum Beispiel um alle VPN zu identifizieren, die auf eine bestimmte
    Art konfiguriert sind.

Und natürlich arbeite ich bei allen diesen Werkzeugen mit regulären
Ausdrücken um zu konkretisieren, an welchem Teil des Textes ich
interessiert bin.

Less
----

Das wichtigste, was man bei einem interaktiven Programm wissen muss, ist
wie man es beendet.
Das geht mit den Tastaturkommandos ``Q``, ``q``, ``:Q``, ``:q`` oder ``ZZ``.
Kenner des Editors *vi* beziehungsweise seiner Nachfahren sehen in den
letzten beiden Möglichkeiten eine Verwandschaft der Bedienung zu diesem
Editor.

Den Text, den ich mit less betrachten will, kann ich auf der
Kommandozeile als Dateinamen angeben oder über eine Pipe zur
Standardeingabe hinein schicken::

    less datei1 [ datei2 [ ... ] ]

    grep muster /var/log/syslog | less

Der Hauptgrund, less zu benutzen ist jedoch die komfortable und dabei
schnelle Navigation in größeren Texten.
Dazu bewege ich mich mit jeweils einem Tastendruck

ENTER, RETURN, ``j`` oder Pfeil-runter
    eine Zeile nach unten

SPACE oder ``f``
    einen Bildschirm nach unten

``>`` oder ``G``
    an das Ende der Datei

``y``, CTRL-P, ``k`` oder Pfeil-rauf
    eine Zeile nach oben

``b``
    eine Bildschirmseite nach oben

``<``, ``g`` oder ``1G``
    an den Anfang der Datei (ich kann zu beliebigen Zeilen springen
    durch Eingabe der Zeilennummer gefolgt von ``G``)

ESC-) oder Pfeil-rechts
    eine halbe Bildschirmseite nach rechts (die Anzahl der Spalten kann
    ich mit der Option ``-# Spaltenzahl`` ändern)

ESC-( oder Pfeil-links
    eine halbe Bildschirmseite nach links

Die letzten beiden Bewegungen sind praktisch, wenn ich less so
eingestellt habe, dass lange Zeilen am Bildschirmrand abgeschnitten werden.
Das mache ich grundsätzlich bei Logzeilen mit der Option ``-S``.

Mit den Befehlen ``/Muster`` suche ich vorwärts im Text nach dem nächsten
Vorkommen von *Muster*.
Um rückwärts zu suchen verwende ich stattdessen ``?Muster``.
Mit ``n`` wiederhole ich die letzte Suche und mit ``N`` kehre ich die
Suchrichtung um.

Mit ``&Muster`` kann ich die Anzeige auf die Zeilen beschränken, die
*Muster* enthalten.

Mit ``m`` gefolgt von einem Kleinbuchstaben kann ich eine Stelle im Text
markieren und mit ``'`` (dem Apostroph) gefolgt von eben diesem
Kleinbuchstaben kann ich später zu dieser Stelle zurückspringen.

Habe ich mehrere Dateien beim Aufruf von less angegeben, kann ich mit
``:n`` zur nächsten Datei gehen und mit ``:p`` zur vorherigen in der
Liste.

Zum Schluss kommen ich noch ein paar nützliche Optionen, die ich
regelmäßig bei Less verwende.
Alle Optionen können auf der Kommandozeile beim Aufruf angegeben werden
oder interaktiv mit dem vorangestellten ``-``.
Bei der interaktiven Eingabe werden die Einstellungen abwechselnd ein-
und ausgeschaltet (toggle).

``-i``
    Groß- und Kleinschreibung bei der Suche ignorieren.

``-N``
    Zeilennummern anzeigen

``-S``
    Lange Zeilen abschneiden.

Das sind die Kommandos und Optionen, die ich am häufigsten verwende.
Less hat noch sehr viel mehr zu bieten, die meisten davon sind nicht wichtig,
bei Bedarf gibt es Hilfe aus der Handbuchseite ``man less``, die übrigens bei den meisten
Systemen mit less paginiert wird.
Noch schneller kommt man an Hilfe mit der Kommandozeilenoption ``--help``
beziehungsweise ``-?`` oder, während das Programm schon läuft,
mit dem Tastaturkommando ``h`` oder ``H``.

Grep
----

Ich verwende grep am häufigsten um Text in einer Pipe oder Datei zu
filtern oder zu suchen, um eine Datei zu finden, die einen bestimmten
Text enthält oder um überflüssige Zeilen beim Betrachten einer Datei zu
entfernen.

Normalerweise unterscheidet grep die Groß- und Kleinschreibung der
angegebenen Muster, mit der Option ``-i`` kann ich das abschalten.

Text in einer Pipe filtere ich meist beim analysieren von Logdateien.
Wenn ich zum Beispiel während einer Debugging-Sitzung die relevanten
aktuellen Logzeilen im Auge behalten will, filtere ich in einer Console
mit dem Befehl::

  tail -f /var/log/syslog | grep Muster

Ist das Muster zu grob, kann ich den Filter iterativ verfeinern, indem
ich einen weiteren Aufruf via Pipe hinten anfüge::

  tail -f /var/log/syslog | grep Muster | grep -v Muster2

Beim Debugging von IPsec-Problemen ist als erstes Muster oft die
IP-Adresse des Peer-VPN-Gateways geeignet.
Mit der Option ``-v`` schließe ich anschließend Zeilen aus, die mich
nicht interessieren.

Manchmal interessiert mich nur ein kleiner Ausschnitt aus einer Datei,
von dem ich weiß, dass er ein bestimmtes Muster enthält.
Dann suche ich die Zeilen mit diesem Muster::

  grep Muster Dateiname
  grep -A n Muster Dateiname
  grep -B n Muster Dateiname
  grep -C n Muster Dateiname

Stehen die interessanten Informationen nicht genau in den Zeilen mit dem
Muster, kann ich mit der Option ``-A n`` *n* Zeilen danach (after)
ausgeben lassen oder mit Option ``-B n`` *n* Zeilen davor (before).
Die Option ``-C n`` (context) hingegen gibt mir sowohl *n* Zeilen vor
der mit dem Muster als auch die darauf folgenden *n* Zeilen aus.

Komme ich auf ein mir bis dahin unbekanntes System, dann muss ich
mitunter erst einmal die Datei suchen, die ein bestimmtes Muster enthält.
Dabei hilft mir zum Beispiel für Konfigurationsdateien::

  grep -r Muster /etc

Will ich die Datei gleich betrachten, dann bin ich nur an den Dateinamen
interessiert, die ich mit der Option ``-l`` bekomme::

  less $(grep -r Muster /etc)

Manchmal finde ich auf einem System als Konfigurationsdatei eine
modifizierte Default-Datei mit großen Mengen an Kommentaren und nur
wenigen Konfigurationsanweisungen.
Dann reduziere ich die Datei mit folgendem Befehl auf das Wesentliche::

  grep -v -E '^\s*(|#.*)$' Dateiname

Sollten andere Zeichen als ``#`` einen Kommentar einleiten, muss ich den
Ausdruck entsprechend anpassen.
Was der Ausdruck nach Option ``-E`` konkret bedeutet, erläutere ich im
Abschnitt :ref:`grundlagen/textdateien:Reguläre Ausdrücke`.

Diff
----

Ein weiteres Werkzeug für die Analyse von Texten ist diff.
Es vergleicht zwei Texte und markiert die Unterschiede, üblicherweise
zeilenweise, wobei es die unterschiedlichen Zeilen untereinander
anzeigt (die Alternative wdiff hingegen markiert wortweise Unterschied
im Text).

Generell verwende ich diff, wenn ich durch optischen Vergleich zweier
Texte nur mühsam die Unterschiede erkennen kann.
Das betrifft in den meisten Fällen Konfigurationsdateien, manchmal aber
auch die Ausgabe von anderen Programmen.

Am häufigsten verwende ich dabei die Option ``-u``, bei der Zeilen, die
nur in einer Datei vorkommen, mit ``-`` gekennzeichnet werden und die
der anderen Datei mit ``+``.
Davor und dahinter werden drei Zeilen, die in beiden Dateien gleich
sind, ohne Markierung angezeigt.

Unterscheiden sich zwei Dateien in der Anzahl oder Art der Leerzeichen,
zum Beispiel weil eine Datei Zeilenende nach DOS-Konvention (CRLF) und
die andere nach Unix-Konvention (LF) hat, oder in einer Tabulatoren
verwendet werden und in der anderen Leerzeichen, dann kann ich mit den
Optionen ``-b``, ``-B``, ``-E``, ``-w`` oder ``-Z`` diese Unterschiede
ignorieren lassen.
Die genaue Bedeutung der Optionen steht in der Handbuchseite oder wird
beim Aufruf von ``diff --help`` angezeigt.

AWK
---

AWK verwende ich für einfache Manipulationen von zeilenorientierten Daten.
Dafür ist es ideal geeignet denn die Grundstruktur eines AWK-Skripts
besteht aus einer Folge von Mustern, denen zugehörige Aktionen in einem
Anweisnugsblock folgen::

  /Muster/ { aktionen }

Dabei können die Aktionen sehr komplex sein und auch
Stringmanipulationen enthalten.
Bei den Aktionen steht mir die ganze Zeile als ``$0`` für die Bearbeitung
zur Verfügung und die einzelnen Felder daraus als ``$1`` bis ``$n``
wobei die Felder durch Leerzeichen getrennt werden, wenn ich den
Feldtrenner nicht mit der Option ``-F`` modifiziert habe.

Mit den beiden Spezialformen ::

  BEGIN { aktionen }
  END   { aktionen }

kann ich zum Beispiel am Anfang Zähl- oder Summenvariablen
initialisieren, die beim Einlesen der Zeilen manipuliert werden und am
Ende ausgegeben werden können.

Oft verwende ich AWK mal eben schnell um in den Logs nach bestimmten
Fehlermeldungen zu suchen und dann im Aktionsblock die IP-Adresse des
Peer-VPN-Gateways zu extrahieren und  auszugeben.
Dazu muss ich wissen, in welchem Feld die Adresse steht und komme dann
mit folgendem Einzeiler aus::

  awk '/fehlermeldung/ { print $n }' < /var/log/syslog

Für aufwendigere Manipulationen schaue ich mit ``man awk`` in den
Handbuchseiten nach, welche Funktionen mir weiterhelfen können.

Perl, Python und andere Skriptsprachen
--------------------------------------

.. _regex:

Reguläre Ausdrücke
------------------

