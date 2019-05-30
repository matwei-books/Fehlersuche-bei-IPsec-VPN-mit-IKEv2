
pfSense
=======

*pfSense* ist eine Netzwerk-Firewall-Distribution, die auf FreeBSD als
Betriebsystem mit einem angepassten Kernel basiert.

Für die Konfiguration steht eein Web-Interface zur Verfügung, mit dem
alle enthaltenen Komponenten konfiguriert werden können.
Es ist nicht nötig, bei pfSense die Kommandozeile zu benutzen.
Immerhin ist es möglich.

.. index:: pfSense; Kommandozeile

Auf die Kommandozeile kommt man entweder über die Konsole des Rechners,
auf dem pfSense läuft, oder nach Anmeldung via SSH.
Zunächst landet man in einem Menü wie dem folgenden:

.. todo:: Screenshot pfSense-Konsolenmenü

Von dort kommt man über den Menüpunkt 8) auf die Unix-Shell oder über 12)
auf die PHP-Shell.

.. index:: pfSense; viconfig

Will man die Konfiguration über die Kommandozeile bearbeiten, empfiehlt
sich die Benutzung des Programs ``viconfig``, mit dem man die
Konfiguration mit dem Editor ``vi`` in einer XML-Datei bearbeitet.
``viconfig`` kümmert sich anschließend um das Entfernen des
Configuration-Cache, so dass die geänderten Einstellungen aktiv werden.

.. index:: ! vi

.. topic:: vi

   Der Editor *vi* geht auf den visuellen Modus des Unix-Editors *ex*
   aus dem Jahr 1976 zurück und ist seit dem auf den meisten
   Unix-artigen Betriebssystemen zu finden.
   Dieser Editor arbeitet in drei Modi, dem Befehlsmodus (*command mode*),
   dem Einfügemodus (*insert mode*) und dem Kommandozeilenmodus (*colon
   mode* oder *ex mode*).
   Beim Start befindet man sich im Befehlsmodus.

   Es empfiehlt sich die grundlegenden Tastenbefehle zu lernen, um mit
   diesem Editor zu arbeiten.
   Startet man unerwarteterweise diesen Editor - wie zum Beispiel über
   das Programm ``viconfig`` - kommt man mit der Tastenfolge *ESC*,
   ``:``, ``q!`` *ENTER* wieder heraus, ohne allzuviel Schaden
   anzurichten.

   *ESC*
     wechselt vom Einfügemodus in den Befehlsmodus und ist in den
     meisten Fällen nicht nötig, nur wenn man aus Versehen bereits in
     den Einfügemodus gewechselt ist.

   ``:``
     wechselt vom Befehlsmodus in den Kommandozeilenmodus.

   ``q!``
     gibt den Befehl zum Verlassen des Editors, ohne eventuell getätigte
     Änderungen in die Datei zu schreiben und ohne weitere Rückfragen.

   *ENTER*
     schließt den Befehl im Kommandozeilenmodus ab.

   Wer mit dem Editor *vi* oder einem seiner Nachfolger vertraut ist,
   weiß auch, wie er seine gewollten Änderungen in die Datei
   zurückschreibt.


