#! /bin/sh

wmname LG3D
# pgrep -x sxhkd > /dev/null || sxhkd &
$HOME/.config/polybar/launch.sh &
nm-applet &
nitrogen --restore &
# picom &
dunst &
thunderbird &
electron-mail &
caffeine &
unclutter --timeout 1 --jitter 25 --ignore-scrolling &
redshift-gtk &

xmodmap ~/.Xmodmap
setxkbmap -layout pl,pl -variant ,dvorak &
setxkbmap -option caps:escape &
xset r rate 300 50 &

xsettingsd &
rclone mount syncraft_at_google:/ /home/himon/Remote/syncraft@google/ --vfs-cache-mode full --daemon
# keepassxc &
