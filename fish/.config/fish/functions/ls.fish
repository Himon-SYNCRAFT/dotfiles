function ls --description 'exa or ls'
    if ! command -v exa &> /dev/null
        command ls $argv --group-directories-first;
    else
        command exa $argv --group-directories-first;
    end
end
