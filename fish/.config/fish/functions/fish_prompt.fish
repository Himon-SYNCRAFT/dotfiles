function fish_prompt
    if set -q NVIM
        set_color $fish_color_cwd

        if test "$fish_key_bindings" = "fish_vi_key_bindings"
            switch $fish_bind_mode
                case default
                    set_color --bold blue
                    printf '[N] '
                case insert
                    set_color --bold magenta
                    printf '[I] '
                case replace_one
                    set_color --bold green
                    printf '[R] '
                case replace
                    set_color --bold cyan
                    printf '[R] '
                case visual
                    set_color --bold yellow
                    printf '[V] '
            end
            set_color normal
        else
            printf ' '
        end

        set_color normal
        return
    end
    if not set -q VIRTUAL_ENV_DISABLE_PROMPT
        set -g VIRTUAL_ENV_DISABLE_PROMPT true
    end

    # set_color bryellow
    # set_color yellow
    # printf '%s' $USER
    # set_color normal
    # printf ' in '

    # set_color $fish_color_cwd
    set_color yellow
    # printf '%s' (prompt_pwd)
    # printf '%s' (pwd)
    printf '%s'(string replace -r ~ '~' (pwd))

    set symbol_git_down_arrow ""
    set symbol_git_up_arrow ""
    set symbol_git_dirty ""
    set git_color_yellow (set_color yellow)
    set git_color_red (set_color red)
    set git_color_blue (set_color blue)

    set -l is_git_repository (command git rev-parse --is-inside-work-tree 2> /dev/null)

    if test -n "$is_git_repository"
        set git_branch_name (command git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')

        # Check if there are files to commit
        set -l is_git_dirty (command git status --porcelain --ignore-submodules 2>/dev/null)

        if test -n "$is_git_dirty"
            set git_dirty $symbol_git_dirty
        end

        # Check if there is an upstream configured
        command git rev-parse --abbrev-ref '@{upstream}' >/dev/null 2>/dev/null; and set -l has_upstream
        if set -q has_upstream
            set -l git_status (command git rev-list --left-right --count 'HEAD...@{upstream}' | sed "s/[[:blank:]]/ /" 2>/dev/null)

            # Resolve Git arrows by treating `git_status` as an array
            set -l git_arrow_left (command echo $git_status | cut -c 1 2>/dev/null)
            set -l git_arrow_right (command echo $git_status | cut -c 3 2>/dev/null)

            # If arrow is not "0", it means it's dirty
            if test $git_arrow_left != 0
                set git_arrows "$symbol_git_up_arrow"
            end

            if test $git_arrow_right != 0
                set git_arrows "$git_arrows$symbol_git_down_arrow"
            end
        end

        # Format Git prompt output
        set gprompt $gprompt "$git_branch_name$git_color_yellow$git_dirty$git_arrows$git_color_red "
    end

    set_color red
    printf "$gprompt"
    set_color normal

    # Line 2
    echo
    if test $VIRTUAL_ENV
        printf "(%s) " (set_color blue)(basename $VIRTUAL_ENV)(set_color normal)
    end

    printf "%s " (date +%H:%M)

    if test "$fish_key_bindings" = "fish_vi_key_bindings"
        switch $fish_bind_mode
            case default
                set_color --bold blue
                printf '[N] '
            case insert
                set_color --bold magenta
                printf '[I] '
            case replace_one
                set_color --bold green
                printf '[R] '
            case replace
                set_color --bold cyan
                printf '[R] '
            case visual
                set_color --bold yellow
                printf '[V] '
        end
        set_color normal
    else
        printf ' '
    end

    set_color normal
end
