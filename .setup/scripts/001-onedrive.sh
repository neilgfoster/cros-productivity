
#!/bin/bash

# Error handling
set -e

# Prompt for install
echo
echo -ne "${YELLOW}Install OneDrive? [Y]: ${NC}"
read -r install_onedrive < /dev/tty
echo
install_onedrive=${install_onedrive:-Y}
if [[ $install_onedrive =~ ^[Yy]$ ]]; then

  # Prompt for target directory
  echo -ne "${YELLOW}Enter the target directory (default: ~/onedrive): ${NC}"
  read -r target_dir < /dev/tty
  target_dir=${target_dir:-onedrive}

  # Prompt for folders to sync
  echo -ne "${YELLOW}Enter the OneDrive folders to sync (comma separated, default: ChromeOS): ${NC}"
  read -r sync_folders < /dev/tty
  sync_folders=${sync_folders:-ChromeOS}

  # Prompt for sync period
  echo -ne "${YELLOW}Enter the sync period in seconds (default: 60): ${NC}"
  read -r sync_period < /dev/tty
  sync_period=${sync_period:-60}

  # Install dependencies
  echo
  sudo apt install -y wget gpg

  # Install OneDrive client from OBS repository
  DEB_VER=$(lsb_release -r | awk '{print $2}')
  REPO_VER="Debian_${DEB_VER}"
  sudo rm -f /etc/apt/sources.list.d/onedrive.list
  wget -qO - "https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/${REPO_VER}/Release.key" | gpg --dearmor | sudo tee /usr/share/keyrings/obs-onedrive.gpg > /dev/null
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/obs-onedrive.gpg] https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/${REPO_VER}/ ./" | sudo tee /etc/apt/sources.list.d/onedrive.list
  sudo apt update
  sudo apt install -y onedrive

  # Run authentication if not already done
  if [ ! -f ~/.config/onedrive/refresh_token ]; then
    echo
    echo -e "${YELLOW}You will be now prompted to authenticate with your Microsoft account.${NC}"
    echo
    onedrive < /dev/tty
  fi

  # Create local sync directory
  mkdir -p ~/${target_dir}

  # Create OneDrive config directory if it doesn't exist
  mkdir -p ~/.config/onedrive

  # Remove old config
  rm -f ~/.config/onedrive/config

  # Set sync_list to include specified folders
  IFS=',' read -ra FOLDERS <<< "$sync_folders"
  > ~/.config/onedrive/sync_list
  for folder in "${FOLDERS[@]}"; do
    echo "${folder// /}/" >> ~/.config/onedrive/sync_list
  done

  # Set sync_dir and monitor_interval in config (create if missing)
  if ! grep -q '^sync_dir' ~/.config/onedrive/config 2>/dev/null; then
    echo "sync_dir = \"~/${target_dir}\"" >> ~/.config/onedrive/config
  else
    sed -i "s|^sync_dir.*|sync_dir = \"~/${target_dir}\"|" ~/.config/onedrive/config
  fi
  if ! grep -q '^monitor_interval' ~/.config/onedrive/config 2>/dev/null; then
    echo "monitor_interval = \"${sync_period}\"" >> ~/.config/onedrive/config
  else
    sed -i "s|^monitor_interval.*|monitor_interval = \"${sync_period}\"|" ~/.config/onedrive/config
  fi

  # Enable and start the systemd user service
  if ! systemctl --user is-enabled onedrive &>/dev/null; then
    onedrive --resync --synchronize -y < /dev/tty
    systemctl --user enable onedrive
  fi
  if ! systemctl --user is-active onedrive &>/dev/null; then
    systemctl --user start onedrive
  fi

fi