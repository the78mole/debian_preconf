#!/bin/bash

if [ $UID != 0 ]; then
  echo "This script must be run as root. (We should not have sudo yet)"
  exit 2
fi

FIRSTUSER=$(grep ":1000:" /etc/passwd | cut -f 1 -d ":")

usermod -G sudo $FIRSTUSER

apt update
apt upgrade

apt install sudo vim git command-not-found

apt update
update-command-not-found

cat >/etc/skel/.bash_aliases <<HERE
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
HERE

cp /etc/skel/.bash_aliases ~/
cp ~/.bash_aliases /home/$FIRSTUSER/

# Get a bashrc skeleton with a nice color_prompt (root is red, user is green)
wget -O ~/.bashrc https://raw.githubusercontent.com/the78mole/debian_preconf/master/bashrc_skel
cp ~/.bashrc /etc/skel/.bashrc

cat >/etc/vim/vimrc.local <<HERE
runtime! debian.vim

"set compatible
syntax on
set background=dark
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
filetype plugin indent on
set showcmd            " Show (partial) command in status line.
set showmatch          " Show matching brackets.
set ignorecase         " Do case insensitive matching
set smartcase          " Do smart case matching
set incsearch          " Incremental search
set autowrite          " Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
set mouse=a            " Enable mouse usage (all modes)
HERE

