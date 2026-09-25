function less --description 'moar or less'
    if ! command -v moor &> /dev/null
        command less $argv;
    else
        command moor $argv;
    end
end
