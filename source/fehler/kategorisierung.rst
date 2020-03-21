
Problemkategorien
=================

Ein Problem identifiziert zu haben,
ist nur ein Schritt auf dem Weg zur Lösung.
Um es zu lösen sind weitere Schritte nötig.
Möglicherweise delegiere ich dabei Teilschritte an jemand anders.
Die folgende Kategorisierung hilft mir dabei.

Ich unterscheide 

* externe Probleme
* Fehlkonfigurationen
* Softwarefehler

Externe Probleme
----------------

Externe Probleme liegen per Definition nicht im Einflußbereich des
VPN-Administrators. Diese Probleme müssen jedoch gelöst sein, bevor
überhaupt die Chance besteht,
ein VPN aufzubauen oder zu reparieren.

Unter externen Problemen verstehe ich zum Beispiel

* Einen Stromausfall oder ähnliches,
  wodurch das VPN-Gateway nicht erreichbar ist.
  In diesem Fall kann ich ohnehin keine Fehlkonfigurationen erkennen,
  geschweige denn etwas ändern.

* Netzwerkprobleme, bei denen keine oder nicht genügend Daten
  zwischen den VPN-Gateways oder in den roten Netzen übertragen werden.
  Hier liegt es an mir,
  auf der Behebung der Netzwerkprobleme zu bestehen,
  bevor ich Änderungen an der VPN-Konfiguration vornehme.

In einem konkreten Fall gab es
über das Internet keinen Kontakt zwischen zwei VPN-Gateways,
obwohl beide von dritter Stelle erreicht werden konnten.
Die Systemlogs waren nicht eindeutig,
so dass ein VPN-Administrator sich überreden ließ,
die Konfiguration zu ändern.
Nachdem die Verbindungsprobleme behoben waren,
mussten wir diese Änderung zurücknehmen
um das VPN wieder lauffähig zu machen.

Oft genug habe ich es erlebt,
dass die Datagramme,
die wir vom Peer über das VPN bekamen,
in unserem Netz verschwanden,
so dass wir keine Antworten senden konnten.
Als VPN-Administratoren waren wir zwar die ersten Ansprechpartner,
das Problem lösen mussten jedoch die Netzwerk-Administratoren.

Fehlkonfigurationen
-------------------

Hier bin eindeutig ich als VPN-Administrator in der Pflicht.
In manchen Fällen kann man Fehlkonfigurationen
durch gewissenhaften Vergleich mit den vereinbarten Parametern erkennen.

Ich hingegen erkenne eine Fehlkonfiguration oft erst,
wenn ich beim Verbindungsaufbau die Diskrepanz
der vereinbarten Parameter mit den am Ende verwendeten sehe.
Dazu müssen sich die VPN-Gateways gegenseitig erreichen können
und ich Zugang zu den Logs und Debugausgaben haben.
Das heißt,
bestehende externe Probleme zwischen den VPN-Gateways
sollten bis dahin beseitigt sein.

Üblicherweise werden die Parameter vor der Konfiguration vereinbart,
dazu sollte es eine schriftliche Dokumentation geben. Die abweichende
Konfiguration muss dann angepasst werden.

In der Praxis habe ich es häufig erlebt,
dass erst beim Test bemerkt wird,
dass ein VPN-Gateway eine bestimmte Konfiguration gar nicht realisieren kann.
Dann bleiben als Optionen Nachverhandeln der
Konfigurationsparameter oder Ersetzen des nicht kompatiblen VPN-Gateways
durch ein anderes.

Softwarefehler
--------------

Diese Fehler sind am schwierigsten zu behandeln,
weil sie die Hilfe kompetenter Dritter erfordern.
Das kann der Hersteller des VPN-Gateways sein,
ein Dienstleister, der Support für die Software leistet,
oder das Supportforum,
wenn eine freie Software wie OpenSwan oder StrongSwan
für das VPN-Gateway verwendet wird.

In allen Fällen stelle ich sicher,
dass keine externen Probleme und keine Fehlkonfiguration vorliegen.
Dabei überprüfe ich alle meine Annahmen
mindestens ein weiteres Mal, bevor ich das Problem eskaliere und um
Hilfe bitte.

Mitunter ist das Problem bereits bekannt und in Knowledge-Base-Artikeln
oder Fehlerreports beschrieben.
Danach kann ich in den Foren, beim Hersteller oder einfach im Internet suchen.
Bei dieser Suche helfen mir die bis dahin erlangten Informationen,
das Problem möglichst genau zu beschreiben.
Gibt es einen Workaround,
dann kann ich diesen prüfen und vielleicht anwenden.

Wenn das nicht hilft, nehme ich Kontakt zum Support des Herstellers
beziehungsweise zu geeigneten Supportforen auf.
Oft bekomme ich Hinweise auf weitere Tests, die ich machen kann um das
Problem weiter einzugrenzen.

Kann das Problem behoben werden, nehme ich die Lösung in meine eigene
Wissensdatenbank auf. Habe ich ein öffentliches Forum bemüht, so
hinterlasse ich dort eine Beschreibung der Lösung für mein Problem,
möglichst in einer Form die leicht nachvollziehbar ist.

Manchmal bleibt auch hier als Ausweg nur
der Wechsel auf andere Konfigurationsparameter,
wenn das möglich ist,
oder auf eine andere Software für das VPN-Gateway.

