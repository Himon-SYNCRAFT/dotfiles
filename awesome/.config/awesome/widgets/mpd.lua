local mpd = require("lain.widget.mpd")
local wibox = require("wibox")
local theme = require("configuration.theme")

local function factory()
	return mpd({
		host = "localhost",
		port = 6600,
		music_dir = os.getenv("HOME") .. "/Music",
		widget = wibox.widget.textbox,
		font = theme.font_regular,
	})
end

return factory
