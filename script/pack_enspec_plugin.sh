#!/usr/bin/env bash

# Plugin display name
PLUGIN_TITLE=EnSpec

echo "Packaging files for plugin ${PLUGIN_TITLE}"

# Get name in lowercase
PLUGIN_NAME=$(echo "$PLUGIN_TITLE" | awk '{print tolower($0)}')
# Get directory of the current script
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Get plugin directory
PLUGIN_DIR="$( dirname "$SCRIPT_DIR" )"
# Get path to plugin .ZIP archive
PLUGIN_ZIP="$PLUGIN_DIR/$PLUGIN_TITLE.zip"

TMP_DIR=$PLUGIN_DIR/tmp
mkdir $TMP_DIR && cd $TMP_DIR

# Remove existing .ZIP, if present
rm -f $PLUGIN_ZIP
# Link directory under a titlecase alias
ln -s "$PLUGIN_DIR/$PLUGIN_NAME" $PLUGIN_TITLE
# Compress plugin files to .ZIP
zip -r $PLUGIN_ZIP $PLUGIN_TITLE
# Remove temporary alias
cd ../ && rm -r $TMP_DIR
