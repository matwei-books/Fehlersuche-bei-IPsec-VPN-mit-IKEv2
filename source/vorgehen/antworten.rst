
Antworten
=========

Gute Fragen zu stellen trägt schon ein großes Stück bei zur Lösung eines
Problems. Die Fragen nützen mir jedoch nichts, wenn ich nicht in der
Lage bin, Antworten darauf zu finden.
Darum geht es in diesem Kapitel.

Dabei muss ich mich - insbesondere bei schwierigen Problemen -
immer fragen "Ist das wahr? Ist das, was ich gesehen habe, alles"?
In den meisten Fällen werden mich die gefundenen Antworten auf den richtigen Weg bringen.
Wenn jedoch meine Antworten scheinbar keinen Sinn ergeben,
muss ich die Voraussetzungen und Zwischenschritte hinterfragen und kontrollieren.

Im Wesentlichen habe ich drei Möglichkeiten,
Antworten auf meine Fragen zu bekommen:

* Aussagen von VPN-Benutzern
* Systemlogs vom VPN-Gateway
* Paketmitschnitte
* Debugausgaben

Aussagen von VPN-Benutzern
--------------------------

Aussagen von VPN-Benutzern in Form von Fehlermeldungen sind oft der
Anlass für die Fehlersuche bei einem VPN.

Gerade am Anfang der Untersuchung ist es daher wichtig, so viel wie
möglich von den Benutzern über die genauen Umstände des Problems zu
erfahren: seit wann tritt das Problem auf, welche Geräte sind daran
beteiligt, bei welchen Aktionen tritt das Problem auf.

Am Ende der Fehlersuche gehört es einfach dazu,
dass ich denjenigen, der ein Problem gemeldet hat,
befrage, ob es wirklich beseitigt ist.
Dieser Moment wird gern benutzt, um das nächste Problem zu melden.
In so einem Fall kann ich ein neues Ticket aufmachen,
sobald klar wird, dass es nicht mehr um das ursprüngliche Problem geht.

Leider sind die Aussagen der Endbenutzer
bei der konkreten Fehlersuche oft wenig hilfreich.
Dann ist es sinnvoll die Anwendungsbetreuer,
die Administratoren der Server
und eventuell auch die Netzwerkadministratoren
(wenn diese in einer anderen Gruppe arbeiten als die VPN-Administratoren)
zu Rate zu ziehen,
um das Problem einzugrenzen und die beteiligten Adressen zu erfahren.

Systemlogs vom VPN-Gateway
--------------------------

Systemlogs sind ein zweischneidiges Schwert. Zum einen liefern sie
zeitnah Hinweise auf außergewöhnliche Ereignisse und bieten sich an für
eine automatische Überwachung. Bei der Fehlermeldung können sie
wertvolle Tipps geben, die die Suche nach der Ursache verkürzen.

Zum anderen können Sie, insbesondere wenn sie nicht eindeutig sind, in
die Irre führen und eine Fehlersuche unnötig verlängern.
In einem konkreten Fall "sah" ein Netzwerkadministrator,
der Zugang zu den VPN-Logs hatte,
plötzlich Traffic zwischen zwei VPN-Gateways in den Logs,
obwohl zwischen beiden Geräten nicht einmal PING funktionierte
und im Paketmitschnitt auf beiden Seiten nachweislich
kein Traffic des jeweils anderen VPN-Gateways auftauchte.
Das VPN-Gateway generierte einen Logeintrag für jeden Verbindungsversuch,
den es unternahm.
Dieser Logeintrag enthält die Traffic-Selektoren
für den auslösenden Traffic, der durch das VPN gehen soll,
und die IP-Adresse des Peer-Gateways,
zu dem die Verbindung aufgebaut werden soll.
Es dauerte einige Zeit, diesen Netzwerkadministrator zu überzeugen,
dass es sich bei diesen Logeinträgen um ausgehenden Traffic handelte,
für den in diesem Fall keine Antwort vom Peer-Gateway ankam.
Zeit, die für die Lösung des eigentlichen Problems verloren ging.

