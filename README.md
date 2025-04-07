# Cursor Patch 🛠️

A maintenance script for enhancing Cursor editor on Linux systems. Removes window frame for better Wayland compatibility and provides easy update management.

<img src="./cursor.png" alt="Cursor Logo" width="100px">

## Features ✨
- Automated patching of Cursor AppImage
- Desktop integration with proper icon
- Built-in update mechanism
- Clean uninstall capability
- Wayland compatibility improvements

## Installation 📥

### Quick Install

Run the following command in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/mkarajohn/cursor_linux_patch_scripts/master/cursor-install.sh | bash
```

### Manual Install

1. Get the installation script:

* Either by downloading it directly:

```bash
wget https://raw.githubusercontent.com/mkarajohn/cursor_linux_patch_scripts/master/cursor-install.sh
```

* or by cloning the repo with `git clone git@github.com:mkarajohn/cursor_linux_patch_scripts.git` 

* or by downloading a `.zip` file of the repo

and then

2. Run the script:

```bash
cursor-install.sh
```

3. Update Cursor:

```bash
$HOME/Applications/cursor/cursor-update.sh
```

## Uninstallation

Run the following command in your terminal:

```bash
rm -rf $HOME/Applications/cursor $HOME/.icons/cursor.png $HOME/.local/share/applications/cursor.desktop
```

## Acknowledgments

- [Cursor](https://www.cursor.com/)
- [AppImage](https://appimage.org/)
- [AppImageKit](https://github.com/AppImage/AppImageKit)

