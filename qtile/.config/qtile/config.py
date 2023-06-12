import os
import subprocess
from typing import Any, Dict, List

from libqtile import bar, hook  # , widget
from libqtile.config import Click, Drag, Group, Key, Match, Rule, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# from libqtile.layout.bsp import Bsp
from libqtile.layout.columns import Columns
from libqtile.layout.floating import Floating
# from libqtile.layout.matrix import Matrix
# from libqtile.layout.max import Max
# from libqtile.layout.ratiotile import RatioTile
# from libqtile.layout.stack import Stack
# from libqtile.layout.tile import Tile
# from libqtile.layout.tree import TreeTab
# from libqtile.layout.verticaltile import VerticalTile
from libqtile.layout.xmonad import MonadTall, MonadWide
# from libqtile.layout.zoomy import Zoomy


mod = "mod1"
super_key = "mod4"
terminal = guess_terminal('st')
terminal_in_fish = "st -w '' -e fish"


class DraculaTheme:
    background = "#282A36"
    foreground = "#F8F8F2"
    foreground_alt = "#F8F8F2"
    primary = "#FF79C6"
    secondary = "#FF79C6"
    alert = "#FF5555"

    black = "#4D4D4D"
    red = "#FF5555"
    green = "#50FA7B"
    yellow = "#F1FA8C"
    blue = "#BD93F9"
    magenta = "#FF79C6"
    cyan = "#8BE9FD"
    white = "#BFBFBF"


class CatppuccinMacchiato:
    background = "#24273A"
    foreground = "#CAD3F5"
    foreground_alt = "#b8c0e0"
    primary = "#ee99a0"
    secondary = "#8aadf4"
    alert = "#c6a0f6"

    black = "#181926"
    red = "#ed8796"
    green = "#a6da95"
    yellow = "#eed49f"
    blue = "#8aadf4"
    magenta = "#ee99a0"
    cyan = "#8bd5ca"
    white = "#cad3f5"


class TokyoNight:
    background = "#24283b"
    foreground = "#c0caf5"
    foreground_alt = "#414868"
    primary = "#7aa2f7"
    secondary = "#bb9af7"
    alert = "#f7768e"

    black = "#1d202f"
    red = "#f7768e"
    green = "#9ece6a"
    yellow = "#e0af68"
    blue = "#7aa2f7"
    magenta = "#bb9af7"
    cyan = "#7dcfff"
    white = "#a9b1d6"


class Kanagawa:
    background = "#1f1f28"
    foreground = "#dcd7ba"
    foreground_alt = "#c8c093"
    primary = "#6a9589"
    secondary = "#76946a"
    alert = "#c34043"

    black = "#090618"
    red = "#c34043"
    green = "#76946a"
    yellow = "#c0a36e"
    blue = "#7e9cd8"
    magenta = "#957fb8"
    cyan = "#6a9589"
    white = "#c8c093"


theme = Kanagawa


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(),
        desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    # Key([mod, "control"], "h", lazy.layout.grow_left(),
    #     desc="Grow window to the left"),
    # Key([mod, "control"], "l", lazy.layout.grow_right(),
    #     desc="Grow window to the right"),
    # Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    # Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "control"], "j", lazy.layout.shrink(), desc="Shrink window"),
    Key([mod, "control"], "k", lazy.layout.grow(), desc="Grow window"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key(["control"], "x", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    Key([mod, "control"], "t", lazy.spawn(
        terminal_in_fish), desc="Launch terminal"),
    Key([mod], "r", lazy.spawn(
        "st -w '' -e ranger"), desc="Launch ranger"),
    Key([super_key], "l", lazy.spawn("betterlockscreen -s dim"), desc="Suspend"),
    Key([mod], "d", lazy.spawn('dmenu_run -b -l 10 -p "run:"'),
        desc="Program launcher"),
    Key([mod], "t", lazy.spawn(os.path.expanduser('~/.config/scripts/openinterminal.sh')),
        desc="Open in terminal"),
    Key([mod], 'period', lazy.screen.next_group(
        True), desc="Switch to next group"),
    Key([mod], 'comma', lazy.screen.prev_group(
        True), desc="Switch to previous group"),
    # Switch focus of monitors
    Key(["control"], "period",
        lazy.next_screen(),
        desc='Move focus to next monitor'
        ),
    Key(["control"], "comma",
        lazy.prev_screen(),
        desc='Move focus to prev monitor'
        ),
    Key([], "Print", lazy.spawn(
        "gscreenshot"),
        desc="Screenshot"
        ),
    Key([super_key], "f", lazy.window.toggle_floating(), desc="Toggle floating"),
]


groups = []

for name, label in zip("1234567890", [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]):
    layout = 'monadtall'
    group = Group(name=str(name), label=label, layout=layout)

    if name == '8':
        layout = 'monadwide'
        group = Group(name=str(name), label=label, layout=layout,
                      layout_opts=dict(ratio=0.25, min_ratio=0.20, max_ratio=0.80))

    groups.append(group)

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc="Switch to & move focused window to group {}".format(
                    i.name),
            ),

            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )


