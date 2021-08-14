#!/usr/bin/env bash

# Doom Emacs
if [ -d ~/.emacs.d ]; then
    rm -Rf ~/.emacs.d
fi
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install

# Anaconda
wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh
chmod +x Anaconda3-2021.05-Linux-x86_64.sh
./Anaconda3-2021.05-Linux-x86_64.sh

# Jetbrains
if [ ! -d ~/Apps ]; then
    mkdir ~/Apps
fi
cd ~/Apps || return
wget https://download.jetbrains.com/python/pycharm-community-2021.2.tar.gz
wget https://download.jetbrains.com/idea/ideaIC-2021.2.tar.gz
tar -xzf pycharm-community-2021.2.tar.gz
tar -xzf ideaIC-2021.2.tar.gz
rm pycharm-community-2021.2.tar.gz
rm ideaIC-2021.2.tar.gz
cd ~ || return

# Bash
git clone --recursive https://github.com/andresgongora/synth-shell.git
chmod +x synth-shell/setup.sh
cd synth-shell || return
./setup.sh
cd ..
rm -rf synth-shell

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
} >>~/.zshrc
chsh -s /usr/bin/zsh

