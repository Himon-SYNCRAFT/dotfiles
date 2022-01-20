#!/bin/sh


current_desktop=$(xprop -root | grep "_NET_CURRENT_DESKTOP(CARDINAL)" | cut -d " " -f 3)
current_desktop=$((current_desktop+1))

layout=$(bsp-layout get "$current_desktop")

if [ "$layout" = "-" ]; then
    layout="tile"
fi

echo "$layout"
# echo "$current_desktop $layout"
