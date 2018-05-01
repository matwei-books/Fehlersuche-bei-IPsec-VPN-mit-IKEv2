
Funktioniert alles?
===================

Habe ich zumindest einen Tunnel mit IPsec SA, kann ich davon ausgehen,
dass das VPN grundsätzlich funktioniert. Auch dann bleiben noch genügend
Fragen.

-  Gibt es eingehenden und ausgehenden Traffic?

Ein aufgebauter VPN-Tunnel nützt nur dann etwas, wenn er Traffic in
beiden Richtungen überträgt. Fehlt eine Richtung, frage ich zunächst, ob
der fragliche Traffic überhaupt bei meinem VPN-Gateway ankommt. Kommt
dieser Traffic nicht an, brauche ich zunächst nichts weiter zu machen
und kann die Suche wieder delegieren. Kommt er am VPN-Gateway an, muss
ich untersuchen, warum der Traffic nicht auf der anderen Seite
hinausgeht.

Gehen keine weiteren IPsec SA nach dem ersten auf, vergleiche ich die
ACL und IPsec Krypto Parameter.

Finde ich keine Erklärung, ist das ein guter Zeitpunkt zu eskalieren und
mir Hilfe zu holen.

-  Gibt es Traffic für alle konfigurierten IPsec SA in beiden
   Richtungen?

Diese Frage ist etwas schwierig zu beantworten, weil der Traffic
üblicherweise von anderen erzeugt wird und hier ein Koordinationsproblem
entstehen kann. Nichtsdestotrotz sollte diese Frage spätestens bei der
Abnahme des VPN mit *Ja* beantwortet sein.

-  Gibt es Fehlermeldungen oder Warnungen in den Logs?

Auch wenn das VPN scheinbar vollständig funktioniert, kann ein Blick in
die Logs auf bisher unentdeckte Probleme hinweisen. Natürlich setzt das
einen zeitnahen Zugriff auf die Systemprotokolle voraus.

