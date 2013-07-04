#!/usr/bin/env sh

ASSETS=`pwd`/assets
ASSETS_FILES=`find $ASSETS -maxdepth 1 -type f`
SCRIPTS=`pwd`/scripts

chsh -s /bin/zsh
git clone git://github.com/flebel/oh-my-zsh.git ~/.oh-my-zhs
git clone git://github.com/kennethreitz/autoenv.git ~/.autoenv
git clone git://github.com/creationix/nvm.git ~/nvm

mkdir ~/dotfiles_backup > /dev/null 2>&1
for f in $ASSETS_FILES; do
  filename="${f##*/}"
  mv ~/$filename ~/dotfiles_backup/
  ln -s ${ASSETS}/$filename ~/$filename
done

mkdir ~/scripts > /dev/null 2>&1
ln -s ${SCRIPTS}/lock.sh ~/scripts/lock.sh
ln -s ${SCRIPTS}/set_trackball_acceleration.sh ~/scripts/set_trackball_acceleration.sh

