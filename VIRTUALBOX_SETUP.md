# VirtualBox OVA Download and Import Guide

This guide provides step-by-step instructions for downloading and importing two OVA (Open Virtualization Appliance) files for VirtualBox: Gateway and Workstation.

## Prerequisites

- **VirtualBox** installed on your system (version 6.1 or later recommended)
  - Download from: https://www.virtualbox.org/wiki/Downloads
- At least **20 GB** of free disk space
- At least **4 GB** of RAM (8 GB or more recommended)
- Active internet connection for downloading OVA files

## Step 1: Download the OVA Files

### For Whonix (Recommended Security Setup)

Whonix is a security-focused operating system that uses a Gateway/Workstation architecture for enhanced privacy.

1. **Visit the Whonix Download Page**
   - Go to: https://www.whonix.org/wiki/VirtualBox

2. **Download Both OVA Files**
   - **Whonix-Gateway OVA**: Handles all network connections through Tor
   - **Whonix-Workstation OVA**: Your working environment, isolated from direct internet access

3. **Download Verification Files** (Recommended)
   - Download the corresponding `.asc` signature files
   - Download the signing key to verify authenticity

### Direct Download Links (Example)
```bash
# Gateway
wget https://download.whonix.org/ova/[version]/Whonix-Gateway-[version].ova

# Workstation  
wget https://download.whonix.org/ova/[version]/Whonix-Workstation-[version].ova
```

## Step 2: Verify Downloads (Optional but Recommended)

### Verify File Integrity

1. **Check SHA-256 Checksums**
   ```bash
   sha256sum Whonix-Gateway-*.ova
   sha256sum Whonix-Workstation-*.ova
   ```
   Compare the output with checksums published on the official website.

2. **Verify GPG Signatures** (Advanced)
   ```bash
   # Import the signing key
   gpg --import [signing-key-file]
   
   # Verify signatures
   gpg --verify Whonix-Gateway-*.ova.asc Whonix-Gateway-*.ova
   gpg --verify Whonix-Workstation-*.ova.asc Whonix-Workstation-*.ova
   ```

## Step 3: Import OVA Files into VirtualBox

### Import Gateway VM

1. **Open VirtualBox**
   - Launch the VirtualBox application

2. **Import the Gateway OVA**
   - Click **File** → **Import Appliance**
   - Browse and select the **Whonix-Gateway-*.ova** file
   - Click **Next**

3. **Review Appliance Settings**
   - Review the default settings (CPU, RAM, storage)
   - Adjust if needed based on your system resources
   - Click **Import**

4. **Wait for Import to Complete**
   - This may take several minutes depending on your system

### Import Workstation VM

1. **Import the Workstation OVA**
   - Click **File** → **Import Appliance** again
   - Browse and select the **Whonix-Workstation-*.ova** file
   - Click **Next**

2. **Review Appliance Settings**
   - Review and adjust settings if needed
   - Click **Import**

3. **Wait for Import to Complete**

## Step 4: Configure VirtualBox Network Settings

### Verify Network Adapters

Both VMs should be configured to use an **Internal Network**:

1. **For Gateway VM**
   - Right-click the Gateway VM → **Settings** → **Network**
   - Adapter 1: Should be set to **NAT** (for internet access)
   - Adapter 2: Should be set to **Internal Network** named "Whonix"

2. **For Workstation VM**
   - Right-click the Workstation VM → **Settings** → **Network**
   - Adapter 1: Should be set to **Internal Network** named "Whonix"
   - This ensures the Workstation routes all traffic through the Gateway

## Step 5: Start the Virtual Machines

### Starting Order

1. **Start Gateway First**
   - Select the Gateway VM
   - Click **Start**
   - Wait for it to fully boot up

2. **Start Workstation**
   - Select the Workstation VM
   - Click **Start**
   - The Workstation will route all traffic through the Gateway

## Step 6: Initial Configuration

### First Boot Setup

1. **Gateway Configuration**
   - Follow the on-screen setup wizard
   - Default credentials are usually provided in the documentation
   - Update the system when prompted

2. **Workstation Configuration**
   - Complete the initial setup
   - Update the system
   - Configure your working environment

## Troubleshooting

### Common Issues

1. **VT-x/AMD-V not enabled**
   - Enable hardware virtualization in your BIOS/UEFI settings

2. **Not enough RAM**
   - Reduce RAM allocation in VM settings
   - Close other applications to free up memory

3. **Import fails**
   - Verify the OVA file is not corrupted
   - Check available disk space
   - Try re-downloading the OVA file

4. **Network connectivity issues**
   - Verify both VMs are using the correct network settings
   - Ensure Gateway is started before Workstation
   - Check firewall settings on host system

### Getting Help

- **Whonix Documentation**: https://www.whonix.org/wiki/Documentation
- **Whonix Forums**: https://forums.whonix.org/
- **VirtualBox Manual**: https://www.virtualbox.org/manual/

## Security Notes

- Always download OVA files from official sources
- Verify checksums and signatures when possible
- Keep both VMs updated with latest security patches
- Never run untrusted software in the Gateway VM
- Use the Workstation for your actual work/browsing

## Next Steps

After successful import and setup:
1. Update both VMs to the latest versions
2. Create snapshots for easy recovery
3. Configure your workstation with necessary applications
4. Review security best practices for your use case

---

**Note**: This guide uses Whonix as an example. If you're using different Gateway/Workstation OVA files, adjust the URLs and specific instructions accordingly, but the general process remains the same.
