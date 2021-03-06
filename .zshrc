bindkey -v
bindkey "^P" up-line-or-history
bindkey "^N" down-line-or-history
bindkey "^R" history-incremental-search-backward
bindkey "^E" end-of-line
bindkey "^A" beginning-of-line
bindkey '\e.' insert-last-word

autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

## Keep n lines of history within the shell and save it to ~/.zhistory:
export HISTSIZE=1000000
export SAVEHIST=1000000
HISTFILE=~/.zhistory
setopt INC_APPEND_HISTORY SHARE_HISTORY

##Various options
setopt APPEND_HISTORY
unsetopt BG_NICE        # do NOT nice bg commands
setopt CORRECT          # command CORRECTION
setopt EXTENDED_HISTORY     # puts timestamps in the history
setopt MENUCOMPLETE
setopt ALL_EXPORT
setopt HIST_IGNORE_ALL_DUPS

## Set/unset  shell options
setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash

PAGER='less'
EDITOR='vim'

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:vim:*:*files' ignored-patterns '*.cmi' '*.cmt' '*.exe' '*.cmti' '*.cmx' '*.cmo' '*.ml.d' \
  '*.mli.d' '*.o' '*.cmxa' '*.libdeps' '*.interface.deps' '*.a' '*.stub.names' '*.inferred-1step.deps' \
  '*.pack-order' '*.build_info.*' '*.exe.build_info.*' '*.exe.hg_version.*' '*.objdeps' '*.ocaml_plugin.*' \
  '*.fe.sexp' '*.cmi.deps'
zstyle ':completion:*:*:sl:*:*files' ignored-patterns '*.cmi' '*.cmt' '*.exe' '*.cmti' '*.cmx' '*.cmo' '*.ml.d' \
  '*.mli.d' '*.o' '*.cmxa' '*.libdeps' '*.interface.deps' '*.a' '*.stub.names' '*.inferred-1step.deps' \
  '*.pack-order' '*.build_info.*' '*.exe.build_info.*' '*.exe.hg_version.*' '*.objdeps' '*.ocaml_plugin.*' \
  '*.fe.sexp' '*.cmi.deps'
zstyle ':completion:*:*:scp:*:*files' ignored-patterns '*.cmi' '*.cmt' '*.cmti' '*.cmx' '*.cmo' '*.ml.d' \
  '*.mli.d' '*.o' '*.cmxa' '*.libdeps' '*.interface.deps' '*.a' '*.stub.names' '*.inferred-1step.deps' \
  '*.pack-order' '*.build_info.*' '*.exe.build_info.*' '*.exe.hg_version.*' '*.objdeps' '*.ocaml_plugin.*'

## stop backward-kill-word on directory delimiter
autoload -U select-word-style
select-word-style bash

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='mvim'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Auto jump tool
# https://github.com/joelthelion/autojump/blob/master/README.md
source $HOME/.autojump/etc/profile.d/autojump.sh

# this is needed for vim to have good colors in tmux
export TERM="xterm-256color"

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
export LESS=-r

autoload bashcompinit
bashcompinit

# print exit status of every command, if non-zero
function prompt {
  exit_status=$?
  red='\033[0;31m'
  NC='\033[0m' # No Color
  if (( $exit_status != 0 )); then
    echo -e "${red}EXIT STATUS $exit_status${NC}"
  fi
}

PROMPT_COMMAND=prompt
precmd() { eval "$PROMPT_COMMAND" }
