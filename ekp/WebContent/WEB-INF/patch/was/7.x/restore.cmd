@ECHO OFF
echo .
echo .
echo                  EKP 的 WAS 7 补丁还原程序
echo ===================================================================
echo   在执行程序前，请仔细阅读系统安装维护手册中WebSphere环境的配置内容。
echo   该程序会取消WAS 7.x patch.cmd补丁程序所作的修改。
echo .
echo   确定要执行本程序？

SET Choice=
SET /P Choice=选择 Y:执行  N:不执行
IF /I "%Choice%"=="N" GOTO :END
IF /I "%Choice%"=="n" GOTO :END

:RESTORE

SETLOCAL

set EKPLIB=..\..\..\lib
set WEBINF=%EKPLIB%\..
set RESTORE=restore

rem echo WEBINF : %WEBINF%
rem echo EKPLIB : %EKPLIB%
rem echo RESTORE: %RESTORE%

del /Q %EKPLIB%\jsr173-api-1.0.jar
copy /Y %RESTORE%\*.jar  %EKPLIB%
copy /Y %RESTORE%\*.sign %EKPLIB%

ENDLOCAL

echo .
echo .
echo 程序运行完毕。如果你还做了其它修改，请自行手动还原。

:END

pause

