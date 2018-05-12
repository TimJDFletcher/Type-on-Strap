---
id: 390
title: Lollipop on the Galaxy S2 – Stage 3/4 resizing /system
date: 2015-01-14T16:58:23+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=390
permalink: /2015/01/lollipop-on-the-galaxy-s2-stage-34-resizing-system/
categories:
  - Hardware
  - i9100
  - Linux
---
I had a freshly installed phone running pure CyanogenMod 12, but I also wanted the standard Google Apps so now what? Back to the forums to read about how Google Apps work on 3rd party ROMs. The main complication is the default flash layout in the Galaxy S2 only has 537MB for the /system partition, not enough for full Google Apps. There is also a fairly small /data partition which holds other apps but not user data.

More reading about this and I found out about PIT files (or **P**artition **I**nformation **T**able), which are a file containing information about how the flash should be laid out. I&#8217;m capable of using a partition table editor so messing about with PIT files and heimdall all looks a bit complex and unnecessary to me, granted I might have misunderstood what they do but there we go.

To change the flash layout I rebooted back into recovery and opened an adb shell and repartitioned the flash by hand, I also used a trick to make sure I had a record. I ran adb from screen with the -L flag so that screen records a log file to screenlog.0 by default.

<pre>screen -L adb shell</pre>

The next sections are picked out from my log of repartitioning, first of all print the current partitions before changing anything. You can see that /system which is labelled as FACTORYFS is only 512MiB

<pre>(parted) p
Model: MMC V3U00M (sd/mmc)
Disk /dev/block/mmcblk0: 15.8GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Number  Start   End     Size    File system  Name       Flags
 1      4194kB  25.2MB  21.0MB  ext4         EFS
 2      25.2MB  26.5MB  1311kB               SBL1
 3      27.3MB  28.6MB  1311kB               SBL2
 4      29.4MB  37.7MB  8389kB               PARAM
 5      37.7MB  46.1MB  8389kB               KERNEL
 6      46.1MB  54.5MB  8389kB               RECOVERY
 7      54.5MB  159MB   105MB   ext4         CACHE
 8      159MB   176MB   16.8MB               MODEM
 9      176MB   713MB   537MB   ext4         FACTORYFS
10      713MB   5008MB  4295MB  ext4         DATAFS
11      5008MB  15.2GB  10.2GB               UMS
12      15.2GB  15.8GB  537MB   ext4         HIDDEN</pre>

Now to start making changes, delete the FACTORYFS, DATAFS and UMS partitions to clear space, this will remove **all** data you did a backup first right?

<pre>(parted) rm 9
(parted) rm 10
(parted) rm 11</pre>

Look again at the partitions, you can see that there is now empty space from 176MB to 15.2GB in the flash.

<pre>(parted) p
Model: MMC V3U00M (sd/mmc)
Disk /dev/block/mmcblk0: 15.8GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Number  Start   End     Size    File system  Name       Flags
 1      4194kB  25.2MB  21.0MB  ext4         EFS
 2      25.2MB  26.5MB  1311kB               SBL1
 3      27.3MB  28.6MB  1311kB               SBL2
 4      29.4MB  37.7MB  8389kB               PARAM
 5      37.7MB  46.1MB  8389kB               KERNEL
 6      46.1MB  54.5MB  8389kB               RECOVERY
 7      54.5MB  159MB   105MB   ext4         CACHE
 8      159MB   176MB   16.8MB               MODEM
12      15.2GB  15.8GB  537MB   ext4         HIDDEN</pre>

Switch to units of bytes to make sure the layout is as exact as possible and create the new partitions, create the same 3 partitions but with 1GB for /system, 12.8GB for /data and a minimal 512MB for UMS or internal SD.

<pre>(parted) unit b

(parted) mkpart primary 176160768   1249902591
(parted) mkpart primary 1249902592  14680064511
(parted) mkpart primary 14680064512 15216934911

(parted) name 9  FACTORYFS
(parted) name 10 DATAFS
(parted) name 11 UMS</pre>

And finally a printout of the new layout, with 1G for /system, 12.8GB for /data and a minimal 512MB for the emulated SD card of UMS.

<pre>(parted) p
Model: MMC V3U00M (sd/mmc)
Disk /dev/block/mmcblk0: 15758000128B
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Number Start End Size File system Name Flags

1 4194304B 25165823B 20971520B ext4 EFS
2 25165824B 26476543B 1310720B SBL1
3 27262976B 28573695B 1310720B SBL2
4 29360128B 37748735B 8388608B PARAM
5 37748736B 46137343B 8388608B KERNEL
6 46137344B 54525951B 8388608B RECOVERY
7 54525952B 159383551B 104857600B ext4 CACHE
8 159383552B 176160767B 16777216B MODEM
9 176160768B 1249902591B 1073741824B ext4 FACTORYFS
10 1249902592B 14680064511B 13430161920B DATAFS
11 14680064512B 15216934911B 536870400B UMS
12 15216934912B 15753805823B 536870912B ext4 HIDDEN</pre>

At this stage you need to reboot back to recovery mode and either format all partitions and reinstall or if you are feeling brave use resize2fs to grow /system to fill the partition and just wipe /data. I reinstalled from scratch, and pushed Google Apps at the same time, but that&#8217;s the next blog post.

If you want to resize the /system filesystem use:

<pre>adb shell resize2fs /dev/block/mmcblk0p9</pre>