Wichtig ist darum, insbesondere bei Logeinträgen, die man nicht kennt,
nach anderen Wegen zu suchen um ihre Aussage zu überprüfen.
In obigem Fall konnte ein Paketmitschnitt zeigen,
dass kein Traffic vom Peer ankam.

Wenn ich es mit neuer Software zu tun bekomme,
die Logeinträge schreibt,
mit denen ich nicht viel anfangen kann
und zu denen ich keine gute Dokumentation bekomme,
fange ich meist damit an,
die Logeinträge statistisch zu untersuchen.
Dabei abstrahiere ich von - in meinen Augen irrelevanten - Details
und schaue zunächst,
welche Zeilen am häufigsten und welche am seltensten vorkommen.
Bei den Logeinträgen, die am häufigsten vorkommen,
entscheide ich dann,
ob sie irrelevant sind und ausgefiltert werden können,
oder ob sie ein Problem darstellen, dass ich vorrangig bearbeiten will.
Die seltenen Logeinträge
lassen sich meist leicht mit bestimmten Ereignissen verknüpfen,
so dass ich mit der Zeit ein Gefühl
für die Bedeutung der einzelnen Einträge bekomme.

Die folgende Befehlskette in einer Unix-Shell liefert mir die Häufigkeit
von bestimmten Logzeilen in absteigender Reihenfolge::

  sed -E 's/^.{16}//' < $logfile | sort | uniq -c | sort -rn | less

Dabei passiert folgendes:

``sed -E 's/^.{16}//' < $logfile``
  Der Befehl *sed* bekommt den Inhalt der Datei *$logfile* in der
  Standardeingabe, entfernt in jeder Zeile die ersten 16 Zeichen - den
  Zeitstempel - und gibt den Rest aus.

``sort``
  Der Befehl *sort* gibt die Zeilen (ohne Zeitstempel) alphabetisch
  sortiert aus.

``uniq -c``
  Dieser Befehl fasst identische Zeilen zusammen und schreibt vor jede
  Zeile, wie häufig sie auftritt.

``sort -rn``
  Die Ausgabe von *uniq* wird numerisch in absteigender Reihenfolge
  sortiert und weitergereicht.

``less``
  Mit diesem Befehl bekomme ich die abschließende Ausgabe seitenweise
  ausgegeben und kann bequem darin navigieren.

Damit bekomme ich bereits einen ersten Überblick.
Bei komplexeren
Logzeilen, die Elemente enthalten, welche ich ignorieren will,
greife ich zu einem Perl-Skript,
das die irrelevanten Details maskiert.
Mit der Zeit bekomme ich so ein Gefühl dafür,
welche Logzeilen wichtig sind und was sie bedeuten.

