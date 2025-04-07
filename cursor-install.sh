#!/bin/bash -ex

# Default installation directory
DEFAULT_BINDIR=$HOME/Applications/cursor

# Parse command line arguments
if [ $# -eq 1 ]; then
    BINDIR="$1"
else
    BINDIR="$DEFAULT_BINDIR"
fi

TEMPDIR=$BINDIR/tmp

# Install dependencies
# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install jq and try again."
    echo "You can install it with: sudo apt-get install jq (Debian/Ubuntu) or sudo yum install jq (CentOS/RHEL)"
    exit 1
fi

if ! command -v curl &> /dev/null; then
    echo "Error: curl is not installed. Please install curl and try again."
    echo "You can install it with: sudo apt-get install curl (Debian/Ubuntu) or sudo yum install curl (CentOS/RHEL)"
    exit 1
fi

if ! command -v tr &> /dev/null; then
    echo "Error: tr is not installed. Please install tr and try again."
    echo "You can install it with: sudo apt-get install tr (Debian/Ubuntu) or sudo yum install tr (CentOS/RHEL)"
    exit 1
fi

mkdir -p $BINDIR/icons $BINDIR/lib $HOME/.local/share/applications

# Check and copy or download cursor.png
if [ -f ./cursor.png ]; then
    cp ./cursor.png $BINDIR/icons/cursor.png
else
    echo "cursor.png not found locally. Downloading..."
    curl -L -o $BINDIR/icons/cursor.png https://raw.githubusercontent.com/mkarajohn/cursor_linux_patch_scripts/master/cursor.png
fi

# Check and copy or download cursor-update.sh
if [ -f ./cursor-update.sh ]; then
    cp ./cursor-update.sh $BINDIR/cursor-update.sh
else
    echo "cursor-update.sh not found locally. Downloading..."
    curl -L -o $BINDIR/cursor-update.sh https://raw.githubusercontent.com/mkarajohn/cursor_linux_patch_scripts/master/cursor-update.sh
fi
chmod +x $BINDIR/cursor-update.sh

# Download latest appimagetool
curl -L -o $BINDIR/lib/appimagetool-x86_64.AppImage https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x $BINDIR/lib/appimagetool-x86_64.AppImage

cat <<EOF > $HOME/.local/share/applications/cursor.desktop
[Desktop Entry]
Name=Cursor
Exec=$BINDIR/cursor --no-sandbox --enable-features=UseOzonePlatform --ozone-platform-hint=wayland %F
Path=$BINDIR
Icon=$BINDIR/icons/cursor.png
Type=Application
Categories=Utility;Development;
StartupWMClass=Cursor
X-AppImage-Version=latest
Comment=Cursor is an AI-first coding environment.
MimeType=x-scheme-handler/cursor;
Terminal=false

[Desktop Action new-empty-window]
Exec=$BINDIR/cursor --no-sandbox --enable-features=UseOzonePlatform --ozone-platform-hint --new-window %F
EOF

$BINDIR/cursor-update.sh "$BINDIR"
