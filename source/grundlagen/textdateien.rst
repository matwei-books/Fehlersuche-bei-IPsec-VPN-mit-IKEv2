
.. raw:: latex

   \clearpage

Arbeit mit Textdateien
======================

Eine grundlegende Fähigkeit bei der Fehlersuche ist der souveräne Umgang
mit großen Mengen Text. Leider vermisse ich diese Fähigkeit bei einigen
meiner Kollegen, vor allem bei denen, die sich schwer tun mit komplexen
Fehlersuchen.

Kann ich souverän mit Text umgehen, so hilft mir das bei der Auswertung
der Logs und der Debugausgaben sowie bei der Analyse von
Konfigurationsdateien, wenn diese als Text vorliegen.

.. admonition:: Am Rande

   Ich bekomme immer wieder
   von verschiedener Seite Log-Software empfohlen,
   die den Umgang mit den Logs gut unterstützen kann
   und so viele Filtermöglichkeiten bietet
   oder gar Nachrichten korrellieren kann.

   Fakt ist, dass ich noch von keinem dieser Programme,
   das ich bisher erleben durfte,
   bessere Ergebnisse als bei einer Auswertung mit
   Textwerkzeugen bekommen habe.
   Was mir allerdings jedesmal verloren ging,
   war die Zeit für die Bedienung der graphischen Benutzeroberfläche.
   Ganz abgesehen von den Macken die manche unausgereifte Software hat.

   In einem Fall änderten wir notgedrungen unseren Workflow so ab,
   dass wir alle interessanten Logzeilen nach Excel exportieren,
   in Excel genau die Spalte,
   welche die Logzeilen enthielt,
   als CSV exportierten
   und dann mit den üblichen Textwerkzeugen weiter arbeiteten.
   Damit waren wir immer noch schneller
   als die ganze Untersuchung in QRadar zu machen.
   Kein Grund zum Aufatmen bei Splunk, Prolog und Co.,
   keines von diesen ist besser.

   Ein Kollege, der bei einer Fehlersuche stundenlang mit einem
   derartigen Tool Logs untersuchte und dabei nicht davon abließ, sein
   Tool zu preisen, brachte das Problem unbewusst so auf den Punkt:
   Man kann mit diesen Tools relativ schnell die Ursache eines Problems
   finden, *wenn man weiß, wonach man suchen muss*.
   
   Bei komplizierten Problemen habe ich diesen Luxus jedoch nicht oft
   und weiß meist erst hinterher,
   wonach ich hätte suchen sollen.
   Dann kommt es während der Untersuchung darauf an,
   dass ich schnell in großen Texten navigieren kann
   und dass ich schnell Text selektieren, reduzieren und extrahieren kann.
   Und in manchen Fällen brauche ich einen rudimentären Parser
   für semistrukturierten Text
   wie zum Beispiel Konfigurationsdateien.

.. raw:: latex

   \clearpage

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
    um Text zu extrahieren oder um schwach strukturierten Text zu parsen,
    zum Beispiel um alle VPN zu identifizieren, die auf eine bestimmte
    Art konfiguriert sind.

Und natürlich arbeite ich bei allen diesen Werkzeugen mit regulären
Ausdrücken um zu konkretisieren, an welchem Teil des Textes ich
interessiert bin.

.. index:: less

Less
----

Das wichtigste,
was man bei einem interaktiven Programm wie less wissen muss,
ist wie man es beendet.
Das geht mit den Tastaturbefehlen ``Q`` oder ``:Q``,
egal ob Groß- oder Kleinbuchstabe.

Den Text, den ich mit less betrachten will, kann ich auf der
Kommandozeile als Dateinamen angeben oder über eine Pipe zur
Standardeingabe hinein schicken::

    less datei1 [ datei2 [ ... ] ]

    grep muster /var/log/syslog | less

Bewegen
.......

Der Hauptgrund, less zu benutzen ist die komfortable und dabei
schnelle Bewegung in größeren Texten.
Das funktioniert mit einem Tastendruck oder einer kurzen Tastenfolge.
Die gängigsten Tastaturbefehle für das Bewegen im Text.
zeigt :numref:`less-bewegen`.

