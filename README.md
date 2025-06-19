# SyntheticCore Gaming Package

> *Advanced gaming environment deployment system*

```
===============================================================
                  SYNTHETICCORE v2025.6
             Comprehensive Gaming Runtime Suite
===============================================================
```

**Developer:** [Marek-Codex](https://github.com/Marek-Codex) • **Build:** 2025.6.19 • **Status:** Active Development

---

## Overview

SyntheticCore automates the deployment of essential gaming runtime components across multiple generations of software. From vintage DOS applications to cutting-edge DirectX 12 titles, this package ensures comprehensive compatibility.

**Coverage Spectrum:**
- **Vintage Era** → DOS, Windows 3.1, 16-bit applications
- **Legacy Era** → Windows 95/98/XP gaming ecosystem
- **Modern Era** → Current DirectX 12, Vulkan, .NET applications

## System Requirements

| Component | Specification |
|-----------|---------------|
| **OS** | Windows 10 21H2+ / Windows 11 |
| **PowerShell** | 5.1+ (included in Windows) |
| **Network** | Internet connection required |
| **Privileges** | Administrator required for system redistributables |
| **Architecture** | x64 recommended, x86 supported |

## Deployment Methods

### Option 1: PowerShell One-Liner (Recommended)
```powershell
# Run in PowerShell as Administrator
irm https://github.com/Marek-Codex/SyntheticCore-Gaming-Package/raw/main/Install.ps1 | iex
```

### Option 2: Alternative PowerShell Syntax
```powershell
# Alternative one-liner (same functionality)
iwr -useb https://github.com/Marek-Codex/SyntheticCore-Gaming-Package/raw/main/Install.ps1 | iex
```

### Option 3: Download and Run Batch File
```batch
# Download Install.bat and run as Administrator
# The batch file will automatically fetch and execute the PowerShell script
# No manual PowerShell command needed - just right-click "Run as Administrator"
```

### Option 4: Local Development/Testing
```batch
# Clone repository and run LocalTest.bat for safe testing
# Use AIOInstaller.bat for direct local installation
```

## Package Matrix

### Administrator Privileges Required
**Why Admin?** System redistributables (VC++, .NET, DirectX) require administrator privileges to install into Windows system directories. The installer will:
- Check for admin privileges automatically
- Prompt for elevation if needed
- Install all components silently without user interaction
- Handle WinGet installation if not present

| Category | Components | Versions |
|----------|------------|----------|
| **Runtime Libraries** | VC++ Redistributables | 2005, 2008, 2010, 2012, 2013, 2015-2022 |
| **Framework Support** | .NET Framework | All available versions |
| **Graphics APIs** | DirectX, Vulkan | Latest runtime packages |
| **Gaming Frameworks** | XNA Framework | 4.0 Redistributable |
| **Audio Systems** | OpenAL | Cross-platform audio library |
| **Physics Engines** | NVIDIA PhysX | Current + Legacy versions |
| **Legacy Support** | WineVDM | DOS/16-bit compatibility layer |
| **Development Tools** | PowerShell, Windows Terminal | Latest stable releases |
| **Compression** | NanaZip | Modern 7-Zip successor |
| **Runtime Support** | Java SE, Python | Oracle JRE + Python 3.12 |

## Performance Features

- **Parallel Installation** → Multiple packages deployed simultaneously
- **Optimized Batching** → Related components grouped for efficiency
- **Smart Resource Management** → Prevents system overload
- **Progress Tracking** → Real-time deployment status
- **Error Recovery** → Automatic retry mechanisms
- **Estimated Deployment Time** → 3-5 minutes (typical system)

## Troubleshooting

### Package Manager Issues
If WinGet initialization fails:
1. Install WinGet from [Microsoft Store](https://www.microsoft.com/store/productId/9NBLGGH4NNS1) (search "App Installer")
2. Or download latest from [GitHub Releases](https://github.com/microsoft/winget-cli/releases/latest)
3. Re-execute deployment sequence

### Network Connectivity
- Ensure stable internet connection
- Verify Windows Update service is running
- Check firewall/antivirus interference

## Development Notes

**Architecture:** Modular PowerShell + Batch hybrid system
**Package Manager:** Microsoft WinGet with automated fallbacks
**Deployment Strategy:** Parallel processing with intelligent batching
**Error Handling:** Comprehensive retry logic and graceful degradation

## Contributing

Issues, suggestions, and contributions are welcome through the GitHub repository.

**License:** Distributed under original project terms with enhancements
**Attribution:** Based on work by [harryeffinpotter](https://github.com/harryeffinpotter) and [skrimix](https://github.com/skrimix)

---

[![Downloads](https://img.shields.io/github/downloads/Marek-Codex/SyntheticCore-Gaming-Package/total.svg?style=flat-square&color=3ca0ff)](https://github.com/Marek-Codex/SyntheticCore-Gaming-Package)
[![Profile Views](https://komarev.com/ghpvc/?username=Marek-Codex&style=flat-square&color=a03cff)](https://github.com/Marek-Codex)

**Build 2025.6.19** • **Next Update:** Continuous Integration
