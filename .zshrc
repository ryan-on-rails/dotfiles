# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a rando:wm theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="spaceship"

# Move next only if `homebrew` is installed
if command -v brew >/dev/null 2>&1; then
  # Load rupa's z if installed
  [ -f $(brew --prefix)/etc/profile.d/z.sh ] && source $(brew --prefix)/etc/profile.d/z.sh
fi

# Get operating system
platform='unknown'
unamestr=$(uname)
if [[ $unamestr == 'Linux' ]]; then
  platform='linux'
elif [[ $unamestr == 'Darwin' ]]; then
  platform='darwin'
fi

# =============================================================================
#                                   Functions
# =============================================================================

# Use fd and fzf to get the args to a command.
# Works only with zsh
# Examples:
# f mv # To move files. You can write the destination after selecting the files.
# f 'echo Selected:'
# f 'echo Selected music:' --extention mp3
# fm rm # To rm files in current directory
f() {
    sels=( "${(@f)$(fd "${fd_default[@]}" "${@:2}"| fzf)}" )
    test -n "$sels" && print -z -- "$1 ${sels[@]:q:q}"
}

# Like f, but not recursive.
fm() f "$@" --max-depth 1

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# using ripgrep combined with preview
# find-in-file - usage: fif <searchTerm>
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() (
  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
)

fgb() (
  local branch
  branch=$(git branch | fzf -m | awk '{print $1}')
  git switch $branch
)

# =============================================================================
#                                   Variables
# =============================================================================
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# =============================================================================
#                                   Plugins
# =============================================================================
# Check if zplug is installed
[ ! -d ~/.zplug ] && git clone https://github.com/zplug/zplug ~/.zplug
source ~/.zplug/init.zsh && zplug update > /dev/null
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "plugins/git",                  from:oh-my-zsh, if:"which git"
zplug "plugins/sudo",                 from:oh-my-zsh, if:"which sudo"
zplug "plugins/bundler",              from:oh-my-zsh, if:"which bundle"
zplug "plugins/colored-man-pages",    from:oh-my-zsh
zplug "plugins/extract",              from:oh-my-zsh
zplug "plugins/fancy-ctrl-z",         from:oh-my-zsh
zplug "plugins/globalias",            from:oh-my-zsh
zplug "plugins/gpg-agent",            from:oh-my-zsh, if:"which gpg-agent"
zplug "plugins/httpie",               from:oh-my-zsh, if:"which httpie"
zplug "plugins/nanoc",                from:oh-my-zsh, if:"which nanoc"
zplug "plugins/nmap",                 from:oh-my-zsh, if:"which nmap"
zplug "rupa/z"
zplug "clvv/fasd"
zplug "desyncr/auto-ls"
zplug "MichaelAquilina/zsh-you-should-use"
zplug "seebi/dircolors-solarized", ignore:"*", as:plugin
zplug "zsh-users/zsh-completions",              defer:0
zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting",      defer:3, on:"zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search", defer:3, on:"zsh-users/zsh-syntax-highlighting"
zplug "b4b4r07/enhancd", use:init.sh
if zplug check "b4b4r07/enhancd"; then
  export ENHANCD_FILTER="fzf --height 50% --reverse --ansi --preview 'ls -l {}' --preview-window down"
  export ENHANCD_DOT_SHOW_FULLPATH=1
fi

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
  printf "Some plugins need to be installed. Install plugins? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
zplug load
source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='subl --wait'
fi

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Homebrew
alias brewu='brew update && brew upgrade && brew cleanup && brew doctor'
alias bup="brew upgrade && brew update"

# Common shell functions
alias less='less -r'
alias tf='tail -f'
alias l='less'
alias lh='ls -alt | head' # see the last modified files
alias screen='TERM=screen screen'
alias cl='clear'
alias cls='clear;ls'
alias ve="$EDITOR ~/.vimrc"
alias ze="$EDITOR ~/.zshrc"
alias rz='source ~/.zshrc'
alias envconfig="$EDITOR ~/Documents/code/env.sh"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
alias bashconfig="$EDITOR ~/.bash_profile"
alias desk="cd ~/Desktop"
alias host="$EDITOR /etc/hosts"
alias fuck='$(thefuck $(fc -ln -1))'
alias speed="speedtest-cli"

