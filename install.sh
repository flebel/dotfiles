#!/usr/bin/env sh

ASSETS=`pwd`/assets
ASSETS_FILES=`find $ASSETS -maxdepth 1 -type f`
ICONS=`pwd`/icons
SCRIPTS=`pwd`/scripts
SCRIPTS_FILES=`find $SCRIPTS -maxdepth 1 -type f`
MISC=`pwd`/misc

chsh -s /bin/zsh
git submodule init
git submodule update
ln -s `pwd`/autoenv ~/.autoenv
ln -s `pwd`/nvm ~/.nvm
ln -s `pwd`/oh-my-zsh ~/.oh-my-zsh
ln -s `pwd`/pyenv ~/.pyenv

mkdir -p ~/dotfiles_backup/assets > /dev/null 2>&1
for f in $ASSETS_FILES; do
  filename="${f##*/}"
  mv ~/$filename ~/dotfiles_backup/assets/
  ln -s ${ASSETS}/$filename ~/$filename
done

mkdir ~/scripts > /dev/null 2>&1
mkdir -p ~/dotfiles_backup/scripts > /dev/null 2>&1
for f in $SCRIPTS_FILES; do
  filename="${f##*/}"
  mv ~/$filename ~/dotfiles_backup/scripts/
  ln -s ${SCRIPTS}/$filename ~/scripts/$filename
done

sudo cp $MISC/50-marblemouse.conf /usr/share/X11/xorg.conf.d/50-marblemouse.conf

cp ${ICONS}/* ~/.local/share/subtle/icons/

