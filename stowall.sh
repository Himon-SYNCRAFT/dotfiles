#!/bin/sh


if ! command -v stow &> /dev/null; then
    echo "stow not installed"
    exit 1
fi

stow -v -t ~/ alacritty
stow -v -t ~/ home
stow -v -t ~/ polybar
stow -v -t ~/ ranger
stow -v -t ~/ tmux
stow -v -t ~/ dunst
stow -v -t ~/ i3
stow -v -t ~/ picom
stow -v -t ~/ qutebrowser
stow -v -t ~/ vim

xrdb ~/.Xresources
