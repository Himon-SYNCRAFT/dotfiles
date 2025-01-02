local wibox = require("wibox")
local lain = require("lain")
local dpi = require("beautiful").xresources.apply_dpi
local theme = require("configuration.theme")

local markup = lain.util.markup

local icon = ""

local mem_low = markup.fontfg(theme.icon_font, theme.fg_normal, icon)
local mem_avg = markup.fontfg(theme.icon_font, theme.yellow, icon)
local mem_high = markup.fontfg(theme.icon_font, theme.red, icon)

local function factory()
	local mem_icon = wibox.widget({
		markup = icon,
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
		forced_width = dpi(20),
	})

	local mem = lain.widget.mem({
		font = theme.icon_font,
		settings = function()
			if mem_now.perc >= 80 then
				mem_icon:set_markup(mem_high)
			elseif mem_now.perc >= 50 then
				mem_icon:set_markup(mem_avg)
			else
				mem_icon:set_markup(mem_low)
			end

			local used = string.format("%.1f", mem_now.used / 1024)
			widget:set_markup(markup.font(theme.icon_font, " " .. used .. "GB "))
		end,
	})

	return wibox.container.margin(
		wibox.widget({
			mem_icon,
			mem.widget,
			layout = wibox.layout.align.horizontal,
		}),
		dpi(0),
		dpi(0),
		dpi(2)
	)
end

return factory
