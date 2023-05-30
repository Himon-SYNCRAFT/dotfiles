#! /bin/sh

wmname LG3D
# pgrep -x sxhkd > /dev/null || sxhkd &
nm-applet &
nitrogen --restore &
dunst &
# electron-mail &
caffeine &
unclutter --timeout 1 --jitter 25 --ignore-scrolling &
# redshift-gtk &

# setxkbmap -layout pl,pl -variant ,dvorak &
setxkbmap -option caps:escape &
xset r rate 250 60 &

xsettingsd &

syncthing --no-browser &
udiskie --tray &

# picom &

thunderbird &
solaar -w hide &

xmodmap ~/.Xmodmap

$HOME/.config/polybar/launch.sh &

rclone mount syncraft_at_google:/ /home/himon/Remote/syncraft@google/ --vfs-cache-mode full --daemon
