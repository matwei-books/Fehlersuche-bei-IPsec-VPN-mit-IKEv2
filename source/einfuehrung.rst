
Einführung
==========

Bis 2015 waren IPsec-VPN eher ein Problem für mich und bei den wenigen,
die ich eingerichtet hatte, war ich froh, wenn der Administrator der
Gegenstelle genug von der Materie verstand, um mir zu helfen oder
wenigstens nicht noch zusätzliche Probleme zu bereiten. Damals
bevorzugte ich OpenVPN und bei IPsec war IKEv1 das vorherrschende
Protokoll für das Aushandeln der Verbindungsparameter.

Das war damals und 2016 begann ich eine neue Arbeit, bei der ich unter
anderem für einen großen IT-Dienstleister IPsec-Tunnel zu sehr vielen
verschiedenen Gegenstellen - den Peers betreute. Ich hatte pro Woche
drei, vier und mehr IPsec-VPN einzurichten und natürlich gehörte die
Fehlersuche dazu, wenn es nicht sofort funktionierte.
Von Anfang an profitierte ich sehr von der Hilfe meiner Kollegen,
die mir Templates zum Einrichten von neuen und zum
Ändern von bestehenden VPN gaben. Sie zeigten mir auch, woran ich
erkennen konnte, ob ein VPN funktionierte oder nicht.

Mit unseren VPN-Gateways - Cisco ASA - war es zu der Zeit nicht möglich,
die geforderten kryptografischen Parameter mit IKEv1 einzustellen, so
dass wir begannen, bereits bestehende VPN von IKEv1 auf IKEv2 umzustellen.

Obwohl IKEv2 erstmalig 2005 in RFC 4306 beschrieben wurde (die zur Zeit
aktuelle Fassung ist RFC 7296 von 2014 :cite:`RFC7296`), gab es 2016 noch
nicht viele Administratoren, die sich intensiv damit beschäftigt hatten,
dafür allerdings etliche VPN-Gateways, die IKEv2 nicht oder nicht in genügendem Maße
beherrschten. Viele Gelegenheiten zum Lernen.

Aus meinen in dieser Zeit gesammelten Erfahrungen entstand ein Workshop
zum Thema Fehlersuche bei IPsec für die Kollegen und schließlich dieses
Buch.

Ein VPN zu betreiben und Fehler dabei zu suchen ist schon nicht einfach,
wenn man beide Endpunkte selbst betreibt.
Dann hat man allerdings die meisten Komponenten unter eigener Kontrolle
und kann in Ruhe alles kontrollieren und testen.

Schwieriger wird es bei einem half-managed VPN,
wo jeder Administrator nur sein eigenes Gateway kontrollieren kann.
Kommen dazu noch Geräte oder Software unterschiedlicher Hersteller auf
beiden Seiten ins Spiel, kann es schon vertrackt werden, einem
Problem auf die Schliche zu kommen.

.. figure:: /images/vpn.png
   :alt: Half-managed VPN

   Half-Managed VPN

Das Diagramm zeigt die verschiedenen Akteure
bei einem VPN zwischen zwei Netzwerken.
Dabei gibt es verschiedene mögliche Problemfelder:

.. index:: IPsec

* An zentraler Stelle ist IPsec als Protokoll selbst.
  Im Gegensatz zu OpenVPN,
  bei dem beide Seiten Software aus der gleichen Quelle verwenden,
  handelt es sich bei IPsec
  um ein durch RFCs definiertes und standardisiertes Protokoll,
  das von beiden Seiten auf je eigene Weise interpretiert wird.

* Verschiedene Hersteller implementieren verschiedene Features des
  Protokolls, so dass man eine Schnittmenge bilden muss, zwischen den
  Fähigkeiten der beteiligten Geräte und den Anforderungen an die Verbindung.
  Manchmal verwenden die Hersteller gleiche Begriffe für unterschiedliche
  Dinge oder unterschiedliche Begriffe für die gleichen Dinge.
  Beides trägt keineswegs dazu bei, die Verständigung zwischen den
  Administratoren der beiden Seiten zu erleichtern.
  Dabei ist gerade eine gute Kommunikation notwendig, denn im schlimmsten Fall
  sieht jeder Administrator nur sein VPN-Gateway, was im Diagramm durch die
  Strichlinien angedeutet ist.

