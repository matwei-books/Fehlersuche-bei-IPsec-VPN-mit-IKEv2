
Hilfsmittel
===========

Testlab
-------

Ein Testlab ist ein nützliches Werkzeug. Nicht nur für die Fehlersuche
bei VPNs, sondern allgemein bei Netzwerkproblemen und vor allem auch zum
Lernen und Testen von neuen Lösungen bevor man diese aktiv in
Produktionsnetzen einsetzt. Ich kann damit ein Problem nachstellen oder,
wenn ich es nicht nachstellen kann, gezielt nach den Unterschieden
zwischen der Problem- und der Testumgebung suchen und darüber Hinweise
für die Lösung bekommen. Außerdem kann ich es für Schulungszwecke
einsetzen um die theroretischen Erörterungen mit praktischen Übungen
anschaulich zu machen.

Ich kann ein Testlab temporär aus vorhandenener redundanter Hardware
zusammenstecken oder dauerhaft mit extra dafür angeschaffter Hardware.
Es gibt Simulationssoftware wie GNS3, auf die ich noch zurückkommen
werde, mit der ich viele Problemstellungen ohne die dafür im
Produktivnetz eingesetzte Hardware untersuchen kann. Ich kann eine
solche Netzwerk-Simulation auch mit Hardware-Komponenten ergänzen, deren
Funktionalität sich nicht simulieren lässt.

Generell habe ich eine Menge Vorteile von einem Testlab:

* Ich kann Probleme unabhängig vom Produktivnetz untersuchen und bin
  damit an keine zeitlichen Einschränkungen gebunden und kann den
  Lösungsraum experimentell verifizieren, was nichts anderes heißt, als
  dass ich verschiedene Lösungen ausprobieren kann, ohne Angst haben zu
  müssen, noch mehr kaputt zu machen.

* Ich kann die Komplexität eines Problems auf die minimale Anzahle von
  beteiligten Komponenten reduzieren um mir damit seine Natur klar zu
  machen. Mit diesem reduzierten Problem ist es vielleicht auch
  einfacher, Hilfe von anderen zu bekommen.

* Für die Nachfrage in öffentlichen Foren kann ich das Problem mit
  anderen, privaten Adressen reproduzieren um mir das Modifizieren der
  Adressen beim Posten von Konfigurationen oder Mitschnitten zu
  ersparen.

* In einem Testlab kann ich Paketmitschnitte problemlos an verschiedenen
  Stellen des Netzwerks anfertigen.

* Und insbesondere eine Software-Simulation wie GNS3 kann ich sehr
  schnell an verschiedene Problemstellungen anpassen, so dass das
  Umschalten von einem Problem auf ein anderes in einem Bruchteil der
  Zeit gelingen kann.

Dem stehen einige Nachteile gegenüber:

* So benötige ich für ein Testlab zusätzliche Ressourcen, die zunächst
  einmal nicht produktiv genutz werden können. Dieses Argument reduziert
  sich beim Einsatz einer Simulationssoftware wie GNS3 auf den
  reservierten Plattenplatz und den benötigten RAM beziehungsweise die
  CPU-Leistung. Letzteres auch nur, wenn wirklich eine Simulation läuft.

* Ich habe in einem Testlab immer ein anderes Zeitverhalten als im
  Produktiv-Netz. Auch ist der Traffic im Testlab ein ganz anderer als
  im Produktivnetz und es ist nicht trivial, ähnliche Bedingungen für
  die Untersuchung von Lastproblemen herzustellen. Das heißt, bestimmte
  Problemklassen eignen sich schlecht für die Untersuchung im Testlab.

* Insbesondere bei Simulationen muss ich neben dem geänderten
  Zeitverhalten auch mit anderen MTU rechnen und deren Einfluß auf die
  Problemlösung berücksichtigen.

* Schließlich stehen mir für eine Software-Simulation oft nicht genau
  die Versionen zur Verfügung, die im Produktivnetz eingesetzt werden.
  Das kann ich durch eine Kombination von echter Hardware und
  Software-Simulation kompensieren, wodurch wiederum die Kosten und der
  Aufwand für das Testlab steigen.

GNS3
....

Trotz der möglichen Nachteile möchte ich ein Testlab mit GNS3 für die
Untersuchung von Netzwerkproblemen, für Proof-of-Concepts oder einfach
nur zum Lernen empfehlen.

