# Network Manager Hell



I recently re-installed **my laptop** (which **has loopback, WIFI and wired network connections**) from scratch and I found that it has **"NetworkManager is not running"** displayed when I click the NetworkManager applet, which is [apparently](https://askubuntu.com/questions/572003/network-manager-no-longer-starts-automatically/572007#572007) [not](http://askubuntu.com/questions/429207/network-manager-not-running) [that](http://ubuntuforums.org/showthread.php?t=2009719) [strange](http://ubuntuforums.org/showthread.php?t=1706208). This was straight after an install which was disappointing :-(

My installation method for my laptop comes from an **Ubuntu 14.04 Server** base with some desktop components. The reason for this is that I have switched to OpenBox which is lovely compared to Unity and I don't run into the bugs I always do when customising XFCE... it's also lightning fast. Unfortunately sometimes because of this it's a bit difficult to google for answers...

If I installed the desktop version of Ubuntu I believe it will let you use the the WIFI when installing (which is very nice) however when you install the server edition there is no prompt for wifi and I ended up **plugging in a cable for the installation**, this left my `/etc/network/interfaces` looking like the following:

```
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet dhcp
```

Which is pretty reasonable and correct... however this configuration causes NetworkManager to not start, or at least be disabled... You need to remove all the lines which reference `eth0` and then NetworkManager will start properly!

Pretty surprised at this, as I have three network devices. Surely I've just gone down from 2 network devices being managed by `/etc/network/interfaces` to one, so I don't understand why NetworkManager would refuse to start and manage my WIFI in both cases...

