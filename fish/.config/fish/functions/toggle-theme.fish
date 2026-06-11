function toggle-theme
    if test (gsettings get org.gnome.desktop.interface color-scheme) = "'prefer-dark'"
        gsettings set org.gnome.desktop.interface color-scheme prefer-light
        set -Ux THEME_MODE light
        ln -sf ~/.config/alacritty/themes/kanagawa_lotus.toml ~/.config/alacritty/themes/current.toml
        pkill -USR2 foot 2>/dev/null
        pkill -USR1 nvim 2>/dev/null
    else
        gsettings set org.gnome.desktop.interface color-scheme prefer-dark
        set -Ux THEME_MODE dark
        ln -sf ~/.config/alacritty/themes/kanagawa_wave.toml ~/.config/alacritty/themes/current.toml
        pkill -USR1 foot 2>/dev/null
        pkill -USR1 nvim 2>/dev/null
    end

    touch /home/himon/.config/alacritty/alacritty.toml
end
