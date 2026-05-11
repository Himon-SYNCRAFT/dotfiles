#!/bin/bash


command=$(
  IFS=:
  find $PATH -maxdepth 1 -type f -executable 2>/dev/null \
  | sed 's#.*/##' \
  | sort -u \
  | dmenu -l 10 -p "run in terminal:"
)
command -v "$command" && foot --title "$command" -e "$command" &
