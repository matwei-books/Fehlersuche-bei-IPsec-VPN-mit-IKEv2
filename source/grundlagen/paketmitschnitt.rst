
Paketmitschnitt
===============

Für mich ist ein Paketmitschnitt (Packet Capture) insbesondere bei
schwierigen Problemen oft die Ultima Ratio bei der Diagnose.
Zwar sind andere Hilfsmittel wie Logs, Debugausgaben oder
Diagnosewerkzeuge des VPN-Gateways oft anschaulicher und schneller zu
kontrollieren.
Aber gerade, wenn ich Zweifel daran habe, ob das was mir angezeigt wird,
auch das ist, was passiert, finde ich in einem Paketmitschnitt oft
Gewissheit in der einen oder anderen Richtung.

Dazu muss ich wissen, wie und wo ich einen Paketmitschnitt anfertige,
wie ich ihn auswerte und vor allem, welche Informationen ich ihm
entnehmen kann.

.. figure:: /images/vpn-packet-capture.png
   :name: vpn-packet-capture

   Packet Capture (PC) am VPN-Gateway

Als VPN-Administrator habe ich üblicherweise nur zwei Stellen, von denen
ich relativ leicht Paketmitschnitte bekommen kann, der entschlüsselten
Seite und der verschlüsselten Seite meines VPN-Gateways.
Wann ich auf welcher Seite den Datenverkehr mitschneide und auswerte
hängt von der Art des Problems ab.

In den meisten Fällen schneide ich den Datenverkehr auf der
entschlüsselten Seite (Inside, links in :numref:`vpn-packet-capture`) nur mit,
wenn ein VPN-Tunnel bereits aufgebaut ist und ich kontrollieren möchte,
ob Daten für alle vereinbarten IPsec-SA übertragen werden. Eine Ausnahme
ist ein VPN, das von meiner Seite zum Peer aufgebaut wird und sich nicht
automatisch aufbaut. In diesem Fall kontrolliere ich auf der
entschlüsselten Seite, ob der Traffic, der den Aufbau des VPNs auslösen
soll, überhaupt am VPN-Gateway ankommt.

An der verschlüsselten Seite (Outside, rechts in
:numref:`vpn-packet-capture`) schneide ich den Datenverkehr mit, wenn es
Probleme beim Aufbau des VPN oder einzelner Tunnel gibt. Da auf dieser
Seite überwiegend verschlüsselte Datagramme übertragen werden, kann ich
meist nicht viel zum Inhalt sagen, insbesondere bei den
IPsec-Datagrammen. Anhand der Payload, der Größe und der zeitlichen
Abfolge der Datagramme kann ich jedoch zumindest für IKEv2 bereits
einige Rückschlüsse ziehen.

Bei Cisco ASA Geräten ist es sogar möglich Pseudo-Paketmitschnitte zu
generieren, die den Inhalt der verschlüsselten IKE-Datagramme zeigen,
obwohl dieser normalerweise in einem Paketmitschnitt nicht zugänglich
ist. In allen anderen Fällen muss ich die Informationen aus dem
Mitschnitt mit Logs und Debuginformationen kombinieren.

