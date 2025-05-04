@echo off
setlocal enabledelayedexpansion

set /p NUMBER_SERVERS=Enter the number of judgehost servers to run:

for /f "tokens=4" %%p in ('docker exec domserver cat /opt/domjudge/domserver/etc/restapi.secret') do (
    set JUDGEPASS=%%p
)

:: Configuration des ressources
set CPU_LIMIT=4
set MEMORY_LIMIT=12g

for /L %%i in (1,1,%NUMBER_SERVERS%) do (
    echo Démarrage du Judgehost %%i...
    docker run -d --privileged --name judgehost-%%i ^
        --cpus=%CPU_LIMIT% --memory=%MEMORY_LIMIT% ^
        --link domserver:domserver --hostname judgedaemon-%%i ^
        -e DAEMON_ID=%%i ^
        -e JUDGEDAEMON_PASSWORD=!JUDGEPASS! ^
        -e CONTAINER_NO_CGROUPS=1 domjudge/judgehost:latest
)

echo Tous les judgehosts ont été démarrés avec %CPU_LIMIT% CPU(s) et %MEMORY_LIMIT% de RAM.
pause
