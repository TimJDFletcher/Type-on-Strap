---
id: 335
title: Smoothwall in a heterogeneous network
date: 2014-01-13T10:55:17+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=335
permalink: /2014/01/smoothwall-in-a-heterogeneous-network/
categories:
  - Apple
  - Linux
  - Security
---
Smoothwall is a Linux based UTM appliance, combining a firewall, web proxy and content filter. I have recently implemented Smoothwall for a customer, this implementation included Single Sign On (SSO) support for both Mac OS X and Windows. I didn&#8217;t find any good documentation on SSO with Smoothwall for both Mac OS X and Windows so I&#8217;ve written up my notes.

Windows has for a long time had SSO support via NTLM, meaning that Windows can (fairly) securely and transparently log in to other systems that are joined to the same Active Directory controller. This is done with a ticket based challenge/response authentication process built into Active Directory.

Mac OS X has had support for Kerberos SSO via Kerberos tickets to various systems since 10.3, it has been through a number of revisions and changes over the years. However it&#8217;s not until [Mac OS X 10.6.8](http://support.apple.com/kb/HT4561) that support for Kerberos authentication to web-proxies like the guardian filter in Smoothwall was introduced.

This is the final piece in the puzzle for this customer and now both Apple Macs and Windows desktops &#8220;just work&#8221; automatically authenticating with Kerberos tickets.

Kerberos SSO requires slightly more careful configuration than NTLM. The main thing to make sure about is that you are accessing the proxy via it&#8217;s fully quallified name, ie proxy.example.com not just proxy or it&#8217;s IP address.

In this case the customer uses a [proxy.pac](http://en.wikipedia.org/wiki/Proxy_auto-config) file, which also needs to contain the proxy server&#8217;s full name. Smoothwall includes an option to enable this but it didn&#8217;t seem to work in this case so I just made my own simple .pac file and uploaded it.

The configuration on the clients was simple just set the network proxy settings to URL auto-configuration and point it at http://proxy.example.com/proxy.pac