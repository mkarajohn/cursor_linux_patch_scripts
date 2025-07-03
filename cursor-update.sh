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

APPIMAGE_URL=$(curl -s -H 'Accept: application/json' 'https://cursor.com/api/download?platform=linux-x64&releaseTrack=stable' | jq -r '.downloadUrl' | tr -d '"')

mkdir -p $TEMPDIR
pushd $TEMPDIR

curl -L "$APPIMAGE_URL" --output $TEMPDIR/cursor.AppImage.original
chmod +x $TEMPDIR/cursor.AppImage.original

# Extract the AppImage
$TEMPDIR/cursor.AppImage.original --appimage-extract
rm $TEMPDIR/cursor.AppImage.original

# Fix it by replacing all occurrences of ",minHeight" with ",frame:false,minHeight"
TARGET_FILE="squashfs-root/usr/share/cursor/resources/app/out/main.js"
sed -i 's/,minHeight/,frame:false,minHeight/g' "$TARGET_FILE"

# Repackage the AppImage using appimagetool
rm -f $BINDIR/cursor
$BINDIR/lib/appimagetool-x86_64.AppImage squashfs-root/ $BINDIR/cursor
chmod +x $BINDIR/cursor

popd

# Cleaning Up
rm -rf $TEMPDIR
