# Modul-346
Setup eines Content Management Systems mit dem aws cli programm.

Das "initialWordPress.sh" Skript muss auf einem Linux Host, mit aws cli installiert, ausgeführrt werden. Die Dateinen "initialmysql.txt" und "initialWordPress.txt" müssen im gleichen Ordner wie das "initialWordPress.sh" sein.

Um unser Content Management System zu installieren muss man einen Linux Host, welcher mit aws cli installiert wurde, starten.
Danach muss man unser Githubverzeichnis in das Hauptverzeichnis klonen und das Script "initialWordPress.sh" ausführen.
Anschliessend wird unser Content Management System installiert. Nach dem das Script erfolgreich durchgelaufen ist erhält man eine IP die zu unserem Wordpress führt.

Folgende Befehle klonen unser Githubverzeichnis und führen das Script "initialWordPress.sh" aus:
git clone https://github.com/leonie04/Modul-346
cd Modul-346/
sh installWordPress.sh
