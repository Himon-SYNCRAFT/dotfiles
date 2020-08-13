# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.lazy import lazy
from libqtile import layout, bar, widget

from typing import List  # noqa: F401

mod = "mod4"

COLORS = {
    "dark_0": "#1d2021",
    "dark_1": "#282828",
    "dark_2": "#32302f",
    "dark_3": "#3c3836",
    "dark_4": "#504945",
    "dark_5": "#665c54",
    "dark_6": "#7c6f64",
    "gray_0": "#928374",
    "light_0": "#f9f5d7",
    "light_1": "#fbf1c7",
    "light_2": "#f2e5bc",
    "light_3": "#ebdbb2",
    "light_4": "#d5c4a1",
    "light_5": "#bdae93",
    "light_6": "#a89984",
    "red_0": "#fb4934",
    "red_1": "#cc241d",
    "red_2": "#9d0006",
    "green_0": "#b8bb26",
    "green_1": "#98971a",
    "green_2": "#79740e",
    "yellow_0": "#fabd2f",
    "yellow_1": "#d79921",
    "yellow_2": "#b57614",
    "blue_0": "#83a598",
    "blue_1": "#458588",
    "blue_2": "#076678",
    "purple_0": "#d3869b",
    "purple_1": "#b16286",
    "purple_2": "#8f3f71",
    "aqua_0": "#8ec07c",
    "aqua_1": "#689d6a",
    "aqua_2": "#427b58",
    "orange_0": "#fe8019",
    "orange_1": "#d65d0e",
    "orange_2": "#af3a03",
}

FONT = 'TerminessTTF Nerd Font Bold'
FONT_SIZE = 13
PADDING = 3
FONT_PARAMS = dict(
    font=FONT,
    fontsize=FONT_SIZE,
    foreground=COLORS['light_3']
)

BORDER_NORMAL = COLORS["dark_2"]
BORDER_FOCUS = COLORS["red_1"]
BORDER_WIDTH = 3
MARGIN = 10

# default keys
# keys = [
#     # Switch between windows in current stack pane
#     Key([mod], "k", lazy.layout.down()),
#     Key([mod], "j", lazy.layout.up()),

#     # Move windows up or down in current stack
#     Key([mod, "control"], "k", lazy.layout.shuffle_down()),
#     Key([mod, "control"], "j", lazy.layout.shuffle_up()),

#     # Switch window focus to other pane(s) of stack
#     Key([mod], "space", lazy.layout.next()),

#     # Swap panes of split stack
#     Key([mod, "shift"], "space", lazy.layout.rotate()),

#     # Toggle between split and unsplit sides of stack.
#     # Split = all windows displayed
#     # Unsplit = 1 window displayed, like Max layout, but still with
#     # multiple stack panes
#     Key([mod, "shift"], "Return", lazy.layout.toggle_split()),
#     Key([mod], "Return", lazy.spawn("alacritty")),

#     # Toggle between different layouts as defined below
#     Key([mod], "Tab", lazy.next_layout()),
#     Key([mod], "w", lazy.window.kill()),

#     Key([mod, "control"], "r", lazy.restart()),
#     Key([mod, "control"], "q", lazy.shutdown()),
#     Key([mod], "r", lazy.spawncmd()),
# ]

keys = [
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    Key([mod, "mod1"], "j", lazy.layout.flip_down()),
    Key([mod, "mod1"], "k", lazy.layout.flip_up()),
    Key([mod, "mod1"], "h", lazy.layout.flip_left()),
    Key([mod, "mod1"], "l", lazy.layout.flip_right()),
    Key([mod, "control"], "j", lazy.layout.grow_down()),
    Key([mod, "control"], "k", lazy.layout.grow_up()),
    Key([mod, "control"], "h", lazy.layout.grow_left()),
    Key([mod, "control"], "l", lazy.layout.grow_right()),
    Key([mod, "shift"], "n", lazy.layout.normalize()),
    Key([mod], "Return", lazy.spawn("alacritty")),
    Key([mod], "e", lazy.layout.toggle_split()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod], "w", lazy.window.kill()),
    Key([mod], "r", lazy.spawncmd()),
]

groups = [Group(i) for i in "12345678"]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen()),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
    ])

layouts = [
    layout.Max(),
    # layout.Stack(num_stacks=2),
    # Try more layouts by unleashing below layouts.
    layout.Bsp(
        border_normal=BORDER_NORMAL,
        border_focus=BORDER_FOCUS,
        border_width=BORDER_WIDTH,
        margin=MARGIN,
        fair=False
    ),
    # layout.Columns(),
    # layout.Matrix(),
    layout.MonadTall(
        border_normal=BORDER_NORMAL,
        border_focus=BORDER_FOCUS,
        border_width=BORDER_WIDTH,
        margin=MARGIN,
        ratio=0.7
    ),
    layout.MonadWide(
        border_normal=BORDER_NORMAL,
        border_focus=BORDER_FOCUS,
        border_width=BORDER_WIDTH,
        margin=MARGIN,
        ratio=0.9
    ),
    # layout.RatioTile(margin=3),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]


screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Sep(linewidth=2, foreground=COLORS["dark_2"]),
                widget.CurrentLayout(**FONT_PARAMS),
                widget.TextBox(
                    font="Arial",
                    foreground=COLORS["dark_4"],
                    text="◢",
                    fontsize=70,
                    padding=-7
                ),
                widget.GroupBox(
                    other_current_screen_border=COLORS["orange_0"],
                    this_current_screen_border=COLORS["blue_0"],
                    other_screen_border=COLORS["orange_0"],
                    this_screen_border=COLORS["blue_0"],
                    highlight_color=COLORS["blue_0"],
                    urgent_border=COLORS["red_1"],
                    background=COLORS["dark_4"],
                    highlight_method="line",
                    inactive=COLORS["dark_2"],
                    active=COLORS["light_2"],
                    disable_drag=True,
                    borderwidth=2,
                    **FONT_PARAMS,
                ),
                widget.TextBox(
                    font="Arial",
                    foreground=COLORS["dark_4"],
                    text="◤ ",
                    fontsize=70,
                    padding=-7
                ),
                widget.Prompt(**FONT_PARAMS),
                widget.WindowName(**FONT_PARAMS),
                widget.Systray(**FONT_PARAMS),
                widget.Clock(
                    format='%H:%M %d.%m.%Y',
                    **FONT_PARAMS,
                ),
            ],
            25,
            background=COLORS["dark_2"]
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
