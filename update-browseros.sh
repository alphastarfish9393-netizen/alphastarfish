#!/bin/bash
#
# BrowserOS Update Script
# Automatically downloads and updates BrowserOS to the latest version
#

set -e

REPO="browseros-ai/BrowserOS"
VERSION="v0.35.0"
INSTALL_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"

echo "==================================="
echo "BrowserOS Update Script"
echo "==================================="
echo ""
echo "Target version: $VERSION"
echo ""

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH_SUFFIX="x64"
        ;;
    aarch64|arm64)
        ARCH_SUFFIX="arm64"
        ;;
    *)
        echo "Error: Unsupported architecture: $ARCH"
        echo "BrowserOS supports x86_64 (x64) and ARM64 architectures."
        exit 1
        ;;
esac

echo "Detected architecture: $ARCH ($ARCH_SUFFIX)"
echo ""

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PLATFORM="linux"
    FILENAME="BrowserOS_${VERSION}_${ARCH_SUFFIX}.AppImage"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
    FILENAME="BrowserOS_${VERSION}_${ARCH_SUFFIX}.dmg"
else
    echo "Error: Unsupported operating system: $OSTYPE"
    echo "BrowserOS supports Linux and macOS."
    exit 1
fi

echo "Platform: $PLATFORM"
echo "Download file: $FILENAME"
echo ""

# Create directories if they don't exist
mkdir -p "$INSTALL_DIR"
mkdir -p "$DESKTOP_DIR"

# Download URL
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${FILENAME}"

echo "Downloading BrowserOS $VERSION..."
echo "URL: $DOWNLOAD_URL"
echo ""

# Try to download with curl, fallback to wget
if command -v curl &> /dev/null; then
    curl -L -o "/tmp/$FILENAME" "$DOWNLOAD_URL"
elif command -v wget &> /dev/null; then
    wget -O "/tmp/$FILENAME" "$DOWNLOAD_URL"
else
    echo "Error: Neither curl nor wget is available."
    echo "Please install curl or wget and try again."
    exit 1
fi

# Verify download
if [[ ! -f "/tmp/$FILENAME" ]]; then
    echo "Error: Download failed. File not found."
    exit 1
fi

FILE_SIZE=$(stat -c%s "/tmp/$FILENAME" 2>/dev/null || stat -f%z "/tmp/$FILENAME" 2>/dev/null)
if [[ $FILE_SIZE -lt 100000000 ]]; then
    echo "Error: Downloaded file seems too small (${FILE_SIZE} bytes)."
    echo "Expected at least 100MB. Download may have failed."
    rm -f "/tmp/$FILENAME"
    exit 1
fi

echo "✓ Download successful ($(numfmt --to=iec $FILE_SIZE 2>/dev/null || echo "${FILE_SIZE} bytes"))"
echo ""

# Install based on platform
if [[ "$PLATFORM" == "linux" ]]; then
    echo "Installing BrowserOS AppImage..."
    
    # Remove old version if exists
    if [[ -f "$INSTALL_DIR/BrowserOS.AppImage" ]]; then
        echo "Removing old version..."
        rm -f "$INSTALL_DIR/BrowserOS.AppImage"
    fi
    
    # Move and make executable
    mv "/tmp/$FILENAME" "$INSTALL_DIR/BrowserOS.AppImage"
    chmod +x "$INSTALL_DIR/BrowserOS.AppImage"
    
    echo "✓ AppImage installed to $INSTALL_DIR/BrowserOS.AppImage"
    echo ""
    
    # Create/update desktop entry
    DESKTOP_FILE="$DESKTOP_DIR/browseros.desktop"
    cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Name=BrowserOS
Comment=AI-powered web browser with automation agents
Exec=$INSTALL_DIR/BrowserOS.AppImage
Icon=browseros
Type=Application
Categories=Network;WebBrowser;
Terminal=false
EOF
    
    echo "✓ Desktop entry created/updated at $DESKTOP_FILE"
    echo ""
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        echo "Note: $INSTALL_DIR is not in your PATH."
        echo "Add the following line to your ~/.bashrc or ~/.zshrc:"
        echo ""
        echo "  export PATH=\"\$PATH:$INSTALL_DIR\""
        echo ""
    fi
    
    echo "==================================="
    echo "✓ BrowserOS updated successfully!"
    echo "==================================="
    echo ""
    echo "You can launch BrowserOS by:"
    echo "  1. Running: $INSTALL_DIR/BrowserOS.AppImage"
    echo "  2. Searching for 'BrowserOS' in your application menu"
    echo ""
    
    # Offer to launch
    read -p "Would you like to launch BrowserOS now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        "$INSTALL_DIR/BrowserOS.AppImage" &
        echo "BrowserOS launched in background."
    fi
    
elif [[ "$PLATFORM" == "macos" ]]; then
    echo "Installing BrowserOS on macOS..."
    
    DMG_PATH="/tmp/$FILENAME"
    
    echo "Opening DMG file..."
    echo "Please drag BrowserOS to your Applications folder when the window opens."
    echo ""
    
    open "$DMG_PATH"
    
    echo "==================================="
    echo "✓ BrowserOS DMG opened!"
    echo "==================================="
    echo ""
    echo "Next steps:"
    echo "  1. Drag BrowserOS to your Applications folder"
    echo "  2. Eject the BrowserOS disk image"
    echo "  3. Launch BrowserOS from Applications"
    echo ""
    echo "The DMG file is located at: $DMG_PATH"
    echo "You can delete it after installation."
fi

echo ""
echo "Update complete!"
