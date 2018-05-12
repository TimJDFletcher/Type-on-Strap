---
id: 282
title: 'Finding my wife&#8217;s missing phone with OpenWRT'
date: 2013-08-23T22:07:29+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=282
permalink: /2013/08/finding-my-wifes-missing-phone-with-openwrt/
categories:
  - iOS
  - OpenWRT
  - WR703N
---
A few weeks ago my wife and I where visiting some friends in Sweden, they own a small cottage in the woodland near Stockholm. The location is lovely but slightly out of the way with a small lake about 200m from the cottage.

<a href="https://blog.night-shade.org.uk/wp-content/uploads/2013/08/IMG_3659.jpg" rel="lightbox[282]" title="Swedish Lake"><img class="aligncenter size-medium wp-image-284" alt="Swedish Lake" src="https://blog.night-shade.org.uk/wp-content/uploads/2013/08/IMG_3659-300x225.jpg" width="300" height="225" srcset="https://blog.night-shade.org.uk/wp-content/uploads/2013/08/IMG_3659-300x225.jpg 300w, https://blog.night-shade.org.uk/wp-content/uploads/2013/08/IMG_3659-1024x768.jpg 1024w, https://blog.night-shade.org.uk/wp-content/uploads/2013/08/IMG_3659-400x300.jpg 400w" sizes="(max-width: 300px) 100vw, 300px" /></a>We went for a walk round the lake to enjoy the glorious weather and take some photos of the mirror smooth lake. About 1/2 way round the lake my wife realised that she didn&#8217;t have her phone. We did the obvious things of retracing our steps looking at the floor and trying to work out which of the little paths we took round the lake. We found a number of things
  
including large numbers of frogs and my sunglasses which I didn&#8217;t even realise I had lost, but no phone.

Normally the next step would be to get the phone to make some noise, either by ringing it or using the anti-theft product that was installed on it. Both of these ideas had problems, the phone was on silent meaning ringing the phone was a waste of time. The problem with the anti-theft product was that it needed a data connection and because the phone was
  
connected to a foreign network it was in roaming mode and the data connection was disabled to avoid massive bills. So what next?

The phone has WIFI and will automatically join an AP it knows about, but which SSIDs could I be certain it would join and how would I get an AP close enough to the phone in the middle of the Swedish woodland?

I always carry a little bag of tricks and I thought there might be something in there that could to help. In the bag I had a mobile phone charging battery, a TP-Link WR703 with OpenWRT installed and I had an ssh client ([Prompt](http://panic.com/prompt/) from Panic Inc) on my iDevices.

So I can build a mobile AP (WR703 + USB Battery) and because it&#8217;s running OpenWRT I can customize and monitor the AP. Next I needed some configuration for the AP particularly an SSID that the missing phone is guaranteed to join. The obvious option is the SSID from home. So I logged into the AP at home via OpenVPN copied /etc/config/wireless to the WR703 I had running. After I reboot I had an AP that appear to be the same as the one at home and my iDevices joined straight away, step one completed.

We loaded my rucksack with all of the kit and set off for another walk round the lake. I had logged into AP from my iPhone and was running logread -f to monitor the logs on the AP. We repeated the route again, debating about which path we took and poking about in bushes looking for a phone. We where getting towards the point where my wife realised she has lost her phone and starting to give up hope. Then another device joined the access point, authenticated and got an IP from the DHCP server it was an Android device. This was a big step forward, we knew that there was an Android phone within about 100m of us, that had our WIFI password set on it.

Because of the way that radio works with a bit of walking about with my iPhone and my bag hung on a tree we could map the edge of the wifi from the AP. Once we had a clear idea where we should be looking we had another good hard look at the 100m or so of path that my mapping suggested the phone could be in. No luck and it was starting to get dark
  
and the phone&#8217;s battery would probably not last the night, time for some more thinking. The real thing that would help would getting an internet connection on the phone, so back to the cottage for another think.

One of our friends in Sweden had a Windows phone that includes mobile AP, which unlike the iPhone you could set the SSID and password on. After typing in the long random WPA password I set on the home AP, I set off again with a mobile AP in my bag but this time with internet access.

<a href="https://blog.night-shade.org.uk/wp-content/uploads/2013/08/Moonlight.jpg" rel="lightbox[282]" title="Moonlight"><img class="aligncenter size-medium wp-image-287" alt="Moonlight" src="https://blog.night-shade.org.uk/wp-content/uploads/2013/08/Moonlight-300x225.jpg" width="300" height="225" srcset="https://blog.night-shade.org.uk/wp-content/uploads/2013/08/Moonlight-300x225.jpg 300w, https://blog.night-shade.org.uk/wp-content/uploads/2013/08/Moonlight-400x300.jpg 400w, https://blog.night-shade.org.uk/wp-content/uploads/2013/08/Moonlight.jpg 1024w" sizes="(max-width: 300px) 100vw, 300px" /></a>

After a little detour to take photos of the moonlight on the lake, I returned to the tree where the missing phone got WIFI marked with a Swedish napkin. I triggered off another round of alerts to the phone over the internet but no luck, no noises from the undergrowth and it was finally getting dark even in Sweden and it was time to head back to the cottage.

Now was the time for any last good ideas, after a bit of thought I had an idea! Wifi works in a circle and while I could be pretty sure that the phone wasn&#8217;t 100m into the lake I should really check if there was another path further into the woodland. I went a bit further along the path and there was a fork leading back into the woodland that looked promising. I set off down the path and after a minute I could hear something ahead and sure enough there was the missing phone.