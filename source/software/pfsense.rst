
.. raw:: latex

   \clearpage

.. index:: ! pfSense

pfSense
=======

.. index:: StrongSwan

*pfSense* ist eine Netzwerk-Firewall-Distribution,
die auf FreeBSD als Betriebssystem basiert
und StrongSwan [#]_ für IPsec verwendet.

.. [#] https://www.strongswan.org/

.. index:: RouterOS

Für die Konfiguration steht ein Web-Interface zur Verfügung,
mit dem ich die enthaltenen Komponenten konfigurieren kann.
Das Web-Interface der pfSense benötigt JavaScript.
Es hat den Vorteil,
dass ich jeweils mit einem Klick
zwischen der Konfiguration, dem Status und den Logs der VPN wechseln kann.
Das erleichtert die Fehlersuche.
Mit der pfSense ist es einfacher als mit RouterOS,
mehrere VPN zu unterschiedlichen Peers zu pflegen.
Sowohl im Web-Interface als auch in der Kommandozeile
kann ich einfach Status-Informationen verschiedenen SA zuordnen
und auch die Logs lassen sich sehr gut nach einzelnen VPN filtern.

.. index:: pfSense; Kommandozeile

Auf die Kommandozeile komme ich entweder über die Konsole des Rechners,
auf dem pfSense läuft oder nach Anmeldung via SSH.
Zunächst lande ich in einem Menü wie dem folgenden:

.. literalinclude:: pfsense-console.txt
   :language: text
   :lines: 5-16

Von dort komme ich über den Menüpunkt 8) auf die Unix-Shell.

.. index:: pfSense; viconfig

Will ich die Konfiguration über die Kommandozeile ändern,
nehme ich das Programm ``viconfig``,
welches den Editor ``vi`` aufruft
um die XML-Konfigurationsdatei zu bearbeiten.
Anschließend kümmert sich ``viconfig``
um das Leeren des Configuration-Cache,
so dass die geänderten Einstellungen aktiv werden.

.. index:: ! vi

.. topic:: vi

   Der Editor *vi* geht auf den visuellen Modus des Unix-Editors *ex*
   aus dem Jahr 1976 zurück und ist seitdem auf den meisten
   Unix-artigen Betriebssystemen zu finden.
   Dieser Editor arbeitet in drei Modi, dem Befehlsmodus (*command mode*),
   dem Einfügemodus (*insert mode*) und dem Kommandozeilenmodus (*colon
   mode* oder *ex mode*).
   Beim Start befindet man sich im Befehlsmodus.

   Es empfiehlt sich die grundlegenden Tastenbefehle zu lernen.
   Startet man vi unerwarteterweise - wie zum Beispiel über
   das Programm ``viconfig`` - kommt man mit der Tastenfolge *ESC*,
   ``:``, ``q!``, *ENTER* wieder heraus, ohne allzuviel Schaden
   anzurichten.

   *ESC*
     wechselt vom Einfügemodus in den Befehlsmodus
     und ist in den meisten Fällen nicht nötig,
     sondern nur,
     wenn man aus Versehen bereits in den Einfügemodus gewechselt ist.

   ``:``
     wechselt vom Befehlsmodus in den Kommandozeilenmodus.
     Der Cursor geht in die unterste Zeile,
     die in den anderen Modi nicht zugänglich ist.

   ``q!``
     gibt den Befehl zum Verlassen des Editors, ohne eventuell getätigte
     Änderungen in die Datei zu schreiben und ohne weitere Rückfragen.

   *ENTER*
     schließt den Befehl im Kommandozeilenmodus ab.

   Wer mit *vi* oder einem seiner Nachfolger vertraut ist,
   weiß, wie er seine gewollten Änderungen in die Datei zurückschreibt.
   Wer mit diesem Editor vertraut werden will,
   kann sich die wichtigsten Befehle mit einem Tutorial [#]_ aneignen.

.. [#] zum Beispiel https://de.wikibooks.org/wiki/Learning_the_vi_editor

Da die pfSense auf einem Unix-System aufsetzt, empfiehlt es sich, sie
nicht einfach auszuschalten, sondern vorher geordnet hinunterzufahren.

Im Web-Interface geht man dafür nach **Diagnostics > Halt System**, in
der Konsole wählt man ``6) Halt System``.
Befindet man sich bereits in der Unix-Shell,
geht auch der Befehl ``shutdown -h now``.
Sofern ein Lautsprecher eingebaut ist,
meldet sich die Hardware akustisch,
danach dauert es noch ein paar Sekunden,
bis die Platten vollständig ausgehängt sind.

Starten, Stoppen und Kontrollieren von VPN-Tunneln
--------------------------------------------------

Der einfachste Test, ob ein VPN funktioniert, ist ein PING von einem
Client hinter der Firewall.
Bei pfSense ist das der empfohlene Weg, einen Tunnel aufzubauen, wenn es
nicht automatisch passiert.

Läuft das VPN im Transportmodus oder die pfSense hat ein Interface im
Adressbereich des lokalen Traffic-Selektors beim Tunnelmodus, kann man
den PING auch direkt von der pfSense absetzen.

Im Web-Interface geht man dazu nach **Diagnostics > Ping**
und trägt im Formular außer der Zieladresse
auch die Absenderadresse aus dem lokalen Traffic-Selektor ein.

In der Shell gibt man die Absenderadresse mit der Option ``-S`` an::

  ping -S lokale.adresse entfernte.adresse

Mit dem Programm ``ipsec`` kann man auf der Konsole
VPN-Verbindungen initiieren oder zurücksetzen.
Um sich einen Überblick zu verschaffen verwendet man den Befehl::

  ipsec status

oder::

  ipsec statusall

Im Web-Interface geht man nach **Status > IPsec**
und kann im Tab **Overview** VPN zu den Peers verbinden oder trennen.
Im Tab **SADs** kann man einzelne Child-SA zurücksetzen.

Das Äquivalent auf der Kommandozeile wären die Befehle::

  ipsec statusall
  ipsec up name
  ipsec down name
  ipsec down name{n}

Dabei zeigt der erste Befehl die verfügbaren VPN
und bei bestehenden Verbindungen die Child-SA.

Mit ``ipsec up name`` starte ich eine IKE-Verbindung.

Der Befehl ``ipsec down name`` beendet die IKE-Verbindung
und ``ipsec down name{n}`` beendet die spezifizierte Child-SA.

Systemlogs und Debug-Informationen
----------------------------------

An die Systemlogs komme ich im Web-Interface über **Status > System Logs**.
Dort finde ich ein Log, das ausschließlich auf IPsec bezogene
Informationen sammelt, das Systemlog und weitere.

Auf der Konsole finde ich die Logs im Verzeichnis */var/log/*, die Datei
mit den IPsec-Logs ist */var/log/ipsec.log*. Mit ``ls /var/log`` bekomme
ich die Namen der anderen Dateien angezeigt.

.. .. figure:: /images/pfsense-logging.png
   :alt: Einstellungen für Logging

Ob Logs zu anderen Server geschickt werden und wenn ja, zu welchen,
bekomme ich im Web-Interface über **Status > System Logs > Settings**
heraus. Dort schaue ich bei **Remote Logging Options** nach.

.. .. figure:: /images/pfsense-logging-remote.png
   :alt: Einstellungen für Remote Logging

Ob und in welchem Maße Debug-Informationen protokolliert werden, stelle
ich für IPsec unter **VPN > IPsec > Advanced Settings** ein.

Meist sind IKE SA, IKE Child SA und Configuration Backend auf
*Diag* eingestellt, und alle anderen auf *Control*.
Bei allen Topics kann ich zwischen den Optionen *Silent*, *Audit*,
*Control*, *Diag*, *Raw* und *Highest* wählen.

Die Logzeilen der einzelnen VPN lassen sich sehr einfach filtern.
Fast alle Zeilen für einen Peer enthalten einen String,
wie zum Beispiel ``"con1000"``,
der genau einem Peer zugeordnet ist.
Welchem Peer gerade welcher String zugeordnet ist,
erfahre ich im Web-Interface unter **Status > IPsec > Overview**
und im CLI über den Befehl ``ipsec status``.
Im Web-Interface kann ich die Logs filtern und dabei den String angeben,
im CLI verwende ich ``grep``.

In der Online-Dokumentation [#]_
finden sich viele weitere Tipps und Hinweise zur Fehlersuche bei IPsec,
dort gibt es auch Hilfe zur Interpretation der Logzeilen.

.. [#] https://docs.netgate.com/pfsense/en/latest/vpn/ipsec/ipsec-troubleshooting.html

.. figure:: /images/pfsense-packet-capture.png
   :alt: Paketmitschnitt im Web-Interface

Paketmitschnitte
----------------

Ich habe zwei Möglichkeiten, einen Paketmitschnitt auf einer
pfSense-Firewall anzufertigen: über das Web-Interface oder über die
Konsole.

Im Web-Interface gehe ich im Menü zu **Diagnostics > Packet Capture**.
Dort spezifiziere ich in einem Web-Formular die Datagramme, an denen ich
interessiert bin und die Schnittstelle.
Unter dem Formular befindet sich ein Start/Stop-Button, mit dem ich die
Aufzeichnung beginnen und enden lasse.
Nach dem Ende der Aufzeichnung kann ich den Mitschnitt direkt im
Web-Interface betrachten, was mir bei einfachen Fragestellungen Zeit
erspart.
Für detaillierte Untersuchungen
kann ich den Mitschnitt auch im PCAP-Format herunterladen
und dann mit Wireshark oder anderen Werkzeugen untersuchen.

Auf der Konsole wähle ich zunächst über Menüpunkt 8) die Shell aus und
schneide dann den Datenverkehr mit ``tcpdump`` mit, wie im Abschnitt
:ref:`grundlagen/paketmitschnitt:Paketmitschnitt mit tcpdump` bei den
Grundlagen beschrieben.

Konfiguration analysieren
-------------------------

Die Konfiguration der pfSense kann ich als Textdatei *config.xml* im
XML-Format bekommen.

.. figure:: /images/pfsense-backup-config.png
   :alt: Download der Konfiguration

Im Web-Interface gehe ich zu **Diagnostics > Backup & Restore > Backup &
Restore**. Dort kann ich die Konfiguration herunterladen oder mit den
letzten Ständen vergleichen.

Auf der Konsole finde ich die Konfiguration im Verzeichnis */cf/conf/*, die
alten Stände in */cf/conf/backup/*.
Hier stehen mir Textwerkzeuge,
wie ``diff``, ``grep`` oder ``less``,
für einfache Analysen zur Verfügung.

Will ich die Konfigurationsdatei in der Shell bearbeiten,
verwende ich das bereits erwähnte Programm ``viconfig``,
das sich um Details wie das Leeren des Config-Caches kümmert.

.. index:: StrongSwan

Bin ich mir nicht im Klaren,
was eine bestimmte Konfiguration im Web-Interface
beziehungsweise in der XML-Datei bedeutet,
kann ich die daraus erzeugte Konfiguration für StrongSwan
unter */var/etc/* anschauen.

Besonderheiten
--------------

Beim Hinzufügen von IPsec-Proposals (Phase 2)
kann es passieren,
dass kein Tunnel für das neue Proposal aufgebaut wird,
auch wenn das VPN selbst und die anderen IPsec-Tunnel funktionieren.
In diesem Fall hilft unter Umständen,
IPsec kurz zu beenden und wieder neu zu starten [#]_.
Natürlich kann das problematisch sein,
wenn auf der pfSense andere VPN produktiv sind.
In diesem Fall muss man einen geeigneten Zeitpunkt
für eine Downtime abpassen.

.. [#] vgl. https://www.reddit.com/r/PFSENSE/comments/be84a7/ipsec_problem_with_additional_p2_proposal/

