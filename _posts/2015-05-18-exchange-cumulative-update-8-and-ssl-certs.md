---
id: 519
title: Exchange Cumulative Update 8 and SSL certificates
date: 2015-05-18T15:05:25+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=519
permalink: /2015/05/exchange-cumulative-update-8-and-ssl-certs/
categories:
  - Exchange
  - Microsoft
  - Security
---
This weekend while I was patching and rebooting KVM systems for Venom I took the opportunity to apply Microsoft&#8217;s latest [Exchange Cumulative Update 8](https://support.microsoft.com/en-gb/kb/3030080) work&#8217;s Exchange server.

I ran the pre-upgrade checks and  they picked up that my user wasn&#8217;t in the correct AD groups for scheme updates, once that was fixed the upgrade started without problems.

When the upgrade got to Section 10 &#8211; Mailbox role: Transport Services the upgrade failed because a certificate had expired. Fine just install an updated certificate but all of the Exchange management tools have been uninstalled so you can&#8217;t get to the certificate.

When you rerun the installer it detects the failed install and tries to resume and fails at the same place, in the end I had to move the clock back two days on the server to get the management tools to install so that the certificate could be replaced.

I&#8217;ve reviewed the Microsoft documentation and I can&#8217;t see any reference to this problem and it wasn&#8217;t detected in the pre-upgrade checks. I&#8217;m sure there is some powershell magic that could fix this but at 1am on a Monday morning I wasn&#8217;t all that interested in finding out!