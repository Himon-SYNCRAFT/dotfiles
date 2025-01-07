local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local theme = require("configuration.theme")
local awful = require("awful")
local naughty = require("naughty")
local lain = require("lain")
local markup = lain.util.markup

-- local ghost_icon = "󰮯"
local icon = "󰅧 "

local font_icon_style = theme.icon_font
local font_regular = theme.icon_font

local function factory()
	local command = 'bash -c "checkupdates 2> /dev/null | wc -l"'
	local base_widget = wibox.widget.textbox()
	base_widget:set_markup(markup.fontfg(font_regular, theme.fg_normal, "0"))
	local content = awful.widget.watch(command, 607, function(widget, stdout)
		local text = markup.fontfg(font_regular, theme.fg_normal, stdout)
		widget:set_markup(text)
	end, base_widget)

	local widget_icon = wibox.widget({
		markup = icon,
		font = font_icon_style,
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
		forced_width = dpi(20),
	})

	local group = wibox.widget({
		widget_icon,
		content,
		font = font_icon_style,
		layout = wibox.layout.align.horizontal,
	})

	group:buttons(awful.button({}, 1, function()
		awful.spawn.easy_async("checkupdates", function(stdout)
			naughty.notify({
				title = "Updates",
				text = stdout,
				timeout = 10,
			})
		end)
	end))

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

-- local function factory()
-- 	local pacman_icon = wibox.widget({
-- 		markup = icon,
-- 		font = font_icon_style,
-- 		align = "center",
-- 		valign = "center",
-- 		widget = wibox.widget.textbox,
-- 		forced_width = dpi(20),
-- 	})
--
-- 	local widget = pacman_widget({
-- 		font = font_regular,
-- 		interval = 600, -- Refresh every 10 minutes
-- 		popup_bg_color = theme.bg_normal,
-- 		popup_border_width = 0,
-- 		popup_border_color = theme.fg_normal,
-- 		popup_height = 10, -- 10 packages shown in scrollable window
-- 		popup_width = 300,
-- 		polkit_agent_path = "/usr/lib/lxpolkit",
-- 	})
--
-- 	local group = wibox.widget({
-- 		pacman_icon,
-- 		widget,
-- 		font = font_regular,
-- 		layout = wibox.layout.align.horizontal,
-- 	})
--
-- 	return wibox.container.margin(
-- 		wibox.widget({
-- 			group,
-- 			font = font_regular,
-- 			layout = wibox.layout.align.horizontal,
-- 		}),
-- 		dpi(0),
-- 		dpi(0),
-- 		dpi(2)
-- 	)
-- end

return factory
