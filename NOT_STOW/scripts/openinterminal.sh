#!/bin/sh


command=$(ls -1 /usr/bin | dmenu -l 10 -p "run in terminal:")
st -e $command &
