---
id: 383
title: 'Lollipop on the Galaxy S2 &#8211; Stage 1/4 Gathering tools and backups'
date: 2015-01-14T16:11:06+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=383
permalink: /2015/01/lollipop-on-the-galaxy-s2-stage-14-gathering-tools-and-backups/
categories:
  - Hardware
  - i9100
  - Linux
---
I recently changed jobs and got a Galaxy SII (i9100) from my new employer, which was running some ancient Samsung&#8217;d version of Android 4.1. I now have it running a non-official but for me fully functional version of CyanogenMod 12 (Android 5.0.2), with the full version of Google Apps installed and working.

First of all I should say I&#8217;m new to the whole Android and alternative ROMs thing, my personal phone has been an iPhone for a long time. That said I&#8217;m very familiar with Linux and embedded systems, I&#8217;ve jailbroken iPhones and done data recovery from iPhones too. This isn&#8217;t really meant as a fully comprehensive &#8220;howto&#8221; more just a record of what I did and it all worked for me.

There a standard set of tools for working with Android devices, so lets get them installed before anything else. On modern versions of Debian / Ubuntu the command to install the packages is as simple as:

<pre>sudo apt-get install heimdall-flash android-tools-adb android-tools-fastboot</pre>

First of all I took a backup of the phone, to do this I installed a CWM enabled kernel zImage using [heimdall](http://glassechidna.com.au/heimdall/). The kernel zImage I used was from [LysergicAcid](http://forum.xda-developers.com/member.php?u=6159291) the developer on XDA who created the CM12 build for the Galaxy S2. The kernels with CWM or TWRP can be found on [Android File Host](https://www.androidfilehost.com/?w=files&flid=23595), I used the file [lp-kernel-02-01-CWM.zip](https://www.androidfilehost.com/?fid=95864024717074056).

Get the phone into download mode with power+volume down+home button and then OK (with volume up) the warning that appears. Plug the phone in via USB and run:

<pre>sudo heimdall flash --KERNEL zImage --no-reboot</pre>

Now reboot the phone and enter recover mode using power+volume up+home together, and you should be in clockwork recovery. Because I know more about Linux than Android I just cloned the entire nand image using good old dd and netcat. To do this open up two terminal windows and run in the first one:

<pre>adb forward tcp:5555 tcp:5555
adb shell mount /system
adb shell /system/xbin/busybox nc -l -p 5555 -e /system/xbin/busybox dd if=/dev/block/mmcblk0

</pre>

In In the second terminal window run:

<pre>size=$(adb shell cat /proc/partitions | grep -w mmcblk0| awk '{print $3}')
nc 127.0.0.1 5555 |  pv -s ${size}k -erp | pigz -c &gt; /path/to/backup/mmcblk0.raw.gz</pre>

This will pull a full raw backup out of the onboard flash, transfer it with netcat, compress it and write it to the file /path/to/backup/mmcblk0.raw.gz