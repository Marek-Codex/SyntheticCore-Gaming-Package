@echo off
REM SyntheticCore Gaming Package - Quick Installer
REM Marek-Codex Build 2025.6.19

title SyntheticCore Gaming Package :: Initializer
color 0B

echo.
echo  +========================================+
echo  ^|      SYNTHETICCORE GAMING PACKAGE      ^|
echo  ^|         QUICK DEPLOYMENT MODE          ^|
echo  +========================================+
echo.
echo  Launching PowerShell deployment script...
echo.

powershell -Command "&{[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}; """"& { $((Invoke-WebRequest -UseBasicParsing 'https://github.com/Marek-Codex/SyntheticCore-Gaming-Package/raw/main/Install.ps1').Content)}"""" | Invoke-Expression"

echo.
echo  Deployment complete. Press any key to exit.
pause > nul
exit /b