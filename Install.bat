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

REM Method 1: Direct PowerShell execution
powershell -ExecutionPolicy Bypass -Command "irm https://github.com/Marek-Codex/SyntheticCore-Gaming-Package/raw/main/Install.ps1 | iex"

REM If Method 1 fails, try Method 2
if %errorlevel% neq 0 (
    echo.
    echo  First method failed, trying alternative approach...
    powershell -ExecutionPolicy Bypass -Command "& { $script = Invoke-WebRequest -UseBasicParsing 'https://github.com/Marek-Codex/SyntheticCore-Gaming-Package/raw/main/Install.ps1'; if ($script.Content) { Invoke-Expression $script.Content } else { Write-Error 'Failed to download script content' } }"
)

echo.
echo  Deployment complete. Press any key to exit.
pause > nul
exit /b