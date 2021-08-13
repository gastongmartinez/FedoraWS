#!/usr/bin/env bash

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ];
then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

read -rp "Desea establecer el password para root? (S/N): " PR
if [ "$PR" == 'S' ]; 
then
    passwd root
fi

read -rp "Desea corregir la resolucion en VMWare Workstation? (S/N): " RES
if [ "$RES" == 'S' ]; 
then
    cp /etc/vmware-tools/tools.conf.example /etc/vmware-tools/tools.conf
    sed -i 's/#enable=true/enable=true/g' "/etc/vmware-tools/tools.conf"
    systemctl restart vmtoolsd.service
fi

read -rp "Desea establecer el nombre del equipo? (S/N): " HN
if [ "$HN" == 'S' ]; 
then
    read -rp "Ingrese el nombre del equipo: " EQUIPO
    if [ -n "$EQUIPO" ]; 
    then
        echo -e "$EQUIPO" > /etc/hostname
    fi
fi

dnf update -y

systemctl enable sshd

# Ajuste Swappiness
su - root <<EOF
        echo -e "vm.swappiness=10\n" >> /etc/sysctl.d/90-sysctl.conf
EOF

# RPMFusion
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm -y
dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm -y

# Repositorio VSCode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update

# Brave
dnf install dnf-plugins-core -y
dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

############################### Apps Generales ################################
PAQUETES=(
    #### Powermanagement ####
    'tlp'
    'powertop'

    #### Gnome ####
    'gnome-tweaks'
    'gnome-extensions-app'
    'gnome-shell-extension-user-theme'
    'file-roller-nautilus'

    #### WEB ####
    'chromium'
    'thunderbird'
    'remmina'
    'qbittorrent'
    'brave-browser'
    'evolution'

    #### Shells ####
    'fish'
    'zsh'
    'zsh-autosuggestions'
    'zsh-syntax-highlighting'
    'dialog'
    'autojump'
    'autojump-fish'
    'autojump-zsh'
    'ShellCheck'

    #### Archivos ####
    'mc'
    'doublecmd-gtk'
    'vifm'
    'meld'
    'stow'
    'ripgrep'
    'exfatprogs'
    'autofs'

    #### Sistema ####
    'p7zip'
    'alacritty'
    'conky'
    'conky-manager'
    'htop'
    'bpytop'
    'neofetch'
    'lshw'
    'lshw-gui'
    'powerline'
    'neovim'
    'emacs'
    'util-linux-user'
    'flameshot'
    'ktouch'
    'fd-find'
    'fzf'
    'the_silver_searcher'
    'libreoffice-langpack-es'
    'x2goserver'
    'plank'
    'dconf-editor'
    'ulauncher'

    #### Multimedia ####
    'clementine'
    'vlc'
    'python-vlc'
    'mpv'

    #### Juegos ####
    'chromium-bsu'

    #### Redes ####
    'nmap'
    'wireshark'
    'firewall-applet'
    'firewall-config'

    #### Diseño ####
    'gimp'
    'inkscape'
    'krita'
    'blender'
    'freecad'

    #### DEV ####
    'clang'
    'codeblocks'
    'filezilla'
    'golang'
    'rust'
    'java-1.8.0-openjdk'
    #'java-latest-openjdk'
    'code'
    'nodejs'
    'npm'
)
 
for PAQ in "${PAQUETES[@]}"; do
    dnf install "$PAQ" -y
done
###############################################################################

########################## Virtualizacion #####################################
read -rp "Instalar virtualizacion? (S/N): " VIRT
if [ "$VIRT" == 'S' ]; then
    VIRTPKGS=(
        'virt-manager'
        'qemu-kvm'
        'edk2-ovmf'
        'ebtables-services'
        'dnsmasq'
        'bridge-utils'
    )
    for PAQ in "${VIRTPKGS[@]}"; do
        dnf install "$PAQ" -y
    done
fi
################################################################################

################################# Fuentes ######################################
read -rp "Instalar fuentes adicionales? (S/N): " FT
if [ "$FT" == 'S' ]; then
    FUENTES=(
        'terminus-fonts'
        'fontawesome-fonts'
        'cascadia-code-fonts'
        'texlive-roboto'
        'dejavu-fonts-all'
        'powerline-fonts'
        'fira-code-fonts'
        'cabextract'
        'xorg-x11-font-utils'
        'fontconfig'
    )
    for F in "${FUENTES[@]}"; do
        dnf install "$F" -y
    done
    rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
fi
################################################################################

################################ Wallpapers #####################################
read -rp "Instalar Wallpapers? (S/N): " WPP
if [ "$WPP" == 'S' ]; then
    echo -e "\nInstalando wallpapers..."
    git clone https://github.com/gastongmartinez/wallpapers.git
    mv -f wallpapers/ "/usr/share/backgrounds/"
fi
#################################################################################

################################## Iconos #######################################
read -rp "Instalar iconos? (S/N): " IC
if [ "$IC" == 'S' ]; then
    echo -e "\nInstalando iconos...\n"
    for ICON in ./Iconos/*.xz
    do
        tar -xf "$ICON" -C /usr/share/icons/
    done
fi
#################################################################################

################################ Temas GTK ######################################
read -rp "Instalar temas de escritorio? (S/N): " TM
if [ "$TM" == 'S' ]; then
    echo -e "\nInstalando temas GTK...\n"
    for TEMA in ./TemasGTK/*.xz
    do
        tar -xf "$TEMA" -C /usr/share/themes/
    done
fi
#################################################################################

######################## Extensiones Gnome ######################################
read -rp "Instalar Extensiones Gnome? (S/N): " EXT
if [ "$EXT" == 'S' ]; then
    HOMEDIR=$(grep "1000" /etc/passwd | awk -F : '{ print $6 }')
    USER=$(grep "1000" /etc/passwd | awk -F : '{ print $1 }')
    PWD=$(pwd)
    for ARCHIVO in "$PWD"/Extensiones/*.zip
    do
        UUID=$(unzip -c "$ARCHIVO" metadata.json | grep uuid | cut -d \" -f4)
        mkdir -p "$HOMEDIR"/.local/share/gnome-shell/extensions/"$UUID"
        unzip -q "$ARCHIVO" -d "$HOMEDIR"/.local/share/gnome-shell/extensions/"$UUID"/
    done
    chown -R "$USER":"$USER" "$HOMEDIR"/.local/
fi
#################################################################################

################################## Awesome ######################################
read -rp "Instalar AwesomeWM? (S/N): " AW
if [ "$AW" == 'S' ]; then
    AWPAQ=(
        'awesome'
        'dmenu'
        'rofi'
        'nitrogen'
        'feh'
        'picom'
        'lxappearance'
    )
    for PAQ in "${AWPAQ[@]}"; do
        dnf install "$PAQ" -y
    done
    sed -i 's/Name=awesome/Name=Awesome/g' "/usr/share/xsessions/awesome.desktop"
fi
#################################################################################

############################### GRUB ############################################
cp /usr/share/grub/unicode.pf2 /boot/efi/EFI/fedora/fonts/unicode.pf2
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes || return
./install.sh
#################################################################################
reboot