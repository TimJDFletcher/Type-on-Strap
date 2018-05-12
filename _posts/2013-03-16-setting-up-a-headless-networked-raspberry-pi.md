---
id: 233
title: Setting up a headless networked Raspberry Pi
date: 2013-03-16T12:40:59+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=233
permalink: /2013/03/setting-up-a-headless-networked-raspberry-pi/
categories:
  - Hardware
  - Linux
---
I&#8217;m sure most people know about the [Raspberry Pi](http://www.raspberrypi.org/faqs) and all of the cool and interesting things you can do with but I&#8217;m interested in using my Pi as a headless networked computer.

First you need an image to boot the Pi, I use [Raspbian](http://www.raspbian.org/) because it&#8217;s close to Debian (which I know) and is built for arm hardfloat (which makes it faster on the Pi). SD card images for Raspbian can be found on the [official download page](http://www.raspberrypi.org/downloads).

Once you have written the image to an SD card, you need to find your Pi after it boots. Because Raspbian gets an IP address from DHCP and starts an SSH server by default, the easiest way to do this just scan your local network for systems running an SSH server. You can do this with nmap, the reason you need to run nmap as root is to get the mac address back off the wire.

<pre>sudo nmap -p 22 --open  192.168.1.0/24</pre>

You get something like this back, notice the &#8220;Raspberry Pi Foundation&#8221; label by the mac address, this means you&#8217;ve found a Pi.

<pre>Nmap scan report for 192.168.1.xxx
Host is up (0.00064s latency).
PORT   STATE SERVICE
22/tcp open  ssh
MAC Address: B8:27:EB:XX:XX:XX (Raspberry Pi Foundation)</pre>

Once you have found your Pi you need to login and set it up, the user name is pi and the password is raspberry you should really change this.

<pre>ssh -l pi &lt;IP address&gt;</pre>

First off updating, as raspbian is just a spin of Debian so we can just use apt-get to update.

<pre>sudo apt-get update
sudo apt-get dist-upgrade</pre>

You can also use apt-get to install packages as well but that&#8217;s a different tutorial.

The latest version of the Pi model B has 512MB of RAM which is much better and gives a lot more flexibility but as we want to run a headless Pi we really don&#8217;t need to give the GPU much ram so edit /boot/config.txt and add this line to end of the config file

<pre>gpu_mem=16M</pre>

As we don&#8217;t have a monitor plugged into the Pi there isn&#8217;t much point in running X windows and disabling it will save some ram.

<pre>update-rc.d lightdm disable</pre>

By default raspbian sets up a 100M swapfile on the SD card, I don&#8217;t really like that as it&#8217;s slow and can wear out the SD card so I disable swap.

<pre>sudo update-rc.d dphys-swapfile disable</pre>

There is a system in Linux called &#8220;zram&#8221; ie a compressed ramdisk we can use to swap to instead of the SD card. When it&#8217;s not in use the zram ramdisk takes up almost no memory so I tend to enable it on most systems I look after. I&#8217;ve hacked up an [init script](http://co-lo.night-shade.org.uk/~tim/Pi/zram) that setups a compress ramdisk 1/2 the size of the memory on the Pi and formats it as swap. To install this script download it, make is executable and enable it.

<pre>sudo wget -O /etc/init.d/zram http://co-lo.night-shade.org.uk/~tim/Pi/zram
sudo chmod 755 /etc/init.d/zram
sudo update-rc.d zram enable</pre>

The Raspberry Pi foundation call the Linux kernel that the Pi boots from the SD card [firmware](https://github.com/raspberrypi/firmware), however as the licensing is &#8220;complex&#8221; and not something that I&#8217;m going to comment on here you can&#8217;t update it with standard Debian tools. There is an update script from <https://github.com/Hexxeh/rpi-update> that will automate downloading and installing the latest firmware.

<pre>sudo apt-get install git-core
wget -O rpi-update https://raw.github.com/Hexxeh/rpi-update/master/rpi-update
chmod 755 rpi-update
sudo ./rpi-update</pre>

Finally we need to resize the main system partition on the SD card to use all the space the SD card, raspbian includes a method to do this in the config application raspi-config, but you can also just use sfdisk like this:

<pre>echo ",+," | sudo sfdisk --force -N2 --no-reread /dev/mmcblk0</pre>

Finally you will need to reboot for all of these changes to take effect.

Once the Pi has rebooted, final step is to login again and resize the root filesystem

<pre>sudo resize2fs /dev/mmcblk0p2</pre>

You now have a tiny little networked computer that you can use to do all sorts of things, I&#8217;ll post some examples of what you can do later.