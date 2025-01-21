#!/usr/bin/env bash

wmname LG3D
# pgrep -x sxhkd > /dev/null || sxhkd &
pgrep -x nm-applet > /dev/null || nm-applet &
# nitrogen --restore &
# pgrep -x dunst > /dev/null || dunst &
# electron-mail &
pgrep -f caffeine > /dev/null || caffeine &
pgrep -x unclutter > /dev/null || unclutter --timeout 1 --jitter 25 --ignore-scrolling &
# redshift-gtk &

sudo ntfsfix -d /dev/sdb1

# setxkbmap -layout pl,pl -variant ,dvorak &
setxkbmap -option caps:escape &
xset r rate 250 60 &

pgrep -x xsettingsd > /dev/null || xsettingsd &

pgrep -x syncthing > /dev/null || syncthing --no-browser &
pgrep -x udiskie > /dev/null || udiskie --tray &

pgrep -x picom > /dev/null || picom &

pgrep -x thunderbird > /dev/null || thunderbird &
pgrep -x solaar > /dev/null || solaar -w hide &

xmodmap ~/.Xmodmap &

rclone mount syncraft_at_google:/ /home/himon/Remote/syncraft@google/ --vfs-cache-mode full --daemon &
