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
ln -s ${SUBMODULES}/git-open ~/.oh-my-zsh/custom/plugins/git-open
ln -s ${SUBMODULES}/kubetail/kubetail ~/bin/kubetail
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

sudo easy_install pip

cd ${SUBMODULES}/cv && make && sudo make install && cd -
cd ${SUBMODULES}/sysadmin-util && make build && cd -
cd ${SUBMODULES}/pgcli && sudo pip install -e . && cd -

if [ "$(uname)" == "Linux" ]; then
  sudo cp $MISC/50-marblemouse.conf /usr/share/X11/xorg.conf.d/50-marblemouse.conf
fi

if [ "$(uname)" == "Darwin" ]; then
  defaults write com.apple.finder AppleShowAllFiles YES

  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew install fpp
  brew install golang
  brew install git # Upgrade to latest version
  brew install gnupg
  brew install kubernetes-helm
  brew install htop
  brew install npm
  brew install reattach-to-user-namespace # Accessing the Mac OS X pasteboard in tmux sessions.
  brew install tig
  brew install tree
  brew install tmux
  brew install vim # Upgrade to latest version
  brew install wget
  brew install zsh

  brew cast install minikube &&\
    brew install docker-machine-driver-xhyve &&\
    sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve &&\
    sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve &&\
    minikube start --vm-driver xhyve
fi

# Irssi
sudo cpan install Net::Twitter JSON::Any

helm init
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/

# Misc
sudo gem install mailcatcher
sudo gem install pry-byebug
sudo gem install pry-stack_explorer
sudo pip install ohmu
sudo pip install ipython
sudo pip install mypy
pip install pur
sudo pip install virtualenvwrapper --ignore-installed six # Workaround OS X El Capitan's installed six https://github.com/pypa/pip/issues/3165

# Subtle window manager
if [ "$(uname)" == "Linux" ]; then
  cp ${ICONS}/* ~/.local/share/subtle/icons/
  sur install battery clock layout loadavg textfile
fi

# Vim
# Tagbar requires ctags-exuberant
sudo pip install flake8 jedi isort --ignore-installed six
mkdir -p ~/.vim/autoload
ln -s ${ASSETS}/.vim/bundle/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/
# Manual install for vim-sparkup
cd ${ASSETS}/.vim/bundle/vim-sparkup && make vim-pathogen && cd -

chsh -s /bin/zsh
npm -g update instant-markdown-d

# Select most recent 4096 bits GPG key to auto-sign git commits.
gpg --list-keys|grep -B1 francoislebel@gmail.com|grep "201[0-9]"|sed -e 's|.*4096R/\(.*\) 201[0-9].*|\1|'

echo "Download and install JRE: http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html"

