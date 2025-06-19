# SyntheticCore Gaming Package - Installer
# Marek-Codex Build 2025.6.19
# https://github.com/Marek-Codex/SyntheticCore-Gaming-Package

Function Test-CommandExists {
	[CmdletBinding()]
	Param ([string]$command)
	try {
		if (Get-Command $command -ErrorAction SilentlyContinue) {
			return $true
		}
	}
	catch {
		return $false
	}
}

# Initialize secure connection
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = 'Continue'  # Changed from 'Stop' to prevent script termination on individual package failures

# Check PowerShell execution policy
$executionPolicy = Get-ExecutionPolicy
if ($executionPolicy -eq 'Restricted') {
	Write-Host "PowerShell execution policy is Restricted. Setting to RemoteSigned for this session..." -ForegroundColor Yellow
	Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
}

Write-Host "SyntheticCore Gaming Package - Deployment Initializer" -ForegroundColor Cyan
Write-Host "Build 2025.6.19 by Marek-Codex" -ForegroundColor DarkCyan
Write-Host ""

# WinGet Installation and Update
if (!(Test-CommandExists -command 'winget')) {
	Write-Host "Installing latest WinGet package manager..." -ForegroundColor Yellow
	Write-Host "Note: AIOInstaller.bat will also verify WinGet installation..." -ForegroundColor Gray
	$DownloadURL = 'https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
	$VCLibsURL = 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'

	$FilePath = "$env:TEMP\WinGet.msixbundle"
	$VCLibsPath = "$env:TEMP\Microsoft.VCLibs.x64.14.00.Desktop.appx"

	try {
		Write-Host "Downloading WinGet and dependencies..." -ForegroundColor Gray
		# Parallel download for efficiency
		$job1 = Start-Job -ScriptBlock {
			param($url, $path)
			Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $path
		} -ArgumentList $DownloadURL, $FilePath

		$job2 = Start-Job -ScriptBlock {
			param($url, $path)
			Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $path
		} -ArgumentList $VCLibsURL, $VCLibsPath

		Wait-Job -Job $job1, $job2 | Out-Null
		Remove-Job -Job $job1, $job2

		Write-Host "Installing WinGet components..." -ForegroundColor Gray
		Add-AppxPackage -Path $VCLibsPath -ErrorAction SilentlyContinue
		Add-AppxPackage -Path $FilePath

		# Cleanup temporary files
		Remove-Item $FilePath -Force -ErrorAction SilentlyContinue
		Remove-Item $VCLibsPath -Force -ErrorAction SilentlyContinue

		Write-Host "WinGet installation completed." -ForegroundColor Green
	}
	catch {
		Write-Host "WinGet installation failed - AIOInstaller.bat will retry..." -ForegroundColor Yellow
		Write-Warning "Error: $_"
	}
}
else {
	Write-Host "WinGet detected, updating sources..." -ForegroundColor Green
}

# Refresh package sources
try {
	Write-Host "Refreshing package sources..." -ForegroundColor Gray
	& winget source update --accept-source-agreements | Out-Null
	Start-Sleep -Seconds 2
}
catch {
	Write-Host "Sources already current." -ForegroundColor Gray
}

# Check for Administrator privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
	Write-Host "Administrator privileges required for installation." -ForegroundColor Yellow
	Write-Host "Restarting with elevated privileges..." -ForegroundColor Gray
	try {
		$scriptContent = [System.Net.WebClient]::new().DownloadString('https://raw.githubusercontent.com/Marek-Codex/SyntheticCore-Gaming-Package/main/Install.ps1')
		$encodedCommand = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($scriptContent))
		Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -EncodedCommand $encodedCommand" -Verb RunAs -Wait
		Write-Host "Installation completed!" -ForegroundColor Green
	}
	catch {
		Write-Host "Failed to restart with admin privileges. Please run as Administrator manually." -ForegroundColor Red
		Write-Host "Alternative: Right-click PowerShell -> Run as Administrator, then run:" -ForegroundColor Yellow
		Write-Host "irm https://raw.githubusercontent.com/Marek-Codex/SyntheticCore-Gaming-Package/main/Install.ps1 | iex" -ForegroundColor Cyan
	}
	return
}

