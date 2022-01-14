import os
import subprocess
from typing import List

from libqtile import bar, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from libqtile.layout.bsp import Bsp
from libqtile.layout.columns import Columns
from libqtile.layout.floating import Floating
from libqtile.layout.matrix import Matrix
from libqtile.layout.max import Max
from libqtile.layout.ratiotile import RatioTile
from libqtile.layout.stack import Stack
from libqtile.layout.tile import Tile
from libqtile.layout.tree import TreeTab
from libqtile.layout.verticaltile import VerticalTile
from libqtile.layout.xmonad import MonadTall, MonadWide
from libqtile.layout.zoomy import Zoomy

from libqtile.widget.currentlayout import CurrentLayout

mod = "mod1"
super_key = "mod4"
terminal = guess_terminal('st')
terminal_in_fish = 'tabbed -n "st" -d -r 2 st -w '' -e fish'

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
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
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key(["control"], "x", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    Key([mod, "control"], "t", lazy.spawn(terminal_in_fish), desc="Launch terminal"),
    Key([mod, "control"], "r", lazy.spawn("st -w '' -e ranger"), desc="Launch ranger"),
    Key([super_key], "l", lazy.spawn("betterlockscreen -s dim"), desc="Suspend"),
    Key([mod], "d", lazy.spawn('dmenu_run -b -l 10 -p "run:"'), desc="Program launcher"),
    Key([mod], "t", lazy.spawn('~/.config/scripts/openinterminal.sh'), desc="Open in terminal"),
]

groups = [Group(i) for i in "1234567890"]

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
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

border_focus = '#3e518e'
border_normal = '#312e39'
border_width = 2
margin = [10, 10, 10, 10]
layout_config = dict(
    border_focus=border_focus,
    border_normal=border_normal,
    border_width=border_width,
    margin=margin,
)

layouts = [
    # Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    # Max(**layout_config),
    # Try more layouts by unleashing below layouts.
    # Stack(num_stacks=2),
    # Matrix(**layout_config),
    MonadTall(**layout_config),
    MonadWide(**layout_config),
    # RatioTile(**layout_config),
    Tile(**layout_config),
    Bsp(**layout_config),
    # TreeTab(**layout_config),
    # VerticalTile(**layout_config),
    # Zoomy(**layout_config),
]

widget_defaults = dict(
    font="SauceCodePro Nerd Font",
    fontsize=11,
    padding=2,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Gap(36),
        left=bar.Gap(5),
        right=bar.Gap(5),
        bottom=bar.Gap(5),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
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
    ]
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
