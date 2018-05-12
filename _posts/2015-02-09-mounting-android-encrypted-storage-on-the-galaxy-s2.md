---
id: 441
title: Mounting Android encrypted storage on the Galaxy S2
date: 2015-02-09T00:16:13+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=441
permalink: /2015/02/mounting-android-encrypted-storage-on-the-galaxy-s2/
categories:
  - Hardware
  - i9100
  - Linux
---
Because I like to understand how things work before they break, I wanted to be able to mount the encrypted storage of my Galaxy S2 phone from the ADB shell.

My understanding of the Android encryption system is that there is a metadata file stored in /efs at least for phones that have an efs partition. This metadata file contains the normal LUKS headers and encryption keys.

The following works for me in the ADB shell, it mounts the efs partition and then requests that vold unlocks the storage.

<pre>mkdir /efs
mount /dev/block/mmcblk0p1 /efs
setprop ro.crypto.state encrypted
vdc cryptfs checkpw 'your passphrase here'
mount -o ro /dev/block/dm-0 /data</pre>