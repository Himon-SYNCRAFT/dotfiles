local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local lain = require("lain")
local dpi = require("beautiful").xresources.apply_dpi
local beautiful = require("beautiful")
local theme = require("configuration.theme")

local function build_progressbar(level, step)
	local icon = "󰹞"
	local bar = ""

	if not step then
		step = 20
	end

	level = level / step

	for i = 1, level do
		bar = bar .. icon
	end

	return bar
end

local volume_enabled = " "
local volume_mute = "󰖁"
local notify_id = nil

local volume_level_command = string.format(
	"pactl list sinks | grep '^[[:space:]]Volume:' | head -n %d | tail -n 1 | sed -e 's,.* \\([0-9][0-9]*\\)%%.*,\\1,'",
	1
)

local function get_volume_level(callback)
	awful.spawn.easy_async_with_shell(volume_level_command, function(volume_level, stderr, _reason, _existyletcode)
		callback(tonumber(volume_level))
	end)
end

local font = theme.font_monospace
local font_strong = theme.font_monospace_bold
local font_icon = theme.icon_font

local function notify_change_level(volumeicon)
	awful.spawn.easy_async_with_shell(volume_level_command, function(volume_level, stderr, _reason, _exitcode)
		get_volume_level(function(volume_level)
			local icon = volume_level == 0 and volume_mute or volume_enabled

			volumeicon:set_markup(icon)

			notify_id = naughty.notify({
				title = volume_enabled .. " Volume",
				font = font_strong,
				text = build_progressbar(volume_level, 10) .. " " .. volume_level .. "%",
				position = "top_right",
				bg = theme.bg_normal,
				fg = theme.fg_normal,
				margin = 10,
				width = 142,
				replaces_id = notify_id,
				border_width = 0,
			}).id
		end)
	end)
end

local function up_volume(volume, callback)
	get_volume_level(function(volume_level)
		if volume_level >= 99 then
			return
		end

		awful.spawn(string.format("pactl set-sink-volume %d +5%%", volume.device))

		callback()
	end)
end

local function factory()
	local volumeicon = wibox.widget({
		markup = volume_enabled,
		font = font_icon,
		valign = "center",
		halign = "center",
		widget = wibox.widget.textbox,
		forced_width = dpi(20),
	})

	local volume = lain.widget.pulsebar({ font = font })

	local do_update = function(volume)
		volume.update()
		notify_change_level(volumeicon)
	end

	volumeicon:buttons(awful.util.table.join(
		awful.button({}, 1, function() -- left click
			awful.spawn(string.format("pactl set-sink-mute %d toggle", volume.device))
			do_update(volume)
		end),
		awful.button({}, 2, function() -- middle click
			awful.spawn(string.format("pactl set-sink-volume %d 100%%", volume.device))
			do_update(volume)
		end),
		awful.button({}, 3, function() -- right click
			awful.spawn.with_shell("(pkill pavucontrol | true) && pavucontrol")
		end),
		awful.button({}, 4, function() -- scroll up
			up_volume(volume, function()
				do_update(volume)
			end)
		end),
		awful.button({}, 5, function() -- scroll down
			awful.spawn(string.format("pactl set-sink-volume %d -5%%", volume.device))
			do_update(volume)
		end)
	))

	return wibox.container.margin(
		wibox.widget({
			volumeicon,
			volume.widget,
			layout = wibox.layout.align.horizontal,
		}),
		dpi(0),
		dpi(0),
		dpi(2)
	)
end

return factory
