@REM amazonmq-cli launcher script
@REM
@REM Environment:
@REM JAVA_HOME - location of a JDK home dir (optional if java on path)
@REM CFG_OPTS  - JVM options (optional)
@REM Configuration:
@REM AMAZONMQ_CLI_config.txt found in the AMAZONMQ_CLI_HOME.
@setlocal enabledelayedexpansion

@echo off


if "%AMAZONMQ_CLI_HOME%"=="" (
  set "APP_HOME=%~dp0\\.."

  rem Also set the old env name for backwards compatibility
  set "AMAZONMQ_CLI_HOME=%~dp0\\.."
) else (
  set "APP_HOME=%AMAZONMQ_CLI_HOME%"
)

set "APP_LIB_DIR=%APP_HOME%\lib\"

rem Detect if we were double clicked, although theoretically A user could
rem manually run cmd /c
for %%x in (!cmdcmdline!) do if %%~x==/c set DOUBLECLICKED=1

rem FIRST we load the config file of extra options.
set "CFG_FILE=%APP_HOME%\AMAZONMQ_CLI_config.txt"
set CFG_OPTS=
call :parse_config "%CFG_FILE%" CFG_OPTS

rem We use the value of the JAVACMD environment variable if defined
set _JAVACMD=%JAVACMD%

if "%_JAVACMD%"=="" (
  if not "%JAVA_HOME%"=="" (
    if exist "%JAVA_HOME%\bin\java.exe" set "_JAVACMD=%JAVA_HOME%\bin\java.exe"
  )
)

if "%_JAVACMD%"=="" set _JAVACMD=java

rem Detect if this java is ok to use.
for /F %%j in ('"%_JAVACMD%" -version  2^>^&1') do (
  if %%~j==java set JAVAINSTALLED=1
  if %%~j==openjdk set JAVAINSTALLED=1
)

rem BAT has no logical or, so we do it OLD SCHOOL! Oppan Redmond Style
set JAVAOK=true
if not defined JAVAINSTALLED set JAVAOK=false

if "%JAVAOK%"=="false" (
  echo.
  echo A Java JDK is not installed or can't be found.
  if not "%JAVA_HOME%"=="" (
    echo JAVA_HOME = "%JAVA_HOME%"
  )
  echo.
  echo Please go to
  echo   http://www.oracle.com/technetwork/java/javase/downloads/index.html
  echo and download a valid Java JDK and install before running amazonmq-cli.
  echo.
  echo If you think this message is in error, please check
  echo your environment variables to see if "java.exe" and "javac.exe" are
  echo available via JAVA_HOME or PATH.
  echo.
  if defined DOUBLECLICKED pause
  exit /B 1
)


rem We use the value of the JAVA_OPTS environment variable if defined, rather than the config.
set _JAVA_OPTS=%JAVA_OPTS%
if "!_JAVA_OPTS!"=="" set _JAVA_OPTS=!CFG_OPTS!

rem We keep in _JAVA_PARAMS all -J-prefixed and -D-prefixed arguments
rem "-J" is stripped, "-D" is left as is, and everything is appended to JAVA_OPTS
set _JAVA_PARAMS=
set _APP_ARGS=

set "APP_CLASSPATH=%APP_LIB_DIR%\com.antonwierenga.amazonmq-cli-0.2.2.jar;%APP_LIB_DIR%\org.scala-lang.scala-library-2.11.6.jar;%APP_LIB_DIR%\org.springframework.shell.spring-shell-1.2.0.RELEASE.jar;%APP_LIB_DIR%\com.google.guava.guava-17.0.jar;%APP_LIB_DIR%\jline.jline-2.12.jar;%APP_LIB_DIR%\org.springframework.spring-context-support-4.2.4.RELEASE.jar;%APP_LIB_DIR%\org.springframework.spring-beans-4.2.4.RELEASE.jar;%APP_LIB_DIR%\org.springframework.spring-core-4.2.4.RELEASE.jar;%APP_LIB_DIR%\commons-logging.commons-logging-1.2.jar;%APP_LIB_DIR%\org.springframework.spring-context-4.2.4.RELEASE.jar;%APP_LIB_DIR%\org.springframework.spring-aop-4.2.4.RELEASE.jar;%APP_LIB_DIR%\aopalliance.aopalliance-1.0.jar;%APP_LIB_DIR%\org.springframework.spring-expression-4.2.4.RELEASE.jar;%APP_LIB_DIR%\org.apache.activemq.activemq-all-5.15.9.jar;%APP_LIB_DIR%\com.typesafe.config-1.2.1.jar;%APP_LIB_DIR%\org.scala-lang.jline-2.11.0-M3.jar;%APP_LIB_DIR%\org.fusesource.jansi.jansi-1.4.jar;%APP_LIB_DIR%\org.scala-lang.modules.scala-xml_2.11-1.0.3.jar;%APP_LIB_DIR%\net.sourceforge.htmlunit.htmlunit-2.36.0.jar;%APP_LIB_DIR%\xalan.xalan-2.7.2.jar;%APP_LIB_DIR%\xalan.serializer-2.7.2.jar;%APP_LIB_DIR%\org.apache.commons.commons-lang3-3.9.jar;%APP_LIB_DIR%\org.apache.commons.commons-text-1.7.jar;%APP_LIB_DIR%\org.apache.httpcomponents.httpmime-4.5.9.jar;%APP_LIB_DIR%\org.apache.httpcomponents.httpclient-4.5.9.jar;%APP_LIB_DIR%\org.apache.httpcomponents.httpcore-4.4.11.jar;%APP_LIB_DIR%\commons-codec.commons-codec-1.11.jar;%APP_LIB_DIR%\net.sourceforge.htmlunit.htmlunit-core-js-2.36.0.jar;%APP_LIB_DIR%\net.sourceforge.htmlunit.neko-htmlunit-2.36.0.jar;%APP_LIB_DIR%\xerces.xercesImpl-2.12.0.jar;%APP_LIB_DIR%\xml-apis.xml-apis-1.4.01.jar;%APP_LIB_DIR%\net.sourceforge.htmlunit.htmlunit-cssparser-1.5.0.jar;%APP_LIB_DIR%\commons-io.commons-io-2.6.jar;%APP_LIB_DIR%\commons-net.commons-net-3.6.jar;%APP_LIB_DIR%\org.brotli.dec-0.1.2.jar;%APP_LIB_DIR%\org.eclipse.jetty.websocket.websocket-client-9.4.20.v20190813.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-client-9.4.20.v20190813.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-http-9.4.20.v20190813.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-util-9.4.20.v20190813.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-io-9.4.20.v20190813.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-xml-9.4.20.v20190813.jar;%APP_LIB_DIR%\org.eclipse.jetty.websocket.websocket-common-9.4.20.v20190813.jar;%APP_LIB_DIR%\org.eclipse.jetty.websocket.websocket-api-9.4.20.v20190813.jar;%APP_LIB_DIR%\javax.xml.bind.jaxb-api-2.3.1.jar;%APP_LIB_DIR%\javax.activation.javax.activation-api-1.2.0.jar"
set "APP_MAIN_CLASS=amazonmq.cli.AmazonMQCLI"
set "SCRIPT_CONF_FILE=%APP_HOME%\conf\application.ini"