# PS
alias psa="ps aux"
alias psrg="ps aux | rg "

# Show human friendly numbers and colors
alias df='df -h'
alias du='du -h -d 2'

if [[ $platform == 'linux' ]]; then
  alias ll='ls -alh --color=auto'
  alias ls='ls --color=auto'
elif [[ $platform == 'darwin' ]]; then
  alias ll='ls -alGh'
  alias ls='ls -Gh'
fi

# FASD
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # intecomesractive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection

# docker
alias de='docker exec -e COLUMNS="$(tput cols)" -e LINES="$(tput lines)" -ti'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Command}}\t{{.Image}}"'
alias dra='docker restart $(docker container ls -a -q)'
alias dr='docker restart'
alias dl='./script/docker_launch'
alias docker_stopall='docker stop $(docker container ls -a -q)'
alias docker_removeall='docker container rm $(docker container ls -a -q)'
alias docker_freshstart='docker container stop $(docker container ls -a -q) && docker system prune -a -f --volumes'
alias dprune='docker system prune'

alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

alias cmmlocal="$EDITOR ~/dev/local_override.yml"

# Kill all running containers.
alias dockerkillall='docker kill $(docker ps -q)'

# Delete all stopped containers.
alias dockercleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

# Delete all untagged images.
alias dockercleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

# Delete all stopped containers and untagged images.
alias dockerclean='dockercleanc || true && dockercleani'

alias rubocop_only_changes='git ls-files -m | xargs ls -1 2>/dev/null | grep '\.rb$' | xargs rubocop'

drm() {
  docker stop $1
  docker rm $1
  rm -rf /Users/rmilstead/dev/apps/$1
}

dlog() {
  docker logs $1 --tail 1000 -f
}

# replace ~/dev with the path to your platform/dev checkout
shovel() ( cd ~/dev && ./script/run shovel "$@"; )

# If you're using zsh, you can add the following to enable tab complete for shovel run.
export PLATFORM_DEV=$HOME/dev # change to match your local dev directory
fpath=($PLATFORM_DEV/misc/completion/ $fpath)

gradingstart() {
  NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  echo "starting grading at $(date +"%F %r")"
  CURRENT_TIME_ENTRY_ID=$(curl -H "content-type: application/json" -H "X-Api-Key: X8FmNmqxrwljBr2X" -d '{"start": "'"$NOW"'", "description": "Grading", "projectId": "5f6f98eeedd8bb741e5f4b7a"}' -X POST https://api.clockify.me/api/v1/workspaces/5f6f97b0edd8bb741e5f4973/time-entries | jq --raw-output '.id')
}

gradingend() {
  NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  echo "ending grading at $(date +"%F %r")"
  curl -H "content-type: application/json" -H "X-Api-Key: X8FmNmqxrwljBr2X" -d '{"end": "'"$NOW"'"}' -X PATCH https://api.clockify.me/api/v1/workspaces/5f6f97b0edd8bb741e5f4973/user/5f6f97b0edd8bb741e5f4971/time-entries
}

gradingclean() {
  setopt extendedglob
  rm -rf -- ^noteful-json-server -type d
}

timecheck() {
  NOW=$(date -u +"%Y-%m-%dT%H:%M:%S")
  START_TIME=$(curl -H "content-type: application/json" -H "X-Api-Key: X8FmNmqxrwljBr2X" -X GET https://api.clockify.me/api/v1/workspaces/5f6f97b0edd8bb741e5f4973/time-entries/$CURRENT_TIME_ENTRY_ID | jq --raw-output '.timeInterval.start')
  datediff ${START_TIME%Z} $NOW -f '%H hours %M minutes %S seconds'
}

reload() {
  source ~/.zshrc
}

export APP_ENV="development"
export APP_ID="rmilstead"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.

autoload -U promptinit && promptinit
prompt pure
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
