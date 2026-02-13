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
alias l='eza -l --icons --git -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias c='clear'

# Custom function definition
cl() { cd "$@" && l; }

### INITIALIZATIONS ###
# opencode
OPENCODE_PATH="$HOME/.opencode/bin/"
if [ -d "$OPENCODE_PATH" ]; then
    export PATH="$OPENCODE_PATH:$PATH"
    export OPENCODE_EXPERIMENTAL_LSP_TOOL=true
    export OPENCODE_ENABLE_EXA=1        # Enable websearch tool
fi

# Antidote initialization
ANTIDOTE_SCRIPT="${ZDOTDIR:-~}/.antidote/antidote.zsh"
if [ -f "$ANTIDOTE_SCRIPT" ]; then
    source "$ANTIDOTE_SCRIPT"
    antidote load
fi

# fzf
FZF_PATH="$HOME/.fzf/bin/"
if [ -d "$FZF_PATH" ]; then
    export PATH="$FZF_PATH:$PATH"
fi

if command -v fzf > /dev/null; then
    source <(fzf --zsh)
    export FZF_CTRL_T_OPTS="
      --walker-skip .git,node_modules,venv,target
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

# LOCAL_BIN
LOCAL_BIN="$HOME/.local/bin"
if [[ ":$PATH:" != *":$LOCAL_BIN"* ]]; then
    export PATH="$LOCAL_BIN:$PATH"
fi

# fnm
FNM_HOME="$HOME/.local/share/fnm"
if [ -d "$FNM_HOME" ]; then
    export PATH="$FNM_HOME:$PATH"
    eval "`fnm env`"
fi

# pyenv
PYENV_HOME="$HOME/.pyenv/bin"
if [ -d "$PYENV_HOME" ]; then
    export PATH="$PYENV_HOME:$PATH"
    eval "$(pyenv init - zsh)"
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

### BINDINGS
bindkey '^ ' autosuggest-accept
bindkey -s '^f' "tmux-sessionizer\n"
