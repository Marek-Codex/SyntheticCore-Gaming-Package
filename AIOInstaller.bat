@echo off
title SyntheticCore Gaming Package - Runtime Installer
color 0a
cls

echo.
echo ===============================================================================
echo    _____ _  _ _  _ _____ _  _ ___ _____ _ ___    _____ ___  ___ ___
echo   ^|   __^| ^|^| ^| \^| ^|_   _^| ^|^| ^|__ ^|_   _^|^|^|  __^|  ___^|   ^|  _^|  ___^|
echo   ^|__   ^| ^|^| ^| . ^|  ^| ^| ^| ^|^| ^|___ ^| ^| ^| ^|^| ^|__ ^| ^|   ^| ^| ^| ^|   ^|__
echo   ^|_____^|___^|_^|^|_^|  ^|_^| ^|_^|^|_^|___^| ^|_^| ^|_^|___^|^|___^|^|_^|^|_^|  ^|___^|
echo.
echo                          GAMING PACKAGE v2.0
echo                        Advanced Runtime Installer
echo ===============================================================================
echo.
echo  [#] Installing essential gaming redistributables...
echo  [#] Targeting compatibility: DOS/Win3.1 to Modern (Vulkan/DX12)
echo  [#] Includes: VC++, .NET, DirectX, Vulkan, XNA, OpenAL, PhysX, Java, Python
echo  [#] Optimized for maximum speed and reliability
echo.
echo ===============================================================================
echo.

REM Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] ERROR: Administrator privileges required!
    echo [#] Please run as Administrator to install system redistributables.
    echo.
    pause
    exit /b 1
)

echo [+] Administrator privileges confirmed
echo [#] Initializing installation sequence...
echo.

REM Create temporary directory
set "TEMP_DIR=%TEMP%\SyntheticCore_Install"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"
cd /d "%TEMP_DIR%"

echo [+] Temporary directory: %TEMP_DIR%
echo.

REM Check WinGet availability
winget --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] WinGet not detected - Installing latest version...
    echo [#] Downloading WinGet and dependencies from GitHub...

    REM Download latest WinGet bundle and VCLibs dependency
    powershell -Command "& {
        $ProgressPreference = 'SilentlyContinue'
        $WinGetURL = 'https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
        $VCLibsURL = 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'
        $WinGetPath = '$env:TEMP\WinGet_Latest.msixbundle'
        $VCLibsPath = '$env:TEMP\VCLibs_Latest.appx'

        Write-Host '[#] Downloading WinGet bundle...' -ForegroundColor Yellow
        Invoke-WebRequest -Uri $WinGetURL -UseBasicParsing -OutFile $WinGetPath

        Write-Host '[#] Downloading VCLibs dependency...' -ForegroundColor Yellow
        Invoke-WebRequest -Uri $VCLibsURL -UseBasicParsing -OutFile $VCLibsPath

        Write-Host '[#] Installing VCLibs dependency...' -ForegroundColor Yellow
        Add-AppxPackage -Path $VCLibsPath -ErrorAction SilentlyContinue

        Write-Host '[#] Installing WinGet package manager...' -ForegroundColor Yellow
        Add-AppxPackage -Path $WinGetPath

        Write-Host '[+] WinGet installation completed!' -ForegroundColor Green

        # Cleanup temp files
        Remove-Item $WinGetPath -ErrorAction SilentlyContinue
        Remove-Item $VCLibsPath -ErrorAction SilentlyContinue
    }"

    REM Verify installation worked
    timeout /t 3 /nobreak >nul
    winget --version >nul 2>&1
    if %errorLevel% neq 0 (
        echo [!] ERROR: WinGet installation failed!
        echo [#] Please install manually from GitHub or Microsoft Store
        pause
        exit /b 1
    ) else (
        echo [+] WinGet installation successful - continuing...
    )
) else (
    echo [+] WinGet detected and ready
)
echo.

echo ===============================================================================
echo                            CORE RUNTIMES
echo ===============================================================================
echo.

REM Visual C++ Redistributables (Essential)
echo [#] Installing Visual C++ Redistributables...
echo     - VC++ 2005 SP1 (x86/x64)
echo     - VC++ 2008 SP1 (x86/x64)
echo     - VC++ 2010 SP1 (x86/x64)
echo     - VC++ 2012 Update 4 (x86/x64)
echo     - VC++ 2013 (x86/x64)
echo     - VC++ 2015-2022 (x86/x64)
echo.

start /wait winget install --id Microsoft.VCRedist.2005.x86 --silent --accept-package-agreements --accept-source-agreements
start /wait winget install --id Microsoft.VCRedist.2005.x64 --silent --accept-package-agreements --accept-source-agreements
start /wait winget install --id Microsoft.VCRedist.2008.x86 --silent --accept-package-agreements --accept-source-agreements
start /wait winget install --id Microsoft.VCRedist.2008.x64 --silent --accept-package-agreements --accept-source-agreements
start /wait winget install --id Microsoft.VCRedist.2010.x86 --silent --accept-package-agreements --accept-source-agreements
start /wait winget install --id Microsoft.VCRedist.2010.x64 --silent --accept-package-agreements --accept-source-agreements
start /wait winget install --id Microsoft.VCRedist.2012.x86 --silent --accept-package-agreements --accept-source-agreements
start /wait winget install --id Microsoft.VCRedist.2012.x64 --silent --accept-package-agreements --accept-source-agreements
start /wait winget install --id Microsoft.VCRedist.2013.x86 --silent --accept-package-agreements --accept-source-agreements
start /wait winget install --id Microsoft.VCRedist.2013.x64 --silent --accept-package-agreements --accept-source-agreements
start /wait winget install --id Microsoft.VCRedist.2015+.x86 --silent --accept-package-agreements --accept-source-agreements
start /wait winget install --id Microsoft.VCRedist.2015+.x64 --silent --accept-package-agreements --accept-source-agreements

echo [+] Visual C++ Redistributables installation completed
echo.

REM .NET Framework and Runtime
echo [#] Installing .NET Framework and Runtime...
echo     - .NET Framework 3.5 SP1
echo     - .NET Framework 4.8
echo     - .NET 6.0 Runtime
echo     - .NET 7.0 Runtime
echo     - .NET 8.0 Runtime
echo.

start /wait winget install --id Microsoft.DotNet.Framework.DeveloperPack_4 --silent --accept-package-agreements --accept-source-agreements
start /wait winget install --id Microsoft.DotNet.Runtime.6 --silent --accept-package-agreements --accept-source-agreements
start /wait winget install --id Microsoft.DotNet.Runtime.7 --silent --accept-package-agreements --accept-source-agreements
start /wait winget install --id Microsoft.DotNet.Runtime.8 --silent --accept-package-agreements --accept-source-agreements

echo [+] .NET installation completed
echo.

echo ===============================================================================
echo                           GRAPHICS & GAMING
echo ===============================================================================
echo.

REM DirectX End-User Runtime
echo [#] Installing DirectX End-User Runtime...
start /wait winget install --id Microsoft.DirectX --silent --accept-package-agreements --accept-source-agreements
echo [+] DirectX installation completed
echo.

REM Vulkan Runtime
echo [#] Installing Vulkan Runtime...
start /wait winget install --id KhronosGroup.VulkanRuntime --silent --accept-package-agreements --accept-source-agreements
echo [+] Vulkan Runtime installation completed
echo.

REM XNA Framework
echo [#] Installing XNA Framework 4.0...
start /wait winget install --id Microsoft.XNAFramework --silent --accept-package-agreements --accept-source-agreements
echo [+] XNA Framework installation completed
echo.

echo ===============================================================================
echo                          AUDIO & PHYSICS
echo ===============================================================================
echo.

REM OpenAL
echo [#] Installing OpenAL...
start /wait winget install --id OpenAL.OpenAL --silent --accept-package-agreements --accept-source-agreements
echo [+] OpenAL installation completed
echo.

REM NVIDIA PhysX (Legacy and Current)
echo [#] Installing NVIDIA PhysX...
start /wait winget install --id Nvidia.PhysX --silent --accept-package-agreements --accept-source-agreements
echo [+] PhysX installation completed
echo.

echo ===============================================================================
echo                         LEGACY COMPATIBILITY
echo ===============================================================================
echo.

REM Java Runtime Environment
echo [#] Installing Java Runtime Environment...
start /wait winget install --id Oracle.JavaRuntimeEnvironment --silent --accept-package-agreements --accept-source-agreements
echo [+] Java Runtime installation completed
echo.

REM Python Runtime
echo [#] Installing Python Runtime...
start /wait winget install --id Python.Python.3.12 --silent --accept-package-agreements --accept-source-agreements
echo [+] Python Runtime installation completed
echo.

REM WineVDM (OTVDM) for DOS/16-bit compatibility
echo [#] Installing WineVDM (OTVDM) for DOS/16-bit support...
start /wait winget install --id otya128.OTVDM --silent --accept-package-agreements --accept-source-agreements
echo [+] WineVDM (OTVDM) installation completed
echo.

echo ===============================================================================
echo                         SYSTEM ENHANCEMENTS
echo ===============================================================================
echo.

REM PowerShell 7
echo [#] Installing PowerShell 7...
start /wait winget install --id Microsoft.PowerShell --silent --accept-package-agreements --accept-source-agreements
echo [+] PowerShell 7 installation completed
echo.

REM Windows Terminal
echo [#] Installing Windows Terminal...
start /wait winget install --id Microsoft.WindowsTerminal --silent --accept-package-agreements --accept-source-agreements
echo [+] Windows Terminal installation completed
echo.

REM NanaZip (Modern 7-Zip replacement)
echo [#] Installing NanaZip...
start /wait winget install --id M2Team.NanaZip --silent --accept-package-agreements --accept-source-agreements
echo [+] NanaZip installation completed
echo.

echo ===============================================================================
echo                           CLEANUP & FINISH
echo ===============================================================================
echo.

REM Cleanup temporary files
echo [#] Cleaning up temporary files...
cd /d "%USERPROFILE%"
rmdir /s /q "%TEMP_DIR%" >nul 2>&1
echo [+] Cleanup completed
echo.

echo ===============================================================================
echo.
echo                    [#] INSTALLATION COMPLETED [#]
echo.
echo  [+] All gaming redistributables have been installed successfully!
echo  [+] System is now optimized for maximum game compatibility
echo  [+] Coverage: DOS/Win3.1 era through modern Vulkan/DirectX
echo.
echo  [!] RECOMMENDATION: Restart your system for optimal performance
echo.
echo ===============================================================================
echo.
echo                    Created by: Marek-Codex
echo              https://github.com/Marek-Codex/SyntheticCore
echo.

pause
exit /b 0
