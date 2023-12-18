# <center>M364 Einrichten eines CMS</center>
Davatz Ben, Riedener Samuel, Bischofberger Leonie



## 1. Inhaltsverzeichnis

1. [Tabelle einfügen](#1-tabelle-einfügen) \
   1.1 [Unterkapitel](#11-unterkapitel)

2. [Bild einfügen](#2-bild-einfügen) \
   2.1 [Unterkapitel](#21-unterkapitel)

3. [Formatierungen](#3-formatierungen) \
   3.1 [Unterkapitel](#31-unterkapitel)

4. [Weitere Funktionen](#4-weitere-funktionen) \
   4.1 [Unterkapitel](#41-unterkapitel) 


## 1. Zweck des Skripts und Git Repository
Wir wurden beauftragt ein Script für das automatische einrichten eines CMS in AWS umzusetzen. Für das CMS nutzen wir WordPress und für AWS EC2. Der komplette Prozess der Erstellung wird mit Github dokumentiert und kommenntiert.


## 2. Voraussetzugen
Das initialWordPress.sh skript muss auf einem Linux Host, mit aws cli installiert, ausgeführrt werden. Die Dateinen initialmysql.txt und initialWordPress.txt müssen im gleichen Ordner wie das initialWordPress.sh sein.


## 2. Tests
Um sicherzustellen das nach derm ausführen der Scripts Wordpress und die SQL-Datenbank korrekt zur verfügung stehen haben wird folgende Test durchgeführt und nach den Mängelklassen bewertet.
Mängelklasse: 0 = mängelfrei; 1 = belangloser Mangel; 2 = leichter Mangel; 3 = schwerer Mangel; 4 = kritischer Mangel

### 2.1 Testfall 1 
   |ID / Bezeichnung | T-001 Security-Group prüfen |
   |----------|----------|
   | Beschreibung | Nach dem Durchlaufen der Scripts wird geprüft ob die Security-Group richtig erstellt wurde und die richtigen Konfigurationen besitzt |
   | Testvoraussetzung | Script installWorPress.sh wurde ausgeführt |
   | Testschritte | Auf dem Linux Host wird der folgende Befehl ausgeführt: aws ec2 describe-security-groups \ --group-name word-press-sec-group |
   | Erwartetes Ergebnis | Die Security-Group wordpress-sec-group wird aufgelistet und zeigt die richtige konfiguration. |

Testdurchführung und Testergebnis
   | Testdatum | 16.12.2023 |
   |----------|----------|
   | Tester | Bischofberger Leonie |
   | Mängelklasse | 0 |
   | Mangelbeschrei-bung | Der Test wurde erfolgreich durchgeführt |
   | Bemerkungen | Die Security-Group wordpress-sec-group wurde aufgelistet und zeigt die richtige Konfiguration. Die Security-Groupe sollte nun dafür sor-gen, dass alle Instanzen die richtigen Zugriffe besitzen, aber nur ei-ner geringer Gefahr durch Zugriff von aussen ausgesetzt sind. |

### 2.2 Testfall 2 
   |ID / Bezeichnung | T-002 Schlüsselpaar prüfen |
   |----------|----------|
   | Beschreibung | Nach dem erfolgreichen Durchlaufen der Installationsscripts wird geprüft, ob ein neues Schlüsselpaar erstellt wurde. |
   | Testvoraussetzung | Script installWorPress.sh wurde ausgeführt. |
   | Testschritte | AWS-Konsole starten und zum Bereich Netzwerk & Sicherheit gehen. Dort die Kategorie Schlüsselpaare auswählen. Nun in der Liste prüfen, ob ein Schlüsselpaar namens aws-wordpress-cli existiert. |
   | Erwartetes Ergebnis | Das Schlüsselpaar aws-wordpress-cli wurde erstellt.  |

Testdurchführung und Testergebnis
   | Testdatum | 16.12.2023 |
   |----------|----------|
   | Tester | Bischofberger Leonie |
   | Mängelklasse | 0 |
   | Mangelbeschrei-bung | Der Test wurde erfolgreich durchgeführt. |
   | Bemerkungen | Das Schlüsselpaar aws-wordpress-cli wurde erstellt und wurde den Instancen zugeordnet. |

### 2.3 Testfall 3 
   |ID / Bezeichnung | T-003 Wordpress Installation prüfen |
   |----------|----------|
   | Beschreibung | Es wird geprüft ob Wordpress auf der Instance WordPress korrekt installiert, wurde. |
   | Testvoraussetzung | Die beiden Scripts installWordPress.sh und initialWorPress.txt wur-den ausgeführt. |
   | Testschritte | Öffentliche Adresse des Wordpress-Instance im Browser suchen. |
   | Erwartetes Ergebnis | Es wird die konfigurierte Startseite der Wordpress-Instance gezeigt |

Testdurchführung und Testergebnis
   | Testdatum | 16.12.2023 |
   |----------|----------|
   | Tester | Riedener Samuel |
   | Mängelklasse | 0 |
   | Mangelbeschrei-bung | Der Test wurde erfolgreich durchgeführt. |
   | Bemerkungen | Die Startseite der Wordpress-Instance konnte im Browser geöffnet werden.  |

### 2.4 Testfall 4 
   |ID / Bezeichnung | T-004 Prüfen, ob SQL-Datenbank online ist |
   |----------|----------|
   | Beschreibung | Nach der Installation und Konfiguration der SQL-Datenbank wird geprüft, ob diese online ist. |
   | Testvoraussetzung | Die beiden Scripts installWordPress.sh und initialMySQL.txt wurden ausgeführt. |
   | Testschritte | Die MySQL Instance starten und folgenden Befehl ausführen: systemctl status mysql |
   | Erwartetes Ergebnis | Die SQL-Datenbank ist online. |

Testdurchführung und Testergebnis
   | Testdatum | 16.12.2023 |
   |----------|----------|
   | Tester | Riedener Samuel |
   | Mängelklasse | 1 |
   | Mangelbeschrei-bung | Die SQL-Datenbank war offline. Nach dem Starten der Datenbank war sie bei einem zweiten Testversuch online. |
   | Bemerkungen | Die SQL-Datenbank ist online.  |   

### 2.5 Testfall 5 
   |ID / Bezeichnung | T-005 SQL User Berechtigung prüfen |
   |----------|----------|
   | Beschreibung | Es wird geprüft ob der SQL User wordpress über die gewünschten Berechtigungen verfügt. |
   | Testvoraussetzung | Die beiden Scripts installWordPress.sh und initialMySQL.txt wurden ausgeführt. |
   | Testschritte | Die MySQL Instance starten und folgenden Befehl ausführen: USE your_database_name; Shwo Grants FOR 'wordpress'@'%' |
   | Erwartetes Ergebnis | Der User Wordpress besitzt die Berechtigung SELECT, INSERT, UP-DATE, DELETE, CREATE, DROP und ALTER |

Testdurchführung und Testergebnis
   | Testdatum | 16.12.2023 |
   |----------|----------|
   | Tester | Davatz Ben |
   | Mängelklasse | 0 |
   | Mangelbeschrei-bung | Die SQL-Datenbank war offline. Nach dem Starten der Datenbank war sie bei einem zweiten Testversuch online. |
   | Bemerkungen | Der User Wordpress besitzt die Berechtigung SELECT, INSERT, UP-DATE, DELETE, CREATE, DROP und ALTER  |  

   | Spalte 1 | Spalte 2 |
   |----------|----------|
   | Inhalt 1 | Inhalt 2 |
   | Inhalt 3 | Inhalt 4 |
   | grosser Inhalt 1 | grosser Inhalt 2 |

### 1.1 Unterkapitel

  UnterkapitelUnterkapitel Unterkapitel Unterkapitel Unterkapitel Unterkapitel UnterkapitelUnterkapitelUnterkapitelUnterkapitel Unterkapitel \
  UnterkapitelUnterkapitel Unterkapitel  Unterkapitel UnterkapitelUnterkapitel UnterkapitelUnterkapitelUnterkapitelUnterkapitelUnterkapitel


## 2. Bild einfügen

   ![Bild Baum]([https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.baumpflegeportal.de%2Faktuell%2Fstarke-baumtypen-baum-seidengewand%2F&psig=AOvVaw3BJUOU8hw4QeMupOjJ_ACr&ust=1702492127631000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCICTjcnDioMDFQAAAAAdAAAAABAD])

## 3. Formatierungen

 **Fettschrift** \
 *Kursivschrift*
  
- Aufzählung 1
- Aufzählung 2

1. Schritt 1
2. Schritt 2
    
# Überschriftsebene 1 
## Überschriftsebene 2
### Überschriftsebene 3

> Blockzitate müssen mit einer Leerzeile beginnen und enden

> Jede Zeile des Zitats beginnt mit einer rechten spitzen Klammer und einem Leerzeichen

 `Inlinecode`

 ## 4. Weitere Funktionen

 ### 4.1 Unterkapitel

 > Weitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere FunktionenWeitere Funktionen

 
 

	
