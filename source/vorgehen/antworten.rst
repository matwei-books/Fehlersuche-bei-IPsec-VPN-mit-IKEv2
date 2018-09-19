
Antworten
=========

Gute Fragen zu stellen trägt schon ein großes Stück bei zur Lösung eines
Problems. Die Fragen nützen mir jedoch nichts, wenn ich nicht in der
Lage bin Antworten darauf zu finden.

Darum geht es in diesem Kapitel. Zu jeder der grundlegenden respektive
den davon abgeleiteten konkreten Fragen will ich Wege aufzeigen, mit
denen ich passende Antworten finden kann.

Dabei muss ich - insbesondere bei schwierigen Problemen - zu jeder
Antwort im Hinterkopf die Frage behalten "Ist das wahr, ist das, was ich
gesehen habe, alles"? In den meisten Fällen werde ich nicht davon
Gebrauch machen müssen. Aber besonders, wenn meine Antworten scheinbar
keinen Sinn ergeben, muss ich die Voraussetzungen und die
Zwischenschritte - das heißt, die gefundenen Antworten - hinterfragen
und kontrollieren.

Im Wesentlichen habe drei Möglichkeiten, Antworten auf meine Fragen zu
bekommen:

* Aussagen von VPN-Benutzern
* Systemlogs vom VPN-Gateway
* Paketmitschnitte
* Debugausgaben

Aussagen von VPN-Benutzern
--------------------------

Aussagen von VPN-Benutzern in Form von Fehlermeldungen sind oft der
Anlass für eine Fehlersuche bei einem VPN.

Gerade am Anfang der Untersuchung ist es daher wichtig, so viel wie
möglich von den Benutzern über die genauen Umstände des Problems zu
erfahren: seit wann tritt das Problem auf, welche Geräte sind daran
beteiligt, bei welchen Aktionen tritt das Problem auf.

Am Ende der Fehlersuche gehört es einfach dazu, dass man denjenigen, der
ein Problem gemeldet hat, befragt, ob es wirklich beseitigt ist. Dieser
Moment wird gern benutzt, um das nächste Problem zu melden, in so einem
Fall sollte man ein neues Ticket aufmachen, sobald klar wird, dass es
nicht mehr um das ursprüngliche Problem geht.

Leider sind die Aussagen der Endbenutzer bei der eigentlichen
Fehlersuche oft wenig hilfreich. Dann ist es sinnvoll die
Anwendungsbetreuer, die Administratoren der Server und eventuell auch
die Netzwerkadministratoren (wenn diese in einer anderen Gruppe arbeiten
als die VPN-Administratoren) zu Rate zu ziehen, um das Problem
einzugrenzen und die beteiligten Adressen zu erfahren.

Systemlogs vom VPN-Gateway
--------------------------

Systemlogs sind ein zweischneidiges Schwert. Zum einen liefern sie
zeitnah Hinweise auf außergewöhnliche Ereignisse und bieten sich an für
eine automatische Überwachung. Bei der Fehlermeldung können sie
wertvolle Tipps geben, die die Suche nach der Ursache verkürzen.

Zum anderen können Sie, insbesondere wenn sie nicht eindeutig sind, in
die Irre führen und eine Fehlersuche unnötig verlängern. Ich habe einen
Fall erlebt, bei dem ein Netzwerkadministrator, der Zugang zu den
VPN-Logs hatte, plötzlich Traffic zwischen zwei VPN-Gateways in den Logs
"sah", obwohl zwischen beiden Geräten nicht einmal PING funktionierte
und im Paketmitschnitt auf beiden Seiten nachweislich kein Traffic des
jeweils anderen VPN-Gateways auftauchte. Was passierte, war dass die
Cisco-ASA einen Logeintrag generierte für jeden Verbindungsversuch, den
sie unternahm. Dieser Logeintrag enthielt die Traffic-Selektoren für den
auslösenden Traffic, der durch das VPN gehen sollte und die IP-Adresse
des Peer-Gateways zu dem die Verbindung aufgebaut werden sollte. Es
dauerte einige Zeit, diesen Netzwerkadministrator zu überzeugen, dass es
sich bei diesen Logeinträgen um ausgehenden Traffic handelte, für den in
diesem Fall keine Antwort vom Peer-Gateway ankam. Unglücklicherweise
hatte sich der VPN-Administrator der vorherigen Schicht überreden
lassen, die VPN-Konfiguration "testweise" zu ändern, so dass wir nach
Beseitigung des eigentlichen Problems das VPN wirklich "reparieren"
mussten.

