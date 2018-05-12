---
id: 448
title: Allow virsh as a normal user on Debian Jessie
date: 2015-02-14T17:43:00+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=448
permalink: /2015/02/allow-virsh-as-a-normal-user-on-debian-jessie/
categories:
  - Debian
  - Linux
---
Debian Jessie has migrated libvirt to use polkit which means the normal advice of &#8220;add your user to libvirt and kvm groups&#8221; doesn&#8217;t work for virsh. There doesn&#8217;t seem to be any documentation about the change either. After a bit of head scratching and googling the following fixes the problem and allows members of the libvirt group to use virsh.

You need to create a local policykit access list, this example allows all members of the libvirt group to manage libvirt

**/etc/polkit-1/localauthority/50-local.d/50-libvirt-virsh-access.pkla**
  
`[libvirt Management Access]<br />
Identity=unix-group:libvirt<br />
Action=org.libvirt.unix.manage<br />
ResultAny=yes<br />
ResultInactive=yes<br />
ResultActive=yes`

You also need to configure virsh to connect to libvirtd running on the local system by default, to do this add these lines to .bash_profile to add it to your bash shell environment.

**.bash_profile**
  
`if test -x $(which virsh); then<br />
export LIBVIRT_DEFAULT_URI=qemu:///system<br />
fi`

<http://www.linuxsysadmintutorials.com/configure-polkit-to-run-virsh-as-a-normal-user/>

[https://libvirt.org/auth.html#ACL\_server\_polkit](https://libvirt.org/auth.html#ACL_server_polkit)