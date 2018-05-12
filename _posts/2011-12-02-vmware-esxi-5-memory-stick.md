---
id: 67
title: Setting up VMWare ESXi 5.0 installer on a USB memory stick
date: 2011-12-02T15:40:15+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=67
permalink: /2011/12/vmware-esxi-5-memory-stick/
categories:
  - Linux
---
I&#8217;ve found a couple of ways of doing this with Ubuntu, the quickest way is to make use of the isohybrid tool from the [syslinux](http://en.wikipedia.org/wiki/SYSLINUX) project.

Download the latest version of the ESXi 5.0 install iso, and then use the following command in a terminal to convert the VMware install CD to a hybrid CD:

<pre>isohybrid VMware-VMvisor-Installer-5.0.0.iso</pre>

Then write the converted image onto a memory stick just as would a normal disk image with dd by using this command in a terminal:

<pre>sudo dd if=VMware-VMvisor-Installer-5.0.0.iso of=/dev/sdX bs=1M</pre>

There is also a way to unpack the ISO onto a memory stick and make it bootable, but it&#8217;s a little bit more long winded.