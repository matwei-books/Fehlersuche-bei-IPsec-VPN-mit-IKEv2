
Einführung
==========

Dieses Buch ist für Praktiker, die bereits mindestens ein VPN mit IPsec
eingerichtet haben und dabei auf Probleme gestoßen sind, die sie in
Zukunft vielleicht schneller erkennen und lösen wollen.

Ich beschränke mich hier auf die Fehlersuche bei IPsec-VPN mit IKEv2.
Falls jemand vorhat, ein VPN mit IKEv1 einzurichten, so
ist ihm mit diesem Buch nicht gedient.

Das Buch ist keine Einführung in IPsec und auch keine Anleitung zum
Einrichten von VPN. Dementsprechend gehe ich auch nicht auf die Vor- und
Nachteile der einzelnen kryptographischen Parameter ein, dazu habe ich
nicht die nötigen Kenntnisse.

Das Buch beginnt mit einigen Grundlagen, die ich für das Verständnis und
die Diagnose von Netzwerkproblemen voraussetze. Diese können getrost
übersprungen und bei Bedarf nachgelesen werden.

Danach folgt eine kurze Einführung in IKEv2, soweit das für die Diagnose
von Problemen nötig ist. Für detailliertere Erörterungen verweise ich
auf die Literatur, insbesondere :cite:`RFC7296` und
:cite:`Bartlett2016`, dass eine sehr gute Einführung in IKEv2 insbesondere
mit Cisco Geräten bietet.

Die nächsten drei Kapitel widmen sich der Problemstellung, den Fragen,
die ich mir allgemein bei Fehlersuchen und konkret bei IPsec mit IKEv2
stelle, sowie den Antworten darauf, beziehungsweise woher ich diese
bekomme.

Schließlich gehe ich auf einige typische Probleme ein, die mir in der
Praxis begegnet sind, wie ich diese erkenne und schließlich behebe.

Im Anhang sind führe ich einige Datagramm-Header auf, die mir die Arbeit
mit Paketmitschnitten und generell das Verständnis der ausgetauschten
Nachrichten erleichtern.

