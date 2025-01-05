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

theme.bg_normal = xrdb.background
theme.bg_focus = xrdb.color12
theme.bg_urgent = xrdb.color9
theme.bg_minimize = xrdb.color8
theme.bg_systray = theme.bg_normal

theme.fg_normal = xrdb.foreground
theme.fg_focus = theme.bg_normal
theme.fg_urgent = theme.bg_normal
theme.fg_minimize = theme.bg_normal

local font = "Sans"
local size = "10"
local font_monospace = "Monospace"

theme.font_name = font
theme.font_regular = font .. " " .. size
theme.font_regular_bold = font .. " Bold " .. size
theme.font_monospace = font_monospace .. " " .. size
theme.font_monospace_bold = font_monospace .. " Bold " .. size

theme.icon_font = theme.font_monospace

return theme
