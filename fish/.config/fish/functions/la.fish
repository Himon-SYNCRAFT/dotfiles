function la --description 'exa or ls'
    if ! command -v exa &> /dev/null
        command ls -lA;
    else
        command exa -la;
    end
end
