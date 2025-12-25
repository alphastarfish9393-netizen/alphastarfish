# alphastarfish
Learning

## VirtualBox Setup

This repository includes guides and scripts for setting up VirtualBox with OVA files (Gateway and Workstation).

### Quick Start

1. **Read the comprehensive guide**: [VIRTUALBOX_SETUP.md](VIRTUALBOX_SETUP.md)
2. **Download OVA files**: Use the provided script
   ```bash
   ./download_ova.sh
   ```
3. **Import into VirtualBox**: Follow the instructions in the guide

### Contents

- **VIRTUALBOX_SETUP.md** - Detailed step-by-step guide for downloading and importing OVA files
- **QUICKREF.md** - Quick reference card for fast setup
- **download_ova.sh** - Automated script to help download the OVA files

### What are Gateway and Workstation VMs?

The Gateway/Workstation architecture is a security-focused setup where:
- **Gateway VM**: Handles all network connections (typically through Tor)
- **Workstation VM**: Your working environment, isolated from direct internet access

This setup enhances privacy and security by routing all Workstation traffic through the Gateway.
