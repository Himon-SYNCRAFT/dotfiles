function la --description 'exa or ls'
    if ! command -v exa &> /dev/null
        command ls -lAh --group-directories-first;
    else
        command exa -lah --group-directories-first;
    end
end
