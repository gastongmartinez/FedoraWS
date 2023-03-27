#!/usr/bin/env bash

# NerdFonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts
fc-cache -f -v
rm JetBrainsMono.zip

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
if [ ! -d ~/.local/bin ]; then
    mkdir -p ~/.local/bin
fi
curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer
export PATH="$HOME/.cargo/bin:$PATH"

# Flatpak
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user install flathub fr.handbrake.ghb -y
flatpak --user install flathub md.obsidian.Obsidian -y
flatpak --user install flathub com.mattjakeman.ExtensionManager -y
flatpak --user install flathub io.github.shiftey.Desktop -y
flatpak --user install flathub net.ankiweb.Anki -y
flatpak --user install flathub com.github.marktext.marktext -y
flatpak --user install flathub com.rafaelmardojai.Blanket -y
flatpak --user install flathub com.github.tchx84.Flatseal -y
flatpak --user install flathub com.github.neithern.g4music -y
flatpak --user install flathub com.axosoft.GitKraken -y

# Doom Emacs
if [ -d ~/.emacs.d ]; then
    rm -Rf ~/.emacs.d
fi
go install golang.org/x/tools/gopls@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/cweill/gotests/...@latest
go install github.com/x-motemen/gore/cmd/gore@latest
go install golang.org/x/tools/cmd/guru@latest
pip install nose
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
sleep 5
rm -rf ~/.doom.d
# sudo cp /usr/share/applications/emacs.desktop /usr/share/applications/emacsClient.desktop
# sudo sed -i "s/Name=Emacs/Name=Emacs Client/g" "/usr/share/applications/emacsClient.desktop"
# sudo sed -i "s/Exec=emacs/Exec=emacsclient -c -a 'emacs'/g" "/usr/share/applications/emacsClient.desktop" 

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Anaconda
# wget https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh
# chmod +x Anaconda3-2022.10-Linux-x86_64.sh
# ./Anaconda3-2022.10-Linux-x86_64.sh

# Jetbrains
if [ ! -d ~/Apps ]; then
    mkdir ~/Apps
fi
# cd ~/Apps || return
# wget https://download.jetbrains.com/python/pycharm-professional-2022.3.3.tar.gz
# wget https://download.jetbrains.com/datagrip/datagrip-2022.3.3.tar.gz
##### wget https://download.jetbrains.com/cpp/CLion-2022.3.tar.gz
# tar -xzf pycharm-professional-2022.3.3.tar.gz
# tar -xzf datagrip-2022.3.3.tar.gz
##### tar -xzf CLion-2022.3.tar.gz
# rm pycharm-professional-2022.3.3.tar.gz
# rm datagrip-2022.3.3.tar.gz
##### rm CLion-2022.3.tar.gz
# cd ~ || return


# Android
# if [ ! -d ~/Apps ]; then
#     mkdir ~/Apps
# fi
# cd ~/Apps || return
# wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.3.1.17/android-studio-2021.3.1.17-linux.tar.gz
# tar -xzf android-studio-2021.3.1.17-linux.tar.gz
# rm android-studio-2021.3.1.17-linux.tar.gz
# cd ~/Apps || return
# wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.3.9-stable.tar.xz
# tar xf flutter_linux_3.3.9-stable.tar.xz
# rm flutter_linux_3.3.9-stable.tar.xz
# cd ~ || return

# Bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
sed -i 's/"font"/"powerline"/g' "$HOME/.bashrc"

# Autostart Apps
if [ ! -d ~/.config/autostart ]; then
    mkdir -p ~/.config/autostart
fi
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

pip install black 'python-lsp-server[all]' pyright yamllint autopep8
cargo install taplo-cli --locked
cargo install stylua
sudo npm install -g neovim prettier bash-language-server vscode-langservers-extracted emmet-ls typescript typescript-language-server yaml-language-server live-server markdownlint markdownlint-cli dockerfile-language-server-nodejs stylelint js-beautify

jgmenu_run init --theme=archlabs_1803

sleep 5

reboot

