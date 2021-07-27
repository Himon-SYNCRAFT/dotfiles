#!/bin/bash

url=$(sqlite3 ~/.local/share/qutebrowser/history.sqlite "select url from history" | sort | uniq | sed '/^chrome/d' | sed '/^about/d'| sed '/^qute/d' | sed '/^http:\/\/localhost/d' | sed '/duckduckgo/d' | dmenu -l 20 -p "browser history:")

if [ -n "$url" ]; then
    qutebrowser "$url"
fi
