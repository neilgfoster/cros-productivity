#!/bin/bash

# Error handling
set -e

# Install dependencies
sudo apt install -y wget gpg

# Install onedrive using OpenSuSE Build Service repository (recommended)
# For Ubuntu 22.04 (Jammy). Change xUbuntu_22.04 to match your OS if needed.
wget -qO - https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /usr/share/keyrings/obs-onedrive.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/obs-onedrive.gpg] https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_22.04/ ./" | sudo tee /etc/apt/sources.list.d/onedrive.list
sudo apt update
sudo apt install --no-install-recommends --no-install-suggests -y onedrive

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