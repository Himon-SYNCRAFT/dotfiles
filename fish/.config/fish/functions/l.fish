function l --description 'exa or ls'
    if ! command -v eza &> /dev/null
        command ls -lh --group-directories-first;
    else
        command eza -lh --group-directories-first;
    end
end
