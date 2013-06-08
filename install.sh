#!/usr/bin/env sh

CURRENT=`pwd`

chsh -s /bin/zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
git clone git://github.com/kennethreitz/autoenv.git ~/.autoenv
git clone git://github.com/creationix/nvm.git ~/nvm

ln -s ${CURRENT}/.Xdefaults ~/.Xdefaults
ln -s ${CURRENT}/.zshrc ~/.zshrc

