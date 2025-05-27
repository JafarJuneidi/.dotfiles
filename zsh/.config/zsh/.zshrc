### HISTORICAL SETTINGS ###
HISTFILE=${ZDOTDIR:-$HOME/.config/zsh}/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

### EXPORTS ###
export TERM=${TERM:-"xterm-256color"}

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

# Custom function definition
cl() { cd "$@" && l; }

### INITIALIZATIONS ###
# Antidote initialization
ANTIDOTE_SCRIPT="${ZDOTDIR:-~}/.antidote/antidote.zsh"
if [ -f "$ANTIDOTE_SCRIPT" ]; then
    source "$ANTIDOTE_SCRIPT"
    antidote load
fi

# fzf
if command -v fzf > /dev/null; then
    source <(fzf --zsh)
    export FZF_CTRL_T_OPTS="
      --walker-skip .git,node_modules,venv
      --preview 'bat -n --color=always {}'
      --bind 'ctrl-/:change-preview-window(down|hidden|)'"
fi

# Setting the Starship prompt
if command -v starship > /dev/null; then
    eval "$(starship init zsh)"
fi

### PATH MODIFICATIONS ###
# SCRIPTS
SCRIPTS="$HOME/.local/scripts"
if [[ ":$PATH:" != *":$SCRIPTS"* ]]; then
    export PATH="$SCRIPTS:$PATH"
fi

# fnm
FNM_HOME="$HOME/.local/share/fnm"
if [ -d "$FNM_HOME" ]; then
    export PATH="$FNM_HOME:$PATH"
    eval "`fnm env`"
fi

# cargo
RUST_INIT="$HOME/.cargo/env"
if [ -f "$RUST_INIT" ]; then
    source "$RUST_INIT"
fi

# pnpm
PNPM_HOME="$HOME/.local/share/pnpm"
if [ -d "$PNPM_HOME" ] && [[ ":$PATH:" != *":$PNPM_HOME:"* ]]; then
    export PATH="$PNPM_HOME:$PATH"
fi

# Erlang
ERLANG_PATH="$HOME/.elixir-install/installs/otp/27.1.2/bin"
if [ -d "$ERLANG_PATH" ] && [[ ":$PATH:" != *":$ERLANG_PATH:"* ]]; then
    export PATH="$ERLANG_PATH:$PATH"
fi

# Elixir
ELIXIR_PATH="$HOME/.elixir-install/installs/elixir/1.18.1-otp-27/bin"
if [ -d "$ELIXIR_PATH" ] && [[ ":$PATH:" != *":$ELIXIR_PATH:"* ]]; then
    export PATH="$ELIXIR_PATH:$PATH"
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
