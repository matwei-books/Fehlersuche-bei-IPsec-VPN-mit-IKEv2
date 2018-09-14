
Vorwort
=======

Bis 2015 waren IPsec-VPN eher ein Problem für mich und bei den wenigen,
die ich eingerichtet hatte, war ich froh, wenn der Administrator der
Gegenstelle genug von der Materie verstand, um mir zu helfen oder
wenigstens nicht noch zusätzliche Probleme zu bereiten. Damals
bevorzugte ich OpenVPN und bei IPsec war IKEv1 das vorherrschende
Protokoll.

Das war damals und 2016 begann ich eine neue Arbeit, bei der ich unter
anderem für einen großen IT-Dienstleister IPsec-Tunnel zu sehr vielen
verschiedenen Gegenstellen - den Peers betreute. Ich bekam
Gelegenheit pro Woche drei, vier und mehr IPsec-VPN einzurichten und
natürlich gehörte die Fehlersuche dazu, wenn es nicht sofort
funktionierte. Am Anfang habe ich sehr von der Hilfe meiner Kollegen
profitiert, die mir Templates zum Einrichten von neuen und zum
Ändern von bestehenden VPN gaben. Sie zeigten mir auch, woran ich
erkennen konnte, ob ein VPN funktionierte oder nicht.

Mit den dabei verwendeten VPN-Gateways - Cisco ASA - war es zu der Zeit
nicht mehr möglich, die geforderten kryptografischen Parameter mit IKEv1
einzustellen, so dass wir - zusätzlich zu den neu eingerichteten VPN -
begannen, bereits bestehende VPN von IKEv1 auf IKEv2 umzustellen. Das
weitete sich zu einem eigenen Projekt aus.

Obwohl IKEv2 erstmalig 2005 in RFC 4306 beschrieben wurde (die zur Zeit
aktuelle Fassung ist RFC 7296 von 2014 :cite:`RFC7296`), gab es in 2016 noch
nicht viele, die sich damit beschäftigt hatten, dafür allerdings noch
etliche VPN-Gateways, die IKEv2 nicht oder nicht in genügendem Maße
beherrschten. Also viele Gelegenheiten zum Lernen.

Aus meinen in dieser Zeit gesammelten Erfahrungen entstand ein Workshop
zum Thema Fehlersuche bei IPsec für die Kollegen und schließlich dieses
Buch.

