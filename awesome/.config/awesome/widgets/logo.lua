local awful = require("awful")
local lain = require("lain")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local markup = lain.util.markup
require("widgets.mainmenu")

local function bind_click(logo)
	logo:connect_signal("button::press", function(_, _, _, _)
		awful.spawn(mymainmenu:toggle())
	end)
end

local arch_color = "#1793D1"
local icon = "󰣇"

local function build_icon()
	local text = markup.fontfg("Monospace 18", arch_color, icon)

	return wibox.widget({
		markup = text,
		font = "Monospace 18",
		align = "center",
		valign = "center",
		forced_width = dpi(35),
		fg = arch_color,
		widget = wibox.widget.textbox,
	})
end

local function factory()
	local widget = build_icon()

	bind_click(widget)

	return wibox.container.margin(widget, dpi(10), dpi(10), dpi(0), dpi(2))
end

return factory
