/*
Zweck:      Einrichten der Word-Press Datenbank
Autor:      Bischofberger Leonie, Riedener Samuel, Davatz Ben
Datum:      09.12.2023
*/

-- Datenbank mit dem Namen Worpress erstellen
-- Benutzer wordpress erstellen
-- Benutzer wordpress Berechtigung Select, Insert, Update, Delete, Create, Drop, Alter
-- Berechtigungen aktualisieren/aktivieren

CREATE DATABASE wordpress;
CREATE USER 'wordpress'@'%' IDENTIFIED BY 'p!&vvvn?GtgJ0cRs!gHd[7w@Z&@GMG>pETwzV$.1jw(Ej*^w2mt=*St0n$Hy]TW;';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER
  ON wordpress.*
  TO 'wordpress'@'%';
FLUSH PRIVILEGES;



