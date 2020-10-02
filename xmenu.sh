#!/bin/sh


cat <<EOF | xmenu | sh &
Applications
	IMG:/usr/share/pixmaps/brave.png	Web Browser	brave
	IMG:/usr/share/app-info/icons/archlinux-arch-extra/64x64/gimp_gimp.png	Image editor	gimp
Terminal (urxvt)	urxvt

Shutdown	poweroff
Reboot	reboot
EOF
