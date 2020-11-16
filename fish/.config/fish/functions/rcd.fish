function rcd
    set temp_file (mktemp "ranger_cd.XXXXXXXXXX")
    set temp_path "/tmp/$temp_file"

    ranger --choosedir=$temp_path
    set return_value "$status"

    set chosen_dir (cat $temp_path)

    if $chosen_dir && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]
        cd "$chosen_dir"
    end
    rm -f "$temp_file"
    return "$return_value"
end
