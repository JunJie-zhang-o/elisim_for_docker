#!/bin/bash

if test -f $file; then
  rm /tmp/.X1-lock
fi

# Setup VNC server
Xvfb :0 -screen 0 1280x800x24 &
x11vnc -bg -quiet -forever -shared -display :0 -snapfb >/dev/null 2>/dev/null


sed -i 's/$(hostname)/localhost/g' /usr/share/novnc/utils/launch.sh
/usr/share/novnc/utils/launch.sh --vnc localhost:5900 >/dev/null 2>/dev/null &


# Get container ip address
docker_ip=$(hostname -i)

# User instructions
echo -e "Elite Robots CS Serial Simulator \n\n"

echo -e "IP address of the simulator\n"
echo -e "     $docker_ip\n\n"

echo -e "Access the robots user interface through this URL:\n"
echo -e "     http://$docker_ip:6080/vnc.html?host=$docker_ip&port=6080\n\n"

echo -e "Access the robots user interface with a VNC application on this address:\n"
echo -e "     $docker_ip:5900\n\n"

# echo -e "Press Crtl-C to exit\n\n"

# 启动bash shell
exec /bin/bash