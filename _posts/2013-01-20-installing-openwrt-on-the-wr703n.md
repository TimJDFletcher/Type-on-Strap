---
id: 174
title: Installing OpenWRT on the WR703N
date: 2013-01-20T21:38:30+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=174
permalink: /2013/01/installing-openwrt-on-the-wr703n/
categories:
  - Hardware
  - OpenWRT
  - WR703N
---
The TP Link WR703N is a tiny little embedded Linux system, sold in China as a travel 3G router, you can pick them up for less than £20 from [eBay](http://www.ebay.co.uk/sch/i.html?_nkw=wr703n). They are very popular with hardware hackers as they are cheap and flexible. If you look carefully on eBay you can find a modified version of the WR703N which has 64MB of RAM and 16MB of flash as well as having it&#8217;s serial lines connected to the micro usb port, meaning you get serial console access over the same cable as you plug in for power! These versions are made by a guy in China with the handle SLboat, he has documented the process on his [wiki](http://see.sl088.com/wiki/WR703_16M_Flash) or you can [buy](http://www.ebay.co.uk/sch/i.html?_nkw=slboat+wr703n) them ready made for about £30 including postage.

Out of the box unmodified devices run a Chinese language firmware but you can easily wipe it and install OpenWRT, mouse over the links until you find the firmware upgrade link which is http://192.168.1.1/userRpm/SoftwareUpgradeRpm.htm. Once you have found the link upload the OpenWRT factory upgrade [firmware](http://downloads.openwrt.org/attitude_adjustment/12.09-rc1/ar71xx/generic/openwrt-ar71xx-generic-tl-wr703n-v1-squashfs-factory.bin) from the Attitude Adjustment RC1 branch wait and few minutes and then do basic OpenWRT setup. If you need help OpenWRT [wiki](http://wiki.openwrt.org/doc/howto/basic.config) is useful, once you have done the basics you now have a tiny low power wireless Linux box.

&nbsp;