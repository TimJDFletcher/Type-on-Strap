---
id: 536
title: Why Does Dropbox Add a Unique ID to Every Photo?
date: 2015-06-04T23:51:51+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=536
permalink: /2015/06/why-does-dropbox-add-a-unique-id-to-every-photo/
categories:
  - Apple
  - Backup
  - iOS
  - Photography
  - Security
---
Following on from my last post about Dropbox changing my photos, I noticed a new exif field of &#8220;Image Unique ID&#8221; embedded by Dropbox in the image.

This ID would allow Dropbox to track unique files across their storage estate to avoid duplication. Equally it could used to track the original file and who uploaded it from a cropped version posted online, especially if law enforcement turned up with legal papers and demanded access.

Think about leaked documents or protest photos, yes it&#8217;s good practise to strip the meta data out but not everyone does.

This again comes back to what Dropbox and it&#8217;s camera upload feature is doing and is it documented anywhere?

Note Google Photos does not embedded any tracking data in the exif of the image I tested by uploading and downloading it.

## The Hash

The hash for IMG_7082 is 8af323e74def610b0000000000000000 which looks like a 128bit hash but with only the first 64 bits populated. I&#8217;ve tried a number of hash tools on various parts of the original but they don&#8217;t match the unique ID. I have tested just the pure image data from original and Dropbox modified images.

Reverse engineering the hash function isn&#8217;t the real issue here,  the real question is why has this ID been added?