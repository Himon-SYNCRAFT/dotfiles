local awful = require("awful")
local wibox = require("wibox")

local theme = require("configuration.theme")

local function get_client_name()
	local c = awful.client.focus
	return c.name or ""
end

return wibox.widget({
	widget = wibox.widget.textbox,
	font = theme.font_normal,
	align = "center",
	valign = "center",
	-- text = get_client_name(),
	text = "Test",
})
