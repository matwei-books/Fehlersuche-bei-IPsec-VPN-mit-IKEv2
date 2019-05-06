
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

Diff, wdiff
-----------

AWK
---

Perl
----

Reguläre Ausdrücke
------------------

