local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local theme = require("configuration.theme")

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

-- Create a tasklist widget
-- This works, however it may be better to inherit the s variable from the top panel itself
awful.screen.connect_for_each_screen(function(s)
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.focused,
		buttons = tasklist_buttons,
		style = {
			bg_focus = theme.bg_normal,
			fg_focus = theme.fg_normal,
			shape_border_color_focus = theme.bg_focus,
			shape_border_width_focus = 2,
			font = theme.font_regular,
			disable_task_name = true,
			align = "center",
		},
	})
end)
