#!/bin/bash

# Error handling
set -e

# Prompt for install
echo
echo -ne "${YELLOW}Install LibreOffice? [Y]: ${NC}"
read -r install_libreoffice < /dev/tty
echo
install_libreoffice=${install_libreoffice:-Y}
if [[ $install_libreoffice =~ ^[Yy]$ ]]; then

  # Install LibreOffice and related packages
  sudo apt install -y \
    libreoffice \
    libreoffice-gtk3 \
    libreoffice-style-sifr \
    libreoffice-l10n-en-gb

  # Modify LibreOffice .desktop files to force dark mode
  for desktop_file in \
    /usr/share/applications/libreoffice-startcenter.desktop \
    /usr/share/applications/libreoffice-xsltfilter.desktop \
    /usr/share/applications/libreoffice-base.desktop \
    /usr/share/applications/libreoffice-calc.desktop \
    /usr/share/applications/libreoffice-draw.desktop \
    /usr/share/applications/libreoffice-impress.desktop \
    /usr/share/applications/libreoffice-math.desktop \
    /usr/share/applications/libreoffice-writer.desktop; do
    if [ -f "$desktop_file" ]; then
      sudo sed -i 's|^Exec=|Exec=env GTK_THEME=Adwaita:dark |' "$desktop_file"
    fi
  done

fi