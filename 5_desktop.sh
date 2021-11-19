#!/usr/bin/env bash

read -rp "Habilitar layout Windows? (S/N): " WIN
if [ "$WIN" == 'S' ]; then
    dconf write /org/gnome/shell/enabled-extensions "['background-logo@fedorahosted.org', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'arcmenu@arcmenu.com', 'quake-mode@repsac-by.github.com', 'drive-menu@gnome-shell-extensions.gcampax.github.com', 'Vitals@CoreCoding.com', 'systemd-manager@hardpixel.eu', 'tiling-assistant@leleat-on-github', 'tweaks-system-menu@extensions.gnome-shell.fifi.org', 'blur-my-shell@aunetx', 'no-overview@fthx', 'pop-shell@system76.com', 'dash-to-panel@jderose9.github.com', 'sound-output-device-chooser@kgshank.net']"
    dconf write /org/gnome/shell/disabled-extensions "['dash-to-dock@micxgx.gmail.com']"

    dconf write /org/gnome/shell/extensions/dash-to-panel/panel-element-positions "'{\"0\":[{\"element\":\"showAppsButton\",\"visible\":false,\"position\":\"stackedTL\"},{\"element\":\"activitiesButton\",\"visible\":false,\"position\":\"stackedTL\"},{\"element\":\"leftBox\",\"visible\":true,\"position\":\"stackedTL\"},{\"element\":\"taskbar\",\"visible\":true,\"position\":\"stackedTL\"},{\"element\":\"centerBox\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"rightBox\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"dateMenu\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"systemMenu\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"desktopButton\",\"visible\":true,\"position\":\"stackedBR\"}]}'"
 
    dconf write /org/gnome/shell/extensions/dash-to-panel/panel-sizes "'{\"0\":34}'"
    dconf write /org/gnome/shell/extensions/dash-to-panel/appicon-margin 0
    dconf write /org/gnome/shell/extensions/dash-to-panel/intellihide false
else
    dconf write /org/gnome/shell/enabled-extensions "['background-logo@fedorahosted.org', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'arcmenu@arcmenu.com', 'quake-mode@repsac-by.github.com', 'drive-menu@gnome-shell-extensions.gcampax.github.com', 'Vitals@CoreCoding.com', 'systemd-manager@hardpixel.eu', 'tiling-assistant@leleat-on-github', 'tweaks-system-menu@extensions.gnome-shell.fifi.org', 'blur-my-shell@aunetx', 'no-overview@fthx', 'pop-shell@system76.com', 'dash-to-dock@micxgx.gmail.com', 'sound-output-device-chooser@kgshank.net']"
    dconf write /org/gnome/shell/disabled-extensions "['dash-to-panel@jderose9.github.com']"
fi