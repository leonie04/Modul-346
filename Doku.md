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

## 1. Plannung
Damit wir unser Projekt Systemmatisch umsetzen können haben wir einen groben Zeitplan erstellt. Wir möchten alle Scripts bis am 13.12.3023 fertig haben, damit wir anschliessend noch genügend Zeit für die DOkumentation und alfällige Fehlerbehebung haben. Anschliessend werden wir unsere Umgebung testen und den Abschluss unserer Dokumentation machen. Wir haben das Script erstellen und das Dokumentieren aufteilt, weil wir denken dass wir so schneller zum gewünschten Endergebnis kommen.

   | Tätigkeit | Person | Zeitrahmen |
   |----------|----------|----------|
   | Plannung | Bischofberger Leonie | 06.12.2023 |
   | Dokumentation erstellen | Davatz Ben | 06.12.2023 |
   | Instancen installieren | Bischofberger Leonie, Riedener Samuel | 06. - 13.12.2023 |
   | WordPress installieren | Bischofberger Leonie, Riedener Samuel | 06. - 13.12.2023 |
   | WordPress konfigurieren | Bischofberger Leonie, Riedener Samuel | 06. - 13.12.2023 |
   | MySQL installieren | Bischofberger Leonie, Riedener Samuel | 06. - 13.12.2023 |
   | MySQL konfigurieren | Bischofberger Leonie, Riedener Samuel | 06. - 13.12.2023 |
   | Tests | Bischofberger Leonie, Riedener Samuel, Davatz Ben | 13. - 17.12.2023 |
   | Dokumentation der Scripts | Davatz Ben | 13. - 17.12.2023 |
   | Dokumentation | Davatz Ben | 13. - 17.12.2023 |
   | Reflexion | Bischofberger Leonie, Riedener Samuel, Davatz Ben | 17. - 19.12.2023 |
   | Abschluss | Bischofberger Leonie, Riedener Samuel, Davatz Ben | 17. - 19.12.2023 |
   
## 2. Voraussetzugen
Das initialWordPress.sh skript muss auf einem Linux Host, mit aws cli installiert, ausgeführrt werden. Die Dateinen initialmysql.txt und initialWordPress.txt müssen im gleichen Ordner wie das initialWordPress.sh sein.

## 3. Umsetzung
Um Wordpress in AWs zu installieren haben wir verschiedene Script erstellt. Diese werden wir in diesem Kapitel erläutern.
### 3.1 Script installWordPress.sh erklärt
Mit dem installWordPress.sh script werden zwei Instancen mit den dazugehörigen Schlüsselpaaren udn Sicherehitgruppen erstellt.

 

 `aws ec2 create-key-pair --key-name aws-wordpress-cli --key-type rsa --query 'KeyMaterial' --output text > ~/.ssh/aws-wordpress-cli.pem`
 
Mit diesem Befehl wird ein Schlüsselpaar namens "AWS-wordpress-cli" erstellt. Das Schlüsselpaar verwendet den Typ "rsa". Der private Schlüssel wird exportiert udn in die Datei: ~/.ssh/aws-wordpress-cli.pem geschrieben.

 `aws ec2 create-security-group --group-name wordpress-sec-group --description "EC2-WordPress-SG"
aws ec2 authorize-security-group-ingress --group-name wordpress-sec-group --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name wordpress-sec-group --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name wordpress-sec-group --protocol tcp --port 22 --cidr 0.0.0.0/0`

