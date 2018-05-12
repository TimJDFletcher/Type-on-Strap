---
id: 124
title: 'Linux on the iomega iConnect &#8211; Part I'
date: 2012-06-10T22:28:55+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=124
permalink: /2012/06/linux-on-the-iomega-iconnect-part-i/
categories:
  - Hardware
  - iConnect
  - Linux
---
The iConnect is a small cheap and very hackable ARM NAS, the device is based on the Kirkwood [SoC](http://en.wikipedia.org/wiki/System_on_a_chip) platform.

Hardware highlights are

  * 4 USB ports (on a hub so bandwidth limited)
  * Single mini PCI express port with a Ralink based wireless card included (this can be replaced by something such as an Atheros based card)
  * Gigabit ethernet
  * ARMv5 CPU running at 1Ghz, with 256MB of RAM and 512MB of NAND flash
  * Serial port easily accessible for a serial console
  * Decent version of uboot that supports tftp, nand and usb booting and includes drivers for ext2 and fat filesystems.

I got mine intending to use it for backups but I&#8217;ve basically spent a week playing with it learning uboot as well as Linux on ARM as well as booting a number of different versions of linux on.

So far I&#8217;ve managed to boot Archlinux, Debian and Fedora on the iConnect and they all work but Debian and Fedora don&#8217;t have kernels with the iConnect patches in from the main repos so need a patched kernel to get some of the little extras working.

I&#8217;ve now settled on Debian wheezy installed on a 8gig usb memory stick as the best bet for the board, and I will need to spend some time setting up the backups up.

&nbsp;