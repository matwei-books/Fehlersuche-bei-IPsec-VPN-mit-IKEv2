
Überblick
=========

IPsec bietet Schutz vor Ausspähung und Veränderung für IP-Traffic.
Die grundlegende Architektur für IPsec-konforme Systeme ist in RFC4301
beschrieben (siehe :cite:`RFC4301`).
Eine Implementation kann in einem Host arbeiten, als Security
Gateway oder als unabhängiges Gerät.

Insgesamt setzt sich IPsec aus drei Protokollen zusammen
(siehe :numref:`ipsec-overview`):

.. index:: ! Internet Security Association and Key Management Protocol
   see: ISAKMP; Internet Security Association and Key Management Protocol

.. index:: ! Internet Key Exchange Protocol
   see: IKE; Internet Key Exchange Protocol

* *Internet Security Association and Key Management Protocol* (ISAKMP),
  ursprünglich beschrieben in RFC2408, das durch RFC4306 obsolet wurde,
  welches wiederum durch RFC5996 abgelöst wurde und dieses durch
  RFC7296.
  ISAKMP verwies bereits in RFC2408
  auf IKE (Internet Key Exchange Protocol)
  für den Schlüsselaustausch,
  RFC7296 beschreibt IKEv2 (siehe :cite:`RFC7296`).
  In :cite:`ct-2007-20-210` findet sich
  ein gut verständlicher Überblick über IKEv2 in deutscher Sprache.
  
  Die Aufgabe von ISAKMP ist das Aushandeln der kryptographischen Verfahren und
  Schlüssel für die Security Associations (SA).

.. index:: Authentication Header
   see: AH; Authentication Header

* *Authentication Header* (AH), beschrieben in RFC4302 (siehe
  :cite:`RFC4302`) ist ein Protokoll, dass zwar die Integrität der
  übertragenen Daten schützt, aber nicht deren Vertraulichkeit.
  Ich persönlich habe das Protokoll noch nie in der Praxis vorgefunden.

.. index:: ! Encapsulating Security Protocol
   see: ESP; Encapsulating Security Protocol

* *Encapsulating Security Protocol* (ESP), beschrieben in RFC4303
  (siehe :cite:`RFC4303`) schützt sowohl die Vertraulichkeit als auch
  die Integrität der übertragenen Daten.
  Es kann damit die Funktionalität von AH übernehmen,
  was erklärt,
  dass letzteres so selten anzutreffen ist.

.. figure:: /images/ipsec-overview.png
   :alt: Übersichtsbild für IPsec
   :name: ipsec-overview

   Komponenten von IPsec

.. index:: ! Child-SA
   see: IPsec-SA; Child-SA

Alle drei Protokolle nutzen Security Associations (SA),
um die verwendeten kryptographischen Verfahren, Parameter und Schlüssel
in einer Security Association Database (SAD) abzulegen.
Dabei gibt es sowohl SA für die IKE-Sitzungen,
in der die Parameter ausgehandelt werden,
als auch für die durch IPsec geschützten Daten.
Die letzteren nennt man Child-SA oder auch IPsec-SA.

Die konkreten kryptographischen Algorithmen mit den eventuell nötigen
Parametern werden in einer SA durch Transforms festgehalten.
Für IKEv2 beschreibt :cite:`RFC4307` die kryptographischen Algorithmen,
während :cite:`RFC4305` die Anforderungen an die Implementation von
kryptografischen Algorithmen für ESP und AH beschreibt.

.. index:: Security Policy Database
   see: SPD; Security Policy Database

.. index:: Security Association Database
   see: SAD; Security Association Database

Der Schutz, den IPsec bietet, hängt von den Anforderungen ab,
die in der Security Policy Database (SPD) und der SAD festgelegt sind.
Dabei bestimmt die SPD, welcher Traffic geschützt wird und die SAD, wie
dieser Traffic geschützt werden soll.
Im Gegensatz zur SPD ändert sich die SAD sehr häufig:
mit jeder neuen SA, die ausgehandelt wurde,
und jeder alten SA, die gelöscht wurde.
Die SPD enthält die Policies,
die die erlaubten Parameter für die SA begrenzen
und nur selten durch den Administrator geändert werden.

.. index:: Peer Authorization Database
   see: PAD; Peer Authorization Database

Eine dritte Datenbank, die Peer Authorization Database (PAD)
stellt die Verbindung zwischen der SPD und ISAKMP her.
Sie verknüpft die durch ISAKMP,
beziehungsweise seiner konkreten Ausprägung IKE,
authentifizierten Identitäten mit den erlaubten Policies.

IPsec kann den Traffic zwischen einem Paar von Hosts (a),
zwischen zwei Security-Gateways (b) oder zwischen einem Host und einem
Security-Gateway (c) schützen. Ein konformer Host muss (a) und (b)
unterstützen, ein konformes Security-Gateway muss alle drei Formen
unterstützen.

.. figure:: /images/ipsec-boundary.png
   :alt: Toplevel-Prozessmodell für IPsec
   :name: ipsec-boundary

   Toplevel-Prozessmodell für IPsec

