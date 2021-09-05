#!/usr/bin/env bash

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ];
then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

read -rp "Establecer el password para root? (S/N): " PR
if [ "$PR" == 'S' ]; 
then
    passwd root
fi

read -rp "Corregir la resolucion en VMWare Workstation? (S/N): " RES
if [ "$RES" == 'S' ]; 
then
    cp /etc/vmware-tools/tools.conf.example /etc/vmware-tools/tools.conf
    sed -i 's/#enable=true/enable=true/g' "/etc/vmware-tools/tools.conf"
    systemctl restart vmtoolsd.service
fi

read -rp "Establecer el nombre del equipo? (S/N): " HN
if [ "$HN" == 'S' ]; 
then
    read -rp "Ingrese el nombre del equipo: " EQUIPO
    if [ -n "$EQUIPO" ]; 
    then
        echo -e "$EQUIPO" > /etc/hostname
    fi
fi

systemctl enable sshd

# Ajuste Swappiness
su - root <<EOF
        echo -e "vm.swappiness=10\n" >> /etc/sysctl.d/90-sysctl.conf
EOF

# Configuracion DNF
{
    echo 'fastestmirror=1'
    echo 'max_parallel_downloads=10'
} >> /etc/dnf/dnf.conf
dnf update -y

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
    'gnome-shell-extension-native-window-placement'
    'gnome-shell-extension-user-theme'
    'gnome-shell-extension-dash-to-dock'
    'gnome-shell-extension-no-overview'
    'gnome-shell-extension-pop-shell'
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
    'bash-completion'
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
    'python3-neovim'
    'emacs'
    'util-linux-user'
    'flameshot'
    'ktouch'
    'fd-find'
    'fzf'
    'the_silver_searcher'
    'libreoffice-langpack-es'
    'aspell'
    'x2goserver'
    'plank'
    'dconf-editor'
    'ulauncher'
    'rsync'
    'dnfdragora'
    'elementary-files'
    'elementary-terminal'

    #### Multimedia ####
    'elementary-music'
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
    'meson'
    'codeblocks'
    'python3-spyder'
    'rstudio-desktop'
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

    dnf copr enable dawid/better_fonts -y
    dnf install fontconfig-font-replacements -y
    dnf install fontconfig-enhanced-defaults -y
fi
################################################################################

############################# Codecs ###########################################
dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
dnf install lame\* --exclude=lame-devel -y
dnf group install --with-optional Multimedia -y
################################################################################

################################ Wallpapers #####################################
read -rp "Instalar Wallpapers? (S/N): " WPP
if [ "$WPP" == 'S' ]; then
    echo -e "\nInstalando wallpapers..."
    git clone https://github.com/gastongmartinez/wallpapers.git
    mv -f wallpapers/ "/usr/share/backgrounds/"
fi
#################################################################################

################################ Wallpapers #####################################
read -rp "Instalar PostgreSQL? (S/N): " PGS
if [ "$PGS" == 'S' ]; then
    rpm -i https://ftp.postgresql.org/pub/pgadmin/pgadmin4/yum/pgadmin4-fedora-repo-2-1.noarch.rpm
    dnf install postgresql-server -y
    dnf install pgadmin4 -y
    dnf install postgis -y
    dnf install postgis-client -y
    dnf install postgis-utils -y

    /usr/pgsql-13/bin/postgresql-13-setup initdb
    systemctl enable postgresql.service
    systemctl start postgresql.service
fi
#################################################################################

################################## WM ######################################
read -rp "Instalar Window Managers? (S/N): " AW
if [ "$AW" == 'S' ]; then
    AWPAQ=(
        'qtile'
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
sleep 2

reboot