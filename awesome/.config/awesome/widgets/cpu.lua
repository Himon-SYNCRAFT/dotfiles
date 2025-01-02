local wibox = require("wibox")
local lain = require("lain")
local dpi = require("beautiful").xresources.apply_dpi
local theme = require("configuration.theme")

local markup = lain.util.markup

local icon = ""

local cpu_low = markup.fontfg(theme.icon_font, theme.fg_normal, icon)
local cpu_avg = markup.fontfg(theme.icon_font, theme.yellow, icon)
local cpu_high = markup.fontfg(theme.icon_font, theme.red, icon)

local function factory()
	local cpu_icon = wibox.widget({
		markup = icon,
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
		forced_width = dpi(30),
	})

	local cpu = lain.widget.cpu({
		font = theme.icon_font,
		settings = function()
			local cpu_usage = tonumber(cpu_now.usage)

			if cpu_usage >= 80 then
				cpu_icon:set_markup(cpu_high)
			elseif cpu_usage >= 50 then
				cpu_icon:set_markup(cpu_avg)
			else
				cpu_icon:set_markup(cpu_low)
			end

			widget:set_markup(markup.font(theme.icon_font, "" .. cpu_now.usage .. "% "))
		end,
	})

	return wibox.container.margin(
		wibox.widget({
			cpu_icon,
			cpu.widget,
			layout = wibox.layout.align.horizontal,
		}),
		dpi(0),
		dpi(0),
		dpi(2)
	)
end

return factory