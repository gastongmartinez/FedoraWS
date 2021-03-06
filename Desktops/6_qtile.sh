#!/usr/bin/env bash

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ];
then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

dnf install python3-cffi -y
dnf install python3-xcffib -y
dnf install python3-cairocffi -y
dnf install pango -y
dnf install python3-dbus-next -y
dnf install xorg-x11-server-Xephyr -y
dnf install python3-pyvirtualdisplay -y

pip install --no-cache-dir cairocffi

git clone https://github.com/qtile/qtile.git
cd qtile || return
pip install .
cd ..
rm -rf qtile

{
    echo '[Desktop Entry]'
    echo 'Name=Qtile'
    echo 'Comment=A hackable tiling window manager written and configured in Python'
    echo 'TryExec=qtile'
    echo 'Exec=qtile start'
    echo 'Type=Application'
} > /usr/share/xsessions/qtile.desktop