Wichtig ist also, insbesondere bei Logeinträgen, die man nicht kennt,
nach anderen Wegen zu suchen um ihre Aussage zu überprüfen. In obigem
Fall konnte ein Paketmitschnitt zeigen, dass da kein Traffic vom Peer
ankam.

Wenn ich es mit neuer Software zu tun bekomme, die Logeinträge schreibt,
mit denen ich nicht viel anfangen kann und zu denen ich keine gute
Dokumentation bekomme, fange ich oft an, die Logeinträge statistisch zu
untersuchen. Dabei abstrahiere ich von - in meinen Augen irrelevanten -
Details und schaue zunächst, welche Zeilen am häufigsten und welche am
seltensten vorkommen. Bei den Logeinträgen, die am häufigsten vorkommen,
entscheide ich dann, ob sie irrelevant sind und ausgefiltert werden
können, oder ob sie ein Problem darstellen, dass ich vorrangig
bearbeiten will. Die seltenen Logeinträge lassen sich meist leicht mit
bestimmten Ereignissen verknüpfen, so dass ich mit der Zeit ein Gefühl
für die Bedeutung der einzelnen Einträge bekomme.

Die folgende Befehlskette in einer Unix-Shell liefert mir die Häufigkeit
von bestimmten Logzeilen in absteigender Reihenfolge::

  sed -E 's/^.{16}//' < $logfile | sort | uniq -c | sort -rn | less

Dabei passiert folgendes:

``sed -E 's/^.{16}//' < $logfile``
  Der Befehl *sed* bekommt den Inhalt der Datei *$logfile* in der
  Standardeingabe, entfernt in jeder Zeile die ersten 16 Zeichen (den
  Zeitstempel) und gibt den Rest aus.

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

Damit kann ich bereits einen ersten Überblick bekommen. Bei komplexeren
Logzeilen, die Elemente enthalten, welche ich ignorieren will, greife
ich meist zu einem Perl-Skript, dass die irrelevanten Details maskiert.

Damit bekomme ich mit der Zeit ein Gefühl dafür, welche Logzeilen
wichtig sind und was sie bedeuten.

Manchmal reicht aber schon ein Blick auf die reine Anzahl von Logzeilen,
um zu erkennen, dass etwas nicht in Ordnung ist. In einem konkreten Fall
war ein VPN in Abstimmung mit dem VPN-Administrator des Peers von IKEv1
auf IKEv2 umgestellt worden. Die beteiligten Administratoren hatten zu
der Zeit keinen zeitnahen Zugriff auf die eigenen Logs (es gab eine
Verzögerung von teilweise mehreren Stunden, bis die Logs verfügbar
wurden) und hatten nur den Aufbau der Tunnel getestet und ob Daten
übertragen wurden. Nach etwa einer Woche kam eine Fehlermeldung vom
Peer, dass das VPN seit der Umstellung nicht richtig funktionieren
würde. Zu dem Zeitpunkt standen sowohl Logs vor der Umstellung als auch
vom Zeitraum danach zur Verfügung. Während vor der Umstellung etwa 100
Logzeilen pro Tag für das betreffende VPN generiert worden, waren es
nach der Umstellung etwa 10000, also ungefähr einhundertmal so viele. Im
Monitoring war das nicht aufgefallen, vermutlich, weil das VPN-Gateway
sowieso täglich mehrere Gigabyte Logeinträge generierte. Einige Zeit
später bekamen wir zeitnahen Zugriff auf die VPN-Logs.

Paketmitschnitte
----------------

.. todo::

   Text zu Paketmitschnitten mit Verweis auf Abschnitt in den Grundlagen

Debugausgaben
-------------

.. todo::

   Text zu Debugausgaben

