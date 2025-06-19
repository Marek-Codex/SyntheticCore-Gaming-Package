@echo off
REM SyntheticCore Gaming Package - Local Test Version
REM Marek-Codex Build 2025.6.19

title SyntheticCore Gaming Package :: Local Test Mode
color 0B

:StartTest
cls
echo.
echo  +========================================+
echo  ^|      SYNTHETICCORE GAMING PACKAGE      ^|
echo  ^|         [LOCAL TEST MODE]              ^|
echo  +========================================+
echo  ^| .NET ^| VC++ ^| DX ^| VK ^| XNA ^| LEGACY ^| DOS ^| TERM ^|
echo.
echo  ^> INITIALIZING LOCAL TEST SEQUENCE...
echo  ^> This will install packages directly without downloading
echo.
pause

:TestWinGet
echo.
echo ^> TESTING WINGET AVAILABILITY...
winget --version >nul 2>&1
if %errorlevel% == 0 (
    echo [+] WinGet is available and ready
    winget --version
) else (
    echo [!] WinGet not found - in real installer would auto-download from:
    echo     https://github.com/microsoft/winget-cli/releases/latest
    echo     [LocalTest mode - no actual installation performed]
)

echo.
echo ^> TESTING PACKAGE AVAILABILITY...
echo   Checking a few key packages...

winget show Microsoft.VCRedist.2015+.x64 --accept-source-agreements >nul 2>&1
if %errorlevel% == 0 (
    echo [+] VC++ 2015-2022 x64 available
) else (
    echo [!] VC++ 2015-2022 x64 not found
)

winget show Microsoft.DirectX --accept-source-agreements >nul 2>&1
if %errorlevel% == 0 (
    echo [+] DirectX available
) else (
    echo [!] DirectX not found
)

winget show OpenAL.OpenAL --accept-source-agreements >nul 2>&1
if %errorlevel% == 0 (
    echo [+] OpenAL available
) else (
    echo [!] OpenAL not found
)

echo.
echo ^> WOULD YOU LIKE TO PROCEED WITH ACTUAL INSTALLATION?
echo   Y = Yes, install everything
echo   T = Test install just one package (DirectX)
echo   N = No, just testing
echo.
set /p choice="Enter choice (Y/T/N): "

if /i "%choice%"=="Y" goto :FullInstall
if /i "%choice%"=="T" goto :TestInstall
if /i "%choice%"=="N" goto :TestComplete

:TestInstall
echo.
echo ^> TESTING SINGLE PACKAGE INSTALLATION...
echo ^> Installing DirectX as test...
winget install -e --id Microsoft.DirectX --accept-package-agreements --force --silent
echo [+] Test installation complete
goto :TestComplete

:FullInstall
echo.
echo ^> PROCEEDING WITH FULL INSTALLATION...
echo ^> This is the real deal - installing all packages!
echo.
pause

REM Core utilities
echo ^> Installing Core Utilities...
start /B winget install -e --id Microsoft.DirectX --accept-package-agreements --force --silent
start /B winget install -e --id Microsoft.XNARedist --accept-package-agreements --force --silent
start /B winget install -e --id KhronosGroup.VulkanRT --accept-package-agreements --force --silent
start /B winget install -e --id M2Team.NanaZip --accept-package-agreements --force --silent
timeout /t 5 /nobreak >nul

REM VC++ Redistributables
echo ^> Installing VC++ Redistributables...
start /B winget install -e --id Microsoft.VCRedist.2015+.x86 --accept-package-agreements --force --silent
start /B winget install -e --id Microsoft.VCRedist.2015+.x64 --accept-package-agreements --force --silent
start /B winget install -e --id Microsoft.VCRedist.2013.x86 --accept-package-agreements --force --silent
start /B winget install -e --id Microsoft.VCRedist.2013.x64 --accept-package-agreements --force --silent
timeout /t 5 /nobreak >nul

REM Gaming libraries
echo ^> Installing Gaming Libraries...
start /B winget install -e --id OpenAL.OpenAL --accept-package-agreements --force --silent
start /B winget install -e --id Nvidia.PhysX --accept-package-agreements --force --silent
start /B winget install -e --id Oracle.JavaRuntimeEnvironment --accept-package-agreements --force --silent
timeout /t 10 /nobreak >nul

echo [+] Installation sequence complete!

:TestComplete
echo.
echo  +========================================+
echo  ^|        [LOCAL TEST COMPLETE]           ^|
echo  +========================================+
echo.
echo  Build 2025.6.19 by Marek-Codex
echo  Ready for GitHub deployment when you are!
echo.
pause
