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

# Enable colors and version control info
autoload -Uz vcs_info
autoload -U colors && colors

# Configure vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "%{$fg[yellow]%}(%b)%{$reset_color%} "
zstyle ':vcs_info:git*' actionformats "%{$fg[yellow]%}(%b|%a)%{$reset_color%} "

# Execute before each prompt
precmd() {
    vcs_info
    # Get the current directory (last 3 levels)
    dir="%3~"
    # Check if in git repo and get status
    if [ -n "${vcs_info_msg_0_}" ]; then
        git_status=$(git status --porcelain 2>/dev/null | wc -l | xargs)
        if [ $git_status -gt 0 ]; then
            git_changes="%{$fg[red]%}✗${git_status}%{$reset_color%} "
        else
            git_changes="%{$fg[green]%}✓%{$reset_color%} "
        fi
    else
        git_changes=""
    fi
}

# Fun alternatives to hostname (pick one or rotate them!)
local fun_host="💻"  # Simple emoji
# local fun_host="The Matrix"  # Sci-fi vibe
# local fun_host="Command Central"  # Cool name
# local fun_host="BeepBoop"  # Robot feel

# Set up the prompt
PROMPT='%{$fg[cyan]%}%n%{$reset_color%} at %{$fg[magenta]%}${fun_host}%{$reset_color%} in %{$fg[blue]%}${dir}%{$reset_color%} ${vcs_info_msg_0_}${git_changes}%# '

# Optional: Right-side prompt with time
RPROMPT='%{$fg[grey]%}%*%{$reset_color%}'

# alias vim="nvim"

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

