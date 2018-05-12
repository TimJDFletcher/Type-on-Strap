---
id: 61
title: iPXE, scripts and initrds
date: 2011-12-01T00:06:26+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=61
permalink: /2011/12/ipxe-and-scripts/
categories:
  - Linux
---
You have always been able to build iPXE with a custom script by compiling it to the ipxe binary like this:

<pre>cd /path/to/ipxe/source
make EMBED=myscript.ipxe</pre>

However recently [Micheal Brown](http://unitedtechguys.com/2011/03/20/ipxe-network-bootloader-an-interview-with-michael-brown/) [added](https://git.ipxe.org/ipxe.git/commit/27fdb9557266eaaadfb39a2eddfb06d2aade9) a great new feature to [iPXE](http://ipxe.org/), you can now load a script as an initrd. Being able to load a script dynamically opens up some interesting new possibilities and certainly makes updating my utility memory stick much easier.

I&#8217;ve made a really basic [16MB bootable disk image](https://blog.night-shade.org.uk/wp-content/uploads/2011/12/ipxe.syslinux.img_.gz), for people who just want to start out simply with the iPXE scripting. The image has the latest version of iPXE and syslinux installed and ready to go. Once you have written it to a memory stick with [dd](http://en.wikipedia.org/wiki/Dd_%28Unix%29) or [winimage](http://winimage.com) there is a simple ipxe script called script.ipxe that you can edit.

I use a more slightly more complex setup that allows me to hook iPXE into my general utility memory stick that boots with syslinux. I have added iPXE and so far only a script that allows me to boot over the network from an iSCSI disk with a Ubuntu system on. I&#8217;ve broken the syslinux config up on the memory stick to make it easier to read and maintain.

This line to added to my general syslinux menu shows the iPXE menu

<pre>include ipxe/ipxe.cfg</pre>

In the syslinux/ipxe folder of my memory stick there are four files:

**ipxe.krn** &#8211; this is the actual iPXE binary

**ipxe.cfg** &#8211; this is a simple syslinux config fragment that I use the include directive in the main syslinux menu to load.

<pre>label ipxe
  menu label iPXE loading a script
  kernel ipxe/ipxe.krn
  append initrd=ipxe/iscsi.pxe</pre>

**iscsi.pxe &#8211;** a basic iSCSI boot script for ipxe. This is just an example, there is much more possible with [ipxe scripting](http://ipxe.org/scripting).

<pre>#!ipxe
dhcp
set keep-san 1
sanboot iscsi:&lt;iscsi disk id&gt;</pre>

**update-ipxe.sh** &#8211; a quick bash script to update ipxe to the latest git version as well as compiling and copying it to the right place.

<pre>#!/bin/sh
pwd=$(pwd)
src=/usr/src/git/ipxe/src

cd $src
git pull
make bin/ipxe.lkrn
cp $src/bin/ipxe.lkrn $pwd/ipxe.krn</pre>

I have rolled up a tarball of the files and uploaded it here as well: [iPXE files for syslinux](https://blog.night-shade.org.uk/wp-content/uploads/2011/12/syslinux-ipxe.tar.gz)