IPsec definiert eine Grenze
zwischen ungeschützten und geschützten Schnittstellen.
Datagramme, die diese Grenze überqueren, sind den Regeln der SPD
unterworfen.
Allgemein werden die Datagramme bei IPsec
entweder durch Verschlüsselung geschützt (PROTECT),
verworfen (DISCARD)
oder sie dürfen den IPsec-Schutz umgehen (BYPASS).

.. index:: ! Inside, ! Outside

In :numref:`ipsec-boundary` verweist *Unprotected* auf eine
Schnittstelle, die gemeinhin mit der Farbe schwarz und verschlüsselten
Daten assoziiert wird.
*Protected* verweist dementsprechend auf die Farbe rot und Klartext.
Eine IPsec-Implementation kann mehrere Schnittstellen auf jeder Seite
der Grenze unterstützen.
In diesem Buch meint *Inside* die rote Seite und *Outside* die schwarze.

RFC4301 erläutert die Aufgaben der SPD ausführlich,
ohne auf die konkrete Form der Datenbank
oder ihre Schnittstelle einzugehen.
Der Text spezifiziert nur die minimale Funktionalität,
die eine IPsec-Implementation benötigt,
um den Datenverkehr an einem Gateway oder Host zu steuern.
Eine Implementation muss mindestens eine und kann mehrere SPD haben,
die für sämtlichen Traffic,
welcher die IPsec-Boundary überquert,
konsultiert werden.

Die SPD ist eine sortierte Datenbank,
so wie Access Control Lists oder Paketfilter,
deren Reihenfolge eine Policy explizit vorgibt.
Die Sortierung ist notwendig,
weil sich die Selektoren der Datensätze überlappen können
und in diesem Fall die Reihenfolge in der Policy bestimmt,
welcher Datensatz zur Anwendung kommt.

Logisch ist die SPD in drei Teile unterteilt:

*   die **SPD-S** enthält Informationen für
    den durch IPsec geschützten Datenverkehr.

*   die **SPD-O** entscheidet ob abgehender Datenverkehr
    verworfen oder unverändert durchgelassen werden soll.

*   die **SPD-I** ist für ankommenden Datenverkehr zuständig.

Wenn eine IPsec-Implementation nur eine SPD enthält,
besteht diese aus allen drei Teilen.
Falls mehrere SPD unterstützt werden,
können einige von diesen auch nur einzelne Teile enthalten,
zum Beispiel um ankommenden Traffic
pro Interface effizienter zu klassifizieren.

Für abgehende Datagramme werden immer SPD-O und SPD-S befragt,
für ankommende Datagramme SPD-I und SPD-S.

Abgehender Datenverkehr
-----------------------

Kommt ein Datagramm,
das auf der schwarzen Seite hinausgehen soll,
auf der roten Seite an,
muss die SPD entscheiden,
ob dieser Traffic
ignoriert,
an IPsec vorbei geleitet
oder mit IPsec geschützt werden soll.

Im ersten Fall sehe ich nichts auf der schwarzen Seite,
im zweiten Fall sehe ich dort das unveränderte Datagramm.
Beim dritten Fall sehe ich
AH- beziehungsweise ESP-Traffic auf der schwarzen Seite,
wenn bereits eine passende Security Association (SA) aktiv ist.
Oder ich sehe IKE-Traffic,
mit dem eine passende SA ausgehandelt wird.
Dabei wird wiederum die SPD konsultiert,
um die möglichen Parameter zu bestimmen.

Ankommender Datenverkehr
------------------------

Kommt auf der schwarzen Seite Traffic an,
wird dieser entsprechend folgender Kategorien verarbeitet:

1.  IKE-Traffic
2.  AH- beziehungsweise ESP-Traffic
3.  ICMP-Fehlermeldungen
4.  sonstiger Traffic

Bei IKE-Traffic reagiert das IKE-Subsystem
auf die ankommenden Nachrichten.
Dieses kann neue SA anlegen,
alte SA löschen
oder einfach nur den Zustand der Tunnel überwachen.

Beim AH- beziehungsweise ESP-Traffic wird die entsprechende SA konsultiert,
die am mitgesendeten SPI erkennbar ist.
Der Traffic wird entschlüsselt und durchgeleitet
oder verworfen, wenn Fehler auftreten.

Kann bei ICMP-Fehlermeldungen eine passende SA ermittelt werden,
führt das unter Umständen zur Anpassung der Parameter dieser SA.
Ein Anwendungsfall dafür ist
die Unterstützung der Path-MTU-Discovery für den geschützten Traffic.

Bei allem anderen Traffic
wird die SPD-I konsultiert,
ob der Traffic unverändert durchgelassen
oder verworfen werden soll.

Wie sieht ein SPD-Datensatz aus?
--------------------------------

Jeder SPD-Datensatz spezifiziert die Bestimmung von Datagrammen
entweder als BYPASS, DISCARD oder PROTECT.
Der Schlüssel für den Datensatz besteht aus einem oder mehreren Selektoren.

