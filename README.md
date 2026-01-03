# alphastarfish
Learning

## BrowserOS Update

This repository contains a script to update BrowserOS to the latest version.

### Quick Update

```bash
./update-browseros.sh
```

### What is BrowserOS?

BrowserOS is an open-source, AI-powered web browser built on Chromium that enables users to automate web tasks using natural language commands. It features:

- Local and cloud AI agent automation
- Privacy-first design (run AI models locally)
- Compatible with Chrome extensions
- Supports multiple AI providers (OpenAI GPT, Anthropic Claude, Google Gemini, and local models)

### Current Version

The update script will install **BrowserOS v0.35.0**, which includes:
- Agent stability improvements
- Support for Gemini 3
- Enhanced error message clarity for debugging agent workflows

### Supported Platforms

- **Linux**: x86_64 (installs as AppImage)
- **macOS**: x64 and ARM64 (installs as DMG)
- **Windows**: x64 (installs as EXE)

### Manual Update

If you prefer to update manually:

1. Visit the [BrowserOS releases page](https://github.com/browseros-ai/BrowserOS/releases)
2. Download the appropriate version for your platform:
   - Linux: `BrowserOS_v0.35.0_x64.AppImage`
   - macOS (Intel): `BrowserOS_v0.35.0_x64.dmg`
   - macOS (Apple Silicon): `BrowserOS_v0.35.0_arm64.dmg`
   - Windows: `BrowserOS_v0.35.0_x64_installer.exe`
3. For Linux: Make the AppImage executable (`chmod +x BrowserOS_v0.35.0_x64.AppImage`) and run it
4. For macOS: Open the DMG and drag to Applications
5. For Windows: Run the installer

### More Information

- Official documentation: https://docs.browseros.com
- GitHub repository: https://github.com/browseros-ai/BrowserOS
- Update documentation: https://docs.browseros.com/update
