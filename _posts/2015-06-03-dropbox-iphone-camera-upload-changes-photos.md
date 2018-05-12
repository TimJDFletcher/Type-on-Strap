---
id: 529
title: Dropbox iPhone Camera Upload Changes Photos
date: 2015-06-03T23:04:08+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=529
permalink: /2015/06/dropbox-iphone-camera-upload-changes-photos/
hefo_before:
  - "0"
hefo_after:
  - "0"
categories:
  - Apple
  - Backup
  - iOS
  - Photography
---
When Google announced their new [Photos](https://photos.google.com) tools I decided to give it a go and see what Google&#8217;s machine learning could extract from my 83,292 photos stretching back 15 years. I&#8217;m sure you know that Google are offering &#8220;unlimited&#8221; and &#8220;free&#8221; storage for photos so long as you allow them to optimize your photos. I&#8217;m happy with the trade-off in quality as I already manage an archive of full resolution (or so I thought) photos via [f-spot](http://f-spot.org/) and have backup arrangements for it.

## Dropbox Camera Upload

I have used the Dropbox Camera Upload feature for about 18 months to get photos off my iPhone and on to my various other devices and offsite backup server. Dropbox [state](https://blogs.dropbox.com/dropbox/2012/06/your-photos-simplified-part-iii/) that &#8220;When you open the app, photos and videos from your iPhone or iPad are saved to Dropbox at their original size and quality in a private Camera Uploads folder.&#8221;

This statement hides the fact, that the Dropbox app re-compresses your photos before it uploads them. I found this out when I used the desktop backup client to seed Google Photos from my Dropbox camera folder, before activating the apps on my iPhone and iPad.

Google checksum all photos before uploading to avoid duplication. When I enabled the Google Photos app on my iOS devices to upload directly from the iOS camera roll, the app started to upload all my photos again. This led to duplicated photos and a few gigs of wasted upload bandwidth. I wanted to understand why this happened and adapt my photo work flow to avoid it happening again.

## Image checksums

First of all I extracted a single photo IMG_7082 taken that day directly from my iPhone over USB. I copied the file from the DCIM folder on the phone, gaving me a 2.8MB file as my &#8220;master copy&#8221;. Checking my Dropbox &#8220;Camera Uploads&#8221; folder I found the same photo as expected had been [renamed by Dropbox](https://www.dropbox.com/en/help/4208) but unexpectedly had a different checksum and was over 1 megabyte smaller, the plot thickens!

The obvious next question was what is changing the file, so I extracted the same image file via email (sent as full resolution), iCloud and Photos on my MacBook each time it was the same size with a matching sha1 checksum. Uploading the master file to the free tier of Google Photos and then extracting it via Google Drive or the web UI did change the file but Google are upfront about that.

## The Proof

I have created a github repo with all the photos I used in testing if you want to have a look at them yourself it&#8217;s here: <https://github.com/TimJDFletcher/IMG_7082>

## Quality Change

I had a quick go at reproducing the same change in size of the image using GIMP and changing the JPEG compression level. I found that at 85% the file size was very close to the file size the both Google Photos and Dropbox produced. This is pretty crude test and is not to say this is the only compression that Google and Dropbox do.

## Lessons Learned

The main lesson for me is that I should confirm how applications I rely on to move data work as advertised. I do understand why Dropbox re-compress photos as it gives a large saving in storage and bandwidth, I wish they were as upfront about this as Google are.

Google says they will optimize your photos, if you don&#8217;t like this then you can pay money to store the originals. Dropbox on the other hand say &#8220;Don’t worry about losing those once-in-a-lifetime shots, no matter what happens to your iPhone.&#8221;

## Fixing the duplicates

Fixing the duplicates was fairly simple in the end, I just got a list of files uploaded from my iPhone and then deleted them from Google Drive using [google-drive-ocamlfuse](https://github.com/astrada/google-drive-ocamlfuse) and a bit of shell script.