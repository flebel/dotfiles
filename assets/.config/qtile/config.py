# -*- coding: utf-8 -*-

import os
import platform
import subprocess

from libqtile import bar, hook, layout, widget
from libqtile.command import lazy
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.dgroups import simple_key_binder

ALT_KEY = 'mod1'
CONTROL_KEY = 'control'
MOD_KEY = 'mod4'
PAUSE_KEY = 'Pause'
RETURN_KEY = 'Return'
SHIFT_KEY = 'shift'
TAB_KEY = 'Tab'

BLUE = '#215578'
BRIGHT_BLUE = '#18BAEB'
DARK_GRAY = '#202020'

hostname = platform.node()

bar_defaults = {
    'background': DARK_GRAY,
}

widget_defaults = {
    'font': 'Monospace',
    'fontsize': 11,
    'foreground': BLUE,
}

widget_groupbox_defaults = widget_defaults
widget_groupbox_defaults['fontsize'] = 9
widget_groupbox_defaults['foreground'] = BRIGHT_BLUE
widget_groupbox_defaults['padding'] = 0

widget_graph_defaults = {
    'border_width': 1,
    'line_width': 1,
    'margin_y': 4,
}

if hostname == 'tambora':
    screens = [
        Screen(bottom=bar.Bar(widgets=[
                widget.GroupBox(urgent_alert_method='text', **widget_groupbox_defaults),
                widget.Spacer(width=bar.STRETCH),
                widget.Clock(format='%Y-%m-%d %a %I:%M %p', timezone='UTC', **widget_defaults),
                widget.TextBox('  /\  '),
                widget.Clock(format='%Y-%m-%d %a %I:%M %p', **widget_defaults),
                widget.Spacer(width=5),
            ], size=17, **bar_defaults),
            top=bar.Bar(widgets=[
                widget.WindowName(**widget_defaults),

                widget.TextBox('CPU:'),
                widget.CPUGraph(**widget_graph_defaults),

                widget.Spacer(width=2),
                widget.TextBox('Mem:'),
                widget.MemoryGraph(**widget_graph_defaults),

                widget.Spacer(width=2),
                widget.TextBox('Swap:'),
                widget.SwapGraph(**widget_graph_defaults),

                widget.Spacer(width=2),
                widget.TextBox('Net:'),
                widget.NetGraph(**widget_graph_defaults),

                widget.Spacer(width=4),
                widget.TextBox('Vol:'),
                widget.Spacer(width=1),
                widget.Volume(foreground=BRIGHT_BLUE),
                widget.Spacer(width=5),
            ], size=17, **bar_defaults)
        ),
        Screen(bottom=bar.Bar(widgets=[
                widget.GroupBox(urgent_alert_method='text', **widget_groupbox_defaults),
                widget.Spacer(width=bar.STRETCH),
                widget.Systray(icon_size=14),
                widget.Spacer(width=10),
                widget.Clock(format='%Y-%m-%d %a %I:%M %p', **widget_defaults),
                widget.Spacer(width=5),
            ], size=17, **bar_defaults),
            top=bar.Bar(widgets=[
                widget.WindowName(**widget_defaults),
            ], size=17, **bar_defaults)
        ),
        Screen(bottom=bar.Bar(widgets=[
                widget.GroupBox(urgent_alert_method='text', **widget_groupbox_defaults),
                widget.Spacer(width=bar.STRETCH),
                widget.Clock(format='%Y-%m-%d %a %I:%M %p', **widget_defaults),
                widget.Spacer(width=5),
            ], size=17, **bar_defaults),
            top=bar.Bar(widgets=[
                widget.WindowName(**widget_defaults),
            ], size=17, **bar_defaults)
        ),
    ]
else:
    screens = [
        Screen(bottom=bar.Bar(widgets=[
                widget.GroupBox(urgent_alert_method='text', **widget_groupbox_defaults),
                widget.Spacer(width=bar.STRETCH),
                widget.Systray(icon_size=14),
                widget.Spacer(width=10),
                widget.Clock(format='%Y-%m-%d %a %I:%M %p', **widget_defaults),
                widget.Spacer(width=5),
            ], size=17, **bar_defaults),
            top=bar.Bar(widgets=[
                widget.WindowName(**widget_defaults),

                widget.TextBox('CPU:'),
                widget.CPUGraph(**widget_graph_defaults),

                widget.Spacer(width=2),
                widget.TextBox('Mem:'),
                widget.MemoryGraph(**widget_graph_defaults),

                widget.Spacer(width=2),
                widget.TextBox('Swap:'),
                widget.SwapGraph(**widget_graph_defaults),

                widget.Spacer(width=2),
                widget.TextBox('Net:'),
                widget.NetGraph(**widget_graph_defaults),

                widget.Spacer(width=2),
                widget.TextBox('Bat:'),
                widget.Spacer(width=1),
                widget.Battery(
                    energy_now_file='charge_now',
                    energy_full_file='charge_full',
                    power_now_file='current_now',
                    charge_char='↑',
                    discharge_char='↓',
                    foreground=BRIGHT_BLUE,
                ),

                widget.Spacer(width=4),
                widget.TextBox('Vol:'),
                widget.Spacer(width=1),
                widget.Volume(foreground=BRIGHT_BLUE),
                widget.Spacer(width=5),
            ], size=17, **bar_defaults)
        ),
    ]