Manchmal reicht aber schon ein Blick auf die Anzahl von Logzeilen,
um zu erkennen, dass etwas nicht in Ordnung ist. In einem konkreten Fall
war ein VPN in Abstimmung mit dem VPN-Administrator des Peers von IKEv1
auf IKEv2 und zeitgemäße Crypto-Parameter umgestellt worden.
Die beteiligten Administratoren hatten damals
keinen zeitnahen Zugriff [#]_ auf die eigenen Logs
und nur den Aufbau der Tunnel getestet und ob Daten übertragen wurden.
Nach etwa einer Woche kam eine Fehlermeldung vom
Peer, dass das VPN seit der Umstellung nicht richtig funktionieren
würde. Zu dem Zeitpunkt standen sowohl Logs vor der Umstellung als auch
vom Zeitraum danach zur Verfügung.
Während vor der Umstellung etwa 100 Logzeilen pro Tag
für das betreffende VPN generiert wurden,
waren es nach der Umstellung etwa 10000.
Einige Zeit später bekamen wir zeitnahen Zugriff auf die VPN-Logs.

.. [#] Die Logs standen erst nach mehreren Stunden,
   zeitweilig mehr als einen Tag nach dem Schreiben,
   zur Verfügung.

Paketmitschnitte
----------------

Auf die konkrete Durchführung von Paketmitschnitten gehe ich im Abschnitt
:ref:`grundlagen/paketmitschnitt:Paketmitschnitt` bei den Grundlagen ein.
Hier reiße ich kurz an,
wann und wofür ich Paketmitschnitte bei der Fehlersuche einsetze.

Bei der Fehlersuche verwende ich Paketmitschnitte sehr häufig, und zwar

* wenn Logs nicht eindeutig sind,
* wenn Tests nicht eindeutig sind oder nicht funktionieren,
* zur Überprüfung von Vermutungen denen ich nicht ganz traue.

Ein Paketmitschnitt kann schneller einen Überblick über den groben
Ablauf einer IKE-Konversation geben als die Debug-Informationen,
insbesondere wenn ich mich bei letzteren erst durch viele irrelevante
Details kämpfen muss.

Auch kann ich komplexe Probleme, wie zum Beispiel eine reduzierte MTU
mit einem geeigneten Paketmitschnitt nachweisen falls der Peer diese
Information nicht von sich aus bereitstellt. Der Paketmitschnitt zeigt
mir hinterher auch, ob meine Abhilfe wirksam ist.

Was mir der Paketmitschnitt nicht anzeigt ist der Inhalt der
verschlüsselten IKE-Nachrichten. Vermute ich hierbei Probleme, muss ich
auf Debugmeldungen zurückgreifen. Allerdings gibt es auch hier eine
Ausnahme: die Cisco ASA kann einen Paketmitschnitt vom Typ ``isakmp``
schreiben, bei dem sie zusätzlich zu den verschlüsselten Datagrammen
Pseudo-Datagramme mit den entschlüsselten IKE-Informationen in den
Mitschnitt einfügt. Diese Information kann mir unter Umständen das
Einschalten der Debugmeldungen ersparen.

Debugausgaben
-------------

Debugausgaben verwende ich, wenn die Logmeldungen zu ungenau für die
Eingrenzung des Problems sind und im Paketmitschnitt nicht die nötigen
Informationen zu finden sind.

Konkret suche ich in den Debugausgaben nach den vier Nachrichtentypen,
die bei IKEv2 ausgetauscht werden, deren Parametern und den Reaktionen
meines VPN-Gateways auf diese Nachrichten. Die Nachrichten sind im
Abschnitt :ref:`ikev2/nachrichten:IKEv2 Nachrichten` näher beschrieben.

Die Reaktionen auf diese Nachrichten fallen
durchaus unterschiedlich aus, je nachdem, welche Seite Initiator
beziehungsweise Responder ist. Meist ist eine IKE-Sitzung einfacher auf
der Seite des Responders zu debuggen.

Dabei habe ich das Problem,
das in den Debugmeldungen sehr viel Text enthalten ist,
der es nicht einfacher macht,
die relevanten Informationen zu identifizieren.
Die richtigen Einstellungen dafür sind nicht leicht zu finden.
Ich kann sie in diesem Buch auch nicht geben,
weil sie von Software zu Software und von Version zu Version variieren.
Wenn ein Testlab zur Verfügung steht, kann man eine Situation nachstellen
und in
Ruhe ausprobieren, welche Debugeinstellungen genügend Informationen und
möglichst wenig Beifang liefern.

.. topic:: Beifang

   .. index:: ! Beifang

   *Als Beifang werden in der Fischerei diejenigen Fische und andere
   Meerestiere bezeichnet, die zwar mit dem Netz oder anderen
   Massenfanggeräten gefangen werden, nicht aber das eigentliche
   Fangziel des Fischens sind. [Wikipedia]*

   Im Rahmen der Fehlersuche bezeichne ich als Beifang Informationen,
   die ich - mehr oder weniger - unvermeidlich mit sammle, die aber nicht
   zur Lösung des Problems beitragen. Das können unvermeidbare Datagramme
   im Paketmitschnitt sein, die sich nicht beim Mitschneiden ausfiltern
   lassen, oder Logzeilen beziehungsweise Debugzeilen, die zwar das
   untersuchte VPN betreffen, aber keinen nennenswerten Aussagewert für
   die Fehlersuche haben.

Da ich in den meisten Fällen mit sehr viel Text zu tun bekomme,
muss ich mir überlegen, wie ich diesen in eine Datei bekomme,
die ich mit einem guten Pager wie z.B. *less* untersuchen kann.
Wichtig ist,
dass ich gut und schnell suchen kann
und dabei den Text nicht aus Versehen ändere.

Meist habe ich eine von zwei Möglichkeiten, an Debugmeldungen zu kommen:

* über die Standardausgabe beziehungsweise Standardfehlerausgabe in
  meiner SSH-Sitzung, oder
* direkt in den Systemlogs.

Im ersten Fall protokolliere ich meine Sitzung in eine Datei, entweder
mit dem Programm *script* oder, zum Beispiel bei Putty, durch die
Log-Funktion des SSH-Programms.

Im zweiten Fall filtere ich die Debugnachrichten aus den Systemlogs aus.
Dabei muss ich aufpassen, dass ich alles relevante und möglichst wenig
irrelevantes bekomme. Bei der Cisco ASA haben zum Beispiel alle
Debugnachrichten im Systemlog die gleiche ASA-Nummer, so dass ich sie
recht einfach separieren kann.
Habe ich nur ein oder sehr wenige aktive VPN auf dem Gateway,
kann ich mir das Ausfiltern eventuell sparen.

Bei den Debugmeldungen in der Standardausgabe fehlen oft die
Zeitstempel. Diese kann ich aushilfsweise erzeugen, wenn die Konsole
Befehle entgegennimmt und ich mit *date* (BSD, Linux) oder *show clock*
(Cisco ASA) dann und wann einen Pseudo-Zeitstempel in die Ausgabe
einfügen kann.

In den Systemlogs habe ich automatisch Zeitstempel für jede einzelne
Zeile, wodurch diese dann natürlich länger werden. Dafür bekomme ich
hier beim Debugging ein Gefühl für den Aussagewert der normalen
Systemlogs,
wenn ich mir diese zusätzlich bei der Analyse anzeigen lasse.

Debugausgaben ein- und ausschalten
..................................

Bei der **Cisco ASA** verwende ich die folgenden drei Befehle um
Debugnachrichten einzuschalten::

  debug crypto condition peer $address
  debug crypto ikev2 protocol 127
  debug crypto ikev2 platform 127

Der erste Befehl ist nur wichtig, wenn es mehr als ein VPN auf dem
Gateway gibt.

Habe ich meine Informationen, schalte ich die Debugnachrichten wie folgt
ab::

  undebug all

Bei einem **MikroTik Router** kann ich
Debugausgaben für IPsec mit folgendem Befehl einschalten::

  /system logging topic=ipsec,debug,!packet

Damit landen die Meldungen im lokalen Logpuffer
und sind schnell wieder weg.
Will ich sie zu einem - vorher konfigurierten - Logserver senden,
ergänze ich den Befehl zu folgendem::

  /system logging topic=ipsec,debug,!packet action=remote

Um die Debugausgaben zu deaktivieren,
ermittle ich die Nummer dieser Log-Einstellung
und deaktiviere oder entferne sie::

  /system logging print
  /system logging disable $nr
  /system logging remove $nr

Bei **strongSwan** kann ich die Menge der Debugausgaben mit folgendem Befehl
steuern::

  ipsec stroke loglevel ike $loglevel

Mehr Informationen zu den Loglevel und Nachrichtenquellen finde ich bei
:cite:`StrongSwanLoggerConfiguration`.

