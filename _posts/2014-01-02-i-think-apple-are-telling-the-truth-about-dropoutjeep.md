---
id: 321
title: I think Apple are telling the truth about DROPOUTJEEP
date: 2014-01-02T13:32:06+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=321
permalink: /2014/01/i-think-apple-are-telling-the-truth-about-dropoutjeep/
categories:
  - Apple
  - Security
---
<div id="watch-description-text">
  When I first listened to Jacob &#8220;@ioerror&#8221; Applebaum <a href="https://www.youtube.com/watch?v=b0w36GAyZIA">talk</a> from the 30c3 conference in Berlin I was impressed with the number and variety of different tools the NSA was using to monitor and spy on everything. One tool I was especially interested in being an iOS user was DROPOUTJEEP, sold as allowing full access with a 100% success rate in attacking iPhones but only with physical access.
</div>

<div>
  <a href="https://blog.night-shade.org.uk/wp-content/uploads/2014/01/dropoutjeep.png" rel="lightbox[321]" title="dropoutjeep catalog page"><img class="aligncenter size-medium wp-image-322" alt="dropoutjeep catalog page" src="https://blog.night-shade.org.uk/wp-content/uploads/2014/01/dropoutjeep-231x300.png" width="231" height="300" srcset="https://blog.night-shade.org.uk/wp-content/uploads/2014/01/dropoutjeep-231x300.png 231w, https://blog.night-shade.org.uk/wp-content/uploads/2014/01/dropoutjeep-791x1024.png 791w, https://blog.night-shade.org.uk/wp-content/uploads/2014/01/dropoutjeep.png 799w" sizes="(max-width: 231px) 100vw, 231px" /></a>The physical access part and Apple&#8217;s flat denial got me thinking and combined with some practical knowledge about how iOS security works I am fairly sure I understand what DROPOUTJEEP is. I have broken into iOS devices to recover data and pictures for people, it&#8217;s simple for older iPhones if you have physical access.
</div>

<div>
</div>

<div>
  The earlier iPhones (before the 4S) have bootloader flaws allowing an attack on the phone before the iOS kernel boots and the kernel security kicks in. This type of attack allows the injection of a custom ramdisk image containing unsigned code. I used a ramdisk and <a href="https://github.com/msftguy/ssh-rd">injection tool</a> that was assembled from an open source iOS exploit and includes an ssh server, and <a href="https://code.google.com/p/iphone-dataprotection/source/browse?repo=default#hg%2Fpython_scripts%2Fkeychain%253Fstate%253Dclosed">tools</a> to brute force crack an iPhone PIN code using the iPhone&#8217;s own crypto hardware to accelerate the process.
</div>

<div>
</div>

<div>
  The DROPOUTJEEP catalogue page is from 2008, when the iPhone 3G was the new thing, check out the <a href="http://en.wikipedia.org/wiki/IPhone#Model_comparison">timeline</a> on Wikipedia. Most people who had an iPhone at this time remember the Limera1n jailbreak, which at it&#8217;s core is a boot loader attack. This same boot loader flaw is still unpatched even after nearly 4 years. The Limera1n attack works on the iPhone 3G onwards and there are earlier boot loader attacks too. The <a href="http://theiphonewiki.com/wiki/SHA-1_Image_Segment_Overflow">SHAtter</a> boot loader attack, while never used in a jailbreak was much <a href="http://theiphonewiki.com/wiki/Bootrom#Bootrom_Exploits">discussed</a>.These types of bootloader attacks allowing the upload of custom root disks, give full hardware, disk and keybag access ie total ownage. Once your ramdisk is loaded you can just mount the internal storage and extract the data or use additional exploits to install custom malware. Full disk encryption is only a recent development, ie iPhone 3GS onwards ref: http://support.apple.com/kb/HT4175DROPOUTJEEP&#8217;s need for physical access tallies to my mind with a boot loader attack. Boot loader attacks are simple, reliable and quick so perfect for an NSA black bag job.</p> 
  
  <p>
    All this is not to say that Apple can&#8217;t push remote code to an iOS device, remember Apple has the signing keys and can sign any code they like. There are <a href="http://thenextweb.com/apple/2012/02/06/apple-compensates-victim-of-stolen-iphone-imessage-bug/#!q8j0v">reports</a> from the early days of iMessage that Apple pushed custom remote code to a stolen iPhone to disable iMessage.
  </p>
  
  <p>
    So I think that Apple are telling the truth about DROPOUTJEEP, but that is not to say they don&#8217;t cooperate in other ways when warrants or national security letters are involved.
  </p>
</div>