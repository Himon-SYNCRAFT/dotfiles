function oc
    du -aL ~/.config 2> /dev/null | cut -f 2 | fzf --height 10 -e | xargs -o vim
end
