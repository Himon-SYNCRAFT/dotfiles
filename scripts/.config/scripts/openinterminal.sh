#!/bin/bash


RES=''
IFS=':'
read -ra ADDR <<< "$PATH"
for i in "${ADDR[@]}"; do
    RES+="$i "
done
IFS=' '

command=$(ls -1 $RES | grep . | grep -v / | sort | uniq | dmenu -l 10 -p "run in terminal:")
command -v "$command" && st -n "$command" -e "$command" &
