#!/usr/bin/env sh

ASSETS=`pwd`/assets
ASSETS_FILES=`find $ASSETS -maxdepth 1 -type f`
ICONS=`pwd`/icons
SCRIPTS=`pwd`/scripts
SCRIPTS_FILES=`find $SCRIPTS -maxdepth 1 -type f`
MISC=`pwd`/misc

# Submodules
git submodule init
git submodule update
ln -s `pwd`/autoenv ~/.autoenv
ln -s `pwd`/nvm ~/.nvm
ln -s `pwd`/oh-my-zsh ~/.oh-my-zsh
ln -s `pwd`/pyenv ~/.pyenv

chsh -s /bin/zsh

mkdir -p ~/dotfiles_backup/assets > /dev/null 2>&1
for f in $ASSETS_FILES; do
  filename="${f##*/}"
  mv ~/$filename ~/dotfiles_backup/assets/
  ln -s ${ASSETS}/$filename ~/$filename
done

ln -s ${ASSETS_FILES}/.pip ~/.pip
ln -s ${ASSETS_FILES}/.vim ~/.vim

mkdir ~/scripts > /dev/null 2>&1
mkdir -p ~/dotfiles_backup/scripts > /dev/null 2>&1
for f in $SCRIPTS_FILES; do
  filename="${f##*/}"
  mv ~/$filename ~/dotfiles_backup/scripts/
  ln -s ${SCRIPTS}/$filename ~/scripts/$filename
done

sudo cp $MISC/50-marblemouse.conf /usr/share/X11/xorg.conf.d/50-marblemouse.conf

# Subtle window manager
cp ${ICONS}/* ~/.local/share/subtle/icons/
sur install battery clock layout loadavg textfile

# Vim
sudo pip install jedi
mkdir -p ~/.vim/autoload ~/.vim/bundle
ln -s `pwd`/jedi-vim ~/.vim/bundle/
ln -s `pwd`/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim
ln -s `pwd`/vim-colors-solarized ~/.vim/bundle/
ln -s `pwd`/vim-multiple-cursors ~/.vim/bundle/
ln -s `pwd`/vim-repeat ~/.vim/bundle/
ln -s `pwd`/vim-speeddating ~/.vim/bundle/
ln -s `pwd`/vim-surround ~/.vim/bundle/
ln -s `pwd`/vim-vividchalk ~/.vim/bundle/
ln -s `pwd`/supertab ~/.vim/bundle/

