
.. index:: ! ICMP

Behandlung von ICMP-Nachrichten
===============================

Ein wichtiger Punkt bei IPsec-VPN
ist die Verarbeitung von ICMP-Nachrichten.
Diese sind einerseits essentiell für bestimmte Netzwerkfunktionen,
wie zum Beispiel PMTU-Discovery,
und können andererseits für Angriffe auf die Infrastruktur dienen.
Bereits in :cite:`Weidner201703`
hatte ich mich detailliert
mit der Behandlung von ICMP bei Firewalls auseinandergesetzt
und will das hier nicht weiter als nötig ausdehnen.

RFC4301 :cite:`RFC4301` unterscheidet bei ICMP-Traffic
zwischen den beiden Kategorien
Fehlermeldungen (error), wie zum Beispiel *ICMP Unreachable*,
und informative Meldungen (non-error), wie zum Beispiel PING.

Informative ICMP-Nachrichten werden über die Policy,
das heißt wie normaler Traffic, behandelt
und entsprechend der SPD weitergeleitet oder verworfen.
Nötigenfalls werden Child-SA ausgehandelt,
wenn noch keine passenden existieren
und die Policy die Nachrichten erlaubt.

Mit der Behandlung von ICMP-Fehlermeldungen beschäftigt sich
Abschnitt 6 in RFC4301.
Dieser unterscheidet ICMP-Nachrichten,
die an das VPN-Gateway gerichtet sind,
von Transit-Nachrichten,
die durch IPsec geschützt übertragen werden.

Bei Host-Implentierungen von IPsec fallen einige dieser Kategorien weg,
für die verbleibenden gilt das geschriebene sinngemäß.

ICMP-Nachrichten für das IPsec-Gateway
--------------------------------------

ICMP-Nachrichten, die an das IPsec-Gateway gerichtet sind,
können an der ungeschützten (schwarzen) Seite
oder an der geschützten (roten) Seite des Gateways ankommen.

Nachrichten, die an der ungeschützten Seite ankommen,
gelten als nicht vertrauenswürdig.
Man kann nicht anhand des Datagramms allein entscheiden,
ob tatsächlich das angezeigte Problem im Netzwerk existiert
oder es sich um einen ausgeklügelten Angriff handelt.
Oft hat man auch keine Möglichkeit,
das auf andere Art für Datagramme von der schwarzen Seite zu überprüfen.
RFC4301 verlangt daher von einer konformen Implementierung
für den Administrator bei der Konfiguration die Alternative,
diese Meldungen zu ignorieren oder zu akzeptieren.
Außerdem muss es Mechanismen geben,
um mit diesen Nachrichten umzugehen.
Eine wichtige Nachricht ist hier ICMP Typ 3, Code 4
beziehungsweise ICMPv6 Typ 2, Code 0,
die essentiell für Path-MTU-Discovery sind
und auf die ich weiter unten näher eingehe.

ICMP-Nachrichten, die auf der geschützen Seite ankommen,
sind im Normalfall vertrauenswürdiger,
weil man ihre Herkunft und Beschaffenheit überprüfen kann,
wenn man die Kontrolle über das Netz hat.

Trotzdem sollten auch für den Empfang dieser Nachrichten
Steuerungsmöglichkeiten am Gateway vorhanden sein.

ICMP-Nachrichten zwischen den geschützten Netzen
------------------------------------------------

Neben den ICMP-Nachrichten, die an die VPN-Gateways gerichtet sind,
sind die Transit-Nachrichten zu betrachten,
die geschützt durch das VPN
zwischen den Netzen auf der roten Seite übertragen werden.

Die IPsec-Gateways müssen bei diesen
sowohl die ICMP- und IP-Header als auch die Payload berücksichtigen
damit diese Nachrichten
nicht für Manipulationen missbraucht werden können.
Auch das sollte konfigurierbar sein.

Hier gibt es folgende Konvention:
will ein Administrator, dass die ICMP-Payload nicht beachtet wird,
dann konfiguriert er einen SPD-Eintrag,
der den ICMP-Traffic explizit erlaubt.
Soll die ICMP-Payload für
die Entscheidung über die Weiterleitung eines Datagramms
herangezogen werden,
darf kein SPD-Eintrag existieren,
der das ICMP-Datagramm anhand der Headerdaten erlaubt.

