local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}

if wezterm.config_builder then config = wezterm.config_builder() end

config.color_scheme = "Catppuccin Macchiato"
config.window_background_opacity = 0.87
-- config.window_background_opacity = 1.0

config.font = wezterm.font_with_fallback {
    'Hasklug Nerd Font', 'Noto Color Emoji'
}

config.font_rules = {
    {
        intensity = 'Bold',
        italic = false,
        font = wezterm.font('Hasklug Nerd Font', {
            weight = 'Bold',
            style = 'Normal',
            stretch = 'Normal'
        })
    }, {
        intensity = 'Bold',
        italic = true,
        font = wezterm.font('Hasklug Nerd Font', {
            weight = 'Bold',
            style = 'Italic',
            stretch = 'Normal'
        })
    }
}
config.use_cap_height_to_scale_fallback_fonts = true
config.font_size = 10
config.dpi = 96
config.freetype_load_target = 'Light'
config.freetype_render_target = 'HorizontalLcd'
config.hide_tab_bar_if_only_one_tab = true
config.default_prog = {'fish', '-l'}
config.window_close_confirmation = "NeverPrompt"
config.scrollback_lines = 3500

config.keys = {
    {key = 'k', mods = 'SUPER', action = act.ScrollByLine(-1)},
    {key = 'j', mods = 'SUPER', action = act.ScrollByLine(1)}
}

return config
