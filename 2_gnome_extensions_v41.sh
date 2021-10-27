#!/usr/bin/env bash

R_USER=$(id -u)
if [ "$R_USER" -eq 0 ];
then
   echo "Este script debe usarse con un usuario regular."
   echo "Saliendo..."
   exit 1
fi

if [ -z "$DISPLAY" ];
then
    echo -e "Debe ejecutarse dentro del entorno grafico.\n"
    echo "Saliendo..."
    exit 2
fi

DIRE=$(pwd)
# Arc Menu
git clone https://gitlab.com/arcmenu/ArcMenu.git
cd ArcMenu || return
make install
cd "$DIRE" || return
rm -rf ArcMenu

# Sensory Perception
git clone https://github.com/HarlemSquirrel/gnome-shell-extension-sensory-perception.git
mv ./gnome-shell-extension-sensory-perception ~/.local/share/gnome-shell/extensions/sensory-perception@HarlemSquirrel.github.io
cd "$DIRE" || return

# Blur my shell
git clone https://github.com/aunetx/blur-my-shell
cd blur-my-shell || return
make install
cd "$DIRE" || return
rm -rf blur-my-shell

# Systemd Manager
git clone https://github.com/hardpixel/systemd-manager.git
cd systemd-manager || return
mv ./systemd-manager@hardpixel.eu ~/.local/share/gnome-shell/extensions/systemd-manager@hardpixel.eu
cd "$DIRE" || return
rm -rf systemd-manager

# Tiling assistant
git clone https://github.com/Leleat/Tiling-Assistant.git
cd Tiling-Assistant || return
mv ./tiling-assistant@leleat-on-github ~/.local/share/gnome-shell/extensions/tiling-assistant@leleat-on-github
cd "$DIRE" || return
rm -rf Tiling-Assistant

# Tweaks and Extensions in System Menu
git clone https://github.com/F-i-f/tweaks-system-menu.git
cd tweaks-system-menu || return
meson build
ninja -C build install
cd "$DIRE" || return
rm -rf tweaks-system-menu

# Quake-Mode
git clone https://github.com/repsac-by/gnome-shell-extension-quake-mode.git
cd gnome-shell-extension-quake-mode || return
gnome-extensions pack quake-mode@repsac-by.github.com --extra-source={quakemodeapp,util}.js
gnome-extensions install quake-mode@repsac-by.github.com.shell-extension.zip
cd "$DIRE" || return
rm -rf gnome-shell-extension-quake-mode

# Removable Drive
git clone https://gitlab.gnome.org/GNOME/gnome-shell-extensions.git
cd gnome-shell-extensions || return
meson build
ninja -C build install
cd "$DIRE" || return
rm -rf gnome-shell-extensions

sleep 2

reboot