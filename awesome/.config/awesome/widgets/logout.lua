local awful = require("awful")
local wibox = require("wibox")
local apps = require("configuration.apps")
local dpi = require("beautiful").xresources.apply_dpi
local theme = require("configuration.theme")

local logout_menu = require("awesome-wm-widgets.logout-menu-widget.logout-menu")

return wibox.container.margin(
	logout_menu({
		font = theme.icon_font,
		onlock = function()
			awful.spawn.with_shell(apps.lockscreen)
		end,
	}),
	dpi(-4),
	dpi(2),
	dpi(4),
	dpi(4)
)
