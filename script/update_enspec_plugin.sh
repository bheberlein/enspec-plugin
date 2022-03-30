#!/usr/bin/env bash

# Plugin display name
PLUGIN_TITLE=EnSpec

# Username
USER="brendan"
# QGIS profile
PROFILE="default"

# Linux
if [ $OSTYPE == 'linux-gnu' ]; then
  SUPPORT_DIR="/home/$USER/.local/share"
# Mac OS
elif [ $OSTYPE == 'darwin20' ]; then
  SUPPORT_DIR="/Users/$USER/Library/Application\ Support"
# Windows MSYS/MINGW64 (Git Bash)
elif [ $OSTYPE == 'msys' ]; then
  USER="bheberlein.000"
  SUPPORT_DIR="C:/Users/$USER/AppData/Roaming"
fi

if [[ -z "$SUPPORT_DIR" ]]; then
  echo "ERROR: QGIS resource directory unknown!"
  exit 1
fi

# Location of QGIS Python plugin files
QGIS_PLUGIN_DIR="$SUPPORT_DIR/QGIS/QGIS3/profiles/$PROFILE/python/plugins"

# Get name in lowercase
PLUGIN_NAME=$(echo "$PLUGIN_TITLE" | awk '{print tolower($0)}')
# Get directory of the current script
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Get plugin directory
PLUGIN_DIR="$( dirname "$SCRIPT_DIR" )"
# Get path to plugin .ZIP archive
PLUGIN_ZIP="$PLUGIN_DIR/$PLUGIN_TITLE.zip"

# # Unzip to QGIS plugin directory
# unzip -o $PLUGIN_ZIP -d "$QGIS_PLUGIN_DIR"

# Create plugin directory as needed
mkdir -p "$QGIS_PLUGIN_DIR/$PLUGIN_TITLE"
# Clear QGIS plugin files
rm -rf "$QGIS_PLUGIN_DIR/$PLUGIN_TITLE"/*
# Copy working plugin files to QGIS
cp -r "$PLUGIN_DIR/$PLUGIN_NAME"/* "$QGIS_PLUGIN_DIR/$PLUGIN_TITLE"
