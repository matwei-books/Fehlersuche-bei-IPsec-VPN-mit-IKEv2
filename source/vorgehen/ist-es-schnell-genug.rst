
Ist es schnell genug?
=====================

Die Frage nach der Geschwindigkeit ist nicht leicht zu beantworten. Im
Idealfall habe ich eine Baseline und damit ein einigermaßen objektives
Kriterium für die Geschwindigkeit des VPN.

Zwei Faktoren beeinflussen die Geschwindigkeit in einem Netz und damit
auch im VPN wesentlich:

-  der Durchsatz beziehungsweise die maximale Datenmenge pro
   Zeiteinheit, die durch das Netz gehen - diesen will ich möglichst
   groß - und
-  die Latenz beziehungsweise die Zeit zum Übertragen eines einzelnen
   Datagramms - diese will ich möglichst klein haben.

Beide Faktoren beeinflussen sich gegenseitig und sind im laufenden
Betrieb nicht einfach zu messen. Manchmal ist es möglich, über die
Laufzeit - ein Maß für die Latenz - auf den maximalen Durchsatz zu
schließen.

Da dabei aber fremdbestimmte Netzkomponenten beteiligt sind, muss ich
diese Erkenntnisse immer mit Vorsicht verwenden. Das beste, was ich in
den meisten Fällen tun kann, ist Durchsatz und Latenz an meinem Gateway
optimal einzustellen und versuchen ungefähr zu ermitteln, an welcher
Stelle im Netz die Verbindung verlangsamt wird. Finde ich als Ursache
das VPN-Gateway, muss ich über leistungsfähigere Hardware nachdenken.

-  Wie sieht die Round-Trip-Zeit der entschlüsselten Daten aus?

Das ist eine der Fragen zur Geschwindigkeit eines VPN, die sich relativ
einfach beantworten lässt. Allerdings geht in die Round-Trip-Zeit neben
der Zeit für die Ver- und Entschlüsselung noch die Zeit für die
Übertragung im Netz und die Antwortzeit der Gegenstelle ein, so dass bei
einer zu langen Round-Trip-Zeit die Ursache nicht auf Anhieb genau
benannt werden kann. Durch Vergleichsmessungen der Paketlaufzeit
zwischen den beiden VPN-Gateways lassen sich zumindest Teile der
Störgrößen herausrechnen. Durch genaues Betrachten der Zeitstempel der
Datagramme lässt sich vielleicht ermitteln, ob das Problem eher auf der
verschlüsselten oder auf der entschlüsselten Seite liegt.

-  Wie groß ist die Verzögerung durch Ver- und Entschlüsselung?

Leider lässt sich diese Frage nur beantworten, wenn das VPN selbst nur
wenig benutzt wird, da ich hier die verschlüsselten Datagramme auf der
Außenseite den unverschlüsselten auf der Innenseite zuordnen muss. Dann
kann die Zeit, die für die Verschlüsselung benötigt wird, einen Hinweis
geben, ob vielleicht ein leistungsfähigeres VPN-Gateway oder Maßnahmen
zu dessen Entlastung angebracht sind.

-  Wie groß ist der Durchsatz des VPN-Gateways?

Hierzu kann ich den gesamten verschlüsselten Datenverkehr pro
Zeiteinheit betrachten und vergleichen, ob ich mich einem - vorher
ermittelten - Maximalwert nähere.

