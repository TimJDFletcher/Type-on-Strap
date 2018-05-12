---
id: 156
title: Dual booting OpenWRT and Debian on an iConnect
date: 2012-07-07T15:20:03+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=156
permalink: /2012/07/dual-booting-openwrt-and-debian-on-an-iconnect/
categories:
  - iConnect
  - Linux
  - OpenWRT
---
I&#8217;ve now got both OpenWRT and Debian wheezy installed and working on my iConnect however they both expect to be the only OS installed on the iConnect so the u-boot config needs a bit of tweaking to have them both installed and bootable.

I have OpenWRT installed completely on the internal flash as OpenWRT is setup for that and it&#8217;s only 32MB taken up, Debian I have installed on a usb flash drive but the kernel and initrd are stored on the internal flash after OpenWRT&#8217;s rootfs.

I have divided the the 512M of NAND flash in my iConnect like this:

<p style="padding-left: 30px;">
  1M u-boot loader with config stored @0xc000<br /> 3M of OpenWRT kernel<br /> 32M of OpenWRT root filesystem<br /> 5M of Debian kernel<br /> 20M of Debian initfs<br /> 425M of Data (currently unused)
</p>

First of all we need to make sure that u-boot, OpenWRT and Debian have the same view of the flash in the iConnect:

<pre>setenv mtdparts 'mtdparts=orion_nand:1M(u-boot),3M@1M(kernel),32M@4M(rootfs),5M@36M(debian-uimage),20M@41M(debian-initrd),425M@86M(data)'
saveenv</pre>

Tell u-boot to use the mtdparts we have just defined:

<pre>setenv mtdids 'nand0=orion_nand'
saveenv</pre>

We want the same console settings for all of the OS&#8217;s so lets define it once:

<pre>setenv bootargs_console 'console=ttyS0,115200'
saveenv</pre>

Set the boot command and rootfs UUID for Debian

<pre>setenv debian_root 'root=UUID=8f9f89f2-5bc2-4ba2-9a8f-6d92cf5c46af ro rootdelay=10'
setenv debian_bootcmd 'nand read 0x800000 debian-uimage; nand read 0x1100000 debian-initrd'
saveenv</pre>

Because I&#8217;m using an OpenWRT u-boot the OpenWRT boot commands are already defined as x_ commands, but if you didn&#8217;t the commands to setup OpenWRT booting are

<pre>setenv openwrt_root 'root=/dev/mtdblock2 rw rootfstype=jffs2'
setenv openwrt_bootcmd 'nand read 0x6400000 0x100000 0x300000'
saveenv</pre>

To switch to booting Debian you need to set the machine id to something that Debian works with, update the bootcmd and then save and reset.

<pre>setenv machid 692
setenv bootcmd 'setenv bootargs $(bootargs_console) $(mtdparts) $(debian_root); run debian_bootcmd; bootm 0x00800000 0x01100000; reset'
saveenv
reset</pre>

To switch to booting OpenWRT you need to clear machine id, update the bootcmd and then save and reset.

<pre>setenv machid
setenv bootcmd 'run openwrt_bootcmd; setenv bootargs $(mtdparts) $(bootargs_console) $(openwrt_root); bootm 0x6400000; reset'
saveenv
reset</pre>