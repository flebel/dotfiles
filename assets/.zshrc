# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="nanotech"
MODE_INDICATOR="COMMAND %{$fg_bold[red]%}<%{$fg[red]%}<<%{$reset_color%}"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(autoenv bower cp django git git-flow mercurial pip python screen ssh-agent svn tmux torrent vi-mode)

export PAGER=~/bin/vimpager
export PATH=~/bin:$PATH:~/dotfiles/submodules/percol/percol
export PYTHONPATH=~/dotfiles/submodules/percol
alias less=$PAGER
alias zless=$PAGER

SSH_ENV="$HOME/.ssh/agent-info"
function start_agent {
  echo -n 'Initializing SSH agent... '
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo 'succeeded.'
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  /usr/bin/ssh-add;
}
if [ -f "${SSH_ENV}" ]; then
  . "${SSH_ENV}" > /dev/null
  ps -e | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_agent;
  }
else
  start_agent;
fi

source $ZSH/oh-my-zsh.sh

HISTFILE=$HOME/.zhistory
HISTSIZE=5500
SAVEHIST=5000
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE

export GREP_COLOR="1;32"
export GREP_OPTIONS="--color=auto"

if [ "$(uname)" != "Darwin" ]; then
  xmodmap ~/.Xmodmap
fi

export WORKON_HOME=~/.virtualenv
source /usr/local/bin/virtualenvwrapper.sh

source ~/.autoenv/activate.sh

[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"

source ~/.zsh/plugins/bd/bd.zsh

source ~/.zsh-fuzzy-match/fuzzy-match.zsh

source ~/.fzf.zsh

. ~/.nvm/nvm.sh

. ~/.aliases

#
# Customizations
#
setopt nohup

#
# Key bindings
#

bindkey -v

# http://zshwiki.org/home/zle/bindkeys
# Create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
# Setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
function zle-line-init () {
  echoti smkx
}
function zle-line-finish () {
  echoti rmkx
}
zle -N zle-line-init
zle -N zle-line-finish

bindkey ^R history-incremental-pattern-search-backward

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
if [ "$(uname)" == "Darwin" ]; then
  bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
  bindkey "$terminfo[kcud1]" down-line-or-beginning-search
else
  bindkey "^[[A" up-line-or-beginning-search # Up
  bindkey "^[[B" down-line-or-beginning-search # Down
  bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
  bindkey "$terminfo[kcud1]" down-line-or-beginning-search
  # bindkey "$terminfo[kcuu1]" history-substring-search-up
  # bindkey "$terminfo[kcud1]" history-substring-search-down
fi

local -a precmd_functions
function grep_options() {
  local -a opts
  local proj_opts=${PWD}/.grepoptions

  # Grab the global options
  if [[ -e ${HOME}/.grepoptions ]] ; then
    opts=( ${(f)"$(< "${HOME}/.grepoptions")"} )
  fi

  # Grab any project-local options
  if [[ -r ${proj_opts} ]] ; then
   opts+=( ${${(f)"$(< "${proj_opts}")"}:#[#]*} )
  fi

  # Assemble and export
  GREP_OPTIONS="${(j: :)opts}"
  export GREP_OPTIONS
}
precmd_functions=( grep_options )


if [ -f ~/.zshrc_local ]; then
  . ~/.zshrc_local
fi

if [ -f "$HOME/.shell_notes" ] ; then
  cat $HOME/.shell_notes
fi

