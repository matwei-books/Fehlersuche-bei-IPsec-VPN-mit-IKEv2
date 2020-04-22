
IPsec-Software
==============

In diesem Kapitel gehe ich näher auf einige IPsec-Implementierungen ein.
Es ist mir klar, dass dieser Teil des Buches am schnellsten veralten wird.
Andererseits sind mir im Laufe der Zeit
etliche Uralt-Installationen begegnet,
die aus den verschiedensten Gründen weiter betrieben wurden.

Ich werde nicht
detailliert auf die Konfiguration von konkreten IPsec-VPN eingehen
sondern mich auf Fragen konzentrieren,
die ich als wesentlich für die Fehlersuche erachte:

1. **Wie komme ich an die Systemlogs?**

   Hier gibt es prinzipiell zwei Möglichkeiten:

   * Ich betrachte die Logs direkt auf der Konsole, in der ich angemeldet bin.
     Gibt es hier keine Möglichkeiten zur Filterung,
     ist es sinnvoll,
     die Konsolensitzung in einer Textdatei zu protokollieren,
     um die Logs zu analysieren.

   * Die Logs werden zu einem Logserver ausgeleitet.
     Dann muss ich sie von diesem Server abholen.

2. **Wie komme ich an die Debug-Informationen und wie interpretiere ich diese?**

   Oft landen die Debug-Informationen, wenn eingeschaltet, in den Logs.
   Dann kann ich sie zusammen mit diesen abholen.

   Manchmal kann ich sie direkt in der Terminal-Sitzung betrachten,
   dann gilt das gleiche wie oben für die Logs in der Konsolensitzung.
   Da beim Debugging sehr viele Informationen anfallen, will ich diese,
   wenn möglich,
   gleich bei der Entstehung filtern.

3. **Kann ich einen Paketmitschnitt auf dem VPN-Gateway machen und wenn ja, wie?**

   Aus den anderen Kapiteln dürfte klar geworden sein, dass ich
   Paketmitschnitte als ultimative Bestätigung oder Widerlegung für
   bestimmte Annahmen betrachte.
   Dementsprechend verwende ich dieses Mittel sehr oft.

   Kann ich präzise Filter verwenden,
   sind die gewünschten Informationen leicht zu finden
   und enthalten die nötigen Details,
   wenn es sich nicht gerade um verschlüsselte Datagramme handelt.
   Aber auch da geht bei manchen Implementierungen noch etwas.

   Schließlich sieht ein Paketmitschnitt immer gleich aus, wenn ich ihn
   zum Beispiel mit Wireshark analysiere.
   Demgegenüber unterscheiden sich die Debugausgaben von System zu
   System erheblich.
   Mit einem Paketmitschnitt kann ich somit fundierte Aussagen
   zu mir fremden Systemen treffen.

.. topic:: GUI

   .. index:: ! GUI

   Eine graphische Benutzeroberfläche (Graphical User Interface)
   macht eine Software mit Bildsymbolen und Steuerelementen einfacher nutzbar.
   Gut gemacht ist sie intuitiv benutzbar
   und insbesondere für selten ausgeführte Operationen vorteilhaft.

   Ein Nachteil für die Problemanalyse ist,
   dass die Konfiguration meist über mehrere Bildschirmseiten verteilt ist,
   die meist nicht durchsuchbar
   und durch umständliche Navigation nur nacheinander betrachtbar sind.

4. **Wie komme ich an die Konfiguration in Textform?**

   Obwohl ein GUI für die Konfiguration von VPN
   in bestimmten Situationen vorteilhaft ist,
   habe ich es für die Fehlersuche immer als hinderlich wahrgenommen.
  
   Ich bevorzuge für die Fehleranalyse eine Darstellung der kompletten
   Konfiguration in Textform, weil ich hier selbst entscheiden kann, was
   wichtig ist und was nicht.
   Auch ist das Navigieren im Text mit den richtigen Werkzeugen einfacher
   und schneller als das Öffnen und Schließen von Menüs.
   Schließlich, und das ist für mich der Hauptgrund,
   kann ich bei einer Konfiguration in Textform
   über die Suchfunktionen und Cut&Paste
   den Computer Adressen und Namen vergleichen lassen.
   Das kann dieser um ein Vielfaches besser als ich,
   vor allem wenn ich abgelenkt werde.

5. **Gibt es Besonderheiten?**

   Diese Frage geht auf Inkompatibilitäten oder bestimmte Fehler ein,
   die immer mal wieder auftreten
   und bei denen es Zeit sparen kann,
   wenn ich sie nebenbei kontrolliere.

.. toctree::
   :maxdepth: 2
   :caption: Inhalt:

   cisco-asa
   mikrotik-router
   pfsense

