#!/usr/bin/env sh

ASSETS=`pwd`/assets
ASSETS_FILES=`find $ASSETS -maxdepth 1 -type f`
ICONS=`pwd`/icons
SCRIPTS=`pwd`/scripts
SCRIPTS_FILES=`find $SCRIPTS -maxdepth 1 -type f`
MISC=`pwd`/misc
SUBMODULES=`pwd`/submodules

mkdir ~/go
mkdir ~/tmp
mkdir ~/work

# Submodules
git submodule init
git submodule update
mkdir ~/bin
ln -s ${ASSETS}/.vim/bundle/vimpager/vimpager ~/bin/vimpager
if [ "$(uname)" == "Linux" ]; then
  ln -s ${ASSETS}/.config/qtile ~/.config/qtile
  sudo mkdir /usr/share/fonts/truetype/hack
  sudo cp ${SUBMODULES}/Hack/build/ttf/*.ttf /usr/share/fonts/truetype/hack/
fi
ln -s ${SUBMODULES}/autoenv ~/.autoenv
ln -s ${SUBMODULES}/icdiff/icdiff ~/bin/icdiff
ln -s ${SUBMODULES}/nvm ~/.nvm
ln -s ${SUBMODULES}/oh-my-zsh ~/.oh-my-zsh
ln -s ${SUBMODULES}/percol/bin/percol ~/bin/percol
ln -s ${SUBMODULES}/pyenv ~/.pyenv
ln -s ${SUBMODULES}/pythonpy/pythonpy ~/bin/py
ln -s ${SUBMODULES}/pythonpy/extras/pycompleter ~/bin/pycompleter
ln -s ${SUBMODULES}/git-when-merged/bin/git-when-merged ~/bin/git-when-merged
ln -s ${SUBMODULES}/github-markdown-toc/gh-md-toc ~/bin/gh-md-toc
ln -s ${SUBMODULES}/scm_breeze ~/.scm_breeze
ln -s ${SUBMODULES}/zsh-fuzzy-match ~/.zsh-fuzzy-match
mkdir -p ~/.zsh/plugins/bd
ln -s ${SUBMODULES}/zsh-bd/bd.zsh ~/.zsh/plugins/bd/bd.zsh

if [ "$(uname)" == "Linux" ]; then
  mkdir -p ~/.urxvt/ext
  ln -s ${SUBMODULES}/urxvt-font-size/font-size ~/.urxvt/ext/
  ln -s ${SUBMODULES}/urxvt-perls/clipboard ~/.urxvt/ext/
fi

cd ${SUBMODULES}/rtop && make init && make
ln -s ${SUBMODULES}/rtop/rtop ~/bin/rtop

mkdir -p ~/dotfiles_backup/assets > /dev/null 2>&1
for f in $ASSETS_FILES; do
  filename="${f##*/}"
  mv ~/$filename ~/dotfiles_backup/assets/ > /dev/null 2>&1
  ln -s ${ASSETS}/$filename ~/$filename
done

ln -s ${ASSETS}/.pip ~/.pip
ln -s ${ASSETS}/.vim ~/.vim

mkdir ~/scripts > /dev/null 2>&1
mkdir -p ~/dotfiles_backup/scripts > /dev/null 2>&1
for f in $SCRIPTS_FILES; do
  filename="${f##*/}"
  mv ~/$filename ~/dotfiles_backup/scripts/
  ln -s ${SCRIPTS}/$filename ~/scripts/$filename
done
ln -s ${SUBMODULES}/git/contrib/diff-highlight/diff-highlight ~/scripts/git-diff-highlight

cd ${SUBMODULES}/cv && make && sudo make install && cd -
cd ${SUBMODULES}/sysadmin-util && make build && cd -
cd ${SUBMODULES}/pgcli && sudo pip install -e . && cd -

if [ "$(uname)" == "Linux" ]; then
  sudo cp $MISC/50-marblemouse.conf /usr/share/X11/xorg.conf.d/50-marblemouse.conf
fi

# Irssi
sudo cpan install Net::Twitter JSON::Any

# Misc
sudo gem install mailcatcher
sudo gem install pry-byebug
sudo gem install pry-stack_explorer
sudo pip install ohmu
sudo pip install ipython
sudo pip install virtualenvwrapper --ignore-installed six # Workaround OS X El Capitan's installed six https://github.com/pypa/pip/issues/3165

# Subtle window manager
if [ "$(uname)" == "Linux" ]; then
  cp ${ICONS}/* ~/.local/share/subtle/icons/
  sur install battery clock layout loadavg textfile
fi

# Vim
# Tagbar requires ctags-exuberant
sudo pip install flake8 jedi isort
ln -s ${ASSETS}/.vim/bundle ~/.vim/bundle
mkdir -p ~/.vim/autoload
ln -s ${ASSETS}/.vim/bundle/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/
# Workaround GitHub's mirror missing required files
cd ${ASSETS}/.vim/bundle/Conque-Shell/autoload && svn co http://conque.googlecode.com/svn/trunk/autoload/conque_term/ && cd -
# Manual install for vim-sparkup
cd ${ASSETS}/.vim/bundle/vim-sparkup && make vim-pathogen && cd -

if [ "$(uname)" == "Darwin" ]; then
  brew install golang
  brew install npm
  brew install tig
  brew install tmux
  brew install zsh
fi

chsh -s /bin/zsh
npm -g update instant-markdown-d

