local wibox = require("wibox")
local pacman_widget = require("awesome-wm-widgets.pacman-widget.pacman")
local dpi = require("beautiful").xresources.apply_dpi
local theme = require("configuration.theme")

-- local ghost_icon = "󰮯"
local icon = "󰅧 "

local font_icon_style = theme.icon_font
local font_regular = theme.icon_font
local function factory()
	local pacman_icon = wibox.widget({
		markup = icon,
		font = font_icon_style,
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
		forced_width = dpi(20),
	})

	local widget = pacman_widget({
		font = font_regular,
		interval = 600, -- Refresh every 10 minutes
		popup_bg_color = theme.bg_normal,
		popup_border_width = 0,
		popup_border_color = theme.fg_normal,
		popup_height = 10, -- 10 packages shown in scrollable window
		popup_width = 300,
		polkit_agent_path = "/usr/bin/lxpolkit",
	})

	local group = wibox.widget({
		pacman_icon,
		widget,
		font = font_regular,
		layout = wibox.layout.align.horizontal,
	})

	return wibox.container.margin(
		wibox.widget({
			group,
			font = font_regular,
			layout = wibox.layout.align.horizontal,
		}),
		dpi(0),
		dpi(0),
		dpi(2)
	)
end

return factory
