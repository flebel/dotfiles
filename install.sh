#!/usr/bin/env sh

ASSETS=`pwd`/assets
SCRIPTS=`pwd`/scripts

chsh -s /bin/zsh
git clone git://github.com/flebel/oh-my-zsh.git ~/.oh-my-zhs
git clone git://github.com/kennethreitz/autoenv.git ~/.autoenv
git clone git://github.com/creationix/nvm.git ~/nvm

ln -s ${ASSETS}/.Xdefaults ~/.Xdefaults
ln -s ${ASSETS}/.gitconfig ~/.gitconfig
ln -s ${ASSETS}/.grepoptions ~/.grepoptions
ln -s ${ASSETS}/.hgrc ~/.hgrc
ln -s ${ASSETS}/.inputrc ~/.inputrc
ln -s ${ASSETS}/.zshrc ~/.zshrc

mkdir ~/scripts
ln -s ${SCRIPTS}/lock.sh ~/scripts/lock.sh
ln -s ${SCRIPTS}/set_trackball_acceleration.sh ~/scripts/set_trackball_acceleration.sh

