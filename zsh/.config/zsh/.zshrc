### HISTORICAL SETTINGS ###
HISTFILE=${ZDOTDIR:-$HOME/.config/zsh}/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

### EXPORTS ###
export TERM=${TERM:-"xterm-256color"}  # getting proper colors

# Set XDG_CONFIG_HOME if not already set
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}

# Set ZDOTDIR if not already set
export ZDOTDIR=${ZDOTDIR:-"$XDG_CONFIG_HOME/zsh"}

# Set EDITOR if not already set
export EDITOR=${EDITOR:-vim}

### ALIASES ###
alias l='exa -l --icons --git -a'
alias lt='exa --tree --level=2 --long --icons --git'
alias c='clear'
alias vim=nvim

# Custom function definition
cl() { cd "$@" && l; }

### INITIALIZATIONS ###
# Antidote initialization
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

# fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# Setting the Starship prompt
eval "$(starship init zsh)"

### PATH MODIFICATIONS ###
# SCRIPTS
SCRIPTS="$HOME/.local/scripts"
if [[ ":$PATH:" != *":$SCRIPTS"* ]]; then
    export PATH="$SCRIPTS:$PATH"
fi

# fnm
export PATH="$HOME/.local/share/fnm:$PATH"
eval "`fnm env`"

# cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# bob
NVIM_BIN="$HOME/.local/share/bob/nvim-bin"
if [[ ":$PATH:" != *":$NVIM_BIN:"* ]]; then
    export PATH="$NVIM_BIN:$PATH"
fi

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
if [[ ":$PATH:" != *":$PNPM_HOME:"* ]]; then
    export PATH="$PNPM_HOME:$PATH"
fi

### SSH KEY MANAGEMENT ###
if ! pgrep ssh-agent > /dev/null 2>&1; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
    ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1
fi

# Terminate SSH Agent on exit
trap 'pkill -u "$USER" ssh-agent' EXIT > /dev/null 2>&1

### BINDINGS
bindkey '^ ' autosuggest-accept
bindkey -s '^f' "tmux-sessionizer\n"