rem if configuration files exist, prepend their contents to the script arguments so it can be processed by this runner
call :parse_config "%SCRIPT_CONF_FILE%" SCRIPT_CONF_ARGS

call :process_args %SCRIPT_CONF_ARGS% %%*

set _JAVA_OPTS=!_JAVA_OPTS! !_JAVA_PARAMS!

if defined CUSTOM_MAIN_CLASS (
    set MAIN_CLASS=!CUSTOM_MAIN_CLASS!
) else (
    set MAIN_CLASS=!APP_MAIN_CLASS!
)

rem Call the application and pass all arguments unchanged.
"%_JAVACMD%" !_JAVA_OPTS! !AMAZONMQ_CLI_OPTS! -cp "%APP_CLASSPATH%" %MAIN_CLASS% !_APP_ARGS!

@endlocal

exit /B %ERRORLEVEL%


rem Loads a configuration file full of default command line options for this script.
rem First argument is the path to the config file.
rem Second argument is the name of the environment variable to write to.
:parse_config
  set _PARSE_FILE=%~1
  set _PARSE_OUT=
  if exist "%_PARSE_FILE%" (
    FOR /F "tokens=* eol=# usebackq delims=" %%i IN ("%_PARSE_FILE%") DO (
      set _PARSE_OUT=!_PARSE_OUT! %%i
    )
  )
  set %2=!_PARSE_OUT!
exit /B 0


:add_java
  set _JAVA_PARAMS=!_JAVA_PARAMS! %*
exit /B 0


:add_app
  set _APP_ARGS=!_APP_ARGS! %*
exit /B 0


rem Processes incoming arguments and places them in appropriate global variables
:process_args
  :param_loop
  call set _PARAM1=%%1
  set "_TEST_PARAM=%~1"

  if ["!_PARAM1!"]==[""] goto param_afterloop


  rem ignore arguments that do not start with '-'
  if "%_TEST_PARAM:~0,1%"=="-" goto param_java_check
  set _APP_ARGS=!_APP_ARGS! !_PARAM1!
  shift
  goto param_loop

  :param_java_check
  if "!_TEST_PARAM:~0,2!"=="-J" (
    rem strip -J prefix
    set _JAVA_PARAMS=!_JAVA_PARAMS! !_TEST_PARAM:~2!
    shift
    goto param_loop
  )

  if "!_TEST_PARAM:~0,2!"=="-D" (
    rem test if this was double-quoted property "-Dprop=42"
    for /F "delims== tokens=1,*" %%G in ("!_TEST_PARAM!") DO (
      if not ["%%H"] == [""] (
        set _JAVA_PARAMS=!_JAVA_PARAMS! !_PARAM1!
      ) else if [%2] neq [] (
        rem it was a normal property: -Dprop=42 or -Drop="42"
        call set _PARAM1=%%1=%%2
        set _JAVA_PARAMS=!_JAVA_PARAMS! !_PARAM1!
        shift
      )
    )
  ) else (
    if "!_TEST_PARAM!"=="-main" (
      call set CUSTOM_MAIN_CLASS=%%2
      shift
    ) else (
      set _APP_ARGS=!_APP_ARGS! !_PARAM1!
    )
  )
  shift
  goto param_loop
  :param_afterloop

exit /B 0
