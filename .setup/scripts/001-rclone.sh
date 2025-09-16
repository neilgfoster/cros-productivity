#!/bin/bash

# Error handling
set -e

# Install onedrive
sudo apt install -y \
  onedrive

# Create local sync directory
mkdir -p ~/onedrive

# Create OneDrive config directory if it doesn't exist
mkdir -p ~/.config/onedrive

# Set sync_list to only include 'ChromeOS/'
echo "ChromeOS/" > ~/.config/onedrive/sync_list

# Set sync_dir in config (create if missing)
if ! grep -q '^sync_dir' ~/.config/onedrive/config 2>/dev/null; then
  echo "sync_dir = \"~/onedrive\"" >> ~/.config/onedrive/config
else
  sed -i 's|^sync_dir.*|sync_dir = "~/onedrive"|' ~/.config/onedrive/config
fi

# Run authentication if not already done
if [ ! -f ~/.config/onedrive/refresh_token ]; then
  echo "\n=== OneDrive Authentication Required ==="
  echo "Launching 'onedrive' for authentication..."
  onedrive
  if [ ! -f ~/.config/onedrive/refresh_token ]; then
    echo "Authentication failed or not completed. Please run 'onedrive' manually and re-run this script."
    exit 1
  fi
fi

# Enable and start OneDrive systemd user service for background sync
systemctl --user enable onedrive
systemctl --user start onedrive