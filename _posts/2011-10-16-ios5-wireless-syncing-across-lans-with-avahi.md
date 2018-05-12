---
id: 12
title: iOS5 Wireless Syncing across LANs with Avahi
date: 2011-10-16T00:24:18+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=12
permalink: /2011/10/ios5-wireless-syncing-across-lans-with-avahi/
categories:
  - iOS
  - Linux
  - OpenWRT
---
Just finished playing with my new toy an [iPhone 4S](http://apple.com/iphone "iPhone4S"), and mostly because I couldn&#8217;t find anything about setting up wireless sync across different LANs on google I&#8217;ve published this.

First of all you need a *NIX based router between your different LANs, in my case I used Ubuntu 11.04 but this also works on [OpenWRT](http://openwrt.org "OpenWRT").

First of all install [avahi-daemon](http://wikipedia.org/wiki/Avahi_%28software%29 "Avahi details"), for Ubuntu

<pre>sudo apt-get install avahi-daemon</pre>

or OpenWRT

<pre>opkg install avahi-daemon</pre>

Next you need to configure avahi to act as reflector, you need to set at least the following varibles in /etc/avahi/avahi-daemon.conf

<pre>enable-wide-area=yes
enable-reflector=yes</pre>

You might also want to set

<pre>allow-interfaces=ethX,ethY
deny-interfaces=ethZ</pre>

Then all you need to do is restart the avahi-daemon and then iTunes should then find your phone.

**Update** &#8211; This works much more reliably with iOS 5.1