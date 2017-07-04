@ECHO OFF
echo .
echo .
echo                  这是ekp的weblogic 10.3.x的补丁。
echo ===================================================================
echo   在执行程序前，请仔细阅读readme.doc文档。
echo   本程序仅负责处理和weblogic相关的jar文件，其它步骤还需按照文档要求来做
echo .
echo   确定阅读完文档,并执行？
echo .

SET Choice=
SET /P Choice=选择 Y:执行  N:不执行
IF /I "%Choice%"=="N" GOTO :END
IF /I "%Choice%"=="n" GOTO :END

:PATCH

set EKPLIB=..\..\..\lib
set WEBINF=%EKPLIB%\..
set RESTORE=..\restore

rem echo WEBINF : %WEBINF%
rem echo EKPLIB : %EKPLIB%
rem echo RESTORE: %RESTORE%

del /Q %EKPLIB%\xercesImpl.jar
del /Q %EKPLIB%\geronimo-stax-api_1.0_spec-1.0.jar
del /Q %EKPLIB%\geronimo-ws-metadata_2.0_spec-1.1.3.jar
del /Q %EKPLIB%\saaj-api-1.3.jar
del /Q %EKPLIB%\saaj-impl-1.3.2.jar
del /Q %EKPLIB%\xercesImpl-2.9.1.jar


del /Q %WEBINF%\weblogic.xml
copy /Y weblogic.xml 	%WEBINF%
copy /Y *.sign	%WEBINF%

ENDLOCAL

echo 请务必根据文档继续完成剩下的操作：
echo ** 设置weblogic的classpath
echo ** 删除weblogic下的指定jar文件

:END

pause

