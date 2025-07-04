#!/bin/bash


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

# stow --no-folding -v -t ~/ alacritty
# stow --no-folding -v -t ~/ bspwm
# stow --no-folding -v -t ~/ cmus
# stow --no-folding -v -t ~/ i3
# stow --no-folding -v -t ~/ macchina
# stow --no-folding -v -t ~/ sxhkd
# stow --no-folding -v -t ~/ xmonad
stow --no-folding -v -t ~/ dunst
stow --no-folding -v -t ~/ emacs
stow --no-folding -v -t ~/ feh
stow --no-folding -v -t ~/ fish
stow --no-folding -v -t ~/ home
stow --no-folding -v -t ~/ ideavim
stow --no-folding -v -t ~/ lazygit
stow --ignore='database' --ignore='state' --no-folding -v -t ~/ mpd
stow --no-folding -v -t ~/ ncmpcpp
stow --no-folding -v -t ~/ nvim
stow --no-folding -v -t ~/ picom
stow --no-folding -v -t ~/ polybar
stow --no-folding -v -t ~/ qtile
stow --no-folding -v -t ~/ awesome
stow --ignore='.pyc' --no-folding -v -t ~/ qutebrowser
stow --no-folding -v -t ~/ ranger
stow --no-folding -v -t ~/ scripts
stow --no-folding -v -t ~/ vim
stow --no-folding -v -t ~/ wezterm
stow --no-folding -v -t ~/ zathura
stow --no-folding -v -t ~/ fontconfig
stow --no-folding -v -t ~/ fastfetch
stow --no-folding -v -t ~/ opencode

xrdb ~/.Xresources
