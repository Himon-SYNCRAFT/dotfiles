function cat --wraps=bat --description 'alias cat bat'
    if ! command -v bat &> /dev/null
        command cat $argv;
    else
        bat $argv;
    end
end
