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
$ErrorActionPreference = 'Stop'

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

# Download and execute main installer
Write-Host "Downloading SyntheticCore deployment script..." -ForegroundColor Cyan
$DownloadURL = 'https://github.com/Marek-Codex/SyntheticCore-Gaming-Package/raw/main/AIOInstaller.bat'
$FilePath = "$env:TEMP\SyntheticCore-Installer.bat"

try {
	Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing -OutFile $FilePath

	if (Test-Path $FilePath) {
		Write-Host "Launching deployment sequence..." -ForegroundColor Green
		Write-Host "Note: Administrator privileges will be requested..." -ForegroundColor Yellow
		Start-Process -FilePath $FilePath -Verb runAs -Wait
		Remove-Item $FilePath -Force -ErrorAction SilentlyContinue
		Write-Host "SyntheticCore deployment completed successfully!" -ForegroundColor Green
	}
}
catch {
	Write-Error "Failed to download or execute deployment script: $_"
	Write-Host "Alternative: Download and run AIOInstaller.bat manually as Administrator" -ForegroundColor Yellow
}

Write-Host "SyntheticCore Gaming Package deployment finished." -ForegroundColor Cyan
Write-Host "Visit https://github.com/Marek-Codex/SyntheticCore-Gaming-Package for support." -ForegroundColor Gray
