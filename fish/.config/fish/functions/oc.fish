function oc
    set file (find $HOME/.config/ -type f -follow -print | fzf --height 10 -e | sed 's/ *$//')

    if test -n "$file"
        vim "$file"
    end
    # find $HOME/.config/ -type f -follow -print | fzf --height 10 -e | xargs -o vim
end
