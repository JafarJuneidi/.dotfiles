HISTFILE=~/.config/zsh/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

### EXPORT
export XDG_CONFIG_HOME=$HOME/.config
export ZDOTDIR=$HOME/.config/zsh/
export TERM="xterm-256color"        				# getting proper colors
export EDITOR="/home/jafar/.local/share/bob/nvim-bin/nvim"

### ALIASES ###
alias l='exa -l --icons --git -a'
alias lt='exa --tree --level=2 --long --icons --git'
cl() { cd "$@" && l; }
alias c='clear'
alias vim="/home/jafar/.local/share/bob/nvim-bin/nvim"

# Antidote initialization
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

# fzf
[ -f "$ZDOTDIR/.fzf.zsh" ] && source "$ZDOTDIR/.fzf.zsh" 

### SETTING THE STARSHIP PROMPT ###
eval "$(starship init zsh)"

# fnm
export PATH="/home/jafar/.local/share/fnm:$PATH"
eval "`fnm env`"
bindkey '^ ' autosuggest-accept

# cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env" 

# pnpm
export PNPM_HOME="/home/jafar/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

## SSH-Keys
if ! pgrep ssh-agent > /dev/null 2>&1; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
    ssh-add ~/.ssh/JafarJuneidi > /dev/null 2>&1
fi

trap 'pkill -u "$USER" ssh-agent' EXIT > /dev/null 2>&1
