# VirtualBox OVA Quick Reference

## Quick Setup (5 Steps)

1. **Download**
   ```bash
   ./download_ova.sh
   ```
   Or manually from: https://www.whonix.org/wiki/VirtualBox

2. **Verify** (Optional but Recommended)
   ```bash
   sha256sum *.ova
   gpg --verify *.ova.asc *.ova
   ```

3. **Import Gateway**
   - VirtualBox → File → Import Appliance
   - Select Gateway OVA → Import

4. **Import Workstation**
   - VirtualBox → File → Import Appliance
   - Select Workstation OVA → Import

5. **Start VMs**
   - Start Gateway first
   - Then start Workstation

## Network Configuration

- **Gateway**: NAT + Internal Network "Whonix"
- **Workstation**: Internal Network "Whonix" only

## Troubleshooting

| Problem | Solution |
|---------|----------|
| VT-x not enabled | Enable virtualization in BIOS |
| Low memory | Reduce VM RAM allocation |
| Import fails | Re-download OVA file |
| No network | Check Gateway started first |

## Resources

- Full Guide: [VIRTUALBOX_SETUP.md](VIRTUALBOX_SETUP.md)
- Download Script: `./download_ova.sh`
- Whonix Docs: https://www.whonix.org/wiki/Documentation
