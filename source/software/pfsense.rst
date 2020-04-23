
.. index:: ! pfSense

pfSense
=======

.. index:: StrongSwan

*pfSense* ist eine Netzwerk-Firewall-Distribution, die auf FreeBSD als
Betriebsystem mit einem angepassten Kernel basiert.
Für IPsec verwendet sie StrongSwan [#]_.

.. [#] https://www.strongswan.org/

Für die Konfiguration steht ein Web-Interface zur Verfügung,
mit dem ich die enthaltenen Komponenten konfigurieren kann.
Das Webinterface der pfSense benötigt JavaScript.
Es hat den Vorteil,
dass ich jeweils mit einem Klick
zwischen der Konfiguration, dem Status und den Logs der VPN wechseln kann.
Das erleichtert die Fehlersuche.
Mit der pfSense ist es einfacher,
mehrere VPN zu unterschiedlichen Peers zu pflegen.
Sowohl im Web-Interface als auch in der Kommandozeile ist es relativ einfach,
Status-Informationen verschiedener SA zuzuordnen
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

Will ich die Konfiguration über die Kommandozeile bearbeiten,
verwende ich das Programm ``viconfig``,
in dem ich mit dem Editor ``vi`` eine XML-Konfigurationsdatei bearbeite.
``viconfig`` kümmert sich anschließend
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

   Es empfiehlt sich die grundlegenden Tastenbefehle zu lernen, um mit
   diesem Editor zu arbeiten.
   Startet man vi unerwarteterweise - wie zum Beispiel über
   das Programm ``viconfig`` - kommt man mit der Tastenfolge *ESC*,
   ``:``, ``q!`` *ENTER* wieder heraus, ohne allzuviel Schaden
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

   Wer mit dem Editor *vi* oder einem seiner Nachfolger vertraut ist,
   weiß, wie er seine gewollten Änderungen in die Datei zurückschreibt.

Da die pfSense auf einem Unix-System aufsetzt, empfiehlt es sich, sie
nicht einfach auszuschalten, sondern vorher geordnet hinunterzufahren.

Im Webinterface geht man dafür nach **Diagnostics > Halt System**, in
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

Im Webinterface geht man dazu nach **Diagnostics > Ping**
und trägt im Formular außer der Zieladresse
auch die Absenderadresse aus dem lokalen Traffic-Selektor ein.

In der Shell gibt man die Absenderadresse mit der Option ``-S`` an::

  ping -S lokale.adresse entfernte.adresse

Will man die lokale Adresse nicht explizit angeben, muss man
Vorkehrungen treffen [#]_, damit der auf der pfSense erzeugte
Traffic auch über das VPN gesendet wird und nicht zum falschen Interface
hinausgeht.
Dazu legt man eine statische Route zum Netz auf der Peer-Seite des VPN
auf die Adresse des eigenen LAN-Interface.

.. [#] https://docs.netgate.com/pfsense/en/latest/book/ipsec/site-to-site.html#ipsec-pfsensetraffic

Mit dem Programm ``ipsec`` kann man auf der Konsole
VPN-Verbindungen initiieren oder zurücksetzen.
Um sich einen Überblick zu verschaffen verwendet man den Befehl::

  ipsec statusall

Im Webinterface geht man nach **Status > IPsec**
und kann im Tab **Overview** VPNs zu Peers verbinden oder trennen.
Im Tab **SADs** kann man einzelne Child-SA zurücksetzen.

Das Äquivalent auf der Kommandozeile wären die Befehle::

  ipsec statusall
  ipsec up name
  ipsec down name
  ipsec down name{n}

Dabei zeigt der erste Befehl die verfügbaren VPNs
und bei bestehenden Verbindungen die Child-SA.

Mit ``ipsec up name`` starte ich eine IKE-Verbindung.

Der Befehl ``ipsec down name`` beendet die IKE-Verbindung
und ``ipsec down name{n}`` beendet die spezifizierte Child-SA.

Systemlogs und Debug-Informationen
----------------------------------

An die Systemlogs komme ich im Webinterface über **Status > System Logs**.
Dort finde ich ein Log, das ausschließlich auf IPsec bezogene
Informationen sammelt, das Systemlog und weitere.

Auf der Konsole finde ich die Logs im Verzeichnis */var/log/*, die Datei
mit den IPsec-Logs ist */var/log/ipsec.log*. Mit ``ls /var/log`` bekomme
ich die Namen der anderen Dateien angezeigt.

.. figure:: /images/pfsense-logging.png
   :alt: Einstellungen für Logging

Ob Logs zu anderen Server geschickt werden und wenn ja, zu welchen,
bekomme ich im Webinterface über **Status > System Logs > Settings**
heraus. Dort schaue ich bei **Remote Logging Options** nach.

.. figure:: /images/pfsense-logging-remote.png
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
Welcher Peer gerade welcher String zugeordnet ist,
erfahre ich im Web-Interface unter **Status > IPsec > Overview**
und im CLI über den Befehl ``ipsec status``.
Im Web-Interface kann ich die Logs filtern und dabei den String angeben,
im CLI verwende ich ``grep``.

In der Online-Dokumentation [#]_
finden sich viele weitere Tipps und Hinweise zur Fehlersuche bei IPsec,
dort gibt es auch Hilfe zur Interpretation der Lognachrichten.

.. [#] https://docs.netgate.com/pfsense/en/latest/vpn/ipsec/ipsec-troubleshooting.html

Paketmitschnitte
----------------

Ich habe zwei Möglichkeiten, einen Paketmitschnitt auf einer
pfSense-Firewall anzufertigen: über das Webinterface oder über die
Konsole.

.. figure:: /images/pfsense-packet-capture.png
   :alt: Paketmitschnitt im Webinterface

Im Webinterface gehe ich im Menü zu **Diagnostics > Packet Capture**.
Dort spezifiziere ich in einem Webformular die Datagramme, an denen ich
interessiert bin und die Schnittstelle.
Unter dem Formular befindet sich ein Start/Stop-Button, mit dem ich die
Aufzeichnung beginnen und enden lasse.
Nach dem Ende der Aufzeichnung kann ich den Mitschnitt direkt im
Webinterface betrachten, was mir bei einfachen Fragestellungen Zeit
erspart.
Für detaillierte Untersuchungen kann ich den Mitschnitt auch im
PCAP-Format heruterladen und dann mit Wireshark oder anderen Werkzeugen
näher untersuchen.

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

Im Webinterface gehe ich zu **Diagnostics > Backup & Restore > Backup &
Restore**. Dort kann ich die Konfiguration herunterladen oder mit den
letzten Ständen vergleichen.

Auf der Konsole finde ich die Konfiguration im Verzeichnis */cf/conf/*, die
alten Stände in */cf/conf/backup/*.
Hier stehen mir Textwerkzeuge,
wie ``diff``, ``grep`` oder ``less``,
für einfache Analysen zur Verfügung.

Will ich die Konfigurationsdatei in der Shell bearbeiten, empfiehlt sich
das Programm ``viconfig``, das sich um Details wie das Löschen des
Config-Caches kümmert.

.. index:: StrongSwan

Bin ich mir nicht im Klaren,
was eine bestimmte Konfiguration im Webinterface
beziehungsweise in der XML-Datei bedeutet,
kann ich die daraus erzeugte Konfiguration für StrongSwan
unter */var/etc/* anschauen.

