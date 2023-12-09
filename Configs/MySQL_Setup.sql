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
CREATE USER wordpress@localhost IDENTIFIED BY 'Pa55wort';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER
  ON wordpress.*
  TO wordpress@localhost;
FLUSH PRIVILEGES;
