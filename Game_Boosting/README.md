# Windows Gaming Optimization Scripts

![Gaming Optimization Banner](https://i.imgur.com/YourBannerImage.png)

## Overview

This repository contains batch scripts designed to optimize Windows 10 and Windows 11 for gaming performance. These scripts implement various tweaks and optimizations that can help reduce system overhead and improve frame rates in games.

## Scripts

The repository includes four optimization scripts:

- **optimize_win10.bat** - Optimization script for Windows 10 (Italian)
- **optimize_win11.bat** - Optimization script for Windows 11 (Italian)
- **optimize_win10_en.bat** - Optimization script for Windows 10 (English)
- **optimize_win11_en.bat** - Optimization script for Windows 11 (English)

## Features

These scripts perform various optimizations including:

- Creating a system restore point for safety
- Setting high performance power profile
- Disabling unnecessary Windows services
- Optimizing Windows Defender scheduling
- Disabling telemetry and user experience programs
- Configuring visual effects for performance
- Optimizing mouse settings for gaming
- Activating Game Mode
- Disabling Game DVR and Game Bar
- Disabling NTFS last access time updates
- Optimizing background processes

## Configuration Options

Each script includes configuration options at the beginning that can be enabled (1) or disabled (0):

```batch
:: Disable Core Isolation (Memory Integrity) - Windows 11 only
set DISABLE_CORE_ISOLATION=0

:: Completely disable Windows Defender
set DISABLE_DEFENDER=0

:: Disable Hyper-V (Virtualization)
set DISABLE_HYPERV=0

:: Uninstall preinstalled Windows apps (Bloatware)
set REMOVE_BLOATWARE=0

:: Disable all visual effects
set DISABLE_ALL_VISUAL_EFFECTS=0

:: Disable non-essential Windows services
set DISABLE_NONESSENTIAL_SERVICES=0

:: Disable Xbox Game Bar and related services - Windows 10 only
set DISABLE_XBOX_FEATURES=0

:: Disable NTFS updates (last access time)
set DISABLE_NTFS_UPDATES=0


#Usage

Download the appropriate script for your Windows version and language preference
Right-click the file and select "Run as administrator"
Let the script complete its operations
Restart your computer when prompted

#Warning

Always create a system restore point before running these scripts (they do this automatically)
Some optimizations may affect system functionality outside of gaming
Disabling security features like Windows Defender or Core Isolation will make your system more vulnerable to malware

#Compatibility
These scripts have been tested on:

Windows 10 (21H2, 22H2)
Windows 11 (21H2, 22H2, 23H2)

#Contributing
Feel free to fork this repository and submit pull requests with additional optimizations or improvements.
License
This project is licensed under the MIT License - see the LICENSE file for details.
Acknowledgements
These scripts were inspired by various gaming optimization guides and community knowledge. Special thanks to all the gamers and system tweakers who have shared their knowledge.