---
id: 106
title: 'Fixing my iPad&#8217;s photo order with Samba'
date: 2012-03-11T00:07:18+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=106
permalink: /2012/03/fixing-ipad-photo-sort-order-with-samba/
categories:
  - iOS
  - Linux
  - Photography
---
Since upgrading to iOS 5.0 the photos on my iPad and iPhone have been in the &#8220;wrong&#8221; order and after spending a few hours googling, reading [this](https://discussions.apple.com/message/17796341) thread on the Apple forums and researching I now understand why and how to work round it.

**Summary**

iTunes when syncing to iOS 5.0/5.1 doesn&#8217;t use the exif date, file timestamps or filenames to determine the order of photos in an album, instead the order is based on the order of files returned by the QueryDirectory syscall. You can work round this by presorting the list of files returned by Samba using the VFS module [dirsort](http://www.samba.org/samba/docs/man/manpages-3/vfs_dirsort.8.html).

**Background**

My photos are shared from a HP Microserver running Ubuntu, normally I access and edit my photos under Linux via iSCSI but I have an automatically updating LVM snapshot of my master photo archive exported to Windows by Samba for iTunes to sync my iDevices.

The exact details here don&#8217;t really matter, the keys points are that I have my photos stored on Linux and exported via Samba to iTunes running on Windows 7.

**The problem**

****In iOS 4.x synced photos in the photos app where displayed in exif date order, in iOS 5.0/5.1 they are displayed it what seems to be a random order. This order isn&#8217;t affected by any of the time stamps on the files (ctime/mtime/atime for those who know unix), the names of the files or the exif timestamp embedded in the files.

**Debugging**

After trying all the tricks I could think of fiddling with timestamps and names of the files under Linux I tried copying the files on my Windows machines local NTFS drive and resyncing the iPad and it worked!

So the problem wasn&#8217;t in the files or the file names it had to be somewhere between Windows and Samba, next I fired up [process monitor](http://technet.microsoft.com/en-us/sysinternals/bb896645) from sysinternals to watch exactly what iTunes was doing. After a bit tinkering with the filters on process monitor I finally found something that matched the &#8220;random&#8221; order of photos on my iPad, I had found the problem!

**The cause**

When iTunes builds the list of files to sync onto a iDevice it uses the order of files returned by the QueryDirectory syscall, when this syscall is used to list a directory under NTFS it returns the list of files in the directory sorted in alphabetical order, but Samba returns it unsorted in disk order. As you can see from this screenshot the list of files is unsorted, and it matches perfectly the apparently random order of photos on my iPad in the album.

<p style="text-align: center;">
  <a href="https://blog.night-shade.org.uk/wp-content/uploads/2012/03/NoVFSsort.png" rel="lightbox[106]" title="Fixing my iPad's photo order with Samba"><img class="aligncenter size-medium wp-image-107 cpqqrgvrvurlzrphaeix cpqqrgvrvurlzrphaeix cpqqrgvrvurlzrphaeix" title="NoVFSsort" src="https://blog.night-shade.org.uk/wp-content/uploads/2012/03/NoVFSsort-260x300.png" alt="" width="260" height="300" srcset="https://blog.night-shade.org.uk/wp-content/uploads/2012/03/NoVFSsort-260x300.png 260w, https://blog.night-shade.org.uk/wp-content/uploads/2012/03/NoVFSsort.png 504w" sizes="(max-width: 260px) 100vw, 260px" /></a><img class="aligncenter size-full wp-image-107" title="NoVFSsort" src="https://blog.night-shade.org.uk/wp-content/uploads/2012/03/NoVFSsort.png" alt="" width="504" height="580" srcset="https://blog.night-shade.org.uk/wp-content/uploads/2012/03/NoVFSsort.png 504w, https://blog.night-shade.org.uk/wp-content/uploads/2012/03/NoVFSsort-260x300.png 260w" sizes="(max-width: 504px) 100vw, 504px" />
</p>

**The solution**

Some further googling led me to discover that other people have had problems with Windows applications that assume directory listings are returned sorted, and someone has written a Samba VFS module that works round the problem. The module is called [dirsort](http://www.samba.org/samba/docs/man/manpages-3/vfs_dirsort.8.html) and is included in modern versions of Samba so all you need to work round the problem is add the following line to /etc/samba/smb.conf for your photo&#8217;s share definition.

<pre>vfs objects = dirsort</pre>

After making this change and restarting Samba this is output of the QueryDirectory syscall for the same directory.

<p style="text-align: center;">
  <img class="aligncenter size-full wp-image-108" title="VFSsort" src="https://blog.night-shade.org.uk/wp-content/uploads/2012/03/VFSsort.png" alt="" width="505" height="579" srcset="https://blog.night-shade.org.uk/wp-content/uploads/2012/03/VFSsort.png 505w, https://blog.night-shade.org.uk/wp-content/uploads/2012/03/VFSsort-261x300.png 261w" sizes="(max-width: 505px) 100vw, 505px" />
</p>

This does assume that your photos are named in the order you want to show them, I fix this by using the following [exiftool](http://www.sno.phy.queensu.ca/~phil/exiftool/) command.

<pre>exiftool "-FileName&lt;CreateDate" -d "%Y%m%d_%H%M%S.%%e" <em>DIR</em></pre>

&nbsp;