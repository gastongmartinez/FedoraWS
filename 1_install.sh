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

# MESA
read -rp "Cambiar drivers de video a MESA Freeworld? (S/N): " MESA
if [ "$MESA" == 'S' ]; 
then
    dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y
    dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y
fi

# Repositorios VSCode y Powershell 
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
curl https://packages.microsoft.com/config/rhel/7/prod.repo | tee /etc/yum.repos.d/microsoft.repo
dnf check-update
dnf makecache

# Brave
sh -c 'echo -e "[brave-browser-rpm-release.s3.brave.com_x86_64_]\nname=created by dnf config-manager from https://brave-browser-rpm-release.s3.brave.com/x86_64/\nbaseurl=https://brave-browser-rpm-release.s3.brave.com/x86_64/\nenabled=1" > /etc/yum.repos.d/brave-browser-rpm-release.s3.brave.com_x86_64_.repo'
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

# Librewolf
dnf config-manager --add-repo https://rpm.librewolf.net/librewolf-repo.repo

# CORP
dnf copr enable frostyx/qtile -y
dnf copr enable atim/lazygit -y
dnf copr enable varlad/helix -y
dnf copr enable erikreider/SwayNotificationCenter -y

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
    'gnome-commander'
    'file-roller-nautilus'

    #### WEB ####
    'chromium'
    'librewolf'
    'thunderbird'
    'remmina'
    'qbittorrent'
    'brave-browser'

    #### Shells ####
    'zsh'
    'zsh-autosuggestions'
    'zsh-syntax-highlighting'
    'dialog'
    'autojump'
    'autojump-zsh'
    'ShellCheck'
    'powershell'

    #### Archivos ####
    'mc'
    'thunar'
    'vifm'
    'stow'
    'ripgrep'
    'autofs'

    #### Sistema ####
    'tldr'
    'helix'
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
    'qalculate'
    'qalculate-gtk'
    'foliate'
    'aspell'
    'pandoc'
    'dconf-editor'
    'ulauncher'
    'dnfdragora'
    'stacer'
    'timeshift'
    'setroubleshoot'

    #### Multimedia ####
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
    'java-1.8.0-openjdk'
    'lldb'
    'code'
    'tidy'
    'nodejs'
    'yarnpkg'
    'lazygit'
    'pcre-cpp'

    #### Fuentes ####
    'terminus-fonts'
    'fontawesome-fonts'
    'cascadia-code-fonts'
    'texlive-roboto'
    'dejavu-fonts-all'
    'fira-code-fonts'
    'cabextract'
    'xorg-x11-font-utils'
    'texlive-caladea'
    'fontforge'

    ### Bases de datos ###
    'postgresql-server'
    'pgadmin4'
    'postgis'
    'postgis-client'
    'postgis-utils'
    'community-mysql-server'
    'sqlite'

    ### Cockpit ###
    'cockpit'
    'cockpit-sosreport'
    'cockpit-machines'
    'cockpit-podman'
    'cockpit-selinux'
    'cockpit-navigator'

    ### Virtualizacion ###
    'virt-manager'
    'ebtables-services'
    'bridge-utils'
    'libguestfs'
)
 
for PAQ in "${PAQUETES[@]}"; do
    dnf install "$PAQ" -y
done

rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
rpm -i https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-8.0.31-1.fc37.x86_64.rpm
###############################################################################

############################# Codecs ###########################################
dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
dnf install lame\* --exclude=lame-devel -y
dnf group install --with-optional Multimedia -y
################################################################################

################################ Wallpapers #####################################
echo -e "\nInstalando wallpapers..."
git clone https://github.com/gastongmartinez/wallpapers.git
mv -f wallpapers/ "/usr/share/backgrounds/"
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
        'xorg-x11-server-Xephyr'
        'jgmenu'
        'i3lock'
        'sway'
        'grimshot'
        'waybar'
        'wofi'
        'wlr-randr'
        'wlogout'
        'SwayNotificationCenter'
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

sed -i "s/Icon=\/var\/lib\/AccountsService\/icons\/$USER/Icon=\/usr\/share\/backgrounds\/wallpapers\/Fringe\/fibonacci3.jpg/g" "/var/lib/AccountsService/users/$USER"

usermod -aG libvirt "$USER"
usermod -aG kvm "$USER"

postgresql-setup --initdb --unit postgresql
systemctl enable --now cockpit.socket
firewall-cmd --add-service=cockpit
firewall-cmd --add-service=cockpit --permanent

alternatives --set java java-1.8.0-openjdk.x86_64

read -rp "Modificar fstab? (S/N): " FST
if [ "$FST" == 'S' ]; then
    sed -i 's/subvol=@/compress=zstd,noatime,space_cache=v2,ssd,discard=async,subvol=@/g' "/etc/fstab"
fi

sleep 2

reboot
