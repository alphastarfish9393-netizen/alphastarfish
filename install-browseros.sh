#!/bin/bash

# BrowserOS Update Download and Install Script
# This script downloads and installs the latest BrowserOS release

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Constants
MIN_FILE_SIZE=104857600  # 100MB minimum expected size for BrowserOS

# Print functions
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    print_error "This script is designed for Linux systems only."
    print_info "For macOS, download from: https://cdn.browseros.com/releases/mac/BrowserOS-latest.dmg"
    print_info "For Windows, download from: https://cdn.browseros.com/releases/windows/BrowserOS-Setup-latest.exe"
    exit 1
fi

# Detect architecture
ARCH=$(uname -m)
print_info "Detected architecture: $ARCH"

# Set up download URLs based on architecture
case "$ARCH" in
    x86_64)
        APPIMAGE_URL="https://cdn.browseros.com/releases/linux/BrowserOS-latest-x86_64.AppImage"
        FALLBACK_URL="https://files.browseros.com/releases/linux/BrowserOS-latest-x86_64.AppImage"
        GITHUB_URL="https://github.com/browseros-ai/BrowserOS/releases/download/v0.35.0/BrowserOS_v0.35.0_x64.AppImage"
        ;;
    aarch64|arm64)
        APPIMAGE_URL="https://cdn.browseros.com/releases/linux/BrowserOS-latest-arm64.AppImage"
        FALLBACK_URL="https://files.browseros.com/releases/linux/BrowserOS-latest-arm64.AppImage"
        GITHUB_URL="https://github.com/browseros-ai/BrowserOS/releases/latest/download/BrowserOS_latest_arm64.AppImage"
        ;;
    *)
        print_error "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Create download directory
DOWNLOAD_DIR="$HOME/Downloads"
mkdir -p "$DOWNLOAD_DIR"

# Download file name
FILENAME="BrowserOS-latest.AppImage"
DOWNLOAD_PATH="$DOWNLOAD_DIR/$FILENAME"

print_info "Starting BrowserOS download..."
print_info "Download URL: $APPIMAGE_URL"

# Function to download file
download_file() {
    local url="$1"
    local output="$2"
    if curl -f -L -o "$output" "$url"; then
        return 0
    else
        return 1
    fi
}

# Try to download from primary CDN
if download_file "$APPIMAGE_URL" "$DOWNLOAD_PATH"; then
    print_info "Download completed successfully from primary CDN"
else
    print_warning "Primary CDN failed, trying fallback URL..."
    if download_file "$FALLBACK_URL" "$DOWNLOAD_PATH"; then
        print_info "Download completed successfully from fallback CDN"
    else
        print_warning "Both CDN sources failed, trying GitHub releases..."
        if download_file "$GITHUB_URL" "$DOWNLOAD_PATH"; then
            print_info "Download completed successfully from GitHub"
        else
            print_error "Failed to download BrowserOS from all sources (CDN + GitHub)"
            print_info "Please visit https://github.com/browseros-ai/BrowserOS/releases to download manually"
            exit 1
        fi
    fi
fi

# Verify the download
if [ ! -f "$DOWNLOAD_PATH" ]; then
    print_error "Download file not found: $DOWNLOAD_PATH"
    exit 1
fi

# Check file size (should be at least 100MB for a browser)
FILE_SIZE=$(wc -c < "$DOWNLOAD_PATH")
if [ "$FILE_SIZE" -lt "$MIN_FILE_SIZE" ]; then
    print_error "Downloaded file seems too small ($FILE_SIZE bytes). This might be an error page."
    print_info "Expected minimum size: $(numfmt --to=iec-i --suffix=B $MIN_FILE_SIZE 2>/dev/null || echo "$MIN_FILE_SIZE bytes")"
    print_info "Please check your internet connection and try again, or download manually from:"
    print_info "https://github.com/browseros-ai/BrowserOS/releases"
    exit 1
fi
print_info "Downloaded file size: $(numfmt --to=iec-i --suffix=B $FILE_SIZE 2>/dev/null || echo "$FILE_SIZE bytes")"

# Make AppImage executable
chmod +x "$DOWNLOAD_PATH"
print_info "Made AppImage executable"

# Create desktop entry for easy access
DESKTOP_DIR="$HOME/.local/share/applications"
mkdir -p "$DESKTOP_DIR"

DESKTOP_FILE="$DESKTOP_DIR/browseros.desktop"
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Name=BrowserOS
Comment=AI-powered privacy-first web browser
Exec=$DOWNLOAD_PATH
Icon=browser
Type=Application
Categories=Network;WebBrowser;
Terminal=false
EOF

print_info "Created desktop entry at: $DESKTOP_FILE"

# Installation instructions
echo ""
print_info "=========================================="
print_info "BrowserOS Installation Complete!"
print_info "=========================================="
echo ""
print_info "AppImage location: $DOWNLOAD_PATH"
echo ""
print_info "To run BrowserOS, you can:"
print_info "  1. Execute: $DOWNLOAD_PATH"
print_info "  2. Search for 'BrowserOS' in your application menu"
echo ""
print_info "Optional: Move to a permanent location:"
print_info "  mkdir -p ~/.local/bin"
print_info "  mv $DOWNLOAD_PATH ~/.local/bin/BrowserOS.AppImage"
echo ""

# Ask user if they want to launch now
read -p "Would you like to launch BrowserOS now? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Launching BrowserOS..."
    "$DOWNLOAD_PATH" &
    print_info "BrowserOS has been launched in the background"
fi

print_info "Done!"
