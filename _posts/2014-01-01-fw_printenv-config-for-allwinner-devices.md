---
id: 318
title: fw_printenv config for AllWinner devices
date: 2014-01-01T22:02:45+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=318
permalink: /2014/01/fw_printenv-config-for-allwinner-devices/
categories:
  - Cubietruck
  - Hardware
  - Linux
---
The u-boot suite of tools has a very handy tool allowing you to work with the u-boot environment from Linux user space. There are two complications with this on the Allwinner SoCs, first the version of the u-boot tools that Debian ships don&#8217;t support the mmc card.

You&#8217;ll need an up to date version of u-boot git tree either directly from [denx](http://www.denx.de/wiki/U-Boot) or the [linux-sunxi](https://github.com/linux-sunxi/u-boot-sunxi) project. Downloading and setting up the git u-boot tree is well documented so I&#8217;m not going to cover it here, but the fw_printenv tool isn&#8217;t built by default so you need to build it.

<pre>make env</pre>

The fw_printenv tool is found in the tools/env directory, copy it somewhere useful.

<pre>sudo install -m 755 tools/env/fw_printenv /usr/local/bin/</pre>

To write to the u-boot environment you also need to create a symlink from fw\_printenv to fw\_setenv.

<pre>sudo ln -s /usr/local/bin/fw_printenv /usr/local/bin/fw_setenv</pre>

The second problem is making a working configuration file. The configuration file only needs a single line in it to tell fw_printenv where to look (the offset from the start of the device) for the u-boot environment and how big it is. The complication is they need to be in bytes and given in hex, to calculate the offset and size I used the [sd layout](http://linux-sunxi.org/Bootable_SD_card#SD_Card_Layout) from the sunxi wiki and a bit of maths in bc to convert it to hex.

To calculate the offset, multiply the number (1088) of blocks by the block size (512 bytes) and then convert it to base16 (ie hex)

<pre>echo "obase=16; 1088*512 "| bc</pre>

To calculate the size of the u-boot environment repeat the process but this time with the number (128) of blocks by the block size (1024 bytes) and again convert it to base16.

<pre>echo "obase=16; 128*1024 "| bc</pre>

Finally put the numbers we have calculated in to the configuration file /etc/fw_env.config

<pre># Device to access      offset          env size
/dev/mmcblk0            0x88000         0x20000</pre>

You should now be able to run fw\_printenv and get your environment printed out, if the error &#8220;Warning: Bad CRC, using default environment&#8221; then your u-boot setup is different and you shouldn&#8217;t use fw\_setenv.