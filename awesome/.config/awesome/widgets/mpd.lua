local mpd = require("lain.widget.mpd")
local theme = require("configuration.theme")
local lain = require("lain")

local markup = lain.util.markup

local function factory()
	return mpd({
		host = "localhost",
		port = 6600,
		music_dir = os.getenv("HOME") .. "/Music",
		font = theme.font_regular,
		settings = function()
			local artist = "󰎊"
			local title = ""

			if mpd_now.state == "play" then
				artist = "󰎇  " .. mpd_now.artist .. " - "
				title = mpd_now.title .. " "
			elseif mpd_now.state == "pause" then
				artist = "󰎊"
				title = ""
			end

			widget:set_markup(markup.font(theme.font_regular_bold, artist .. title))
		end,
	})
end

return factory
