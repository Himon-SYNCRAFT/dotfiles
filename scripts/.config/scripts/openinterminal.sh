#!/bin/sh


command=$(ls -1 /usr/bin | dmenu -l 10 -p "run in terminal:")
test -n "$command" && st -e $command &
