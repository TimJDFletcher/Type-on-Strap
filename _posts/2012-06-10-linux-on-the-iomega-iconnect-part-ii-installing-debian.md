---
id: 126
title: 'Linux on the iomega iConnect – Part II &#8211; Installing Debian'
date: 2012-06-10T23:10:06+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=126
permalink: /2012/06/linux-on-the-iomega-iconnect-part-ii-installing-debian/
categories:
  - Hardware
  - iConnect
  - Linux
---
Update &#8211; Changed link to point to archive.org

There is already really good documentation about installing Debian on the iConnect from [http://doip.org/iconnect](https://web.archive.org/web/20121106094410/http://doip.org/iconnect) and <http://www.kroonen.eu/wiki>, so this isn&#8217;t going to be in depth more just my own notes.

Connect the iConnect up to a gigabit switch (has to be a gigabit switch due to kernel bugs), connect a serial port, and get into uboot.

Setup your boot sources, you can use a memory stick or tftp.

**TFTP** &#8211; This assumes that you have a working tftp server and know how to put files on it.

<pre># Choose IPs that are correct for your network
setenv serverip 192.168.1.1
setenv ipaddr 192.168.1.10

# Load the installer kernel and initrd into the iConnect's RAM
tftpboot 0x01100000 iconnect/wheezy/uInitrd
tftpboot 0x00800000 iconnect/wheezy/uImage</pre>

**USB** &#8211; this assumes a fat formated memory stick

<pre># Start the USB subsystem up
usb start

# Load debian installer - usb
fatload usb 0:1 0x01100000 wheezy/uInitrd
fatload usb 0:1 0x00800000 wheezy/uImage</pre>

Once you have loaded the kernel and initrd into RAM the actually boot process is the same

<pre># Set the command line up
setenv bootargs console=ttyS0,115200n8 base-installer/initramfs-tools/driver-policy=most

# Boot the installer
bootm 0x00800000 0x01100000</pre>

After a bit of waiting and downloading you will end up with the normal Debian installer, you can install to the memory stick you booted off or anything else connected to the USB ports.

Once you have finished the kernel will fail to install properly, here are a couple of choices now either rearrange the NAND partitions and install the kernel there or modify the boot setup in uboot to boot off USB but I&#8217;ll cover booting in a later post.

&nbsp;