#!/usr/bin/env bash

selected=`cat ~/.config/tmux/.tmux-cht-languages ~/.config/tmux/.tmux-cht-commands | fzf`
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" ~/.config/tmux/.tmux-cht-languages; then
    query=`echo $query | tr ' ' '+'`
    tmux neww zsh -c "curl cht.sh/$selected/$query | less -R"
else
    tmux neww zsh -c "curl cht.sh/$selected~$query | less -R"
fi