Es gibt verschiedene Möglichkeiten, ein Testlab mit GNS3 einzurichten.

Ein Laptop mit geeigneter CPU und genügend RAM kann bereits ausreichen
um viele Situationen nachzustellen. Da hier sowohl das Frontend als auch
der VM-Host, auf dem die simulierten Geräte laufen, in einem Rechner
vereint sind, ist diese Lösung - einmal eingerichtet - am bequemsten
einsetzbar. Über einen Netzwerkanschluss und VLANs kann ich diesen
Aufbau mit externer Hardware zu komplexen Setups erweitern.

Habe ich keinen Laptop übrig, kann ich das Backend mit den VM auch auf
einer vorhandenen virtuellen Umgebung laufen lassen. Je nachdem, ob
diese Umgebung in meinem Rechenzentrum oder auf angemieteten Servern im
Internet läuft, kann ich auch hier vielleicht externe hardware
einbringen.

Schließlich habe ich für ein Schulungsprojekt das GNS3-Backend auf einem
Einplatinenrechner mit genügend RAM und CPU-Leistung installiert und nur
das Frontend auf meinenm Laptop.

Bei dieser sowie be der Cloud-Lösung muss ich darauf achten, dass Front-
und Backend die gleiche Software-Version haben. Bei der kompletten
Installation auf einem Laptop sind diese automatisch auf dem gleichen
Stand.

Zum Einrichten folgt man am besten einem der vorhandenen Tutorials.
Für das Einrichten auf einem Laptop habe ich die Installation für Ubuntu
herangezogen. Der Laptop sollte also ausreichend von Ubuntu unterstützt
werden.

Für das Einrichten auf PC Engines APU habe ich zunächst darauf Ubuntu
LTS Server installiert und anschließend die Cloud-Lösung von GNS3
darauf. Auf dem Laptop reicht dann die Bedienoberfläche.

Beim Betrieb von GNS3 kann es einige Probleme geben, die sich umgehen
lassen, wenn man sie kennt.

Ich hatte Probleme mit den Konsolen einiger Geräte, die mit VNC für die
Konsole arbeiten. Insbesondere ließen sich einge essentielle Zeichen
nicht eingeben. In diesem Fall half es, auf eine andere
VNC-Viewer-Software zu wechseln.
Ist es mögich, die simulierten Geräte auf eine serielle Konsole
einzustellen, so bevorzuge ich diese, weil dann Cut&Paste
uneingeschränkt funktioniert.

GNS3-Simulationen (Projekte) interagieren via Clouds mit externen
Netzen. In einfachen Cloud-Devices stehen die Network-Interfaces des
Backend-Hosts zur Verfügung, bei NAT-Clouds geht es nur hinaus, weil
alle Zugriffe auf externe Netze hinter der Schnitstellen-Adresse
verborgen sind.  Obwohl ich Zugriff von GNS3-Projekten über die
Netzinterfaces auf alle angeschlossenen Netze bekommen kann, erreiche
ich den Host selbst darüber nicht. Um diesen zu erreichen, muss ich ein
*Tap* Device einrichten und kann mit diesem dann über eine Cloud mit den
simulierten Geräten interagieren. Das ist insbesondere dann wichtig,
wenn GNS3 komplett auf einem Laptop läuft und ich von diesem
beispielsweise das Web-Interface eines der simulierten Geräte ansprechen
will.

Für komplexe Simulationen mit externen Geräten verwende ich
sinvollerweise VLANs, wobei der Ethernet-Schnittstelle, die von der
GNS3-Cloud verwendet wird, ein Trunk zugewiesen wird. Auf einem
simulierten Switch in GNS3 kann ich dann die VLAns trennen.

Obwohl es sehr einfach ist, an den Verbindungen zwischen den simulierten
Geräten in GNS3 Paketmitschnitte aufzunehmen, muss ich vorsichtig sein,
wenn ich den Traffic an dem Interface mitschneiden will, über das das
Frontend auf das Backend zugreift. Wenn ich hier keinen simulierten
Switch dazwischenschalte, bekomme ich leicht den Steuerverkehr von GNS3
in den Capture mit dem ich über den Mitschnitt das Backend lahm lege,
wenn die Daten zu einem Wireshark ausgeleitet werden. Da ich an diesen
Datagrammen meist sowieso nicht interessiert bin, ist ein Switch an
dieser Stelle eine gute Lösung.

Sonde zum Injizieren von Traffic
--------------------------------
