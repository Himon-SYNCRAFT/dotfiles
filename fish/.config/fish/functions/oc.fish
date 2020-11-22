function oc
    set file (find $HOME/.config/ -type f -follow -print | fzf --height 10 -e | sed 's/ *$//')

    if test -n "$file"
        if ! command -v nvim &> /dev/null
            vim "$file"
        else
            nvim "$file"
        end
    end
    # find $HOME/.config/ -type f -follow -print | fzf --height 10 -e | xargs -o vim
end
