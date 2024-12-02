#!/bin/bash
/usr/bin/Xvfb :1 -screen 0 1024x768x16 &
/usr/bin/x11vnc -display :1 -nopw -forever -rfbport 5901 &
/opt/noVNC/utils/launch.sh --vnc localhost:5901 --listen 6080 &
exec "$@"
