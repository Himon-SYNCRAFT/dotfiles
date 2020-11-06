#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Launch bar1 and bar2
# echo "---" | tee -a /tmp/polybar-windows.log /tmp/polybar-music.log /tmp/polybar-tray.log

# polybar launcher >>/tmp/polybar-launcher.log 2>&1 & disown
# polybar windows >>/tmp/polybar-windows.log 2>&1 & disown
# polybar status >>/tmp/polybar-status.log 2>&1 & disown
# polybar tray >>/tmp/polybar-tray.log 2>&1 & disown
# polybar info >>/tmp/polybar-info.log 2>&1 & disown

# polybar music >>/tmp/polybar-music.log 2>&1 & disown
# polybar audio >>/tmp/polybar-audio.log 2>&1 & disown
# polybar network >>/tmp/polybar-network.log 2>&1 & disown
# polybar date >>/tmp/polybar-date.log 2>&1 & disown
# echo "---" | tee -a /tmp/polybar-all.log
polybar all >>/tmp/polybar-all.log 2>&1 & disown

echo "Bars launched..."
