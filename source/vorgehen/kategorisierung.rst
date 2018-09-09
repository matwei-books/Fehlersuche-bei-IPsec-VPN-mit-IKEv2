
Wie weiter?
===========

Das Problem identifiziert zu haben, ist nur ein Schritt auf dem Weg zur
Lösung. Um es zu lösen sind weitere Schritte nötig. Möglicherweise
delegiere ich die Lösung des Problems an jemand anders.
Die folgende Kategorisierung hilft mir dabei.

Ich unterscheide 

* externe Probleme
* Fehlkonfigurationen
* Softwarefehler

Externe Probleme
----------------

Externe Probleme liegen per Definition nicht im Einflußbereich des
VPN-Administrators. Diese Probleme müssen jedoch gelöst sein, bevor
überhaupt die Chance besteht, ein VPN aufzubauen.

Ich verstehe darunter zum Beispiel

* Stromausfälle oder ähnliches, durch die das VPN-Gateway überhaupt
  nicht erreichbar ist.
  In diesem Fall kann ich ohnehin keine Fehlkonfigurationen erkennen,
  geschweige denn etwas ändern.

* Netzwerkprobleme, bei denen keine Daten zwischen den
  VPN-Gateways übertragen werden.
  Hier liegt es an mir, vor allem anderen auf der Behebung der
  Netzwerkprobleme zu bestehen, bevor ich signifikante Änderungen an der
  VPN-Konfiguration vornehme.

Bei einem Problem gab es keinen direkten Kontakt über das Internet
zwischen zwei VPN-Gateways, obwohl beide von dritten erreicht werden
konnten. Die Systemlogs waren nicht eindeutig, so dass einer meiner
Kollegen sich überreden ließ, die Konfiguration zu ändern.
Am Ende, nachdem die Verbindungsprobleme behoben waren, mussten wir nun
auch die Konfigurationsänderung zurückzunehmen um das VPN wieder
lauffähig zu machen.

Fehlkonfigurationen
-------------------

Bei Fehlkonfigurationen sind eindeutig die VPN-Administratoren in der
Pflicht. In manchen Fällen kann ich sie durch gewissenhaften Vergleich
mit den vereinbarten Parametern erkennen.

Oft erkenne ich die Fehlkonfiguration aber erst, wenn ich beim
Verbindungsaufbau die Diskrepanz der vereinbarten Parameter mit den am
Ende verwendeten sehe. Dazu müssen sich die VPN-Gateways erreichen
können und ich Zugang zu den Logs und Debugausgaben haben.
Das heißt externe Probleme sollten beseitigt sein.

Üblicherweise werden die Parameter vor der Konfiguration vereinbart,
dazu sollte es eine schriftliche Dokumentation geben. Die abweichende
Konfiguration muss dann angepasst werden.

In der Praxis habe ich es häufig erlebt, dass erst bei der Konfiguration
bemerkt wird, dass ein VPN-Gateway eine bestimmte Konfiguration gar
nicht realisieren kann. Dann bleiben als Optionen Nachverhandeln der
Konfigurationsparameter oder Ersetzen des nicht kompatiblen VPN-Gateways
durch ein anderes.

Softwarefehler
--------------

Diese Fehler sind am schwierigsten zu behandeln, weil sie die Hilfe
Dritter erfordern. Das kann der Hersteller des VPN-Gateways sein, ein
Kontraktor, der Support für die Software leistet oder das Supportforum,
wenn eine freie Software wie OpenSwan für das VPN-Gateway verwendet
wird.

In allen Fällen stelle sicher, dass keine externen Probleme und keine
Fehlkonfiguration vorliegen. Dabei überprüfe ich alle meine Annahmen
mindestens ein weiteres Mal, bevor ich das Problem eskaliere und um
Hilfe bitte.

Mitunter ist das Problem bereits bekannt und in Knowledgebase-Artikeln
oder Fehlerreports beschrieben. Danach kann ich in den entsprechenden
Foren, beim Hersteller oder einfach im Internet suchen. Gibt es einen
Workaround, dann kann ich diesen vielleicht anwenden.

Wenn das nicht hilft, nehme ich Kontakt zum Support des Herstellers
beziehungsweise zu geeigneten Supportforen auf.
Oft bekomme ich Hinweise auf weitere Tests, die ich machen kann um das
Problem weiter einzugrenzen.

Kann das Problem behoben werden, nehme ich die Lösung in meine eigene
Wissensdatenbank auf. Habe ich ein öffentliches Forum bemüht, so
hinterlasse ich dort eine Beschreibung der Lösung für mein Problem,
möglichst in einer Form die leicht nachvollziehbar ist.

Manchmal bleibt aus Ausweg nur der Wechsel auf andere
Konfigurationsparameter, wenn das möglich ist, oder auf eine andere
Software für das VPN-Gateway.