Bei Traffic,
über den mittels eines SPD-I- oder SPD-O-Datensatzes entschieden wird,
ist genau eine Richtung vorgegeben.
Bei Traffic, der durch IPsec geschützt wird,
muss jedoch die Richtung beachtet werden.
Üblicherweise benötigen die durch IPsec geschützten Protokolle
symmetrische SA für ankommenden und abgehenden Verkehr.
Hier werden nötigenfalls
die lokalen und fernen Adressen des SPD-Eintrags vertauscht.

.. raw:: latex

   \newpage

Dementsprechend enthält der SPD-Datensatz die folgenden Informationen

- einen Selektor, der erlaubt, ein Datagramm dem Eintrag zuzuordnen
- die Entscheidung über das Datagramm: BYPASS, DISCARD oder PROTECT
- bei PROTECT-Einträgen (SPD-S)
  
  * *PFP Flags* - einen pro Traffic-Selektor
  * Parameter die für den Schutz des Datagramms notwendig sind,
    wie Algorithmen, Modi, DH-Gruppen, ...

PFP-Flags (Populate From Packet) legen fest,
ob beim Aushandeln einer SA der Wert
aus der SPD übernommen
oder vom auslösenden Datagramm abgeleitet wird.
Im zweiten Fall ist es möglich,
gleichzeitig verschiedene SA aus dem gleichen SPD-Datensatz zu erzeugen,
bei denen sich die Werte unterscheiden,
für die das PFP-Flag in der SPD gesetzt ist.

Woran unterscheidet die SPD den Traffic?
----------------------------------------

Prinzipiell unterscheidet die SPD den Traffic anhand von Selektoren,
die entweder Eigenschaften der Datagramme beschreiben
oder mit dem IKE-Protokoll ausgehandelt werden.

Mögliche Werte für Selektoren
sind neben den feldspezifischen wie Adressen oder Ports
die Werte OPAQUE,
der anzeigt, dass der Wert im Datagramm nicht verfügbar ist,
und ANY,
der auf jeden Wert passt, auch wenn der Wert nicht verfügbar ist.
Damit umfasst ANY auch OPAQUE und letzteres ist nur notwendig,
wenn es darauf ankommt diesen speziellen Fall zu unterscheiden,
zum Beispiel für Fragmente von Datagrammen.

Folgende Selektoren
müssen von allen IPsec-Implementationen unterstützt werden:

* Eigene IP-Adressen (Local IP Addresses)
* IP-Adressen der Gegenseite (Remote IP Addresses)
* das Protokoll der nächsten Ebene (Next Layer Protocol)
* vom Protokoll abhängige Selektoren
* ein Name

Local IP Addresses /  Remote IP Addresses
.........................................

Hierbei handelt es sich jeweils
um eine Liste von Adressbereichen (IPv4 oder IPv6).
Die Struktur erlaubt die Angabe von

* einzelnen Adressen
* einer Liste von Adressen
* einem Adressbereich mit Anfangs- und Endadresse
* einer Liste von Adressbereichen

Die SPD bietet keinen Support für Multicast-Adressen.
Wenn Multicast über IPsec gesendet werden soll,
muss man eine Group SPD, wie in RFC3740 definiert, verwenden.

Next Layer Protocol
...................

Dieser Selektor entspricht dem Feld *Protocol* bei IPv4
beziehungsweise dem Feld *Next Header* bei IPv6.
Das kann eine einzelne Protokollnummer sein, *ANY* oder *OPAQUE*.

Verschiedene zusätzliche Selektoren hängen
von den Werten bei *Next Layer Protocol* ab:

*   Wenn das Next Layer Protocol zwei Ports verwendet
    (wie TCP, UDP und andere),
    gibt es Selektoren für *Local Ports* und *Remote Ports*.

*   Ist das Next Layer Protocol ein Mobility Header,
    dann gibt es einen Selektor
    für den *IPv6 Mobility Header Message Type*.

*   Wenn das Next Layer Protocol ICMP ist,
    gibt es einen Selektor
    für ICMP-Message-Type und -Code.

Name
....

Dieser Selektor unterscheidet sich von den anderen darin,
dass er nicht von einem Datagramm abgeleitet wird.
Ein Name kann als Identifikator
für eine lokale oder entfernte Adresse bei IPsec
verwendet werden.

Benannte SPD-Einträge werden auf zwei Arten verwendet:

1. Ein SPD-Eintrag mit Name wird beim Responder (nicht dem Initiator)
   zur Unterstützung der Zugangskontrolle verwendet,
   wenn eine Adresse für den Selektor
   nicht geeignet wäre,
   zum Beispiel bei einem "Road Warrior".
   In diesem Fall überschreibt
   der Wert der Remote IP Address in der SPD
   den Wert der Adresse im ESP-Tunnel.

2. Ein SPD-Eintrag mit Name wird vom Initiator
   einer IKE-Sitzung verwendet,
   um den Benutzer zu identifizieren,
   für den eine IPsec-SA angelegt werden soll.
   Diese Verwendung ist optional für IPsec auf einem Host
   in einer Multiuser-Umgebung.
   Der Name wird nur lokal verwendet und nicht über
   das Netz zum Peer kommuniziert.
   
Details hierzu finden sich auf Seite 28-29 von RFC4301.

