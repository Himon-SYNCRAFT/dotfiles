local dpi = require("beautiful.xresources").apply_dpi
local menubar = require("menubar")

apps = {
	-- Your default terminal
	-- terminal = "ghostty",
	terminal = "st",

	-- Your default text editor
	editor = "nvim",

	-- editor_cmd = terminal .. " -e " .. editor,

	-- Your default file explorer
	explorer = "pcmanfm",

	lockscreen = "betterlockscreen -s dim",
}

-- apps.open_terminal_cmd = "ghostty --gtk-single-instance=true"
apps.open_terminal_cmd = "st -w '' -e fish"
apps.editor_cmd = apps.terminal .. " -e " .. apps.editor
apps.explorer_cmd = apps.terminal .. " -e " .. apps.explorer
menubar.utils.terminal = apps.terminal -- Set the terminal for applications that require it

return apps
