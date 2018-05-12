---
id: 131
title: Linux on the iomega iConnect – Part III – Installing OpenWRT
date: 2012-06-23T18:05:44+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=131
permalink: /2012/06/linux-on-the-iomega-iconnect-part-iii-installing-openwrt/
categories:
  - Hardware
  - iConnect
  - Linux
  - OpenWRT
---
[OpenWRT](https://openwrt.org/) is an entire build system designed to produce flexible linux system images for embedded devices with full package and configuration management, there is a version of it for the Kirkwood SoC included in the Iomage iConnect.

My install method installs OpenWRT to the NAND of the iConnect and completely overwrites the original firmware, the method does need a basic working network with a tftp server as well as a serial console on your iConnect.

It&#8217;s easier to update uboot on the iConnect to the latest version that is built as part of OpenWRT, however this isn&#8217;t 100% necessary as you can change the arcNumber, boot flags and NAND layout in uboot to match what the OpenWRT kernel expects. I have updated my iConnect&#8217;s uboot to the latest version from OpenWRT so I&#8217;ve included the instructions here.

The files you will need to download and put on your tftp server to install the latest snapshot version of uboot and OpenWRT on the iConnect are:

  * [openwrt-kirkwood-iconnect-u-boot.kwb](http://downloads.openwrt.org/snapshots/trunk/kirkwood/uboot-kirkwood-iconnect/openwrt-kirkwood-iconnect-u-boot.kwb) &#8211; This is the new uboot with kirkwood header
  * [openwrt-kirkwood-uImage](http://downloads.openwrt.org/snapshots/trunk/kirkwood/openwrt-kirkwood-uImage) &#8211; This is the OpenWRT Linux kernel
  * [openwrt-kirkwood-generic-jffs2-nand-2048-128k.img](http://downloads.openwrt.org/snapshots/trunk/kirkwood/openwrt-kirkwood-generic-jffs2-nand-2048-128k.img) &#8211; This is the OpenWRT root filesystem

First things first, backup your uboot binary and environment settings, I used nandread from the original Linux install on the iConnect to backup uboot and just cut and pasted the output of printenv into a text file to backup the environment.

The main environment variable you will need to make sure you have a note of it the mac address of the ethernet chip, you can get this from the uboot command line with the command:

<pre>printenv ethaddr</pre>

Once you have got your backups sorted you can install the new uboot with the following commands in the uboot shell, if any of the early stages fail **do not** erase the NAND otherwise the iConnect will not boot.

<pre>setenv serverip 192.168.1.2 # IP of your TFTP server
setenv ipaddr 192.168.1.200 # IP of your iConnect
mw 0x0800000 0xffff 0x60000                             
tftpboot 0x0800000 openwrt-kirkwood-iconnect-u-boot.kwb
nand erase 0x0 0x60000                                  
nand write 0x0800000 0x0 0x60000                        
reset</pre>

You should hopefully now see a fresh new uboot prompt which has a very minimal environment, you will need to set your original ethernet address you have saved as well as your network details.

<pre>setenv ethaddr &lt;my saved ethernet address&gt;
setenv serverip 192.168.1.2 # IP of your TFTP server
setenv ipaddr 192.168.1.200 # IP of your iConnect
saveenv
reset</pre>

Once the iConnect has restarted with the original ethernet address you will need to install the OpenWRT kernel on the NAND

<pre>mw 0x6400000 0xffff 0x300000                
tftp 0x6400000 openwrt-kirkwood-uImage
nand erase 0x100000 0x400000
nand write.e 0x6400000 0x100000 0x400000</pre>

and finally flash the OpenWRT root filesystem

<pre>mw 0x6400000 0xffff 0x200000
tftp 0x6400000 openwrt-kirkwood-generic-jffs2-nand-2048-128k.img
nand erase 0x500000 0xfb00000
nand write.e 0x6400000 0x500000 0x200000</pre>

Once this has finished type

<pre>boot</pre>

You should now see the OpenWRT kernel booting and starting the first boot setup on your iConnect.