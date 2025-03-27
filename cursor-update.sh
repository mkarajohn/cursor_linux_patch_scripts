#!/bin/bash -ex

BINDIR=$HOME/bin
TEMPDIR=/tmp/cursor
APPIMAGE_URL=$(curl --silent 'https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable' | jq '.downloadUrl' | tr -d '"')

mkdir -p $TEMPDIR
pushd $TEMPDIR

curl $APPIMAGE_URL --output $TEMPDIR/cursor.AppImage.original 
chmod +x $TEMPDIR/cursor.AppImage.original

# Extract the AppImage
$TEMPDIR/cursor.AppImage.original --appimage-extract
rm $TEMPDIR/cursor.AppImage.original

# Fix it by replacing all occurrences of ",minHeight" with ",frame:false,minHeight"
TARGET_FILE="squashfs-root/usr/share/cursor/resources/app/out/main.js"
sed -i 's/,minHeight/,frame:false,minHeight/g' "$TARGET_FILE"

# Download latest appimagetool
curl -L -o $TEMPDIR/appimagetool-x86_64.AppImage https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x $TEMPDIR/appimagetool-x86_64.AppImage

# Repackage the AppImage using appimagetool
rm -f $BINDIR/cursor
$TEMPDIR/appimagetool-x86_64.AppImage squashfs-root/ $BINDIR/cursor
chmod +x $BINDIR/cursor

popd
# Cleaning Up
#rm -rf $TEMPDIR
