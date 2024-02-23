function ls --description 'exa or ls'
    if ! command -v eza &> /dev/null
        command ls $argv --group-directories-first;
    else
        command eza $argv --group-directories-first;
    end
end