keys = [
    Key([ALT_KEY, CONTROL_KEY, MOD_KEY, SHIFT_KEY], 'q',    lazy.shutdown()),
    Key([ALT_KEY, CONTROL_KEY, MOD_KEY, SHIFT_KEY], 'r',    lazy.restart()),
    Key([MOD_KEY], 'k',                                     lazy.layout.up()),
    Key([MOD_KEY], 'j',                                     lazy.layout.down()),
    Key([MOD_KEY], 'h',                                     lazy.layout.previous()),
    Key([MOD_KEY], 'l',                                     lazy.layout.next()),
    Key([MOD_KEY], RETURN_KEY,                              lazy.layout.maximize()),
    Key([MOD_KEY, SHIFT_KEY], RETURN_KEY,                   lazy.layout.normalize()),
    Key([CONTROL_KEY, MOD_KEY], 'h',                        lazy.layout.prev_screen()),
    Key([CONTROL_KEY, MOD_KEY], 'l',                        lazy.layout.next_screen()),
    Key([MOD_KEY], '1',                                     lazy.to_screen(0)),
    Key([MOD_KEY], '2',                                     lazy.to_screen(1)),
    Key([MOD_KEY], '3',                                     lazy.to_screen(2)),
    Key([ALT_KEY, CONTROL_KEY, MOD_KEY, SHIFT_KEY], 'x',    lazy.window.kill()),

    Key([MOD_KEY], RETURN_KEY,                              lazy.spawn('urxvt -title term -e zsh')),
    Key([SHIFT_KEY, MOD_KEY], RETURN_KEY,                   lazy.spawn('urxvt -title miscterm -e zsh')),

    Key([MOD_KEY], PAUSE_KEY,                               lazy.spawn('~/bin/lock.sh')),
    Key([ALT_KEY, CONTROL_KEY, MOD_KEY], PAUSE_KEY,         lazy.spawn('~/bin/suspend.sh')),

    Key([MOD_KEY], 'equal', lazy.spawn('amixer -c 0 -q set Master 2dB+')),
    Key([MOD_KEY], 'minus', lazy.spawn('amixer -c 0 -q set Master 2dB-')),
    Key([CONTROL_KEY, MOD_KEY], 'equal', lazy.spawn('amixer -c 0 -q set Master mute')),
    Key([CONTROL_KEY, MOD_KEY], 'minus', lazy.spawn('amixer -c 0 -q set Master unmute')),
]

mouse = [
    # Drag([MOD_KEY], 'Button1', lazy.window.set_position_floating(),
    #     start=lazy.window.get_position()),
    # Click([MOD_KEY], 'Button2', lazy.window.bring_to_front()),
    # Drag([MOD_KEY], 'Button3', lazy.window.set_size_floating(),
    #     start=lazy.window.get_size()),
]

groups = [
    Group('email', layout='vtile',
          matches=[Match(wm_class=['Thunderbird'])]),
    Group('im', layout='vtile',
          matches=[Match(wm_class=['Pidgin'], role=['Buddy List'], title=['irssi'])]),
    Group('www-c', layout='vtile',
          matches=[Match(wm_class=['Google-chrome'])]),
    Group('misc', layout='vtile',
          matches=[Match(wm_class=['Keepassx'])]),
    Group('terms', layout='vtile',
          matches=[Match(title=['term'])]),
    Group('www-f', layout='vtile',
          matches=[Match(wm_class=['Firefox'])]),
    Group('gimp', layout='gimp',
          matches=[Match(wm_class=['Gimp'])]),
    Group('miscterms', layout='vtile',
          matches=[Match(title=['miscterm'])]),
    Group('monitoring', layout='matrix',
          matches=[Match(title=['feh', 'mplayer2'])]),
]

dgroups_key_binder = simple_key_binder(MOD_KEY)

border_args = {
    'border_width': 1,
}

layouts = [
    layout.VerticalTile(name='vtile'),
    layout.Matrix(name='matrix'),
    # layout.Slice('top', 192, name='im', role='irssi',
    #     fallback=layout.Slice('bottom', 256, role='buddy_list',
    #         fallback=layout.Stack(stacks=1))),
    layout.Slice('left', 192, name='gimp',
        fallback=layout.Slice('right', 256,
           fallback=layout.Stack(num_stacks=1, **border_args))),
]

# Override default behavior to support gimp layout
floating_layout = layout.Floating(auto_float_types=[
    'notification',
    'toolbar',
    'splash',
    'dialog',
])

@hook.subscribe.startup
def autostart():
    subprocess.call([os.path.expanduser('~') + '/.config/qtile/autostart.sh'])

