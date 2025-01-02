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
local pacman = require("widgets.pacman")
local volume_widget = require("widgets.volume")
local mpd_widget = require("widgets.mpd")
local clientname_widget = require("widgets.clientname")

beautiful.systray_icon_spacing = 4
-- beautiful.bg_systray = theme.white

local systray = wibox.widget({
	{
		widget = wibox.widget.systray,
		base_size = 15,
	},
	left = -3,
	right = 15,
	top = 6,
	widget = wibox.container.margin,
})

local TopPanel = function(s)
	-- Wiboxes are much more flexible than wibars simply for the fact that there are no defaults, however if you'd rather have the ease of a wibar you can replace this with the original wibar code

	local panel_x_margin = 20
	local panel_y_margin = beautiful.useless_gap

	local panel = wibox({
		ontop = true,
		type = "dock",
		screen = s,
		height = configuration.toppanel_height,
		width = s.geometry.width - panel_x_margin * 2 - 1,
		x = s.geometry.x + panel_x_margin,
		y = s.geometry.y + panel_y_margin,
		stretch = false,
		bg = beautiful.background,
		fg = beautiful.fg_normal,
		struts = {
			top = configuration.toppanel_height,
		},
		shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, dpi(6))
		end,
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
		},
		{
			layout = wibox.layout.fixed.horizontal,
			mytextclock,
			mpd_widget(),
			-- clientname_widget,
		},
		-- s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			-- mykeyboardlayout,
			pacman(),
			cpu_widget(),
			memory_widget(),
			volume_widget(),
			logout,
			s.mylayoutbox,
			systray,
		},
	})

	return panel
end

return TopPanel
