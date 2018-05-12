---
id: 386
title: Lollipop on the Galaxy S2 – Stage 2/4 Installing CyanogenMod
date: 2015-01-14T16:21:11+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=386
permalink: /2015/01/lollipop-on-the-galaxy-s2-stage-24-installing-cyanogenmod/
categories:
  - Hardware
  - i9100
  - Linux
---
Once I had backups and CWM installing CyanogenMod 12 was easy, download the latest version of the ROM from [this](http://forum.xda-developers.com/galaxy-s2/development-derivatives/rom-cyanogenmod-12-t2955551) XDA thread, I used [Beta #8](http://click.xda-developers.com/api/click?format=go&jsonp=vglnk_14212498555488&key=f0a7f91912ae2b52e0700f73990eb321&libId=51c1a323-6cd7-4afd-806e-a425efa01f3a&loc=http%3A%2F%2Fforum.xda-developers.com%2Fgalaxy-s2%2Fdevelopment-derivatives%2From-cyanogenmod-12-t2955551&v=1&out=https%3A%2F%2Fwww.androidfilehost.com%2F%3Ffid%3D95887005526789163&ref=http%3A%2F%2Fforum.xda-developers.com%2Fgalaxy-s2%2Fdevelopment-derivatives%2From-cyanogenmod-12-t2955551%2Fpage232&title=%5BROM%5D%5B5.0.2%5D%5BI9100%5D%20CyanogenMod%2012%20%5BBETA%5D%5B01%E2%80%A6%20%7C%20Samsung%20Galaxy%20S%20II%20I9100%20%7C%20XDA%20Forums&txt=Beta%20%238).

Boot into recovery mode using power+volume up+home, wipe everything (cache, data, system), choose install from sideload and then from your computer run.

<pre>adb sideload /path/to/rom.zip</pre>

Wait for the install to complete and reboot the phone, the first boot will take a very long time while Android is installed and that various caches rebuilt. I now had a Galaxy S2 running Lollipop but without any Google Apps, which is where it got a bit more difficult.