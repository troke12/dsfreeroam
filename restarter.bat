@echo off
title SA:MP Server
:start
cls
samp-server.exe
goto restart

:restart
cls
echo Server Restarting...
echo.
samp-server.exe
goto restart
