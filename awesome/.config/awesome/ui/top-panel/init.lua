local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

local theme = require("configuration.theme")
configuration = require("configuration.config")
require("widgets.top-panel")

local logout = require("widgets.logout")
local logo = require("widgets.logo")
local cpu_widget = require("widgets.cpu")
local memory_widget = require("widgets.memory")
local pkg_widget = require("widgets.pkg")
local volume_widget = require("widgets.volume")
local mpd_widget = require("widgets.mpd")
local clientname_widget = require("widgets.clientname")
-- local battery_widget = require("widgets.battery")

beautiful.systray_icon_spacing = 4
-- beautiful.bg_systray = theme.white
--
local function systray()
	local widget = wibox.widget.systray()
	widget:set_base_size(15)
	widget:set_reverse(true)
	widget:set_visible(true)
	widget:set_forced_width(nil)
	widget:set_forced_height(nil)

	return wibox.widget({
		-- {
		-- 	widget = widget,
		-- 	base_size = 15,
		-- },
		widget,
		left = -3,
		right = 50,
		top = 6,
		widget = wibox.container.margin,
	})
end

local TopPanel = function(s)
	-- Wiboxes are much more flexible than wibars simply for the fact that there are no defaults, however if you'd rather have the ease of a wibar you can replace this with the original wibar code

	-- local panel_x_margin = 20
	-- local panel_y_margin = beautiful.useless_gap

	local panel_x_margin = 0
	local panel_y_margin = 0

	local panel = wibox({
		ontop = true,
		type = "dock",
		screen = s,
		height = configuration.toppanel_height,
		width = s.geometry.width - panel_x_margin * 2,
		x = s.geometry.x + panel_x_margin,
		y = s.geometry.y + panel_y_margin,
		stretch = false,
		bg = beautiful.background,
		fg = beautiful.fg_normal,
		struts = {
			top = configuration.toppanel_height,
		},
		-- shape = function(cr, w, h)
		-- 	gears.shape.rounded_rect(cr, w, h, dpi(6))
		-- end,
	})

	panel:struts({
		top = configuration.toppanel_height,
	})

	panel:setup({
		layout = wibox.layout.align.horizontal,
		expand = "none",
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			logo(),
			-- mylauncher,
			s.mytaglist,
			s.mypromptbox,
			-- wibox.container.margin(s.mytasklist, dpi(5), dpi(5), dpi(7), dpi(7)),
		},
		{
			layout = wibox.layout.fixed.horizontal,
			mytextclock,
			wibox.container.margin(
				wibox.widget({
					widget = wibox.widget.separator,
					orientation = "vertical",
					forced_width = dpi(2),
				}),
				dpi(8),
				dpi(8),
				dpi(8),
				dpi(8)
			),
			mpd_widget(),
			-- clientname_widget,
		},
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			-- mykeyboardlayout,
			pkg_widget(),
			cpu_widget(),
			memory_widget(),
			-- battery_widget(),
			volume_widget(),
			logout,
			s.mylayoutbox,
			systray(),
		},
	})

	return panel
end

return TopPanel
