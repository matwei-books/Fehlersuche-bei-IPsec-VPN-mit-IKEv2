
Grundlagen
==========

Es gibt verschiedene Punkte, die eine erfolgreiche und effiziente
Fehlersuche in einem komplexen Thema ausmachen.
Drei davon sind:

* das Beherrschen der Grundlagen,
* die Kenntnis der Materie und
* eine strukturierte Vorgehensweise.

Die ersten beiden benötige ich, um überhaupt zu einem Ergebnis zu kommen.
Der dritte Punkt hilft mir den Fehler schneller zu finden, indem ich
unnötige Schritte auslasse und die erfolgversprechenden Wege zuerst
gehe.

Erkenne ich ein Problem oder bekomme eines gemeldet, dann arbeite
ich bis zu seiner Lösung in der folgenden Schleife:

.. figure:: /images/bbaet-bw.png
   :alt: Ablauf der Fehlersuche

.. raw:: latex

   \clearpage

* Beim **Beobachten** konzentriere ich mich auf zwei Aspekte:
  zum einen was und zum anderen wie ich beobachte.

  * Was beobachte ich?

    Das Kapitel :ref:`vorgehen/fragen:Fragen` geht darauf ein,
    worauf ich wann bei der Fehlersuche achte.

  * Wie beobachte ich?

    Eine einfache Statusabfrage an die VPN-Software
    kann Fragen zum Zustand des Systems beantworten.
    Diese ist von der verwendeten Software abhängig.
    Im Abschnitt :ref:`software/index:IPsec-Software` im Anhang
    kann ich nur auf eine kleine Auswahl eingehen.

    Beim Auswerten von Systemlogs oder Debugausgaben,
    habe ich es oft mit sehr viel Text zu tun.
    Der Abschnitt :ref:`grundlagen/textdateien:Arbeit mit Textdateien`
    in diesem Kapitel
    geht näher auf effizientes Arbeiten damit ein.

    In vielen Fällen bin ich auf Paketmitschnitte angewiesen,
    um mich zu vergewissern,
    was passiert.
    Der Abschnitt :ref:`grundlagen/paketmitschnitt:Paketmitschnitt`
    in diesem Kapitel
    geht darauf näher ein.

* Beim **Beurteilen** des Beobachteten
  helfen Erfahrung und Grundlagenwissen.

  * Im Kapitel :ref:`fehler/index:Typische Probleme` habe ich
    Erfahrungen mit tatsächlich aufgetretenen Problemen zusammengetragen
    und nach der Ursache, dem Fehlerbild und der Behebung geordnet.

  * Im Abschnitt :ref:`grundlagen/theoretisch:OSI Modell` ist
    eines der grundlegenden Modelle in der Netzwerkwelt erläutert.

    Die wichtigsten Grundlagen zu IPsec und IKEv2 für die Fehlersuche
    sind im Kapitel :ref:`ikev2/index:IPsec und IKEv2` dargelegt

    Auf das Auswerten der Paketmitschnitte geht der Abschnitt
    :ref:`grundlagen/paketmitschnitt:Paketmitschnitt`
    in diesem Kapitel ein.
    Der Abschnitt :ref:`anhang/datagram-header:Datagramm-Header` im Anhang
    kann bei der Interpretation der IKE-Datagramme helfen.

.. index:: GNS3

* Beim **Ändern** der Systemumgebung kommt es darauf an,
  möglichst keine weiteren Beeinträchtigungen
  in produktiven Umgebungen zu verursachen.

  Eventuell ist es möglich, das Problem in einem Testlabor nachzustellen.
  Dieses Testlabor kann aus überzähligen Hardware-Komponenten bestehen
  oder aus einer Simulationsumgebung wie GNS3.
  Abschnitt :ref:`anhang/hilfsmittel:Testlab` im Anhang
  geht auf die Arbeit mit einem Testlabor ein.
  Kann das Problem nicht im Testlabor nachgestellt werden,
  kann ich vielleicht temporär
  auf ein VPN-Gateway an einer anderen Adresse ausweichen,
  um die produktiven Netze nicht zu stören.

* Das Hauptproblem beim **Testen**
  ist das Erzeugen geeigneten Traffics,
  der das Problem zum Vorschein bringt.
  In größeren Umgebungen mit geteilter Verantwortung für die Bereiche
  kann die Koordinierung ein Problem für sich darstellen.

  Ein Ausweg daraus kann eine Sonde zum Injizieren von Test-Traffic sein,
  wie im Abschnitt
  :ref:`anhang/hilfsmittel:Sonde zum Injizieren von Traffic` im Anhang
  beschrieben.

.. toctree::
   :maxdepth: 2
   :caption: Inhalt:

   theoretisch
   textdateien
   paketmitschnitt

