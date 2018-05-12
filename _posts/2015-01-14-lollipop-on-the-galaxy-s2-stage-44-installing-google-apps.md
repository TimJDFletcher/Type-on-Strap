---
id: 392
title: Lollipop on the Galaxy S2 – Stage 4/4 Installing Google Apps
date: 2015-01-14T17:05:57+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=392
permalink: /2015/01/lollipop-on-the-galaxy-s2-stage-44-installing-google-apps/
categories:
  - Hardware
  - i9100
  - Linux
---
Finally we have enough space in /system install the full Google Apps package, download the latest full package from the [official thread](http://forum.xda-developers.com/paranoid-android/general/gapps-official-to-date-pa-google-apps-t2943900).

I had a slight problem getting this on to the phone as adb sideload uses /tmp which is only 400MB so the transfer fails and I didn&#8217;t have an SD card handy. To fix this I mounted /data, pushed the zip file to /data and then used a bind mount to mount /data to the SD card location of /storage/sdcard0

<pre>adb shell mount /data
adb push /path/to/googleapps.zip /data
adb shell mkdir /storage/sdcard0
adb shell mount -o bind /data /storage/sdcard0</pre>

Now choose install from SD card in the CWM menu and select the Google Apps zip file.

After another slow reboot later and I have CyanogenMod 12 and the latest Paranoid Android Google Apps on my Galaxy S2. I&#8217;ve included the obligatory screen shots of the home page and the device status.

<a href="https://blog.night-shade.org.uk/wp-content/uploads/2015/01/Screenshot_2015-01-13-16-54-27.png" rel="lightbox[392]" title="Screenshot_2015-01-13-16-54-27"><img class="aligncenter size-medium wp-image-401" src="https://blog.night-shade.org.uk/wp-content/uploads/2015/01/Screenshot_2015-01-13-16-54-27-180x300.png" alt="Screenshot_2015-01-13-16-54-27" width="180" height="300" srcset="https://blog.night-shade.org.uk/wp-content/uploads/2015/01/Screenshot_2015-01-13-16-54-27-180x300.png 180w, https://blog.night-shade.org.uk/wp-content/uploads/2015/01/Screenshot_2015-01-13-16-54-27.png 480w" sizes="(max-width: 180px) 100vw, 180px" /></a><a href="https://blog.night-shade.org.uk/wp-content/uploads/2015/01/Screenshot_2015-01-13-16-54-40.png" rel="lightbox[392]" title="Screenshot_2015-01-13-16-54-40"><img class="aligncenter size-medium wp-image-400" src="https://blog.night-shade.org.uk/wp-content/uploads/2015/01/Screenshot_2015-01-13-16-54-40-106x300.png" alt="Screenshot_2015-01-13-16-54-40" width="106" height="300" srcset="https://blog.night-shade.org.uk/wp-content/uploads/2015/01/Screenshot_2015-01-13-16-54-40-106x300.png 106w, https://blog.night-shade.org.uk/wp-content/uploads/2015/01/Screenshot_2015-01-13-16-54-40-362x1024.png 362w, https://blog.night-shade.org.uk/wp-content/uploads/2015/01/Screenshot_2015-01-13-16-54-40.png 480w" sizes="(max-width: 106px) 100vw, 106px" /></a>