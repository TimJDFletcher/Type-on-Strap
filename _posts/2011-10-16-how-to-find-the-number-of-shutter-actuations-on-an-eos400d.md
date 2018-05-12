---
id: 21
title: How to find the number of shutter actuations on an Canon EOS400D
date: 2011-10-16T18:39:17+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=21
permalink: /2011/10/how-to-find-the-number-of-shutter-actuations-on-an-eos400d/
categories:
  - Photography
---
Follow these [instructions](https://github.com/400plus/400plus/wiki/Firmware-Hack-Installation) to install the [400plus firmware](https://github.com/400plus/400plus)

Press the Menu button and then the display button, shutter actuations are shown at the bottom camera information page.

Alternatively you can use [gPhoto](http://gphoto.sourceforge.net/) without messing with the firmware

<pre>gphoto2 --get-config /main/status/shuttercounter</pre>