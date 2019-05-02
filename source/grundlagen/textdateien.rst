
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

