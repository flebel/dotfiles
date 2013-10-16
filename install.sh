#!/usr/bin/env sh

ASSETS=`pwd`/assets
ASSETS_FILES=`find $ASSETS -maxdepth 1 -type f`
ICONS=`pwd`/icons
SCRIPTS=`pwd`/scripts
SCRIPTS_FILES=`find $SCRIPTS -maxdepth 1 -type f`
MISC=`pwd`/misc
SUBMODULES=`pwd`/submodules

# Submodules
git submodule init
git submodule update
ln -s ${SUBMODULES}/autoenv ~/.autoenv
ln -s ${SUBMODULES}/nvm ~/.nvm
ln -s ${SUBMODULES}/oh-my-zsh ~/.oh-my-zsh
ln -s ${SUBMODULES}/pyenv ~/.pyenv
mkdir -p ~/.urxvt/ext
ln -s ${SUBMODULES}/submodules/urxvt-font-size/font-size ~/.urxvt/ext/
ln -s ${SUBMODULES}/submodules/urxvt-perls/clipboard ~/.urxvt/ext/

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
# Tagbar requires ctags-exuberant
sudo pip install jedi isort
mkdir -p ~/.vim/autoload ~/.vim/bundle
ln -s ~/.vim/bundle/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/
# Workaround GitHub's mirror missing required files
cd assets/.vim/bundle/Conque-Shell/autoload && svn co http://conque.googlecode.com/svn/trunk/autoload/conque_term/ && cd -

