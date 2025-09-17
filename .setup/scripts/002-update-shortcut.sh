#!/bin/bash
# https://gist.github.com/alexsch01/6dab644fc8348a6874098e53377ccc98

# Error handling
set -e

# Path to the desktop shortcut
SHORTCUT="$HOME/.local/share/applications/Waydroid.desktop"

# Check if the shortcut exists
if [ -f "$SHORTCUT" ]; then
  sed -i 's/^Exec=.*/Exec=start-waydroid/' "$SHORTCUT"
fi