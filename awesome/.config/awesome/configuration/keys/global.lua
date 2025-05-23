local awful = require("awful")
local gears = require("gears")
local gmath = require("gears.math")
local menubar = require("menubar")
local sharedtags = require("sharedtags")

require("awful.autofocus")
local hotkeys_popup = require("awful.hotkeys_popup").widget

local modkey = require("configuration.keys.mod").modKey
local ctrlKey = require("configuration.keys.mod").ctrlKey
local shiftKey = require("configuration.keys.mod").shiftKey
local apps = require("configuration.apps")

local function next_non_empty_tag()
	local screen = awful.screen.focused()
	local current_tag = screen.selected_tag
	local current_tag_index = current_tag.index

	local tags = screen.tags
	local showntags = {}

	for _, t in ipairs(tags) do
		if not awful.tag.getproperty(t, "hide") then
			table.insert(showntags, t)
		end
	end

	awful.tag.viewnone(screen)

	next_index = gmath.cycle(#showntags, current_tag_index + 1)

	while next_index ~= current_tag_index do
		local _tag = screen.tags[next_index]
		local has_clients = #_tag:clients() > 0

		if has_clients then
			break
		end

		next_index = gmath.cycle(#showntags, next_index + 1)
	end

	showntags[gmath.cycle(#showntags, next_index)].selected = true

	screen:emit_signal("tag::history::update")
end

local function prev_non_empty_tag()
	local screen = awful.screen.focused()
	local current_tag = screen.selected_tag
	local current_tag_index = current_tag.index

	local tags = screen.tags
	local showntags = {}

	for _, t in ipairs(tags) do
		if not awful.tag.getproperty(t, "hide") then
			table.insert(showntags, t)
		end
	end

	awful.tag.viewnone(screen)

	next_index = gmath.cycle(#showntags, current_tag_index - 1)

	while next_index ~= current_tag_index do
		local _tag = screen.tags[next_index]
		local has_clients = #_tag:clients() > 0

		if has_clients then
			break
		end

		next_index = gmath.cycle(#showntags, next_index - 1)
	end

	showntags[gmath.cycle(#showntags, next_index)].selected = true

	screen:emit_signal("tag::history::update")
end

local function swap_bydirection(dir)
	local sel = client.focus
	local scr = awful.screen.focused()

	if sel then
		-- move focus
		awful.client.focus.global_bydirection(dir, sel)
		local c = client.focus
		--
		-- -- swapping inside a screen
		if sel.screen.index == c.screen.index and sel ~= c then
			c:swap(sel)

			-- swapping to an empty screen
		elseif sel == c then
			sel:move_to_screen(awful.screen.focused())
			-- swapping to a nonempty screen
		elseif sel.screen.index ~= c.screen.index and sel ~= c then
			sel:move_to_screen(c.screen)
			-- c:move_to_screen(scr)
		end

		awful.screen.focus(sel.screen)
		sel:emit_signal("request::activate", "client.swap.global_bydirection", { raise = false })
	end
end

-- {{{ Key bindings
globalKeys = gears.table.join(
	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({ modkey }, "comma", prev_non_empty_tag, { description = "view previous", group = "tag" }),
	awful.key({ modkey }, "period", next_non_empty_tag, { description = "view next", group = "tag" }),
	-- awful.key({ modkey, "Shift" }, "Left", function()
	-- 	-- get current tag
	-- 	local t = client.focus and client.focus.first_tag or nil
	-- 	if t == nil then
	-- 		return
	-- 	end
	-- 	-- get previous tag (modulo 9 excluding 0 to wrap from 1 to 9)
	-- 	local tag = client.focus.screen.tags[(t.index - 2) % 9 + 1]
	-- 	awful.client.movetotag(tag)
	-- 	awful.tag.viewprev()
	-- end, { description = "move client to previous tag and switch to it", group = "tag" }),
	-- awful.key({ modkey, "Shift" }, "Right", function()
	-- 	-- get current tag
	-- 	local t = client.focus and client.focus.first_tag or nil
	-- 	if t == nil then
	-- 		return
	-- 	end
	-- 	-- get next tag (modulo 9 excluding 0 to wrap from 9 to 1)
	-- 	local tag = client.focus.screen.tags[(t.index % 9) + 1]
	-- 	awful.client.movetotag(tag)
	-- 	awful.tag.viewnext()
	-- end, { description = "move client to next tag and switch to it", group = "tag" }),
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
	awful.key({ modkey }, "j", function()
		awful.client.focus.global_bydirection("down")
	end, { description = "focus window down", group = "client" }),
	awful.key({ modkey }, "k", function()
		awful.client.focus.global_bydirection("up")
	end, { description = "focus window up", group = "client" }),
	awful.key({ modkey }, "h", function()
		awful.client.focus.global_bydirection("left")
	end, { description = "focus window on left", group = "client" }),
	awful.key({ modkey }, "l", function()
		awful.client.focus.global_bydirection("right")
	end, { description = "focus window on right", group = "client" }),
	awful.key({ modkey }, "w", function()
		mymainmenu:show()
	end, { description = "show main menu", group = "awesome" }),

	-- Layout manipulation
	awful.key({ modkey, shiftKey }, "j", function()
		swap_bydirection("down")
	end, { description = "swap window down", group = "client" }),
	awful.key({ modkey, shiftKey }, "k", function()
		swap_bydirection("up")
	end, { description = "swap window up", group = "client" }),
	awful.key({ modkey, shiftKey }, "h", function()
		swap_bydirection("left")
	end, { description = "swap window on left", group = "client" }),
	awful.key({ modkey, shiftKey }, "l", function()
		swap_bydirection("right")
	end, { description = "swap window on right", group = "client" }),
	-- awful.key({ modkey, "Control" }, "j", function()
	-- 	awful.screen.focus_relative(1)
	-- end, { description = "focus the next screen", group = "screen" }),
	-- awful.key({ modkey }, "k", function()
	-- 	awful.screen.focus_relative(-1)
	-- end, { description = "focus the previous screen", group = "screen" }),
	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
	-- awful.key({ modkey }, "Tab", function()
	-- 	awful.client.focus.history.previous()
	-- 	if client.focus then
	-- 		client.focus:raise()
	-- 	end
	-- end, { description = "go back", group = "client" }),

	-- Standard program
	awful.key({ modkey, ctrlKey }, "t", function()
		awful.spawn(apps.open_terminal_cmd)
	end, { description = "open a terminal", group = "launcher" }),
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "e", awesome.quit, { description = "quit awesome", group = "awesome" }),
	-- awful.key({ modkey, "Shift" }, "k", function()
	-- 	awful.tag.incnmaster(1, nil, true)
	-- end, { description = "increase the number of master clients", group = "layout" }),
	-- awful.key({ modkey, "Shift" }, "l", function()
	-- 	awful.tag.incnmaster(-1, nil, true)
	-- end, { description = "decrease the number of master clients", group = "layout" }),
	-- awful.key({ modkey, "Shift" }, "h", function()
	-- 	awful.tag.incncol(1, nil, true)
	-- end, { description = "increase the number of columns", group = "layout" }),
	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),

	awful.key({ modkey }, "space", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),

	awful.key({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),

	-- awful.key({ modkey, "Control" }, "n", function()
	-- 	local c = awful.client.restore()
	-- 	-- Focus restored client
	-- 	if c then
	-- 		c:emit_signal("request::activate", "key.unminimize", { raise = true })
	-- 	end
	-- end, { description = "restore minimized", group = "client" }),

	-- Prompt
	awful.key({ modkey }, "r", function()
		awful.screen.focused().mypromptbox:run()
	end, { description = "run prompt", group = "launcher" }),

	-- awful.key({ modkey }, "x", function()
	-- 	awful.prompt.run({
	-- 		prompt = "Run Lua code: ",
	-- 		textbox = awful.screen.focused().mypromptbox.widget,
	-- 		exe_callback = awful.util.eval,
	-- 		history_path = awful.util.get_cache_dir() .. "/history_eval",
	-- 	})
	-- end, { description = "lua execute prompt", group = "awesome" }),
	--
	-- Menubar
	awful.key({ modkey }, "m", function()
		menubar.show()
	end, { description = "show the menubar", group = "launcher" }),

	awful.key({ modkey }, "d", function()
		awful.spawn("dmenu_run -b -l 10 -p 'run:'")
	end, { description = "dmenu", group = "launcher" }),

	awful.key({ modkey }, "t", function()
		awful.spawn(os.getenv("HOME") .. "/.config/scripts/openinterminal.sh")
	end, { description = "dmenu", group = "launcher" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 10 do
	-- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
	local descr_view, descr_toggle, descr_move, descr_toggle_focus
	if i == 1 or i == 10 then
		descr_view = { description = "view tag #", group = "tag" }
		descr_toggle = { description = "toggle tag #", group = "tag" }
		descr_move = { description = "move focused client to tag #", group = "tag" }
		descr_toggle_focus = { description = "toggle focused client on tag #", group = "tag" }
	end
	globalKeys = awful.util.table.join(
		globalKeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = sharedTags[i]
			if tag then
				sharedtags.viewonly(tag, screen)
			end
		end, descr_view),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = sharedTags[i]
			if tag then
				sharedtags.viewtoggle(tag, screen)
			end
		end, descr_toggle),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = sharedTags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, descr_move),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = sharedTags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, descr_toggle_focus)
	)
end

return globalKeys
