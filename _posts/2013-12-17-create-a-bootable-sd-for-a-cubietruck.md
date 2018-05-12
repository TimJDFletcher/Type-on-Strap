---
id: 295
title: Create a bootable SD for a Cubietruck
date: 2013-12-17T23:45:02+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=295
permalink: /2013/12/create-a-bootable-sd-for-a-cubietruck/
categories:
  - Cubietruck
  - Hardware
  - Linux
---
Assuming you have followed the [last post](https://blog.night-shade.org.uk/2013/12/building-a-pure-debian-armhf-rootfs/ "Building a pure Debian armhf rootfs") you should now have a directory with a Debian armhf root filesystem in. The next stage is to build a bootable SD card image to actually boot your Cubietruck from.

The Allwinner SoC doesn&#8217;t have a bios in the way a x86 computer does and the boot process is made up of a number of stages, for full details see the Rhombus Tech [website](http://rhombus-tech.net/allwinner_a10/a10_boot_process/). The parts that we care about are the SPL and u-boot which are written to the SD card 8 blocks in, u-boot then loads a kernel called uImage from the first partition.

I extracted the kernel, modules and firmware from a Linaro image, which is part of the [Cubietruck lubuntu tutorial](http://docs.cubieboard.org/tutorials/ct1/installation/install_lubuntu_desktop_server_to_sd_card). I did this because Debian doesn&#8217;t currently have a working Allwinner kernel and I intended to build a main line kernel anyway. The files I used are listed below.

<table class="inline">
  <tr class="row0">
    <th class="col0">
      Name
    </th>
    
    <th class="col1">
      Desc
    </th>
    
    <th class="col2">
      <abbr title="Uniform Resource Locator">URL</abbr>
    </th>
  </tr>
  
  <tr class="row1">
    <td class="col0">
      u-boot
    </td>
    
    <td class="col1">
      u-boot with spl
    </td>
    
    <td class="col2">
      <a class="urlextern" title="http://dl.cubieboard.org/software/a20-cubietruck/lubuntu/ct-lubuntu-card0-v1.00/u-boot-sunxi-with-spl-ct-20131102.bin" href="http://dl.cubieboard.org/software/a20-cubietruck/lubuntu/ct-lubuntu-card0-v1.00/u-boot-sunxi-with-spl-ct-20131102.bin" target="_blank" rel="nofollow">download</a>
    </td>
  </tr>
  
  <tr class="row2">
    <td class="col0">
      bootfs
    </td>
    
    <td class="col1">
      uImage, uEnv.txt, script.bin
    </td>
    
    <td class="col2">
      <a class="urlextern" title="http://dl.cubieboard.org/software/a20-cubietruck/lubuntu/ct-lubuntu-card0-v1.00/desktop/bootfs-part1.tar.gz" href="http://dl.cubieboard.org/software/a20-cubietruck/lubuntu/ct-lubuntu-card0-v1.00/desktop/bootfs-part1.tar.gz" target="_blank" rel="nofollow">download</a>
    </td>
  </tr>
  
  <tr class="row3">
    <td class="col0">
      rootfs
    </td>
    
    <td class="col1">
      rootfs
    </td>
    
    <td class="col2">
      <a class="urlextern" title="http://dl.cubieboard.org/software/a20-cubietruck/lubuntu/ct-lubuntu-card0-v1.00/desktop/rootfs-part2.tar.gz" href="http://dl.cubieboard.org/software/a20-cubietruck/lubuntu/ct-lubuntu-card0-v1.00/desktop/rootfs-part2.tar.gz" target="_blank" rel="nofollow">download</a>
    </td>
  </tr>
</table>

Once you have got the files downloaded you need to put the bootloader on the SD card and transfer the rootfs.

First of all set the directory that the rootfs you have made previously or downloaded.

<pre>targetdir=rootfs</pre>

This is the tar command to exact the modules and firmware, to the correct places in the rootfs directory. This assumes you have downloaded the Linaro rootfs file or my file.

<pre>sudo tar xvfz rootfs-part2.tar.gz -C $targetdir lib/modules lib/firmware</pre>

Setup modules to autoload at boottime, these modules are for the GPIO pins, the graphics and the wireless+bluetooth adapter. These modules are for the 3.4 sunxi kernel.

<pre>cat &lt;&lt;EOT &gt; $targetdir/etc/modules
gpio_sunxi
pwm_sunxi
sunxi_gmac
disp
lcd
hdmi
ump
mali
bcmdhd
EOT</pre>

Now we need to actually put things on the SD card, be careful with dd it can and will wipe your harddisk if you make a mistake. In my case I had an SD card reader so I set things to point at that slot only by using the by-id links from udev. These by-id links which include the serial number which helped to avoid mistakes. The following commands assume you have done the same and are using by-id links.

<pre>card='/dev/disk/by-id/usb-Generic_Ultra_HS-SD_MMC_F120A600A9CB-0:0'</pre>

Blank the first 1MB of the card

<pre>dd if=/dev/zero of=${card} bs=1M count=1</pre>

Write u-boot and spl to the correct spot on the SD card.

<pre>dd if=u-boot-sunxi-with-spl-ct-20131102.bin of=$card bs=1024 seek=8</pre>

Build a partition table with 256M of boot space and the rest in a single large partition.

<pre>cat &lt;&lt;EOT | sfdisk --force --in-order -uS $card
2048,524288,L
526336,,L
EOT</pre>

Format and mount the first partition of the SD card

<pre>mkfs.ext2 ${card}-part1
mkdir -p /run/cubietruck-part1
mount  ${card}-part1 /run/cubietruck-part1</pre>

Extract the kernel and support files from the Linaro bootfs download

<pre>tar -C /run/cubietruck-part1 -xvf bootfs-part1.tar.gz
umount /run/cubietruck-part1
rmdir /run/cubietruck-part1</pre>

Finally format the second partition of the SD card and copy over the rootfs you have built

<pre>mkfs.ext4 ${card}-part2
mkdir -p /run/cubietruck-part2
mount  ${card}-part2 /run/cubietruck-part2
rsync -avxPHS $targetdir/ /run/cubietruck-part2/</pre>

And un-mount the card before ejecting it

<pre>umount /run/cubietruck-part1
rmdir /run/cubietruck-part1
eject $card</pre>