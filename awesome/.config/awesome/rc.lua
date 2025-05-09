-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local theme = require("configuration.theme")
local dpi = require("beautiful").xresources.apply_dpi
local naughty_dbus = require("naughty.dbus")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys")

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "xresources/theme.lua")
beautiful.font = theme.font_regular
beautiful.useless_gap = 10
beautiful.gap_single_client = 10

naughty.config.defaults.margin = dpi(20)
naughty.config.defaults.border_width = 0
naughty.config.padding = dpi(10)
naughty.config.spacing = dpi(10)

naughty.config.presets.brave = {
	callback = function()
		return false
	end,
}

table.insert(naughty_dbus.config.mapping, { { appname = "brave-browser" }, naughty.config.presets.brave })

-- Init all modules (You can add/remove active modules here)
require("modules.auto-start")
require("modules.sloppy-focus")
require("modules.set-wallpaper")

-- Setup UI Elements
require("ui")

-- Setup all configurations
require("configuration.tags")
require("configuration.client")
require("configuration.init")
_G.root.keys(require("configuration.keys.global"))
_G.root.buttons(require("configuration.mouse.desktop"))

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	if not awesome.startup then
		awful.client.setslave(c)
	end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

awesome.connect_signal("startup", function()
	naughty.notify({
		preset = naughty.config.presets.low,
		title = "Config Reloaded",
		text = "AwesomeWM has been restarted",
	})
end)
