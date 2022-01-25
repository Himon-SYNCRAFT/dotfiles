#! /bin/sh

# pgrep -x sxhkd > /dev/null || sxhkd &
"$HOME/.config/polybar/launch.sh" &
nm-applet &
nitrogen --restore &
picom &
dunst &
# birdtray &
thunderbird &
electron-mail &
caffeine &
unclutter --timeout 1 --jitter 50 --ignore-scrolling &
redshift-gtk &

xmodmap ~/.Xmodmap
setxkbmap -layout pl,pl -variant ,dvorak &
setxkbmap -option caps:escape &
xset r rate 300 40 &

rclone mount syncraft_at_google:/ /home/himon/Remote/syncraft@google/ --vfs-cache-mode full --daemon
keepassxc &