# Main installation with admin privileges
Write-Host "Installing SyntheticCore Gaming Package components..." -ForegroundColor Green
Write-Host "This may take several minutes depending on your internet connection." -ForegroundColor Gray

# Verify WinGet is available before proceeding
if (!(Test-CommandExists -command 'winget')) {
	Write-Host "❌ WinGet is not available. Cannot proceed with installation." -ForegroundColor Red
	Write-Host "Please install Windows App Installer from the Microsoft Store and try again." -ForegroundColor Yellow
	if ($isAdmin) {
		Write-Host ""
		Write-Host "Press any key to exit..." -ForegroundColor DarkGray
		$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	}
	return
}

Write-Host "✓ WinGet is available. Starting package installation..." -ForegroundColor Green

# Gaming redistributables to install
$packages = @(
	"Microsoft.VCRedist.2005.x64",
	"Microsoft.VCRedist.2005.x86",
	"Microsoft.VCRedist.2008.x64",
	"Microsoft.VCRedist.2008.x86",
	"Microsoft.VCRedist.2010.x64",
	"Microsoft.VCRedist.2010.x86",
	"Microsoft.VCRedist.2012.x64",
	"Microsoft.VCRedist.2012.x86",
	"Microsoft.VCRedist.2013.x64",
	"Microsoft.VCRedist.2013.x86",
	"Microsoft.VCRedist.2015+.x64",
	"Microsoft.VCRedist.2015+.x86",
	"Microsoft.DotNet.Framework.DeveloperPack_4",
	"Microsoft.DotNet.Runtime.6",
	"Microsoft.DotNet.Runtime.7",
	"Microsoft.DotNet.Runtime.8",
	"Microsoft.DirectX",
	"KhronosGroup.VulkanRT",
	"Microsoft.XNA.Framework.Redist",
	"OpenAL.OpenAL",
	"NVIDIA.PhysX",
	"Oracle.JavaRuntimeEnvironment",
	"Python.Python.3.12",
	"Microsoft.PowerShell",
	"Microsoft.WindowsTerminal",
	"M2Team.NanaZip"
)

$successCount = 0
$totalPackages = $packages.Count
$currentPackage = 0

foreach ($package in $packages) {
	$currentPackage++
	try {
		Write-Host "[$currentPackage/$totalPackages] Installing $package..." -ForegroundColor Gray

		# Reset error variables
		$LASTEXITCODE = 0
		$result = ""

		# Run winget install with error capture
		$result = & winget install --id $package --silent --accept-package-agreements --accept-source-agreements --disable-interactivity 2>&1
		$exitCode = $LASTEXITCODE

		if ($exitCode -eq 0) {
			$successCount++
			Write-Host "✓ $package installed successfully" -ForegroundColor Green
		}
		elseif ($exitCode -eq -1978335189 -or $result -like "*already installed*" -or $result -like "*No newer version*") {
			$successCount++
			Write-Host "✓ $package already up to date" -ForegroundColor DarkGreen
		}
		else {
			Write-Host "⚠ $package installation returned code $exitCode" -ForegroundColor Yellow
			if ($result) {
				Write-Host "  Details: $($result -join ' ')" -ForegroundColor DarkGray
			}
		}
	}
	catch {
		Write-Host "✗ Failed to install $package`: $_" -ForegroundColor Red
	}

	# Small delay to prevent overwhelming the system
	Start-Sleep -Milliseconds 500
}

Write-Host ""
Write-Host "Installation Summary:" -ForegroundColor Cyan
Write-Host "Successfully processed: $successCount/$totalPackages packages" -ForegroundColor Green
Write-Host "Failed or skipped: $($totalPackages - $successCount) packages" -ForegroundColor $(if ($successCount -eq $totalPackages) { "Gray" } else { "Yellow" })

Write-Host "SyntheticCore Gaming Package deployment finished." -ForegroundColor Cyan
Write-Host "Visit https://github.com/Marek-Codex/SyntheticCore-Gaming-Package for support." -ForegroundColor Gray

# Pause if running in elevated context (so user can see results)
if ($isAdmin) {
	Write-Host ""
	Write-Host "Press any key to continue..." -ForegroundColor DarkGray
	$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
