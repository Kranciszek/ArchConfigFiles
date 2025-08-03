#!/bin/bash

# This script does NOT back up YOUR config files, it DELETES them to put in the new ones
# This script is NOT tested in real world application but it should be correct
# RUN AT YOUR OWN RISK!!

DOTCONFIGS=(
  "alacritty"
  "hypr"
  "waybar"
)
DOTCONFIGSORIGIN="./home/USER/.config"
DOTCONFIGSDESTINATION="$HOME/.config"

SDDMCONFIGS=(
  "themes"
)
SDDMCONFIGSORIGIN="./usr/share/sddm"
SDDMCONFIGSDESTINATION="/usr/share/sddm"

while true; do
  read -p "install configs? (y/N): " INSTALL_CHOICE
  INSTALL_CHOICE=${INSTALL_CHOICE,,}
  if [[ "$INSTALL_CHOICE" == "y" ]]; then
    while true; do
      read -p "install (default [2]): [1]ALL configs, [2]Ask to choose configs to install: " INSTALL_MODE_CHOICE
      if [[ "$INSTALL_MODE_CHOICE" == "1" ]]; then
        echo "installing config files ..."
        for dotConfig in "${DOTCONFIGS[@]}"; do
          rsync -a --delete "$DOTCONFIGSORIGIN/$dotConfig" "$DOTCONFIGSDESTINATION/"
        done
        for sddmConfig in "${SDDMCONFIGS[@]}"; do
          rsync -a --delete "$SDDMCONFIGSORIGIN/$sddmConfig" "$SDDMCONFIGSDESTINATION/"
        done
        break

      elif [[ -z "$INSTALL_MODE_CHOICE" || "$INSTALL_MODE_CHOICE" == "2" ]]; then
        echo "choose configs to install"
        for dotConfig in "${DOTCONFIGS[@]}"; do
          while true; do
            read -p "install .config for: ${dotConfig}? (Y/n): " CONFIG_CHOICE
            CONFIG_CHOICE=${CONFIG_CHOICE,,}
            if [[ -z "$CONFIG_CHOICE" || "$CONFIG_CHOICE" == "y" ]]; then
              rsync -a --delete "$DOTCONFIGSORIGIN/$dotConfig" "$DOTCONFIGSDESTINATION/"
              break
            elif [[ "$CONFIG_CHOICE" == "n" ]]; then
              echo "skipping .config for: ${dotConfig}"
              break
            else
              echo "invalid input"
            fi
          done
        done
        for sddmConfig in "${SDDMCONFIGS[@]}"; do
          while true; do
            read -p "install sddm config for: ${sddmConfig}? (Y/n): " CONFIG_CHOICE
            CONFIG_CHOICE=${CONFIG_CHOICE,,}
            if [[ -z "$CONFIG_CHOICE" || "$CONFIG_CHOICE" == "y" ]]; then
              rsync -a --delete "$SDDMCONFIGSORIGIN/$sddmConfig" "$SDDMCONFIGSDESTINATION/"
              break
            elif [[ "$CONFIG_CHOICE" == "n" ]]; then
              echo "skipping sddm config for: ${sddmConfig}"
              break
            else
              echo "invalid input"
            fi
          done
        done

      else
        echo "invalid input"
      fi
    done

  elif [[ -z "$INSTALL_CHOICE" || "$INSTALL_CHOICE" == "n" ]]; then
    echo "configs not installed!"
    exit 0
  else
    echo "invalid input"
  fi
done
