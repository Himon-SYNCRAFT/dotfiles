#!/bin/bash

url=$(sqlite3 ~/.local/share/qutebrowser/history.sqlite "select url from history" | sort | uniq | sed '/^chrome/d' | sed '/^about/d'| sed '/^qute/d' | sed '/^http:\/\/localhost/d' | dmenu -l 10 -p "browser history:")

if [ -n "$url" ]; then
    qutebrowser "$url"
fi
