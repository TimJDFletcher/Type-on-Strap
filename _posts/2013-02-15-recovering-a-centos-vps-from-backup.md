---
id: 223
title: Recovering a CentOS VPS from an rsync backup
date: 2013-02-15T23:48:28+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=223
permalink: /2013/02/recovering-a-centos-vps-from-backup/
categories:
  - Linux
---
I have been helping a friend recover his 123-Reg CentOS 6 based VPS from an rsync files backup. My friend has a 123-Reg VPS with a number of small websites running on it, last weekend 123-Reg completely wrecked his VPS by &#8220;upgrading&#8221; the underlying host. The upgrade led to massive file-system corruption and because it&#8217;s &#8220;not a managed product&#8221; 123-Reg washed their hands of helping repair their mistake. The only &#8220;support&#8221; that 123Reg offer is button to trigger a fresh rebuild with the latest CentOS installed.

Fortunately I had been working to migrate some websites and so had taken a full rsync backup just before this upgrade took place. The problem with backups is often recovery this recovery process has now been tested and works. The biggest challenge was working out why the restore fails as 123-Reg don&#8217;t provide console access which makes figuring out recovery failures tricky.

First un-mount all the bind mounted bits that make up the chrooted named stack

<pre>mount | grep bind | awk '{print $1}' | xargs umount</pre>

Next copy fstab someplace safe, in this case we aren&#8217;t rebuilding /boot so stash a copy there. We do this because the fresh install has different UUIDs embedded in the filesystems so we need to make sure they are correct otherwise the VPS will fail to boot and need rebuilding again.

<pre>cp /etc/fstab /boot</pre>

Now we have a safe copy of fstab we need to copy the files over, it&#8217;s a good idea to copy over /etc/passwd and /etc/group first so that file ownerships work correctly. The copy needs to run as root in order to read all the files.

<pre>sudo -E rsync -avzPHS \
--one-file-system --delete-after \
/path/to/backups root@VPS:/</pre>

Once this copy has completed, we need to replace fstab with the one we copied before.

<pre>cp /boot/fstab /etc/fstab</pre>

Next we need to make sure we can boot the VPS, we only get one go at this because we have no console access so we rebuild all of the boot process. First reinstall the current kernel, this is not necessarily the running kernel but the one installed on the backup image.

<pre>rpm -ivh --force &lt;kernel rpm&gt;</pre>

Next reinstall grub

<pre>grub-install /dev/vda</pre>

Finally check the UUID for / matches in grub.conf, initramfs and fstab