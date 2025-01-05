local wibox = require("wibox")
local theme = require("configuration.theme")
local dpi = require("beautiful").xresources.apply_dpi

-- Create a textclock widget
-- mytextclock = wibox.widget({
-- 	-- format = "%d.%m.%Y %H:%M",
-- 	widget = wibox.widget.textclock,
-- 	font = theme.font_regular_bold,
-- })

mytextclock = wibox.container.margin(
	wibox.widget({
		widget = wibox.widget.textclock,
		font = theme.font_regular_bold,
	}),
	dpi(0),
	dpi(0),
	dpi(7),
	dpi(9)
)

-- mytextclock = wibox.widget({
-- 	{
-- 		{
-- 			id = "txt",
-- 			widget = wibox.widget.textclock,
-- 		},
-- 		halign = "center",
-- 		valign = "center",
-- 		fill_vertical = true,
-- 		fill_horizontal = true,
-- 		layout = wibox.container.place,
-- 	},
-- })
--
