@echo off
echo Installation automatique de DOMjudge sur Windows...
echo.

echo Étape 1/4 : Téléchargement des images Docker...
docker pull mariadb:latest & docker pull domjudge/domserver:latest & docker pull domjudge/judgehost:latest

echo.
echo Étape 2/4 : Démarrage de MariaDB...
docker run -d --name dj-mariadb -e MYSQL_ROOT_PASSWORD=rootpw -e MYSQL_USER=domjudge -e MYSQL_PASSWORD=djpw -e MYSQL_DATABASE=domjudge -p 13306:3306 --memory=2g --cpus="2.0" -v mariadb_data:/var/lib/mysql mariadb --max-connections=1000 --innodb_buffer_pool_size=1G --innodb_log_file_size=256M

echo.
echo Étape 3/4 : Démarrage du DOMserver...
docker run -d --link dj-mariadb:mariadb -e MYSQL_HOST=mariadb -e MYSQL_USER=domjudge -e MYSQL_DATABASE=domjudge -e MYSQL_PASSWORD=djpw -e MYSQL_ROOT_PASSWORD=rootpw -p 12345:80 --name domserver domjudge/domserver:latest


echo.
echo Récupération du mot de passe admin de domjudge...
for /f "delims=" %%a in ('docker exec domserver cat /opt/domjudge/domserver/etc/initial_admin_password.secret') do set ADMINPASS=%%a

echo.
echo Installation terminée avec succès!
echo.
echo ========== INFORMATIONS D'ACCÈS ==========
echo URL: http://localhost:12345
echo Utilisateur: admin
echo Mot de passe: %ADMINPASS%
echo ==========================================
echo.
pause