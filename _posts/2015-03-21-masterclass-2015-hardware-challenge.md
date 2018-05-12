---
id: 456
title: Masterclass 2015 hardware challenge
date: 2015-03-21T01:00:55+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=456
permalink: /2015/03/masterclass-2015-hardware-challenge/
categories:
  - Hardware
  - Linux
  - Security
---
Last week I competed in the [UK Cyber Security Challenge](http://cybersecuritychallenge.org.uk/), spending 2 days in London on the HMS Belfast. I was fortunate to be part of a great team, including the event&#8217;s overall winner [Adam Tonks](https://twitter.com/adamtonks).

Part of the challenge was a hardware badge, we were given &#8220;suspicious&#8221; items that had been intercepted and asked to find out what they are.<a href="https://blog.night-shade.org.uk/wp-content/uploads/2015/03/2015-03-20-22.10.58.jpg" rel="lightbox[456]" title="2015-03-20 22.10.58"><img class="aligncenter size-medium wp-image-458" src="https://blog.night-shade.org.uk/wp-content/uploads/2015/03/2015-03-20-22.10.58-300x237.jpg" alt="2015-03-20 22.10.58" width="300" height="237" srcset="https://blog.night-shade.org.uk/wp-content/uploads/2015/03/2015-03-20-22.10.58-300x237.jpg 300w, https://blog.night-shade.org.uk/wp-content/uploads/2015/03/2015-03-20-22.10.58.jpg 1024w, https://blog.night-shade.org.uk/wp-content/uploads/2015/03/2015-03-20-22.10.58-900x710.jpg 900w" sizes="(max-width: 300px) 100vw, 300px" /></a>Other than the USB port and central chip, the next thing I noticed was the five gold pads in the middle of the board. Because I tinker with embedded systems, I thought they look a lot like a serial debug port. In fact I don&#8217;t think they are are a serial port any more but serial port is a good clue. There is a row of 8 LEDs labelled LED1-8 which become important at the end of the puzzle.

When you plug the device in a slew of USB entries in appear in dmesg, the key lines are in bold. The first line tells you the USB device is made by freescale who make ARM chips which are tiny computers. The next line about ttyACM0 and attaching the removable scsi disk we&#8217;ll use to explore the badge in more detail.

<pre>usb 1-4.1.2: new full-speed USB device number 39 using ehci-pci
usb 1-4.1.2: New USB device found, idVendor=15a2, idProduct=0800
usb 1-4.1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-4.1.2: Product: MSD_CDC DEVICE
<strong>usb 1-4.1.2: Manufacturer: FREESCALE SEMICONDUCTOR INC.</strong>
cdc_acm 1-4.1.2:1.0: This device cannot do calls on its own. It is not a modem.
<strong>cdc_acm 1-4.1.2:1.0: ttyACM0: USB ACM device</strong>
usb-storage 1-4.1.2:1.2: USB Mass Storage device detected
scsi20 : usb-storage 1-4.1.2:1.2
<strong>scsi 20:0:0:0: Direct-Access FSL SEMI FSL MASS STORAGE 0001 PQ: 0 ANSI: 4</strong>
sd 20:0:0:0: Attached scsi generic sg6 type 0
sd 20:0:0:0: [sdf] 8 512-byte logical blocks: (4.09 kB/4.00 KiB)
sd 20:0:0:0: [sdf] Write Protect is off
sd 20:0:0:0: [sdf] Mode Sense: 00 00 00 00
sd 20:0:0:0: [sdf] Asking for cache data failed
sd 20:0:0:0: [sdf] Assuming drive cache: write through
sd 20:0:0:0: [sdf] Asking for cache data failed
sd 20:0:0:0: [sdf] Assuming drive cache: write through
Dev sdf: unable to read RDB block 8
sdf: unable to read partition table
sdf: partition table beyond EOD, truncated
sd 20:0:0:0: [sdf] Attached SCSI removable disk</pre>

First question what is on the USB serial port?

I normally use screen to access serial ports when I am working with embedded systems, it&#8217;s easier to use than minicom and putting the -L flag writes a log of the serial session. This is important for forensic and incident response work as it records your artifacts. The number at the end is the serial port speed, however the badge is very forgiving of different speeds, other embedded devices are much less so.

<pre>screen -L /dev/ttyACM0 115200</pre>

Press return, and we get a password prompt but what&#8217;s the password?

<pre>Sorry, wrong password.
Password:*</pre>

We tried various passwords related to our previous investigations but not of them worked.

The next thought was to check the USB mass storage device, the device is tiny only 4k in size. Mostly the device is just empty space and doesn&#8217;t have a filesystem on it so mounting it doesn&#8217;t help. In the heat of the challenge I used strings to &#8220;eyeball&#8221; the raw contents of the device, but the output of xxd is neater. In the raw dump we found some interesting data.

<pre>sudo xxd -a /dev/sdf
0000000: 0000 5365 6375 7265 2070 6173 7377 6f72  ..Secure passwor
0000010: 6420 6469 736b 0000 0000 0000 0000 0000  d disk..........
0000020: 0000 0000 0000 0000 0000 0000 0000 0000  ................
*
0000200: 0053 6563 7572 6520 7061 7373 776f 7264  .Secure password
0000210: 2073 746f 7261 6765 2064 6174 6162 6173   storage databas
0000220: 650d 6164 6d69 6e3a 6e69 6d64 610d 6f70  e.admin:nimda.op
0000230: 6572 6174 6f72 3a62 336c 6661 3574 3233  erator:b3lfa5t23
0000240: 0d00 0000 0000 0000 0000 0000 0000 0000  ................
0000250: 0000 0000 0000 0000 0000 0000 0000 0000  ................
*
0000400: 0053 5550 4552 2053 6563 7572 6520 7061  .SUPER Secure pa
0000410: 7373 776f 7264 2073 746f 7261 6765 2064  ssword storage d
0000420: 6174 6162 6173 650d 0061 6d68 3564 4456  atabase..<strong>amh5dDV</strong>
0000430: 305a 6d51 3d00 0000 0000 0000 0000 0000  <strong>0ZmQ=</strong>...........
0000440: 0000 0000 0000 0000 0000 0000 0000 0000  ................
*
0000ff0: 0000 0000 0000 0000 0000 0000 0000 0000  ................</pre>

A few plain text passwords, and then what looks to be the inevitable base64 encoded string in the &#8220;SUPER Secure password storage database&#8221;. Simply use base64 -d to decode the string and we get what could be a password.

<pre>echo amh5dDV0ZmQ= | base64 -d
<strong>jhyt5tfd</strong></pre>

Using this string as password allows access to a menu, option 1 doesn&#8217;t work and option 2 needs a password.

<pre>Welcome to your new secure badge token. Please start initialisation.
     1 - - - - - Network test
     2 - - - - - Superuser mode
     3 - - - - - Logout
&gt;
&gt;1
Sorry, this device does not support this.
     1 - - - - - Network test
     2 - - - - - Superuser mode
     3 - - - - - Logout
&gt;2
Entering enable mode...
Enable password:*
</pre>

Again try a few passwords without success, Adam worked out that you can buffer overflow the menu and get a crash dump from the menu process.

<pre>Entering enable mode...
Enable password:***********************************************************************************************************************
main_thread(16788): Oops!
 CPU[1]: local_irq_count[0] irqs_running[1] 
 memory DUMP starting 0x004005 
 01 7F 8E 9E 8D D0 55 E3 
<strong>64 62 67 6E 77</strong> 00 78 66
6D 41 49 6C 20 6D 65 21
6A 6F 65 6C 40 62 2E 63 
 6F 6D FF 00 FF 00 FF 00</pre>

Another leap of Adam&#8217;s led to translating the hex dump into binary using perl, and decoding the resulting binary with xxd. This gave more text, an easter egg left by the designer of the puzzle Joel from BT and a null terminated string of 5 characters, lets see if they are a password. I&#8217;ve highlighted in bold this string in the various outputs.

<pre>perl -E'print pack "H*","017F8E9E8DD055E3<strong>6462676E77</strong>0078666D41496C206D65216A6F656C40622E636F6DFF00FF00FF00"'| xxd

0000000: 017f 8e9e 8dd0 55e3 <strong>6462 676e 77</strong>00 7866 ......U.<strong>dbgnw</strong>.xf
0000010: 6d41 496c 206d 6521 6a6f 656c 4062 2e63 mAIl me!joel@b.c
0000020: 6f6d ff00 ff00 ff00                     om......</pre>

The string found in the crash dump does indeed allow access to the final menu that lets find the badge&#8217;s key.

<pre>Password:**
Welcome to your new secure badge token. Please start initialisation.
     1 - - - - - Network test
     2 - - - - - Superuser mode
     3 - - - - - Logout
&gt;2
Entering enable mode...
Enable password:**
     1 - - - - - Debug optical network
     2 - - - - - Logout
&gt;</pre>

How the badge sends the key is the most fun part I think, when you debug the optical network the badge flashes the 8 LEDs on the side of the badge. Again Adam spotted that if you transcribe them as binary the first 2 characters are PW and then 4 random characters which is the badge &#8220;ultimate&#8221; password.

<pre>1 - - - - - Debug optical network
     2 - - - - - Logout
&gt;1
transmitting key...
Format: PW&lt;key&gt;

     1 - - - - - Debug optical network
     2 - - - - - Logout
&gt;</pre>

I&#8217;ve [uploaded a video](http://youtu.be/s__9FEbpdl8) of my badge transmitting it&#8217;s key, see if you can decode it.