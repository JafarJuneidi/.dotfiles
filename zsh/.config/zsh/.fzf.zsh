# Setup fzf
# ---------
if [[ ! "$PATH" == */.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$(dirname "$0")/.fzf/bin"
fi

# Auto-completion
# ---------------
source "./.fzf/shell/completion.zsh"

# Key bindings
# ------------
source "./.fzf/shell/key-bindings.zsh"
