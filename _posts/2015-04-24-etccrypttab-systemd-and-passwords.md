---
id: 476
title: /etc/crypttab, Systemd and keyscripts
date: 2015-04-24T14:59:51+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=476
permalink: /2015/04/etccrypttab-systemd-and-passwords/
categories:
  - Debian
  - Linux
  - Photography
  - Ubuntu
---
I&#8217;ve upgraded some of my systems to Ubuntu 15.04 and found that some system didn&#8217;t boot due to poorly documented interactions between Systemd and /etc/crypttab.

The [major bug](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=618862) is around keyscripts, Debian and Ubuntu have for a long time supported using a binary or script to provide a password for encrypted devices, from the Debian crypttab man page:

<pre>keyscript= The executable at the indicated path is executed with the key file from the third field of the crypttab as its only argument and the output is used as the key.</pre>

People have used this for all sorts of creative ways of getting passwords from TPM chips, cryptocards etc.

The root of the problem is that systemd doesn&#8217;t support keyscripts at all, and in fact [doesn&#8217;t even parse](http://unix.stackexchange.com/questions/64693/how-do-i-configure-systemd-to-activate-an-encrypted-swap-file) /etc/crypttab on boot.

I have worked round this bug by moving all my keyscript dependant volumes to start post system boot. The command cryptdisks_start still uses /etc/crypttab and keyscripts correctly, so I have added either nofail or noauto options to the devices in /etc/fstab and /etc/crypttab to allow the system to boot.

Another minor bug I encountered was caused by using the system UUID as a simple password for my backup disk. While this isn&#8217;t the worlds most secure key it is unique to my laptop and accessible to the system without any user interaction.

I did this by setting keyfile in /etc/crypttab to /sys/class/dmi/id/product_uuid. The bug is that systemd interprets the /sys path and for reasons I&#8217;ve not looked at in depth doesn&#8217;t start the LUKS device. The simple fix is to change the keyfile path and symlink the /sys file to the new location ie:

<pre> sudo ln -s /sys/class/dmi/id/product_uuid /boot/uuid</pre>

&nbsp;

&nbsp;