Kommt ICMP-Traffic für das Netz beim Peer
auf der roten Seite eines VPN-Gateways an,
dann  wird dieses ungeprüft weitergeleitet,
wenn ein SPD-Eintrag existiert,
der den Traffic anhand des ICMP- und IP-Headers erlaubt.
Eine entsprechende Child-SA wird ausgehandelt,
wenn gerade keine passende aktiv ist.

.. index:: ICMP-Payload

Gibt es hingegen keinen SPD-Eintrag,
der auf die ICMP- und IP-Headerdaten passt,
dann wird die ICMP-Payload untersucht.
Und zwar sucht das VPN-Gateway nach einem SPD-Eintrag,
der auf die Headerdaten der Payload
mit vertauschten Quell- und Zieladressen sowie -ports passt.
Gibt es keinen solchen SPD-Eintrag,
wird das ICMP-Datagramm verworfen und ein Logeintrag erzeugt.

Gibt es hingegen einen solchen SPD-Eintrag,
wird das ICMP-Datagramm
mit einer zur Payload passenden Child-SA (mit vertauschen Adressen)
gesendet.

Das VPN-Gateway der Gegenstelle,
das das ICMP-Datagramm dann über diese SA erhält,
prüft seinerseits auf die gleiche Weise,
ob das ICMP-Datagramm entweder auf Grund der Headerdaten
oder der Payload berechtigt ist,
die SA zu nutzen.
Damit sichert sich das empfangende VPN-Gateway
gegen ein nicht konformes Peer-Gateway ab
und schreibt seinerseits bei einer nicht bestandenen Prüfung
einen Logeintrag.

.. todo:: Beispiel mit Erläuterung
   
   * ICMP-Datagramm
   * SPD-Eintrag
   * Zuordnung der Adressen

.. index:: ! PMTU-Discovery, ! Path-MTU Discovery

Path-MTU Discovery
------------------

Mit ICMP-Nachrichten Typ 3, Code 4
beziehungsweise ICMPv6 Typ 2, Code 0
signalisiert ein Gateway/Router
auf dem Weg eines Datagrammes vom Sender zum Empfänger,
dass das Datagramm zu groß für das nächste Netzsegment ist.
Das Verfahren ist in RFC1191 (:cite:`RFC1191`) beschrieben
und wird zum Beispiel von TCP verwendet,
um die optimale Datagrammgröße für eine Verbindung zu finden.

Bezogen auf IPsec-VPNs können diese ICMP-Nachrichten
an drei Stellen generiert werden:

- vor dem lokalen VPN-Gateway, dann ist das kein Thema für den
  VPN-Administrator,

- zwischen den VPN-Gateways, dazu komme ich gleich,

- hinter dem VPN-Gateway des Peers, dann wird es behandelt wie oben für
  alle ICMP-Nachrichten beschrieben.

.. todo:: Bild

Interessant für den VPN-Administrator sind diese Nachrichten,
wenn sie zwischen den VPN-Gateways erzeugt
und folglich an das lokale VPN-Gateways gesendet werden.
Der eigentliche Adressat dieser Nachricht
ist der Rechner im geschützten Netz,
der das zu große Datagramm geschickt hat.
Diesen kann das Gateway unterwegs, das das Problem hat, nicht kennen
weil bei diesem nur verschlüsselte Datagramme vorbeikommen.

Also sendet das Gateway unterwegs die ICMP-Nachricht an das VPN-Gateway,
welches das zu große verschlüsselte Datagramm sendete.
Dieses kann anhand des SPI in der ICMP-Payload die SA identifizieren
und die damit verknüpfte MTU korrigieren.

Was das VPN-Gateway nicht kann,
ist unmittelbar eine passende ICMP-Nachricht
an den Sender im geschützten Netz senden,
denn dessen Datagramm ist bereits verschlüsselt gesendet
und steht damit nicht mehr zur Verfügung,
wenn die ICMP-Nachricht beim VPN-Gateway ankommt.

Das heißt,
der ursprüngliche Sender der zu großen Datagramme
bekommt die ICMP-Nachricht mit der Korrekturgröße
frühestens nach dem zweiten gesendeten großen Datagramm.
Hier gibt es also systembedingt eine zusätzliche Verzögerung,
bis die Path-MTU-Discovery wirksam wird.

RFC4301 schreibt vor,
dass die zu einer SA gehörende Path-MTU altern soll,
damit sie - durch erneute PMTU-Discovery - 
an geänderte Netzbedingungen angepasst werden kann.
Das bedeutet, 
dass bei einer länger bestehenden SA
periodisch das eben beschriebene Spiel wiederholt wird.

