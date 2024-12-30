local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

configuration = require("configuration.config")
require("widgets.top-panel")

local systray = wibox.widget({
	{
		widget = wibox.widget.systray,
		base_size = 24,
	},
	left = 0,
	right = 0,
	top = 3,
	down = 3,
	widget = wibox.container.margin,
})

local TopPanel = function(s)
	-- Wiboxes are much more flexible than wibars simply for the fact that there are no defaults, however if you'd rather have the ease of a wibar you can replace this with the original wibar code
	local panel = wibox({
		ontop = true,
		screen = s,
		height = configuration.toppanel_height,
		width = s.geometry.width,
		x = s.geometry.x,
		y = s.geometry.y,
		stretch = false,
		bg = beautiful.background,
		fg = beautiful.fg_normal,
		struts = {
			top = configuration.toppanel_height,
		},
	})

	panel:struts({
		top = configuration.toppanel_height,
	})

	panel:setup({
		layout = wibox.layout.align.horizontal,
		expand = "none",
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			-- mylauncher,
			s.mytaglist,
			s.mypromptbox,
		},
		{
			layout = wibox.layout.fixed.horizontal,
			mytextclock,
		},
		-- s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			-- mykeyboardlayout,
			s.mylayoutbox,
			systray,
		},
	})

	return panel
end

return TopPanel
