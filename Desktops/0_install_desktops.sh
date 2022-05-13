#!/usr/bin/env bash

#################################################################################
read -rp "Instalar XFCE? (S/N): " XFCE
if [ "$XFCE" == 'S' ]; then
    dnf install @xfce-desktop-environment -y
fi
#################################################################################

#################################################################################
read -rp "Instalar Mate? (S/N): " MT
if [ "$MT" == 'S' ]; then
    dnf install @mate-desktop -y
    dnf install @mate-applications -y
fi
#################################################################################

#################################################################################
read -rp "Instalar KDE? (S/N): " KDE
if [ "$KDE" == 'S' ]; then
    dnf install @kde-desktop -y
    dnf install kvantum -y
    dnf install latte-dock -y
    dnf install krusader -y
    dnf install ksysguard -y
    dnf install yakuake -y
    dnf install kcolorchooser -y
    dnf install kalarm -y
    dnf install artikulate -y
fi
#################################################################################