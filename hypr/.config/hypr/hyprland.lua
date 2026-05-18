-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "DP-1",
	mode = "3840x2160@143.85",
	position = "auto",
	scale = "1",
})

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal = "footclient"
local fileManager = "pcmanfm"
local menu = "dmenu_run -b -l 10 -p 'run:'"

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
	hl.exec_cmd("waybar & hyprpaper")
	hl.exec_cmd("xsettingsd")
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("thunderbird")
	hl.exec_cmd("udiskie --tray")
	hl.exec_cmd("sudo ntfsfix -d /dev/sdb1")
	hl.exec_cmd("rclone mount syncraft_at_google:/ /home/himon/Remote/syncraft@google/ --vfs-cache-mode full --daemon")
	hl.exec_cmd("hyprctl setcursor rose-pine-moon 24")
	hl.exec_cmd("gammastep-indicator")
	hl.exec_cmd("foot -s")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcusor")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 12,
		gaps_out = 16,

		border_size = 0,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "master",
	},

	cursor = {
		inactive_timeout = 1,
	},

	decoration = {
		rounding = 5,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 14,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = false,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},

		dim_inactive = true,
		dim_strength = 0.2,
	},

	animations = {
		enabled = true,
	},
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "slide right" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "slide right" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
	master = {
		new_status = "slave",
		mfact = "0.5",
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
		disable_splash_rendering = true,
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "pl",
		kb_variant = "",
		kb_model = "",
		kb_options = "caps:escape",
		kb_rules = "",
		repeat_rate = 60,
		repeat_delay = 250,

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = false,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
-- hl.device({
-- 	-- name = "epic-mouse-v1",
-- 	-- sensitivity = -0.5,
-- })

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "ALT" -- Sets "Windows" key as main modifier
local ctrlMod = "CTRL"
local shiftMod = "SHIFT"
local superMod = "SUPER"

local function formatKeys(...)
	local keys = { ... }

	return table.concat(keys, " + ")
end

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
-- local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
--
hl.bind(formatKeys(mainMod, ctrlMod, "T"), hl.dsp.exec_cmd(terminal))
hl.bind(formatKeys(mainMod, ctrlMod, "W"), hl.dsp.exec_cmd("killall waybar 2>/dev/null; waybar"))
hl.bind(formatKeys(ctrlMod, "X"), hl.dsp.window.close())
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(formatKeys(superMod, "F"), hl.dsp.window.float({ action = "toggle" }))
hl.bind(formatKeys(mainMod, "D"), hl.dsp.exec_cmd(menu))
hl.bind(formatKeys(mainMod, "T"), hl.dsp.exec_cmd("~/.config/scripts/openinfoot.sh"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(formatKeys(superMod, "L"), hl.dsp.exec_cmd("hyprlock"))
hl.bind(formatKeys(superMod, "T"), hl.dsp.exec_cmd('fish -c "toggle-theme"'))

-- Move focus with mainMod + arrow keys
hl.bind(formatKeys(mainMod, "h"), hl.dsp.focus({ direction = "left" }))
hl.bind(formatKeys(mainMod, "j"), hl.dsp.focus({ direction = "down" }))
hl.bind(formatKeys(mainMod, "k"), hl.dsp.focus({ direction = "up" }))
hl.bind(formatKeys(mainMod, "l"), hl.dsp.focus({ direction = "right" }))

hl.bind(formatKeys(mainMod, shiftMod, "h"), hl.dsp.window.move({ direction = "left" }))
hl.bind(formatKeys(mainMod, shiftMod, "j"), hl.dsp.window.move({ direction = "down" }))
hl.bind(formatKeys(mainMod, shiftMod, "k"), hl.dsp.window.move({ direction = "up" }))
hl.bind(formatKeys(mainMod, shiftMod, "l"), hl.dsp.window.move({ direction = "right" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(formatKeys(mainMod, key), hl.dsp.focus({ workspace = i, on_current_monitor = true }))
	hl.bind(formatKeys(mainMod, shiftMod, key), hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(formatKeys(mainMod, "period"), hl.dsp.focus({ workspace = "e+1", on_current_monitor = true }))
hl.bind(formatKeys(mainMod, "comma"), hl.dsp.focus({ workspace = "e-1", on_current_monitor = true }))
hl.bind(
	formatKeys(mainMod, ctrlMod, "k"),
	hl.dsp.window.resize({ x = "0", y = "30", relative = true }, { description = "resise window" })
)
hl.bind(
	formatKeys(mainMod, ctrlMod, "j"),
	hl.dsp.window.resize({ x = "0", y = "-30", relative = true }, { description = "resize window" })
)
hl.bind(
	formatKeys(mainMod, ctrlMod, "h"),
	hl.dsp.window.resize({ x = "-30", y = "0", relative = true }, { description = "resize window" })
)
hl.bind(
	formatKeys(mainMod, ctrlMod, "l"),
	hl.dsp.window.resize({ x = "30", y = "0", relative = true }, { description = "resize window" })
)

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.window_rule({
	match = {
		modal = true,
	},
	float = true,
})

hl.window_rule({
	match = {
		initial_class = "zen",
	},
	-- fullscreen_state_client = 0,
	-- fullscreen_state_internal = 2,
	tile = true,
})

hl.window_rule({
	match = {
		class = "obsidian",
	},
	workspace = "6 silent",
})

hl.window_rule({
	match = {
		title = "ncmpcpp",
	},
	workspace = "7",
})

hl.window_rule({
	match = {
		title = "cmus",
	},
	workspace = "7",
})

hl.window_rule({
	match = {
		class = "GG",
	},
	workspace = "8 silent",
})

hl.window_rule({
	match = {
		class = "Gg",
	},
	workspace = "8 silent",
})

hl.window_rule({
	match = {
		class = "Thunderbird",
	},
	workspace = "9 silent",
})

hl.window_rule({
	match = {
		class = "thunderbird",
	},
	workspace = "9 silent",
})

hl.window_rule({
	match = {
		class = "Mail",
	},
	workspace = "9 silent",
})

hl.window_rule({
	match = {
		class = "org.mozilla.Thunderbird",
	},
	workspace = "9 silent",
})

hl.window_rule({
	match = {
		class = "Microsoft Teams - Previewworkspace",
	},
	workspace = "10 silent",
})

hl.window_rule({
	match = {
		class = "teams-for-linux",
	},
	workspace = "10 silent",
})

hl.window_rule({
	match = {
		class = "^steam_app_d+$",
	},
	workspace = "10 silent",
	monitor = "1",
	fullscreen = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
hl.workspace_rule({
	workspace = "10",
	no_border = true,
})
