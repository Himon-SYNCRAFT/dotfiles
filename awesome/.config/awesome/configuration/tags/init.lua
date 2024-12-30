local awful = require("awful")
local gears = require("gears")
-- local icons = require('theme.icons')
local apps = require("configuration.apps")

local tags = { "  ", "  ", " 󰇌 ", " 󰇍 ", " 󰇎 ", " 󰠮 ", " 󰓃 ", " 󰍡 ", " 󰇮 ", " 󰋎 " }
local l = awful.layout.suit
local layouts = { l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile.bottom, l.tile, l.tile }

-- Configure Tag Properties
awful.screen.connect_for_each_screen(function(s)
	-- Each screen has its own tag table.
	awful.tag(tags, s, layouts)
end)
-- }}}

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	l.tile,
	l.fair,
	l.tile.bottom,
	l.floating,
	-- l.tile.left,
	-- l.tile.bottom,
	-- l.tile.top,
	-- l.fair.horizontal,
	-- l.spiral,
	-- l.spiral.dwindle,
	-- l.max,
	-- l.max.fullscreen,
	-- l.magnifier,
	-- l.corner.nw,
	-- l.corner.ne,
	-- l.corner.sw,
	-- l.corner.se,
}
-- }}}