Mit diesen Befehlen wird eine Sicherheitgruppe namens "wordpress-sec-group" und der Beschreibung "EC2-WordPress-SG" erstellt. Bei der erstellten Sicherheitsgruppe wird der Zugriff über HTTP (Port 80), HTTPS (Port 443) und SSH (Port 22) von überall (0.0.0.0/0) freigegeben.

 `aws ec2 run-instances --image-id ami-0fc5d935ebf8bc3bc --count 1 --instance-type t2.micro --key-name aws-wordpress-cli --security-groups wordpress-sec-group --iam-instance-profile Name=LabInstanceProfile --user-data file://initialMySQL.txt --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MySQL}]' --no-paginate
aws ec2 run-instances --image-id ami-0fc5d935ebf8bc3bc --count 1 --instance-type t2.micro --key-name aws-wordpress-cli --security-groups wordpress-sec-group --iam-instance-profile Name=LabInstanceProfile --user-data file://initialWordPress.txt --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=WordPress}]' --no-paginate`

Mit diesen Befehlen werden zwei Instancen mit den Namen "MySQL" und "WordPress" gestartet. Den Instanzen werden die zuBeginn erstellte Sicherheitgruppe und Schlüsselpaar mitgegeben. Zusätzlich wir ein Instanzprofil mit dem Namen "LabInstanceProfile" hinzugefügt.

  `chmod 600 ~/.ssh/aws-wordpress-cli.pem`
 
Dieser Befehl so dass nur der Besitzer die Datei lesen und bearbeiten kann.

  `public_ip=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=mysql" --query "Reservations[*].Instances[*].{PublicIP: PublicIpAddress}" --output json | jq -r '.[][].PublicIP')`

Mit deisem Befehl wird die Ip-Adresse der MYSQL -Instanz abegrufen und in der Variable "public_ip" abgespeichert.

  `aws ec2 authorize-security-group-ingress --group-name wordpress-sec-group --protocol tcp --port 22 --cidr $public_ip/32`

Mit diesem Befehl wird die Sicherheitsgruppe wordpress-sec-group aktualisert und der SSH Zugriff über die IP-Adresse der MySQL-Instanz erhlaubt.


### 3.1 Script installWordPress.txt erklärt
Mit dem initialWordPress.txt Script wir auf der Instance WordPress installiert und konfiguriert.


  `sudo apt-get update
sudo apt-get -y install apache2 \
                 ghostscript \
                 libapache2-mod-php \
                 php \
                 php-bcmath \
                 php-curl \
                 php-imagick \
                 php-intl \
                 php-json \
                 php-mbstring \
                 php-mysql \
                 php-xml \
                 php-zip`

Mit diesem Befehl die Instance geupdatet. Anschliessend werden Apache2, Ghostsscript, und PHP installiert.

  `sudo mkdir -p /srv/www
sudo chown www-data: /srv/www`

Das Verzeichnis /srv/www erstellen und dem Webserver Schreibzugriff gewähren.

  `curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www`

Mit diesem Befehl wird die neuste Wordpressversion heruntergeladen. 

  `git clone https://github.com/leonie04/Modul-346
sudo cp Modul-346/Configs/wordpress.conf /etc/apache2/sites-available/`

Nun wird das Git geklont und wordpress.conf in das Verzeichnis des virtuellen Hosts kopieren.

  `sudo a2ensite wordpress
sudo a2enmod rewrite`

Anschliessend wird Wordpress in Apache aktiviert und rewrite für die URL-Umleitung aktiviert.

  `sudo a2dissite 000-default
sudo service apache2 reload`

Mit diesem Befehl wird die Standartseite in Apache deaktivieren und die Konfigurationen neugeladen.

  `sudo cp Modul-346/Configs/wp-config.php /srv/www/wordpress/`

Zum Schluss wird die Wordpress konfigurationsdatei in den Worpress Installationsorder kopiert.


### 3.3 Script initialMySQL.txt erklärt
Mit dem initialWordPress.txt Script wird eine SQL Datenbank erstellt und konfiguriert.

  `sudo apt-get update
sudo apt-get -y install mysql-server` 

Mit diesen Befehlen wird zuerst die Instanz geupdatet und anschliessend den mysql-server zu installieren.
                 
  `git clone https://github.com/leonie04/Modul-346
  sudo mysql -u root < Modul-346/Configs/MySQL_Setup.sql` 