.. table:: Bewegen mit der Tastatur im Programm Less
   :name: less-bewegen

   ============ ======================================
    **Taste**        **Bewegung**
   ============ ======================================
   ENTER        eine Zeile nach unten
   RETURN       "
   Pfeil-runter "
   ``j``        "
   SPACE        eine Bildschirmseite nach unten
   ``f``        "
   ``>``        zum Ende der Datei
   ``G``        "
   CTRL-P       eine Zeile nach oben
   Pfeil-rauf   "
   ``y``        "
   ``k``        "
   ``b``        eine Bildschirmseite nach oben
   ``<``        zum Anfang der Datei
   ``g``        "
   Pfeil-rechts eine halbe Bildschirmseite nach rechts
   ESC+\ ``)``  "
   Pfeil-links  eine halbe Bildschirmseite nach links
   ESC+\ ``(``  "
   ============ ======================================

Die letzten beiden Bewegungen sind praktisch,
wenn less lange Zeilen am Bildschirmrand abschneidet.
Das empfiehlt sich grundsätzlich bei Logzeilen
und kann mit der Option ``-S`` erreicht werden.

Suchen
......

Mit den Befehlen ``/Muster`` suche ich vorwärts im Text nach dem nächsten
Vorkommen von *Muster*.
Um rückwärts zu suchen verwende ich stattdessen ``?Muster``.
Mit ``n`` wiederhole ich die letzte Suche und mit ``N`` kehre ich die
Richtung der Suche um.

Mit ``&Muster`` kann ich die Anzeige auf die Zeilen beschränken, die
*Muster* enthalten.

Mit ``m`` gefolgt von einem Kleinbuchstaben kann ich eine Stelle im Text
markieren und mit dem Apostroph (``'``) gefolgt von eben diesem
Kleinbuchstaben kann ich später zu dieser Stelle zurückspringen.

Habe ich mehrere Dateien beim Aufruf von less angegeben, kann ich mit
``:n`` zur nächsten Datei gehen und mit ``:p`` zur vorherigen in der
Liste.

Optionen
........

Schließlich gibt es noch ein paar nützliche Optionen,
die ich regelmäßig bei Less verwende.
Alle Optionen können auf der Kommandozeile beim Aufruf angegeben werden
oder interaktiv zusammen mit dem vorangestellten ``-``.
Bei der interaktiven Eingabe werden die Einstellungen abwechselnd ein-
und ausgeschaltet (toggle).

``-i``
    Groß- und Kleinschreibung bei der Suche ignorieren.

``-N``
    Zeilennummern anzeigen

``-S``
    Lange Zeilen abschneiden.

Das sind die Kommandos und Optionen, die ich am häufigsten verwende.
Less hat noch sehr viel mehr zu bieten.
Bei Bedarf gibt es Hilfe mit ``man less``.
Noch schneller kommt man
mit der Kommandozeilenoption ``--help`` beziehungsweise ``-?`` an Hilfe
oder, während das Programm schon läuft,
mit dem Tastaturbefehl ``h`` oder ``H``.

.. raw:: latex

   \clearpage

.. index:: grep

Grep
----

Ich verwende grep sehr häufig
um Text in einer Pipe oder Datei zu filtern oder zu suchen,
um eine Datei zu finden, die einen bestimmten Text enthält,
oder um überflüssige Zeilen beim Betrachten einer Datei zu entfernen.

Normalerweise unterscheidet grep
die Groß- und Kleinschreibung der angegebenen Muster.
Mit der Option ``-i`` kann ich das abschalten.

Text in einer Pipe filtere ich meist beim Analysieren von Logdateien.
Wenn ich zum Beispiel während einer Debug-Sitzung die relevanten
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
Dann suche ich die Zeilen mit einem der folgenden Befehle::

  grep Muster Dateiname
  grep -A n Muster Dateiname
  grep -B n Muster Dateiname
  grep -C n Muster Dateiname

Stehen die interessanten Informationen nicht genau in den Zeilen mit dem
Muster, kann ich mit der Option ``-A`` (after) *n* Zeilen danach
ausgeben lassen oder mit Option ``-B`` (before) *n* Zeilen davor.
Die Option ``-C`` (context) hingegen gibt mir
sowohl *n* Zeilen vor derjenigen mit dem Muster
als auch die darauf folgenden *n* Zeilen aus.

.. raw:: latex

   \clearpage

Komme ich auf ein mir bis dahin unbekanntes System, dann muss ich
mitunter erst einmal die Datei suchen, die ein bestimmtes Muster enthält.
Dabei hilft mir ``grep`` mit der rekursiven Dateisuche,
bei der alle Dateien und Verzeichnisse rekursiv unterhalb des
angegebenen Startverzeichnisses durchsucht werden::

  grep -r Muster /etc

Will ich die Datei gleich betrachten, dann bin ich nur an den Dateinamen
interessiert, die ich mit der Option ``-l`` bekomme.
Diese kann ich in der Shell als Argument an ``less`` übergeben::

  less $(grep -lr Muster /etc)

Manchmal finde ich auf einem System als Konfigurationsdatei eine
modifizierte Template-Datei mit großen Mengen an Kommentaren und nur
wenigen Konfigurationsanweisungen.
Dann reduziere ich die Datei mit folgendem Befehl auf das Wesentliche::

  grep -v -E '^\s*(|#.*)$' Dateiname

Sollten andere Zeichen als ``#`` einen Kommentar einleiten, muss ich den
Ausdruck entsprechend anpassen.
Was der Ausdruck nach Option ``-E`` konkret bedeutet,
erläutert der Abschnitt :ref:`grundlagen/textdateien:Reguläre Ausdrücke`.

Die häufigsten mit ``grep`` genutzten Optionen
sind in :numref:`grep-optionen` zusammengefasst.

.. table:: Häufig verwendete Optionen bei grep
   :name: grep-optionen

   ============ ============================================================
    **Option**        **Verwendung**
   ============ ============================================================
   -A n         n Zeilen nach dem Muster ausgeben
   -B n         n Zeilen vor dem Muster ausgeben
   -C n         n Zeilen vor und nach dem Muster ausgeben
   -E *regex*   *regex* als erweiterten regulären Ausdruck verwenden
   -l           nur Dateinamen von Dateien mit dem Muster ausgeben
   -i           Groß- und Kleinschreibung ignorieren
   -r *dir*     alle Dateien unterhalb Verzeichnis *dir* rekursiv betrachten
   -v           nur Zeilen ohne das Muster ausgeben
   ============ ============================================================

.. index:: diff

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

.. index:: AWK

AWK
---

AWK verwende ich für einfache Manipulationen von zeilenorientierten Daten.
Dafür ist es ideal geeignet denn die Grundstruktur eines AWK-Skripts
besteht aus einer Folge von Mustern, denen zugehörige Aktionen in einem
Anweisungsblock folgen::

  /Muster/ { aktionen }

Dabei können die Aktionen sehr komplex sein und auch
den Text ändern.
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

.. index:: Perl

Skriptsprachen
--------------

Für komplexere Probleme, die ich mit den Unix-Textwerkzeugen nicht so
einfach angehen kann, greife ich zu einer Skriptsprache.

Für mich ist Perl die erste Wahl, auf das ich hier kurz eingehen will. 
Aber auch Python und andere Sprachen, die zur effizienten Verarbeitung
von Text geeignet sind und einen umfangreichen Bestand an
Musterlösungen, Bibliotheken und Modulen mitbringen, bieten sich an.

Ich setze auf Perl für tiefer gehende Analysen von Logs und
Konfigurationsdateien.
Dabei kommt es meist nur darauf an, ein Skript zu schreiben, das genau
mein Problem löst und das möglichst schnell.

In einem Fall brauchten wir für ein VPN-Migrationsprojekt mit Cisco-ASA
eine Liste der VPN mit den Peer-Adressen und den pro Peer konfigurierten
Crypto-Parametern.
Bei mehreren hundert VPNs war nicht daran zu denken, das von Hand zu
ermitteln.
Was half war ein rudimentärer Parser für die Konfiguration, der die
benötigten Informationen aus den Policies, Tunnel-Groups und
Crypto-Map-Einträgen einsammelte und am Ende die gewünschten Tabellen
ausgab.
Das Skript hatte am Ende ca 100 Zeilen und erlaubte mit wenig Aufwand in
regelmäßigen Abständen den tatsächlichen Stand der Umstellung zu
kontrollieren.

.. index:: Artificial Ignorance

Das zweite wichtige Anwendungsfall für Perl-Skripts ist die
Log-Komprimierung mit *Artificial Ignorance* (AI), einem Begriff, den ich
zum ersten Mal Ende der 1990er Jahre bei Marcus Ranum las [#]_.
Dabei geht es darum, Schritt für Schritt uninteressante Logzeilen zu
eliminieren, um sich auf die wichtigen zu konzentrieren.
Ähnliche Zeilen werden soweit angeglichen, dass sie identisch werden und
dann mit ``sort`` und ``uniq`` abgezählt werden können.

.. [#] Das Usenet-Posting ist unter
   http://www.ranum.com/security/computer_security/papers/ai/ zu finden.

Während Marcus Ranum auf die Unix-Textwerkzeuge ``sed`` und ``grep``
setzt, finde ich es einfacher die Anpassungen mit Perl zu erledigen.

Der Grundgedanke bei AI ist, die Logzeilen ihrer zufälligen Unterschiede
zu entkleiden und bei dem, was übrig bleibt, zu entscheiden, ob es
ignoriert werden kann.

Der erste Schritt ist immer, alle Zeitinformationen von den Logzeilen zu
entfernen.
Dann mache ich mir einen Überblick über die Häufigkeit einzelner
Meldungen mit folgendem Aufruf::

  logai < /var/log/syslog | sort | uniq -c | sort -nr | less -S

Prinzipiell ließe sich auch der nachfolgende Aufruf von ``sort`` und
``uniq`` gleich im Perl-Skript ``logai`` mit erledigen.

Von der sortierten Liste der Lognachrichten mit deren Häufigkeiten
interessieren mich sowohl der Anfang mit den häufigsten Nachrichten als
auch das Ende mit den einmaligen Logzeilen.

Bei den am häufigsten vorkommenden Meldungen entscheide ich, ob sie
wichtig sind, dann reagiere ich schnellstmöglich darauf, oder unwichtig,
dann überlege ich bei Gelegenheit, ob ich sie los werden kann.

Bei den nur einmalig vorkommenden Nachrichten schaue ich, ob ich
Logzeilen mit leichten Modifikationen zusammenfassen und dann abzählen
kann.

In wenigen Iterationen habe ich damit ein Instrument, dass mich in
meiner konkreten Umgebung schnell auf interessante Ereignisse in den
Systemlogs hinweist, die meine Fehlersuche in die richtige Richtung
lenken können.

Der dritte Anwendungsfall für Skripts ist das Aufbereiten der
Konfiguration für Vergleiche mit ``diff``.
In den meisten Fällen ist es nicht nötig, allerdings hatte ich in einem
Fall bei einer GeNUScreen-Firewall, dass nach einer kleinen Änderung im
Web-Interface ``diff`` sehr viele Änderungen im Textfile der
Konfiguration anzeigte.
Genaueres Hinschauen zeigte, dass einige Listen in einer komplett
anderen Reihenfolge ausgegeben wurden, wenn ein Element hinzugefügt oder
entfernt wurde.
In diesem Fall half ein Perl-Modul, die Konfiguration zu sortieren, so
dass der Vergleich nur noch die kleine ursprüngliche Änderung anzeigte.

Ich setze Artificial Ignorance vor allem ein, wenn ich mich mit einem
neuen System vertraut machen will  und wenn ich regelmäßig über
"interessante" Logzeilen informiert werden will.

.. _regex:

Reguläre Ausdrücke
------------------

Reguläre Ausdrücke sind mächtige Ausdrucksmittel, um Muster in einem
Text zu beschreiben, anhand derer der Text automatisch verarbeitet
werden kann.
Es gibt sie in verschiedenen Spielarten von einfachen über erweiterten
bis hin zu Perl-kompatiblen regulären Ausdrücken (PCRE).
In gewissem Sinne ist auch das Globbing, mit dem in der Shell Dateinamen
spezifiziert werden, eine Art von regulärem Ausdruck.

Generell hat jedes einzelne Zeichen in einem regulären Ausdruck eine
bestimmte Bedeutung, die sich manchmal erst aus dem Kontext erschließt.
Dabei kann ein Zeichen als normales Zeichen agieren, das für sich selbst
steht, wie die Buchstaben und Zahlen.
Alternativ kann es sich um ein Sonderzeichen handeln, dass eine
bestimmte Funktion hat oder um einen Modifikator, der die Bedeutung des
vorhergehenden oder nachfolgenden Zeichens abwandelt.

Reguläre Ausdrücke können case-sensitive oder case-insensitive sein, das
heißt Groß- und Kleinschreibung beachten oder ignorieren.

Generell gilt, dass alle Zeichen, die kein Sonderzeichen und kein
Bestandteil eines Modifikators sind, für sich selbst stehen.

Modifzierer
...........

Die meisten Modifikatoren stehen hinter dem Zeichen, dass sie
modifizieren, wie

``?``
  wenn das vorstehende Zeichen gar nicht oder genau einmal vorkommen
  darf,

``+``
  wenn das vorstehende Zeichen einmal oder mehrfach vorkommen darf,

``*``
  wenn das vorstehende Zeichen gar nicht, einmal oder mehrfach vorkommen
  darf,

``{m,n}``
  wenn das Zeichen mindestens *m* mal und höchstens *n* mal vorkommen
  darf.

Eine Ausnahme bildet der Modifikator ``\``, der einem nachfolgenden
Zeichen eine besondere Bedeutung zuweisen kann (``\w``, ``\d``, ...) oder
eine solche wieder aufheben kann (``\.``, ``\[``, ``\\``, ...).

Sonderzeichen
.............

Die folgenden Sonderzeichen verwende ich am häufigsten:

``.``
  steht für ein beliebiges Zeichen außer dem Zeilenende.

``^``
  steht für kein Zeichen sondern den Beginn der Zeile und wird als
  Anker verwendet, um den regulären Ausdruck an einer bestimmten Stelle
  in der Zeile zu positionieren.

``$``
  steht für kein Zeichen sondern das Ende der Zeile und wird als
  Anker verwendet, um den regulären Ausdruck an einer bestimmten Stelle
  in der Zeile zu positionieren.

``(``
  leitet eine Gruppe von Zeichen ein, die als Gesamtheit betrachtet
  wird. Nachfolgende Modifikator betreffen die ganze Zeichenfolge der
  Gruppe. Beendet wird die Gruppe mit dem zugehörigen ``)``.

``[``
  leitet eine Klassendefinition ein. Eine Klasse ist eine Menge von
  Zeichen, von denen genau eines an der Stelle vorkommen darf. Die
  Klassendefinition endet mit dem zugehörigen ``]``. In einer
  Klassendefinition können Bereiche mit ``-`` angegeben werden, wie z.B.
  ``[0-9]``, das für alle Ziffern steht.

``|``
  bildet eine Alternative in einer Gruppe, sowohl die Zeichenfolge vor
  der Alternative als auch die Zeichenfolge danach stehen für ein
  gültiges Muster in der Gruppe. Zum Beispiel steht ``(abc|def)``
  entweder für die Folge *abc* oder *def*.

Zeichenklassen 
..............

Einige Zeichenklassen sind bereits vordefiniert, was mir das Definieren
an der jeweiligen Stelle erspart. Ich verwende am häufigsten die
folgenden.

``\s``
  Whitespace, also Leerzeichen, Tabulatoren und Zeilenendezeichen.

``\S``
  kein Whitespace, also alle Zeichen, die nicht zu ``\s`` gehören.

``\w``
  alle Zeichen, die in einem Wort vorkommen können.

``\W``
  alle Zeichen, die nicht in einem Wort vorkommen.

Reguläre Ausdrücke bieten noch viel mehr Möglichkeiten, für eine
fundierte Einarbeitung stehen die Handbuchseiten der entsprechenden
Programme zur Verfügung.

Beispiele
.........

Als Beispiel will ich auf den oben bereits vorgestellten Ausdruck zum
Entfernen von Kommentaren aus Konfigurationsdateien näher erläutern. ::

  grep -v -E '^\s*(|#.*)$' /pfad/zur/datei

Mit der Option ``-v`` mache ich klar, dass ich die auf den Ausdruck
passenden Zeilen nicht sehen will.

Der Ausdruck selbst beginnt mit dem Anker ``^`` und endet mit dem Anker
``$``, umfasst also die ganze Zeile.

Am Anfang der Zeile können kein, ein oder mehrere Whitespace-Zeichen stehen
(``\s*``), wieviel genau, ist unerheblich.

Darauf folgt eine Gruppe, die sich bis zum Zeilenende erstreckt (``$``).
Diese Gruppe enthält eine Alternative (``|``).
Eine Variante ist vollkommen leer, damit decke ich leere Zeilen ab und
solche, die nur Whitespace enthalten.
Die andere Variante beginnt mit ``#``, gefolgt von beliebig vielen
beliebigen Zeichen. Damit erfasse ich alle Zeilen, die auskommentiert
sind.

Verwendet die Datei andere Zeichen für Zeilenkommentare, muss ich das
``#`` entsprechend ersetzen.
Bei manchen Konfigurationsdateien im INI-Format sind sowohl ``;`` als
auch ``#`` als Kommentarzeichen zugelassen. Hier ändere ich den
regulären Ausdruck zu ``^\s*(|[;#].*)$``.

Einen anderen nützlichen Ausdruck verwende ich zum Erkennen und Ersetzen
von IPv4-Adressen bei Artificial Ignorance::

  s/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/X.X.X.X/g

Der Ausdruck besteht aus vier Gruppen von je 1 bis 3 Ziffern, die durch
drei Punkte getrennt sind.

Einen ähnlichen Ausdruck verwende ich in Perl zum Maskieren von Teilen
einer IP-Adresse, zum Beispiel für die Pseudonomisierung von Adressbereichen::

  s/(\d{1,3}\.\d{1,3}\.\d{1,3}\).\d{1,3}/$1.X/g
 
