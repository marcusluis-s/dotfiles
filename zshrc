setopt autocd              # change directory just by typing its name
setopt correct             # auto correct mistakes
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

export PROMPT_EOL_MARK=""  # hide EOL sign ('%')

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
# This line obtains information from the vcs.
zstyle ':vcs_info:git*' formats "(%b) "
precmd() {
    vcs_info
}

# Prompt
prompt="%B%F{#5e5c64}┌%f"'${VIRTUAL_ENV:+($(basename$VIRTUAL_ENV))}'"%F{#5e5c64}[%f%F{#77767b}%n%f %F{#ffa348}in%F{#5e5c64}] ─ [%F{#77767b}%(6~.%-1~/…/%3~.%5~)%f%F{#5e5c64}]%f%F{#504e55}"'${vcs_info_msg_0_}'"%f"$'\n'"%F{#5e5c64}└╼%f%F{#ffa348}$%f %b"

alias vim="nvim"

# Select all suggestion instead of top on result only
zstyle ':autocomplete:tab:*' insert-unambiguous yes
zstyle ':autocomplete:tab:*' widget-style menu-select
zstyle ':autocomplete:*' min-input 2
bindkey $key[Up] up-line-or-history
bindkey $key[Down] down-line-or-history

# Apply colors for ls command
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
alias ll="ls -alG"

# Nodejs NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install Antigen with brew, then past the path here
source /opt/homebrew/Cellar/antigen/2.2.3/share/antigen/antigen.zsh

# Zsh Syntax Highlighting, completions and autosuggestions
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen apply

# Load rbenv automatically
eval "$(rbenv init - zsh)"

# Go
export GOPATH=/Users/ms/dev/prog-languages/go-workspace
export PATH=$PATH:$GOPATH/bin

