local awful = require("awful")
local gears = require("gears")
local client_keys = require("configuration.client.keys")
local client_buttons = require("configuration.client.buttons")
local title_bars = require("configuration.client.titlebars")
local beautiful = require("beautiful")

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			-- border_width = beautiful.border_width,
			border_width = 0,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientKeys,
			buttons = clientButtons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
			size_hints_honor = false,
			maximized = false,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	-- Add titlebars to normal clients and dialogs
	{
		rule_any = { type = { "normal", "dialog" } },
		properties = { titlebars_enabled = false },
	},

	-- Set Firefox to always map on the tag named "2" on screen 1.
	{
		rule = { class = "obsidian" },
		properties = { tag = sharedTags[6] },
	},

	{
		rule_any = {
			class = { "ncmpcpp", "cmus" },
			instance = { "ncmpcpp", "cmus" },
		},
		properties = { tag = sharedTags[7] },
	},

	{
		rule_any = { class = { "GG", "Gg" } },
		properties = { tag = sharedTags[8] },
	},

	{
		rule = { class = "Microsoft Teams - Preview" },
		properties = { tag = sharedTags[10] },
	},

	{
		rule_any = {
			class = { "Mail", "Thunderbird", "thunderbird" },
		},
		properties = { tag = sharedTags[9] },
	},
}
-- }}}
