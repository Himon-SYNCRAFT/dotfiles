function vim --description 'alias vim vim'
    command vim $argv;
    return

    if ! command -v nvim &> /dev/null
        command vim $argv;
    else
        command nvim $argv;
    end
end
