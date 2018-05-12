---
id: 507
title: Booting a Raspberry Pi2, with u-boot and HYP enabled
date: 2015-05-03T18:39:59+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=507
permalink: /2015/05/booting-a-raspberry-pi2-with-u-boot-and-hyp-enabled/
categories:
  - Debian
  - Linux
  - Raspberry Pi
  - Uncategorized
---
I have been playing with my Raspberry Pi2 and a nearly pure build of [Debian Jessie](https://www.collabora.com/about-us/blog/2015/02/03/debian-jessie-on-raspberry-pi-2/). I have now got u-boot and QEMU with hardware acceleration (kvm) working in a fairly clean way.

There are a lot of parts to getting this all working correctly, and I have done this by gluing together a number of blog posts, mailing list posts and a bit of arm knowledge.

First thing to do is to get a working cross compile environment, so you can build on modern x86 hardware which is a lot fast then building on the Pi. Fortunately in modern Debian or Ubuntu it&#8217;s as simple as these commands:

<pre>sudo apt-get install gcc-arm-linux-gnueabihf
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-</pre>

## Booting a Raspberry Pi 2 with u-boot

Using u-boot isn&#8217;t strictly needed but I much prefer u-boot to the Pi&#8217;s normal raw kernel boot. Mainline u-boot has support for the Raspberry Pi 2 so it&#8217;s a fairly simple process of:

<pre>git clone git://git.denx.de/u-boot.git
cd u-boot
make rpi_2_defconfig
make all</pre>

This will give you a u-boot.bin binary that will work on the Raspberry Pi2, transfer this to your Raspberry Pi and change the kernel in config.txt to read:

<pre>kernel=u-boot.bin</pre>

For the next part you will need a [serial console](http://elinux.org/RPi_Serial_Connection) on your Raspberry Pi because the Pi will not autoboot this time. Reboot your Pi and you should see the following message on your serial console:

<pre>U-Boot 2015.04-00631-gace97d2 (May 03 2015 - 10:52:52)

DRAM:  944 MiB
WARNING: Caches not enabled
RPI: Board rev 16 outside known range
RPI Unknown model
MMC:   bcm2835_sdhci: 0

In:    serial
Out:   lcd
Err:   lcd
Net:   Net Initialization Skipped
No ethernet found.
Hit any key to stop autoboot:  0</pre>

I suggest that you &#8220;hand boot&#8221; the Pi the first time, to make sure everything works.

<pre># Tell Linux that it is booting on a Raspberry Pi2
setenv machid 0x00000c42
# Set the kernel boot command line
setenv bootargs "earlyprintk console=tty0 console=ttyAMA0 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait noinitrd"
# Save these changes to u-boot's environment
saveenv
# Load the existing Linux kernel into RAM
fatload mmc 0:1 ${kernel_addr_r} kernel7.img
# Boot the kernel we have just loaded
bootz ${kernel_addr_r}</pre>

You should now see Linux booting, I have a little boot script setup to run the last 2 commands automatically.  Put the commands in file and use mkimage to build a u-boot wrapper round them. Note this example assumes that you are using the Debian Jessie image I linked at the top, if you are using Raspbian then you will need to use /boot/boot.scr as the output path.

<pre>mkimage -A arm -O linux -T script -C none -a 0x00000000 -e 0x00000000 -n "RPi2 Boot Script" -d /path/to/script /boot/firmware/boot.scr</pre>

## U-Boot and HYP mode

The next stage is to allow the Raspberry Pi2 to boot with HYP mode enabled on the CPU. This requires starting in secure mode, enabling HYP and then jumping to u-boot or Linux. I didn&#8217;t work this myself I lifted the code and the technique from a [blog post](http://blog.flexvdi.es/2015/02/25/enabling-hyp-mode-on-the-raspberry-pi-2/) by [<s>@</s>sergiolpascual](https://twitter.com/sergiolpascual){.twitter-atreply.pretty-link} a [NetBSD](http://www.netbsd.org/) developer. He does a much better job of explaining the how and why of this if you are interested.

To build the bootloader stub, clone the git <https://github.com/slp/rpi2-hyp-boot> you will need to fix the the gcc path or use the fixed version in my Github [repo](https://github.com/TimJDFletcher/rpi2-hyp-boot). To build type make and you should end up with a file bootblk.bin. The build process is so fast you can build it on the Pi without a problem.

Run this command to stick the HYP bootblock on front of u-boot.bin, again this assumes you are running the Debian Jessie image at the top this post.

<pre>cat bootblk.bin /boot/firmware/u-boot.bin &gt; /boot/firmware/u-boot.hyp</pre>

You will also need to change /boot/firmware/config.txt to contain the kernel_old option so that the GPU bootloader boots the kernel with secure mode enabled. The contents should now be:

<pre>kernel=u-boot.hyp
kernel_old=1</pre>

Reboot the Pi again and you should see u-boot and then Linux boot as normal, login and run this command and you should see: &#8220;CPU: All CPU(s) started in HYP mode.&#8221;

<pre>dmesg | grep "All CPU"</pre>

My next post will be about enabling KVM on the Pi2 and booting your first VM.