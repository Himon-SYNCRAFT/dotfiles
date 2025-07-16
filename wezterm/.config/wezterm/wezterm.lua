local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- config.window_background_opacity = 0.92
config.window_background_opacity = 1.0

-- config.color_scheme = "rose-pine-dawn"
-- config.color_scheme = "rose-pine-moon"
config.color_scheme = "Rosé Pine Moon (base16)"

config.font = wezterm.font_with_fallback({
	"MonaspiceNe NF",
	"Noto Color Emoji",
})

config.font_rules = {
	{
		intensity = "Bold",
		italic = false,
		font = wezterm.font("MonaspiceNe NF", {
			weight = "Bold",
			style = "Normal",
			stretch = "Normal",
		}),
	},
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font("MonaspiceNe NF", {
			weight = "Bold",
			style = "Italic",
			stretch = "Normal",
		}),
	},
	{
		intensity = "Normal",
		italic = false,
		font = wezterm.font("MonaspiceNe NF", {
			weight = "Regular",
			style = "Normal",
			stretch = "Normal",
		}),
	},
	{
		intensity = "Normal",
		italic = true,
		font = wezterm.font("", {
			weight = "Regular",
			style = "Italic",
			stretch = "Normal",
		}),
	},
}
config.use_cap_height_to_scale_fallback_fonts = true
config.font_size = 10
config.line_height = 1.2
config.hide_tab_bar_if_only_one_tab = true
config.default_prog = { "fish", "-l" }
config.window_close_confirmation = "NeverPrompt"
config.scrollback_lines = 3500
config.enable_wayland = false

config.keys = {
	{ key = "k", mods = "SUPER", action = act.ScrollByLine(-1) },
	{ key = "j", mods = "SUPER", action = act.ScrollByLine(1) },
}

config.animation_fps = 120
config.max_fps = 240
config.front_end = "OpenGL"
config.dpi = 96
-- config.front_end = "WebGpu"

return config
