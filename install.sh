#!/usr/bin/env sh

CURRENT=`pwd`

chsh -s /bin/zsh
git clone git://github.com/flebel/oh-my-zsh.git ~/.oh-my-zhs
git clone git://github.com/kennethreitz/autoenv.git ~/.autoenv
git clone git://github.com/creationix/nvm.git ~/nvm

ln -s ${CURRENT}/.Xdefaults ~/.Xdefaults
ln -s ${CURRENT}/.gitconfig ~/.gitconfig
ln -s ${CURRENT}/.inputrc ~/.inputrc
ln -s ${CURRENT}/.zshrc ~/.zshrc

