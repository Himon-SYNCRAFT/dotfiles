local awful = require("awful")
local beautiful = require("beautiful")
require("widgets.mainmenu")

mylauncher = awful.widget.launcher({
	-- text = "󰣇",
	image = beautiful.awesome_icon,
	menu = mymainmenu,
})