* Ein weiteres Problem ist NAT, die Manipulation von IP-Adressen.
  NAT führt dazu, dass sich die Adressen ein und desselben Datagramms im Netz A
  von den im Tunnel verwendeten und diese von den im Netz B unterscheiden
  können.
  Solange alles funktioniert, mag das angehen, im Fehlerfall kann es die
  Verwirrung vergrößern.

.. index:: L2L

* Gerade bei L2L-VPN kommen im Fehlerfall
  oft Probleme mit der Koordination zwischen den Beteiligten hinzu.
  Während es bei den meisten VPN-Gateways eine Möglichkeit gibt,
  Traffic nachzuweisen und zu dokumentieren,
  muss ich für vollständige Tests geeigneten Traffic erzeugen,
  wofür ich auf die Mitarbeit der Nutzer des VPN angewiesen bin.
  Dazu muss ich mich mit allen Beteiligten absprechen,
  was das Finden passender Termine erschweren kann.

Damit ist lediglich der Rahmen abgesteckt,
in dem sich die VPN-Administratoren bewegen
und innerhalb dessen sie mit den unterschiedlichsten Problemen
konfrontiert werden können.
Mit diesem Buch möchte ich helfen, diese Probleme strukturiert
zu diagnostizieren und schnell zu einem Ergebnis zu kommen.

Das Buch ist für Praktiker, die bereits mindestens ein VPN mit IPsec
eingerichtet haben und dabei auf Probleme gestoßen sind, die sie in
Zukunft schneller erkennen und lösen wollen.
Ich beschränke mich auf die Fehlersuche bei IPsec-VPN mit IKEv2.
Für die Diagnose von VPN mit IKEv1 ist dieses Buch nur bedingt geeignet.

Das Buch ist keine Einführung in IPsec und auch keine Anleitung zum
Einrichten von VPN. Dementsprechend gehe ich auch nicht auf die Vor- und
Nachteile der einzelnen kryptographischen Parameter ein und verweise an
dieser Stelle auf externe Quellen wie :cite:`BSI-TR-02102-3`.

Im nächsten Kapitel beginne ich mit Grundlagen,
die ich für das Verständnis und die Diagnose von Netzwerkproblemen voraussetze.
Diese können getrost übersprungen und bei Bedarf nachgelesen werden.

Danach folgt eine Einführung in IKEv2,
soweit für die Diagnose von Problemen nötig.
Für detailliertere Erörterungen verweise ich auf die Literatur,
insbesondere :cite:`RFC7296` und :cite:`Bartlett2016`,
welches eine sehr gute Einführung in IKEv2
insbesondere mit Cisco Geräten bietet.

Die nächsten drei Kapitel widmen sich der Problemstellung, den Fragen,
die ich mir allgemein bei der Fehlersuche und konkret bei IPsec mit IKEv2
stelle, sowie den Antworten darauf, beziehungsweise woher ich diese
bekomme.

Schließlich gehe ich auf einige typische Probleme ein,
darauf wie ich diese erkenne und schließlich behebe.
Alle diese Probleme sind mir in der Praxis begegnet.

Anhang A führt die verwendeten Abkürzungen und deren Bedeutung auf.

Im Anhang B gehe ich auf einige Datagramm-Header ein,
die mir die Arbeit mit Paketmitschnitten
und generell das Verständnis der ausgetauschten Nachrichten erleichtern.

.. raw:: latex

   \clearpage

Einige Hilfsmittel,
die mir die Arbeit bei der Fehlersuche
und beim Analysieren von Problemen erleichtern,
stelle ich in Anhang C vor.

Schließlich gehe ich in Anhang D auf ausgewählte Software ein,
die als IPsec-VPN-Gateway verwendet werden kann,
und erläutere,
wie ich mit diesen die Erkenntnisse aus dem Buch anwende.
Da sich diese Software im Laufe der Zeit weiterentwickelt
sind diese Ausführungen mit einer Extraprise Salz zu genießen.

