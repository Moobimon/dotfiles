# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/m4ntis/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Reduce lag time between zle mode switching
export KEYTIMEOUT=1

# Display msg on the right when in vim normal mode line editing
zle -N zle-line-init
zle -N zle-keymap-select
function zle-line-init zle-keymap-select {
  VIM_PROMPT="%F{red}[NORMAL]%f"
  RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}"
  zle reset-prompt
}

parse_prompt() {
  GIT_STAT=""

  # Check for .git dir
  if [[ -d .git ]]; then
    # Add branch name to msg
    GIT_STAT=" [$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"

    # Test for any changes in working directory
    if [[ "$(git status --porcelain --ignore-submodules -unormal 2> /dev/null)" ]]; then
      GIT_STAT="$GIT_STAT *"
    fi

    GIT_STAT="$GIT_STAT]"
  fi

  PROMPT="[%F{magenta}%n%f@%m%F{green}${GIT_STAT}%f %1~]%f "
}

precmd() {
  parse_prompt
}


# Aliases
alias ls='ls --color=auto --group-directories-first -h'
alias vim='nvim'
alias cdgo='cd $GOPATH/src/github.com/m4ntis'

# Git aliases
alias glog='git log --graph --abbrev-commit --decorate --format=format:'\''%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'\'' --all'
alias gss='git status -s'
alias gdiff='git diff'

# Command caching
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

DISPLAY_TODO=true
if [ -f $HOME/.shush ]; then
  typeset -i SHUSH=$(cat $HOME/.shush)
  typeset -i NOW=$(date +%s)
  if [ "$SHUSH" -gt "$NOW" ]; then
    DISPLAY_TODO=false
  fi
fi

if [ $DISPLAY_TODO = true ]; then
  if [ -f $HOME/.todo ]; then
    echo "PICK A THING TO TAKE OFF THE LIST. BE PRODUCTIVE."
    echo ""
    echo "Run 'cookie' when a task is executed."
    echo "Run 'todo <task>' to add to the list."
    echo ""
    cat $HOME/.todo
  fi

  if [ -f $HOME/.cookies ]; then
    echo ""
    echo "You currently have $(cat $HOME/.cookies) cookies."
  fi
fi