Da Github wird geklont und in das Hauptverzeichnis kopiert. Anschliessen wird die Date MySQL_Setup.sql ausgeführt.

  `sudo service mysql start`

Schlussendlich wird der SQL Server mit dem Namen mysql gestartet.


### 3.3 Configs
Configs werden MYSQL und Wordpress konfiguriert.

#### 3.3 wp-config.php
Dieses Script wird als konfigurationsgrundlage für die Installation von Worpress verwendet. Dieses config wird von Worpress bereitgestellt und man kann darin noch seine eigenen Variablen einfügen.

  `define( 'DB_NAME', 'wordpress' );
define( 'DB_USER', 'wordpress' );
define( 'DB_PASSWORD', 'Vz7,4*,4C3Y7' );
define( 'DB_HOST', '%' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );`

Mit diesen Befehlen werden die folgednen Elemente definiert: Datenbankname, Datenbankuser, Datenbankpasswort, Datenbankhostnamen und Datenbankcharset 

  `mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);`

Mit diesem Befehl wird die Datenbank verbunden. Dazu werden die oben definierten Elemente verwendet.


  `define('AUTH_KEY',         '4^*;gYe@h>iOHX/Q8YwJ[F{h)Wq@!n%76uWqcjjUrH-+udb2B[OrB*8$(>M}78II');`
  `define('SECURE_AUTH_KEY',  '5SI@(M+l]}GU|u3*m1;zWV5Cw3y#g<H3T2s%-ydT_|Xt3!1m {k)D&mLU+ G/FOH');`
  `define('LOGGED_IN_KEY',    'Z%-oXcX2`TDK}xV.DOq]^`41juCRi4tzA}^#+OvllHl4#p|X)/ u-~!K$}O}sVyW');`
  `define('NONCE_KEY',        '^f}0|qU4+%-%`dA2>%^HWMBUeOVWyR>fQ9Om-b0>kin)mHl7SDLIm7em|aaAc9[Z');`
  `define('AUTH_SALT',        'jSewMFUv{5q`|/.+1@upg5GAmt;-.~N0wO$${Yp{/)M%_iH_.LGg>v|Mj2&Ii>EQ');`
  `define('SECURE_AUTH_SALT', '@]1~{mpNVaMm{0p!qA4V8Q!%2RXx:#>J6+u;2psy~4X-:4s;dxrte7j<UUYu.WwL');`
  `define('LOGGED_IN_SALT',   'iyc+jAF5(X95FkYqg{|6>T7%kQ=;3LD>k!1Gv[HE!>)Cdk%|P>w)E/wg=4G+(<d/');`
  `define('NONCE_SALT',       'T4fU0<WU(289+6DpqhQT+!=6oTo<f{K;x tOE`0@z#2[jc1~#-RoN::5-(+w?Cr|');`

Mit diesen Befehlen werden einzigartige Schlüssel für die Authentifizierung definiert.


  `$table_prefix = 'wp_';`

Mit diesem Befehl wird der Wordpress Datenbank ein eindeutiger Tabellenpräfix zugewiesen.


  `define( 'WP_DEBUG', false );`

Mit diesem Befehl kann der WordPress-Debugging-Modus aktiviert werden. Aktuell ist dieser aber deaktiviert.


`if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';`

Mit diesem Befhel werden eingeschlossene Datien von WordPress_Vars eingerichtet.

#### 3.3 wordpress.conf
Mit diesem Script wird WordPress konfiguriert. Dabei wird ein virtueller Host für den WordPress-Webserver konfiguriert.

  `<VirtualHost *:80>
    DocumentRoot /srv/www/wordpress
    <Directory /srv/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /srv/www/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>`

Mit diesesen Befehlen wird zuerst ein Hauptverzeichnis definiert und anschliessend konfiguriert. Bei der Konfiguration das folgen von symbolischen Links aktiviert und das Überschreiben von Konfigurationen in .htacces-Dateien erlaubt. Zusätzlich wird der Standartindex auf index.php gesetzt und der Zugriff auf alle Anfragen erlaubt. Anschliessend wird das Verzeichnis wp-content konfiguriert. Dabei wird das folgen von symbolischen Links erlaubt und der Zugriff auf alle Anfragen erlaubt.

#### 3.3 MySQL_Setup.sql
Mit diesem Script wird die WordPress Datenbank erstellt und eingerichtet. 

 `CREATE DATABASE wordpress;`

 Mit diesem Befehl wird die Wordpress Datenbank mit dem Namen wordpress erstellt.
 
 `CREATE USER 'wordpress'@'%' IDENTIFIED BY 'Vz7,4*,4C3Y7';`

 Mit diesem Befehl wird der Benutzer wordpress erstellt und so konfiguriert, dass er von überall Zugreifen kann.
 
 `GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER
  ON wordpress.*
  TO 'wordpress'@'%';`

Dem eben erstellten Benutzer wordpress werden die Berechtigungen Select, Insert, Update, Delete, Create, Drop und Alter erteilt.
  
 `FLUSH PRIVILEGES;`
 
Mit diesem Befehl werden die Berechtigungen aktualisert und aktiviert.

 
## 3. Tests
Um sicherzustellen das nach derm ausführen der Scripts Wordpress und die SQL-Datenbank korrekt zur verfügung stehen haben wird folgende Test durchgeführt und nach den Mängelklassen bewertet.
Mängelklasse: 0 = mängelfrei; 1 = belangloser Mangel; 2 = leichter Mangel; 3 = schwerer Mangel; 4 = kritischer Mangel

### 3.1 Testfall 1 
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

### 3.2 Testfall 2 
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

### 3.3 Testfall 3 
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
   | Bemerkungen | Die Startseite der Wordpress-Instance konnte im Browser geöffnet werden. Damit wurde steht der Webserver zurverfügung.  |

### 3.4 Testfall 4 
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
   | Bemerkungen | Die SQL-Datenbank ist online. Die Datenbank wurde somit korrekt aufgesetz und kann verwendet werden. |   

### 3.5 Testfall 5 
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

## 4. Reflexion
Im folgenden Kapitel werden wir unser Projekt reflektieren und Verbesserungsvorschläge darlegen.

### 4.1 Bischofberger Leonie
Ich denke wir haben dieses Projekt gut gelöst. Als wir die Aufgabe für dieses Projekt bekammen, wollten wir zuerst das Projekt "Bild verkleinerung" umsetzen. Nach einigen Recherchen mussten wir aber feststellen, dass wir aktuell nicht über einen genug grossen Wissensstand verfügten um diese Projekt umzusetzen. Deshalb haben wir uns schlussendlich für dieses Projekt entschieden. Zu Beginn war ich auch bei diesem Projekt etwas überfordert, doch mti der Hilfe von Samuel Riedener fand ich schnell heraus wie wir dieses Projekt angehen mussten und wo wir uns Informationen beschaffen konnten. Danach hatten wir sehr schnell die erste Version unseres Scripts zur einrichtung des CMS in AWS. Diese Version hat auch sehr gut funktioniert und hat die gewünschten Instancen mit den richtigen konfigurationen erstellt. Leider haben wir uns dann ein bisschen auf unseren Lorbeeren ausgeruht und stellten erst später fest, dass wir unsere SQL-Datenbank auf einer zweiten Instance haben müssen. Daurch kam ich etwas in den Stress, da ich sehr viel Recherche tätigen musste um diese Änderung umzusetzen. Schlussendlich musste ich aber merken, dass diese zusätzliche Änderung grundsätzlich ganz simpel einführbar sit. Dafür dass das Thema AWs für uns alle neu war und wir auch noch nie in einem Projekt GitHub zur Dokumentation verwenden durften, haben wir unsere Projekt sehr gut umgesetz. Als Verbesserungspunkte für ein Weiteres Projekt würde ich neben Github noch ein Kanban System einsetzen, damit die verschiedenen Aufgaben des Projekts klar aufgelistet werden könne. Denn bei diesem Projekt war ich mir nicht immer sicher woran die anderen Teammitglieder arbeiten und somit war es Teils sehr schwer den anderen zu helfen oder den überblick zu behalten welche Aufgabne noch erledigt werden müssen. Mit einem Kanban System wäre diese Problem gelöst und es wäre durch wneige Klicks sichtbar welche Aufgaben noch offen sind und woran die anderen Teammitglieder arbeiten. Ebenfalls würde ich bei einem weiteren Projekt gleich bei Beginn Meetings festlegen an denen alle Teammitglieder teilnehmen und sich austauschen, welche Aufgaben wer übernimmt und wo man noch Hilfe benötigt.

### 4.2 Davatz Ben

### 4.3 Riedener Samuel

## 3. Quellen
### 4.2 Internetquellen
Für unser haben wir zur Recherche hauptächlich die offizielle AWs seite genutz um sicherzustellen dass die gefundenen Varianten auch in unserere Umgebung umsetzbar sind.
   |Quellen | Datum |
   |----------|----------|
   | https://www.geeksforgeeks.org/sed-command-in-linux-unix-with-examples/ | 17.12.2023 |
   | https://ubuntu.com/tutorials/install-and-configure-wordpress#1-overview | 09.12.2023 |
   | https://solvedevops.com.au/docs/wordpress/wordpress-on-aws-getting-started/ | 09.12.2023 |
   | https://dev.to/aws-builders/deploy-wordpress-on-ec2-by-wordpress-ami-2mog | 09.12.2023 |
   | https://docs.aws.amazon.com/de_de/managedservices/latest/appguide/ex-create-wp-stack.html | 09.12.2023 |
   | https://aws.amazon.com/de/solutions/retail/content-management-system/ | 09.12.2023 |

### 4.2 Dokumentquellen
Zusätzlich zu den Internetquellen haben wir auch im Berufsschulunterricht immer wieder DOkumente bekommen mit denen wir 
   |Quellen | Datum |
   |----------|----------|
   | 346-05-AA-Vm-mit-Apache-auf-Cloud.pdf | 17.12.2023 |
   | 06-AA-Cloud-Oekonomie.pdf | 09.12.2023 | 
   | 09-AA-EC2-Instance-CLI.pdf | 09.12.2023 |
   | 346-10-AA-IaC Beispiel.pdf | 09.12.2023 |
   | 09-AA-EC2-Instance-CLI.pdf | 09.12.2023 |




## 3. Formatierungen
   | Spalte 1 | Spalte 2 |
   |----------|----------|
   | Inhalt 1 | Inhalt 2 |
   | Inhalt 3 | Inhalt 4 |
   | grosser Inhalt 1 | grosser Inhalt 2 |


### 1.1 Unterkapitel

  UnterkapitelUnterkapitel Unterkapitel Unterkapitel Unterkapitel Unterkapitel UnterkapitelUnterkapitelUnterkapitelUnterkapitel Unterkapitel \
  UnterkapitelUnterkapitel Unterkapitel  Unterkapitel UnterkapitelUnterkapitel UnterkapitelUnterkapitelUnterkapitelUnterkapitelUnterkapitel


## 3. Reflexion


   ![Bild Baum]([https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.baumpflegeportal.de%2Faktuell%2Fstarke-baumtypen-baum-seidengewand%2F&psig=AOvVaw3BJUOU8hw4QeMupOjJ_ACr&ust=1702492127631000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCICTjcnDioMDFQAAAAAdAAAAABAD])


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

 
 

	
