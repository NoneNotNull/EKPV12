@ECHO OFF
echo .
echo .
echo                         EKP 的 WAS 7 补丁
echo ===================================================================
echo 在执行程序前，请仔细阅读系统安装维护手册中WebSphere环境的配置内容。
echo 本程序仅负责处理和WAS 7相关的jar文件，其它步骤还需按照文档要求来做。
echo .
echo 确定要执行本程序？
echo .

SET Choice=
SET /P Choice=选择 Y:执行  N:不执行
IF /I "%Choice%"=="N" GOTO :END
IF /I "%Choice%"=="n" GOTO :END

:PATCH

set EKPLIB=..\..\..\lib
set WEBINF=%EKPLIB%\..

rem echo WEBINF : %WEBINF%
rem echo EKPLIB : %EKPLIB%

del /Q %EKPLIB%\geronimo-stax-api_1.0_spec-1.0.jar
copy /Y jsr173-api-1.0.jar   %EKPLIB%
copy /Y *.sign %EKPLIB%

ENDLOCAL

echo .
echo .
echo 程序运行完毕。请务必根据文档完成WAS 7环境的其它配置内容

:END

pause

