#!/usr/bin/env bash

R_USER=$(id -u)
if [ "$R_USER" -ne 0 ];
then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

HDIR=$(grep "1000" /etc/passwd | awk -F : '{ print $6 }')

sed -i 's/"40"/"40",\n    "41"/g' "$HDIR/.local/share/gnome-shell/extensions/sensory-perception@HarlemSquirrel.github.io/metadata.json"

sed -i 's/"40.0"/"40.0",\n    "41"/g' "$HDIR/.local/share/gnome-shell/extensions/tweaks-system-menu@extensions.gnome-shell.fifi.org/metadata.json"

sed -i 's/"40.beta"/"40.beta",\n        "41"/g' "/usr/share/gnome-shell/extensions/pop-shell@system76.com/metadata.json"
