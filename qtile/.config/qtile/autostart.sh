#! /bin/sh

wmname LG3D
# pgrep -x sxhkd > /dev/null || sxhkd &
$HOME/.config/polybar/launch.sh &
nm-applet &
nitrogen --restore &
dunst &
thunderbird &
# electron-mail &
caffeine &
unclutter --timeout 1 --jitter 25 --ignore-scrolling &
# redshift-gtk &

# setxkbmap -layout pl,pl -variant ,dvorak &
setxkbmap -option caps:escape &
xset r rate 250 60 &
xmodmap ~/.Xmodmap

xsettingsd &
rclone mount syncraft_at_google:/ /home/himon/Remote/syncraft@google/ --vfs-cache-mode full --daemon

syncthing --no-browser &
udiskie --tray &

picom &
