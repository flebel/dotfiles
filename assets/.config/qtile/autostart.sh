#!/bin/sh

firefox &
google-chrome &
pidgin &
thunderbird &

cp ~/.irssi/config ~/.irssi/config.backup
urxvt -title irssi -e irssi &

urxvt -title miscterm -e zsh &
urxvt -title term -e zsh &

nm-applet &
keepassx &
redshift -l 37.363949:-121.928940 &