border_focus = theme.primary
border_normal = theme.background

border_width = 2
default_margin = 10
margin = [default_margin, default_margin, default_margin, default_margin]

layout_config = dict(
    border_focus=border_focus,
    border_normal=border_normal,
    border_width=border_width,
    margin=margin,
)

monad_layout_config = dict(
    border_focus=border_focus,
    border_normal=border_normal,
    border_width=border_width,
    margin=default_margin,
)

layouts = [
    # Max(**layout_config),
    # Try more layouts by unleashing below layouts.
    # Stack(num_stacks=2),
    # Matrix(**layout_config),
    MonadTall(**monad_layout_config, max_ratio=0.80, min_ratio=0.20),
    MonadWide(**monad_layout_config, max_ratio=0.8,
              min_ratio=0.20, ratio=0.20),
    Columns(**layout_config, insert_position=1),
    # RatioTile(**layout_config),
    # Tile(**layout_config, master_length=4, ratio=0.5, shift_windows=True),
    # Bsp(**layout_config),
    # TreeTab(**layout_config),
    # VerticalTile(**layout_config),
    # Zoomy(**layout_config),
]

widget_defaults = dict(
    font="SauceCodePro Nerd Font",
    fontsize=14,
    foreground='F8F8F2',
    padding=2,
)
extension_defaults = widget_defaults.copy()

group_box_config: Dict[str, Any] = dict(
    **widget_defaults,
    hide_unused=True,
    highlight_method='line',
    highlight_color='50FA7B',
    rounded=False,
    margin_x=20,
    border_width=0,
    urgent_alert_method='line',
    urgent_border='FF5555',
    center_aligned=True,
)
group_box_config['fontsize'] = 18
group_box_config['padding'] = 0

screens = [
    Screen(
        top=bar.Gap(32),
        left=bar.Gap(0),
        right=bar.Gap(0),
        bottom=bar.Gap(0),
        # bottom=bar.Bar(
        #     widgets=[
        #         widget.Sep(),
        #         widget.CurrentLayoutIcon(
        #             **widget_defaults,
        #         ),
        #         widget.GroupBox(
        #             **group_box_config
        #         ),
        #         widget.Spacer(),
        #         widget.WindowName(
        #             **widget_defaults
        #         ),
        #         widget.Cmus(
        #             **widget_defaults
        #         ),
        #         widget.Spacer(),
        #         widget.Chord(
        #             **widget_defaults,
        #             chords_colors={
        #                 "launch": ("#ff0000", "#ffffff"),
        #             },
        #             name_transform=lambda name: name.upper(),
        #         ),
        #         widget.Volume(
        #             **widget_defaults
        #         ),
        #         widget.CheckUpdates(
        #             **widget_defaults
        #         ),
        #         widget.CPU(
        #             **widget_defaults
        #         ),
        #         widget.Memory(
        #             **widget_defaults
        #         ),
        #         widget.HDDGraph(
        #             **widget_defaults
        #         ),
        #         widget.Clock(
        #             **widget_defaults,
        #             format="%d.%m.%Y %H:%M",
        #         ),
        #         widget.KeyboardLayout(
        #             **widget_defaults,
        #             configured_keyboards=['pl', 'pl dvorak'],
        #         ),
        #         widget.Systray(
        #             **widget_defaults,
        #         ),
        #     ],
        #     size=36,
        #     background=CatppuccinMacchiato.background,
        # ),
    ),
    Screen(
        top=bar.Gap(32),
        left=bar.Gap(0),
        right=bar.Gap(0),
        bottom=bar.Gap(0),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules: List[Rule] = [
    Rule(Match(wm_class='obsidian'), group='6'),
    Rule(Match(wm_class='GG'), group='8'),
    Rule(Match(wm_class='Gg'), group='8'),
    Rule(Match(wm_class='microsoft teams - preview'), group='0'),
    Rule(Match(wm_class='Mail'), group='9'),
    Rule(Match(wm_class='Thunderbird'), group='9'),
    Rule(Match(title='cmus'), group='7'),
    Rule(Match(title='ncmpcpp'), group='7'),
    Rule(Match(title='Spotify'), group='7'),
]
follow_mouse_focus = True
bring_front_click = True
cursor_warp = False
floating_layout = Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
    border_focus=theme.primary,
    border_normal=theme.background,
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.run([home])


def move_to_next_group():
    lazy.group.get_next_group(True).toscreen()


def move_to_previous_group():
    lazy.group.get_previous_group(True).toscreen()
