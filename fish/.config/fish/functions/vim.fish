function vim --description 'alias vim vim'
    if ! command -v nvim &> /dev/null
        command vim $argv;
    else
        set -x PHP_CS_FIXER_IGNORE_ENV 1;
        command nvim $argv;
    end
end
