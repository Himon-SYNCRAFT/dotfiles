#!/bin/bash

music_dir="$HOME/Music"
previewdir="$HOME/.config/ncmpcpp/previews"
filename="$(mpc --format "$music_dir"/%file% current)"
previewname="$previewdir/$(mpc --format %album% current | base64).jpg"

# echo $music_dir
# echo $previewdir
# echo $filename
# echo $previewname
#
[ -e "$previewname" ] || ffmpeg -y -i "$filename" -an -vf scale=128:128 "$previewname" > /dev/null 2>&1

notify-send -t 8000 -r 27072 "Now Playing" "$(mpc --format '%title% \n%artist% - %album%' current)" -i "$previewname"
