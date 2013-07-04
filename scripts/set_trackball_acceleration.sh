#!/usr/bin/env sh

xinput --set-ptr-feedback "`xinput --list --short|grep Trackball|awk '{print $6}'|cut -d'=' -f 2`" 1 10 1

