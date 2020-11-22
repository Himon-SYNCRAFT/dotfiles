#!/bin/sh


if ! command -v stow &> /dev/null; then
    echo "Stow is not installed."
    echo ""
    echo "Install snow with your package manager."
    echo ""
    echo "For example:"
    echo "  sudo pacman -S stow"
    echo "  or"
    echo "  sudo apt install stow"
    exit 1
fi

stow -v -t ~/ alacritty
stow -v -t ~/ home
stow -v -t ~/ polybar
stow -v -t ~/ ranger
stow -v -t ~/ dunst
stow -v -t ~/ i3
stow -v -t ~/ picom
stow -v -t ~/ qutebrowser
stow -v -t ~/ vim
stow -v -t ~/ nvim
stow -v -t ~/ cmus
stow -v -t ~/ fish
stow -v -t ~/ ideavim
stow -v -t ~/ bspwm
stow -v -t ~/ sxhkd

xrdb ~/.Xresources
