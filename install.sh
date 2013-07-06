#!/usr/bin/env sh

ASSETS=`pwd`/assets
ASSETS_FILES=`find $ASSETS -maxdepth 1 -type f`
SCRIPTS=`pwd`/scripts
SCRIPTS_FILES=`find $SCRIPTS -maxdepth 1 -type f`

chsh -s /bin/zsh
git clone git://github.com/flebel/oh-my-zsh.git ~/.oh-my-zhs
git clone git://github.com/kennethreitz/autoenv.git ~/.autoenv
git clone git://github.com/creationix/nvm.git ~/nvm

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

