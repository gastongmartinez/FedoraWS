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
# dnf install dnf-plugins-core -y
# dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sh -c 'echo -e "[brave-browser-rpm-release.s3.brave.com_x86_64_]\nname=created by dnf config-manager from https://brave-browser-rpm-release.s3.brave.com/x86_64/\nbaseurl=https://brave-browser-rpm-release.s3.brave.com/x86_64/\nenabled=1" > /etc/yum.repos.d/brave-browser-rpm-release.s3.brave.com_x86_64_.repo'
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

# CORP
# dnf copr enable frostyx/qtile -y
dnf copr enable atim/lazygit -y
dnf copr enable dawid/better_fonts -y

USER=$(grep "1000" /etc/passwd | awk -F : '{ print $1 }')

############################### Apps Generales ################################
PAQUETES=(
    #### Powermanagement ####
    'tlp'
    'tlp-rdw'
    'powertop'

    #### Gnome ####
    'gnome-tweaks'
    'gnome-feeds'
    'gnome-extensions-app'
    'gnome-shell-extension-user-theme'
    'gnome-shell-extension-native-window-placement'
    'gnome-shell-extension-dash-to-dock'
    'gnome-shell-extension-no-overview'
    'gnome-shell-extension-pop-shell'
    'gnome-shell-extension-caffeine'
    #'gnome-shell-extension-sound-output-device-chooser'
    'gnome-commander'
    'file-roller-nautilus'

    #### WEB ####
    'chromium'
    'thunderbird'
    'remmina'
    'qbittorrent'
    'brave-browser'

    #### Shells ####
    'zsh'
    'zsh-autosuggestions'
    'zsh-syntax-highlighting'
    'bash-completion'
    'dialog'
    'autojump'
    'autojump-zsh'
    'ShellCheck'

    #### Archivos ####
    'mc'
    'thunar'
    'vifm'
    'meld'
    'stow'
    'ripgrep'
    'autofs'

    #### Sistema ####
    'lsd'
    'corectrl'
    'p7zip'
    'unrar'
    'alacritty'
    'kitty'
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
    'klavaro'
    'fd-find'
    'fzf'
    'the_silver_searcher'
    'libreoffice-langpack-es'
    'qalculate'
    'qalculate-gtk'
    'foliate'
    'aspell'
    'pandoc'
    'dconf-editor'
    'ulauncher'
    'rsync'
    'dnfdragora'
    'elementary-terminal'
    'stacer'
    'timeshift'
    'setroubleshoot'

    #### Multimedia ####
    'elisa-player'
    'vlc'
    'python-vlc'
    'mpv'

    #### Juegos ####
    'chromium-bsu'
    'retroarch'

    #### Redes ####
    'nmap'
    'wireshark'
    'firewall-applet'
    'gns3-gui'
    'gns3-server'

    #### Diseño ####
    'gimp'
    'inkscape'
    'krita'
    'blender'

    #### DEV ####
    'clang'
    'cmake'
    'meson'
    'pipenv'
    'python3-spyder'
    'rstudio-desktop'
    'filezilla'
    'sbcl'
    'golang'
    'rust'
    'cargo'
    'java-1.8.0-openjdk'
    #'java-latest-openjdk'
    'code'
    'tidy'
    'nodejs'
    'npm'
    'yarnpkg'
    'lazygit'

    #### Fuentes ####
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
    'google-carlito-fonts'
    'texlive-caladea'
    'fontforge'
    'fontconfig-font-replacements'
    'fontconfig-enhanced-defaults'
)
 
for PAQ in "${PAQUETES[@]}"; do
    dnf install "$PAQ" -y
done

rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
###############################################################################

########################## Virtualizacion #####################################
read -rp "Instalar virtualizacion? (S/N): " VIRT
if [ "$VIRT" == 'S' ]; then
    VIRTPKGS=(
        'virt-manager'
        'qemu-kvm'
        'libvirt-client'
        'edk2-ovmf'
        'ebtables-services'
        'dnsmasq'
        'bridge-utils'
        'uml_utilities'
        'libguestfs'
    )
    for PAQ in "${VIRTPKGS[@]}"; do
        dnf install "$PAQ" -y
    done
    usermod -aG libvirt "$USER"
    usermod -aG kvm "$USER"
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

############################## Bases de Datos ###################################
read -rp "Instalar Bases de Datos? (S/N): " PGS
if [ "$PGS" == 'S' ]; then
    #rpm -i https://ftp.postgresql.org/pub/pgadmin/pgadmin4/yum/pgadmin4-fedora-repo-2-1.noarch.rpm
    dnf install postgresql-server -y
    dnf install pgadmin4 -y
    dnf install postgis -y
    dnf install postgis-client -y
    dnf install postgis-utils -y

    postgresql-setup --initdb --unit postgresql
    # systemctl enable postgresql.service

    dnf install mariadb-server-utils -y
fi
#################################################################################

#################################################################################
read -rp "Instalar Cockpit? (S/N): " CKP
if [ "$CKP" == 'S' ]; then
    dnf install cockpit -y
    dnf install cockpit-sosreport -y
    dnf install cockpit-machines -y
    dnf install cockpit-podman -y
    dnf install cockpit-selinux -y
    dnf install cockpit-navigator -y
    systemctl enable --now cockpit.socket
    firewall-cmd --add-service=cockpit
    firewall-cmd --add-service=cockpit --permanent
fi
#################################################################################

sed -i "s/Icon=\/var\/lib\/AccountsService\/icons\/$USER/Icon=\/usr\/share\/backgrounds\/wallpapers\/Fringe\/fibonacci3.jpg/g" "/var/lib/AccountsService/users/$USER"

################################## WM ######################################
read -rp "Instalar Window Managers? (S/N): " AW
if [ "$AW" == 'S' ]; then
    AWPAQ=(
        #'qtile'
        'awesome'
        'dmenu'
        'rofi'
        'nitrogen'
        'feh'
        'picom'
        'lxappearance'
        'xorg-x11-server-Xephyr'
    )
    for PAQ in "${AWPAQ[@]}"; do
        dnf install "$PAQ" -y
    done
    sed -i 's/Name=awesome/Name=Awesome/g' "/usr/share/xsessions/awesome.desktop"
fi
#################################################################################

############################### GRUB ############################################
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes || return
./install.sh
#################################################################################

read -rp "Modificar fstab? (S/N): " FST
if [ "$FST" == 'S' ]; then
    sed -i 's/subvol=@/compress=zstd,noatime,space_cache=v2,ssd,discard=async,subvol=@/g' "/etc/fstab"
fi

alternatives --set java java-1.8.0-openjdk.x86_64

sleep 2

reboot
