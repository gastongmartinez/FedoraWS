#!/usr/bin/env bash

# Flatpak
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user install flathub fr.handbrake.ghb -y
flatpak --user install flathub md.obsidian.Obsidian -y
flatpak --user install flathub com.mattjakeman.ExtensionManager -y
flatpak --user install flathub com.jetbrains.PyCharm-Community -y
flatpak --user install flathub com.jetbrains.IntelliJ-IDEA-Community -y
flatpak --user install flathub com.google.AndroidStudio -y
flatpak --user install flathub io.github.shiftey.Desktop -y
flatpak --user install flathub net.ankiweb.Anki -y

# Doom Emacs
if [ -d ~/.emacs.d ]; then
    rm -Rf ~/.emacs.d
fi
go install golang.org/x/tools/gopls@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/cweill/gotests@latest
pip install nose
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
sleep 5
rm -rf ~/.doom.d
sudo npm -g install stylelint js-beautify
sudo cp /usr/share/applications/emacs.desktop /usr/share/applications/emacsClient.desktop
sudo sed -i "s/Name=Emacs/Name=Emacs Client/g" "/usr/share/applications/emacsClient.desktop"
sudo sed -i "s/Exec=emacs/Exec=emacsclient -c -a 'emacs'/g" "/usr/share/applications/emacsClient.desktop" 

# NeoVim
mkdir -p ~/.config/nvim
git clone https://github.com/gastongmartinez/Nvim ~/.config/nvim

# Anaconda
# wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh
# chmod +x Anaconda3-2021.11-Linux-x86_64.sh
# ./Anaconda3-2021.11-Linux-x86_64.sh

# Android
if [ ! -d ~/Apps ]; then
    mkdir ~/Apps
fi
cd ~/Apps || return
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.0.2-stable.tar.xz
tar xf flutter_linux_3.0.2-stable.tar.xz
rm flutter_linux_3.0.2-stable.tar.xz
cd ~ || return

# Bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
sed -i 's/"font"/"powerline"/g' "$HOME/.bashrc"

# Autostart Apps
if [ ! -d ~/.config/autostart ]; then
    mkdir -p ~/.config/autostart
fi
# cp /usr/share/applications/plank.desktop ~/.config/autostart/
cp /usr/share/applications/ulauncher.desktop ~/.config/autostart/

# ZSH
if [ ! -d ~/.local/share/zsh ]; then
    mkdir ~/.local/share/zsh
fi
touch ~/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/zsh/powerlevel10k
{
    echo 'source ~/.local/share/zsh/powerlevel10k/powerlevel10k.zsh-theme'
    echo 'source /usr/share/autojump/autojump.zsh'
    echo 'source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
    echo 'source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
    echo -e '\n# History in cache directory:'
    echo 'HISTSIZE=10000'
    echo 'SAVEHIST=10000'
    echo 'HISTFILE=~/.cache/zshhistory'
    echo 'setopt appendhistory'
    echo 'setopt sharehistory'
    echo 'setopt incappendhistory'
    echo 'JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk'
    echo 'export PATH="$HOME/anaconda3/bin:$HOME/Apps/flutter/bin:$HOME/.local/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/bin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.emacs.d/bin:$PATH"'
} >>~/.zshrc
chsh -s /usr/bin/zsh

sleep 5

reboot

