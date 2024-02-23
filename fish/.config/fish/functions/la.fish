function la --description 'exa or ls'
    if ! command -v eza &> /dev/null
        command ls -lAh --group-directories-first;
    else
        command eza -lah --group-directories-first;
    end
end
