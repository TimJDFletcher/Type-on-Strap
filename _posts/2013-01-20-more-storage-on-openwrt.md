---
id: 177
title: More storage on an OpenWRT router
date: 2013-01-20T21:56:25+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=177
permalink: /2013/01/more-storage-on-openwrt/
categories:
  - OpenWRT
  - WR703N
---
Even with a modified WR703N you will still likely run out of space quite quickly if you try and use some of the larger OpenWRT packages like Samba or Asterisk. The best way to add more storage is one of the tiny USB flash drives that fit in side the USB port on the router, something like a [16GB SanDisk Cruzer Fit](http://www.amazon.co.uk/gp/product/B005FYNSZA/ref=as_li_tf_tl?ie=UTF8&camp=1634&creative=6738&creativeASIN=B005FYNSZA&linkCode=as2&tag=atraveltinker-21) <img class="bvtsjwxreijcuvjduypx" style="border: none !important; margin: 0px !important;" alt="" src="http://www.assoc-amazon.co.uk/e/ir?t=atraveltinker-21&l=as2&o=2&a=B005FYNSZA" width="1" height="1" border="0" />flash drive.

You can also do clever things such as using different memory sticks for different setups, so you have a memory stick setup that starts up as a PirateBox, while a different one setup to join your wireless and share files from the USB memory stick. Because of the way that the overlay works, effectively the entire system state is stored on the overlay filesystem.

I have a little script that does all the setup for you, it assumes that the drive is setup with 2 primary partitions, the first one formatted with ext4 and the second as swap, you will need to do the partitioning and formatting on a normal Linux box. Once the drive is setup you just need to run the following script, it downloads and installs the correct packages and sets up the usb memory stick as an overlay.

<pre>#!/bin/sh
packages="kmod-fs-ext4 kmod-usb-storage block-mount"
dev=sda1
swapdev=sda2
fstype=ext4
options=rw,sync,noatime

enable()
{
echo "Stopping automounting"
/etc/init.d/fstab stop

opkg update
opkg install $packages

sleep 10

while [ ! -b /dev/$dev ] ; do
echo "/dev/$dev not found please insert the USB storage device"
read junk
done

mkdir -p /mnt/$dev
mount /dev/$dev /mnt/$dev -t $fstype -o $options

tar -C /overlay -cvf - . | tar -C /mnt/$dev -xf -

uci add fstab mount
uci set fstab.@mount[-1].device=/dev/sda1
uci set fstab.@mount[-1].options=$options
uci set fstab.@mount[-1].enabled_fsck=0
uci set fstab.@mount[-1].enabled=1
uci set fstab.@mount[-1].target=/overlay
uci set fstab.@mount[-1].fstype=$fstype

uci add fstab swap
uci set fstab.@swap[-1].device=/dev/sda1
uci set fstab.@swap[-1].enabled=1

uci commit fstab

/etc/init.d/fstab enable

echo "Overlay enabled, you need to reboot to activate it"
}

enable</pre>

The script can be downloaded here: <http://www.night-shade.org.uk/~tim/OpenWRT/usb-overlay.sh.gz>