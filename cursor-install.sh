#!/bin/bash -ex

BINDIR=$HOME/bin
TEMPDIR=/tmp/cursor

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

mkdir -p $TEMPDIR $BINDIR $HOME/.icons $HOME/.local/share/applications

pushd $TEMPDIR


APPIMAGE_URL=$(curl --silent 'https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable' | jq '.downloadUrl' | tr -d '"')

curl --silent $APPIMAGE_URL --output $TEMPDIR/cursor.AppImage.original 
chmod +x $TEMPDIR/cursor.AppImage.original

# Extract the AppImage
$TEMPDIR/cursor.AppImage.original --appimage-extract
cp $TEMPDIR/squashfs-root/usr/share/icons/hicolor/128x128/apps/cursor.png $HOME/.icons/

curl --silent https://raw.githubusercontent.com/mxsteini/cursor_patch/main/cursor-update.sh --output $BINDIR/cursor-update.sh

cat <<EOF > $HOME/.local/share/applications/cursor.desktop
[Desktop Entry]
Name=Cursor
Exec=$BINDIR/cursor --enable-features=UseOzonePlatform --ozone-platform-hint=wayland %F
Path=$BINDIR
Icon=$HOME/.icons/cursor.png
Type=Application
Categories=Utility;Development;
StartupWMClass=Cursor
X-AppImage-Version=latest
Comment=Cursor is an AI-first coding environment.
MimeType=x-scheme-handler/cursor;


[Desktop Action new-empty-window]
Exec=$BINDIR/cursor --enable-features=UseOzonePlatformc --ozone-platform-hint --new-window %F
EOF

chmod +x $BINDIR/cursor-update.sh
popd

$BINDIR/cursor-update.sh
