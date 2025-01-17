local awful = require("awful")
local sharedtags = require("sharedtags")
-- local gears = require("gears")
-- local icons = require('theme.icons')
-- local apps = require("configuration.apps")

local tags = { "󰇊 ", "󰇋 ", "󰇌 ", "󰇍 ", "󰇎 ", "󰠮 ", "󰓃 ", "󰍡 ", "󰇮 ", "󰋎 " }
local l = awful.layout.suit
local layouts = { l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile.bottom, l.tile, l.tile }

-- Configure Tag Properties
-- awful.screen.connect_for_each_screen(function(s)
-- 	-- Each screen has its own tag table.
-- 	awful.tag(tags, s, layouts)
-- end)
-- }}}
--
sharedTags = sharedtags({
	{ name = tags[1], layout = layouts[1] },
	{ name = tags[2], layout = layouts[2] },
	{ name = tags[3], layout = layouts[3] },
	{ name = tags[4], layout = layouts[4] },
	{ name = tags[5], layout = layouts[5] },
	{ name = tags[6], layout = layouts[6] },
	{ name = tags[7], layout = layouts[7] },
	{ name = tags[8], layout = layouts[8] },
	{ name = tags[9], layout = layouts[9] },
	{ name = tags[10], layout = layouts[10] },
})

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
