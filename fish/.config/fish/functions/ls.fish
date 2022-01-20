function ls --description 'exa or ls'
    if ! command -v exa &> /dev/null
        command ls $argv;
    else
        command exa $argv;
    end
end
