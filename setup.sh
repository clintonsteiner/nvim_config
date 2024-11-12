#!/usr/bin/env bash

mkdir -p ~/apps/neovim && cd ~/apps/neovim
wget -O nvim.appimage https://github.com/neovim/neovim/releases/download/v0.10.2/nvim.appimage
wget -O nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-macos-arm64.tar.gz
tar -xzvf nvim.tar.gz
chmod u+x ~/apps/neovim/bin/nvim

VENV_DIR="~/.virtualenvs/nvim"
#if [ -d ~/.virtualenvs/nvim ]
if [ ! -d "$VENV_DIR" ]; then
mkdir ~/.virtualenvs && cd ~/.virtualenvs
python3 -m venv nvim
fi

REPO_DIR="$HOME/dotfiles"
REPO_NAME="nvim"
REPO_URL="https://github.com/clintonsteiner/nvim_config.git"
if [ ! -d "$REPO_DIR" ]; then
mkdir $REPO_DIR 
fi
if [ ! -d "$REPO_DIR/$REPO_NAME" ]; then
pushd $REPO_DIR
git clone $REPO_URL  $REPO_NAME
popd
fi

cd ~/.virtualenvs/nvim
source bin/activate
pip install -r ~/dotfiles/nvim/requirements.txt
deactivate

mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
ln -sf ~/dotfiles/nvim/lua ~/.config/nvim/lua

if [ ! -d ~/.local/bin ]; then
mkdir ~/.local/bin
fi
cp ~/dotfiles/nvim/nvim_launcher.sh ~/.local/bin/nvim
chmod u+x ~/.local/bin/nvim
#vi ~/.local/bin/nvim

