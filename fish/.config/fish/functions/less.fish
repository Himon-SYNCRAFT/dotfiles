function less --description 'moar or less'
    if ! command -v moar &> /dev/null
        command less $argv;
    else
        command moar $argv;
    end
end
