local wibox = require("wibox")

-- Create a textclock widget
mytextclock = wibox.widget({
	format = "%d.%m.%Y %H:%M",
	widget = wibox.widget.textclock,
	font = "Monospace Bold 10",
})

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
