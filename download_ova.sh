#!/bin/bash

# Script to download Whonix OVA files for VirtualBox
# This script downloads both Gateway and Workstation OVA files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Whonix OVA Download Script ===${NC}"
echo ""

# Check if wget or curl is available
if command -v wget &> /dev/null; then
    DOWNLOADER="wget"
elif command -v curl &> /dev/null; then
    DOWNLOADER="curl -O"
else
    echo -e "${RED}Error: Neither wget nor curl is installed.${NC}"
    echo "Please install wget or curl and try again."
    exit 1
fi

# Create download directory
DOWNLOAD_DIR="./whonix_ova"
mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

echo -e "${YELLOW}Note: This script will guide you through downloading Whonix OVA files.${NC}"
echo -e "${YELLOW}You will need to visit the Whonix website to get the latest download URLs.${NC}"
echo ""
echo "Please visit: https://www.whonix.org/wiki/VirtualBox"
echo ""

# Get latest version info
echo -e "${GREEN}Step 1: Get Download URLs${NC}"
echo "Please copy the download URLs from the Whonix website:"
echo ""

read -p "Enter the Whonix Gateway OVA URL: " GATEWAY_URL
read -p "Enter the Whonix Workstation OVA URL: " WORKSTATION_URL

echo ""
echo -e "${GREEN}Step 2: Downloading OVA files${NC}"
echo "This may take a while depending on your internet connection..."
echo ""

# Download Gateway
if [ -n "$GATEWAY_URL" ]; then
    echo -e "${YELLOW}Downloading Gateway OVA...${NC}"
    if [ "$DOWNLOADER" = "wget" ]; then
        wget -c "$GATEWAY_URL" || echo -e "${RED}Gateway download failed${NC}"
    else
        curl -C - -O "$GATEWAY_URL" || echo -e "${RED}Gateway download failed${NC}"
    fi
    echo -e "${GREEN}Gateway download completed!${NC}"
    echo ""
fi

# Download Workstation
if [ -n "$WORKSTATION_URL" ]; then
    echo -e "${YELLOW}Downloading Workstation OVA...${NC}"
    if [ "$DOWNLOADER" = "wget" ]; then
        wget -c "$WORKSTATION_URL" || echo -e "${RED}Workstation download failed${NC}"
    else
        curl -C - -O "$WORKSTATION_URL" || echo -e "${RED}Workstation download failed${NC}"
    fi
    echo -e "${GREEN}Workstation download completed!${NC}"
    echo ""
fi

# List downloaded files
echo -e "${GREEN}Step 3: Downloaded files${NC}"
ls -lh *.ova 2>/dev/null || echo "No OVA files found"
echo ""

# Optional: Download signature files
read -p "Do you want to download signature files for verification? (y/n): " DOWNLOAD_SIG

if [ "$DOWNLOAD_SIG" = "y" ] || [ "$DOWNLOAD_SIG" = "Y" ]; then
    echo ""
    echo -e "${YELLOW}Downloading signature files...${NC}"
    
    if [ -n "$GATEWAY_URL" ]; then
        SIG_URL="${GATEWAY_URL}.asc"
        if [ "$DOWNLOADER" = "wget" ]; then
            wget -c "$SIG_URL" 2>/dev/null || echo "Gateway signature not available"
        else
            curl -O "$SIG_URL" 2>/dev/null || echo "Gateway signature not available"
        fi
    fi
    
    if [ -n "$WORKSTATION_URL" ]; then
        SIG_URL="${WORKSTATION_URL}.asc"
        if [ "$DOWNLOADER" = "wget" ]; then
            wget -c "$SIG_URL" 2>/dev/null || echo "Workstation signature not available"
        else
            curl -O "$SIG_URL" 2>/dev/null || echo "Workstation signature not available"
        fi
    fi
fi

echo ""
echo -e "${GREEN}=== Download Complete ===${NC}"
echo ""
echo "Next steps:"
echo "1. Verify the downloaded OVA files (see VIRTUALBOX_SETUP.md for instructions)"
echo "2. Import the OVA files into VirtualBox:"
echo "   - File → Import Appliance → Select Gateway OVA"
echo "   - File → Import Appliance → Select Workstation OVA"
echo ""
echo "For detailed instructions, see VIRTUALBOX_SETUP.md"
echo ""
echo "Downloaded files are located in: $(pwd)"
