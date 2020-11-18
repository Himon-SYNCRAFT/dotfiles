# Defined in - @ line 1
function r --wraps=ranger --description 'alias r ranger'
    set temp_file (mktemp -p "/tmp" "ranger_cd.XXXXXXXXXX")

    ranger --choosedir=$temp_file $argv
    set return_value "$status"

    set chosen_dir (cat $temp_file)

    if $chosen_dir && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]
        cd "$chosen_dir"
    end
    rm -f "$temp_file"
    return "$return_value"
end
