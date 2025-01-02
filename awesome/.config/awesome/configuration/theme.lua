local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()

local theme = beautiful.get()

theme.black = xrdb.color0
theme.black2 = xrdb.color8

theme.red = xrdb.color1
theme.red2 = xrdb.color9

theme.green = xrdb.color2
theme.green2 = xrdb.color10

theme.yellow = xrdb.color3
theme.yellow2 = xrdb.color11

theme.blue = xrdb.color4
theme.blue2 = xrdb.color12

theme.magenta = xrdb.color5
theme.magenta2 = xrdb.color13

theme.cyan = xrdb.color6
theme.cyan2 = xrdb.color14

theme.white = xrdb.color7
theme.white2 = xrdb.color15

theme.primary = theme.magenta
theme.secondary = theme.blue
theme.alert = theme.red

theme.font_regular = "Noto Sans 10"
theme.font_regular_bold = "Noto Sans Bold 10"
theme.font_monospace = "Monospace 10"
theme.font_monospace_bold = "Monospace Bold 10"

theme.icon_font = theme.font_monospace

return theme
