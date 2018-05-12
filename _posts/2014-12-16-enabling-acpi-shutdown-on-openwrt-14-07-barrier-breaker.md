---
id: 378
title: Enabling ACPI shutdown on OpenWRT 14.07 (Barrier Breaker)
date: 2014-12-16T12:09:16+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=378
permalink: /2014/12/enabling-acpi-shutdown-on-openwrt-14-07-barrier-breaker/
categories:
  - Linux
  - OpenWRT
---
I use OpenWRT VMs as micro routers to build private internal networks inside my Linux workstations using KVM and openvswitch. The problem is that when the libvirt shuts guests down is sends an ACPI shutdown button press (the physical equivalent of pressing the power button) which OpenWRT ignores.

On previous versions of OpenWRT you needed to install the acpid package but now you only need to install the kmod-button-hotplug package.

<pre>opkg update
opkg install kmod-button-hotplug</pre>