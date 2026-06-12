@echo off
:: Maven Wrapper script for Windows
setlocal

set MAVEN_WRAPPER_PROPERTIES=.mvn\wrapper\maven-wrapper.properties

:: Read distributionUrl
for /f "tokens=2 delims==" %%i in ('findstr "distributionUrl" %MAVEN_WRAPPER_PROPERTIES%') do set DISTRIBUTION_URL=%%i

:: Determine user home and maven wrapper dir
set MAVEN_WRAPPER_DIR=%USERPROFILE%\.m2\wrapper

:: Extract distribution name from URL
for %%f in (%DISTRIBUTION_URL:\= %) do set MAVEN_DIST=%%~nf
set MAVEN_HOME=%MAVEN_WRAPPER_DIR%\dists\%MAVEN_DIST%

if not exist "%MAVEN_HOME%" (
    mkdir "%MAVEN_HOME%"
    echo Downloading Maven %MAVEN_DIST%...
    powershell -Command "Invoke-WebRequest -Uri '%DISTRIBUTION_URL%' -OutFile '%MAVEN_HOME%\dist.zip'"
    powershell -Command "Expand-Archive -Path '%MAVEN_HOME%\dist.zip' -DestinationPath '%MAVEN_HOME%' -Force"
    del "%MAVEN_HOME%\dist.zip"
)

:: Find mvn.cmd inside the extracted folder
for /r "%MAVEN_HOME%" %%f in (mvn.cmd) do set MAVEN_BIN=%%f

call "%MAVEN_BIN%" %*
endlocal
