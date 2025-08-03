#!/bin/bash

DOTCONFIGS=(
  "~/.config/alacritty/"
  "~/.config/hypr/"
  "~/.config/waybar/"
)
DOTCONFIGSDESTINATION="~/Other/ArchConfigFiles/home/USER/.config"

SDDMCONFIGS="/usr/share/sddm/themes/"
SDDMCONFIGSDESTINATION="~/Other/ArchConfigFiles/usr/share/sddm/"

echo "copying congfig files ..."
for dotConfig in "${DOTCONFIGS[@]}"; do
  cp -r "$dotConfig" "$DOTCONFIGSDESTINATION"
done
git status

while true; do
  read -p "add changes? (Y/n): " ADD_CHOICE
  ADD_CHOICE=${ADD_CHOICE,,}
  if [[ -z "$ADD_CHOICE" || "$ADD_CHOICE" == "y" ]]; then
    git add .
    break
  elif [[ "$ADD_CHOICE" == "n" ]]; then
    echo "configs copied but not added!"
    exit 0
  else
    echo "invalid input"
  fi
done
git status

while true; do
  read -p "commit changes? (Y/n): " COMMIT_CHOICE
  COMMIT_CHOICE=${COMMIT_CHOICE,,}
  if [[ -z "$COMMIT_CHOICE" || "$COMMIT_CHOICE" == "y" ]]; then
    git commit -m "config files from $(date '+%Y-%m-%d')"
    break
  elif [[ "$COMMIT_CHOICE" == "n" ]]; then
    echo "changes not commited!"
    exit 0
  else
    echo "invalid input"
  fi
done
git log -n 2

while true; do
  read -p "push changes? (y/N): " PUSH_CHOICE
  PUSH_CHOICE=${PUSH_CHOICE,,}
  if [[ "$PUSH_CHOICE" == "y" ]]; then
    git push -u origin master
    break
  elif [[ -z "$PUSH_CHOICE" || "$PUSH_CHOICE" == "n" ]]; then
    echo "changes not pushed!"
    exit 0
  else
    echo "invalid input"
  fi
done
git status
