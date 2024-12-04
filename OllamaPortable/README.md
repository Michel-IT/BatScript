# Ollama Portable for Windows

Create a portable version of Ollama that can run from any location, including USB drives.

## Prerequisites

- Windows 10/11
- Official Ollama installation from https://ollama.com/download/windows
- Run Ollama at least once before creating portable version
- High-performance storage device for optimal usage

## Quick Start

1. Place both scripts in `C:\OllamaPortable`:
   - `Make_OllamaPortable.bat`
   - `run_ollama.bat`
2. Run `Make_OllamaPortable.bat` as administrator
3. Wait for completion
4. Run `run_ollama.bat` to start Ollama

## Directory Structure
```
C:\OllamaPortable\
├── .ollama\
│   └── models\
│       └── blobs\
├── AppData\
│   └── Local\
│       └── Ollama\
│           └── updates\
├── Programs\
│   └── Ollama\
│       └── lib\
│           └── ollama\
├── README.md
├── Make_OllamaPortable.bat
└── run_ollama.bat
```

## Usage with USB Drive

1. Create the portable version using the steps above
2. Copy entire `OllamaPortable` folder to your USB drive
3. Run `run_ollama.bat` from the USB location
4. Keep the command window open while using Ollama

### USB Drive Requirements
- USB 3.0 or higher recommended
- Sufficient free space for models
- Good read/write speeds
- Don't remove while Ollama is running

## Important Notes

- Close original Ollama before running portable version
- Keep command window open during usage
- Models are stored in the portable directory
- Performance depends on storage device speed
- Uninstall by simply deleting the folder

## Scripts Description

### Make_OllamaPortable.bat
- Creates directory structure
- Copies necessary files
- Generates configuration

### run_ollama.bat
- Sets environment variables
- Launches Ollama server
- Starts GUI if available
- Shows help command for verification
- Maintains server process

## Troubleshooting

1. If Ollama doesn't start:
   - Ensure original installation is closed
   - Check command window for errors
   - Verify administrator privileges
   - Check file structure integrity

2. Performance issues:
   - Check storage device speed
   - Ensure sufficient free space
   - Verify USB port compatibility (if using USB)

## Legal

Ollama is a trademark of its respective owners. This portable version is an unofficial modification for convenience.

## Support

For Ollama support, visit the official website: https://ollama.com

For issues with the portable scripts, check the command window output and verify proper setup.
