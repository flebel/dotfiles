#!/bin/sh

firefox &
google-chrome &
pidgin &
quicksynergy &
thunderbird &

cp ~/.irssi/config ~/.irssi/config.backup
urxvt -title irssi -e irssi &

urxvt -title term -e zsh &
#urxvt -title miscterm -e zsh &

nm-applet &
keepassx &
redshift -l 37.363949:-121.928940 &

