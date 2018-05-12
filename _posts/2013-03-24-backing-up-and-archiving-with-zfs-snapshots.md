---
id: 252
title: Backing up and archiving with rsync and ZFS snapshots
date: 2013-03-24T00:39:46+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=252
permalink: /2013/03/backing-up-and-archiving-with-zfs-snapshots/
categories:
  - Linux
---
# Overview

I look after a server for a colleague that runs a number of KVM virtual machines on top of Ubuntu 12.04 LTS, the server has a pair of [USB drives](http://www.amazon.co.uk/gp/product/B008PABFX8/ref=as_li_ss_tl?ie=UTF8&camp=1634&creative=19450&creativeASIN=B008PABFX8&linkCode=as2&tag=atraveltinker-21) plugged in the back for backups.

I talked briefly about this in my lightning talk at [LISA conference in Newcastle](http://www.flossuk.org/Events/Spring2013) this week but I&#8217;m not sure I made much sense so this is a better write up.

Using USB harddrives for backups has drawbacks, namely USB transfers are slow compared to modern SATA harddisks, also I don&#8217;t trust harddisks or USB to transfer and store data correctly. This solution makes use of ZFS to address both of these problems and many others.

# Why ZFS for the backup target?

The ZFS features we are leveraging are:

  * **End to end checksums** &#8211; ZFS provides [end-to-end data integrity](https://blogs.oracle.com/bonwick/entry/zfs_end_to_end_data) by computing and storing a checksum with every block on the disk. This does cost a small amount of space and CPU time, however the gains for backups are huge. You know that the data on the disk is the data you have backed up, and it&#8217;s automatically verified every-time you read your backups.
  * **Compression** &#8211; ZFS allows for data to be compressed before it is sent to the disk, this helps because we can store more backups and because data is compressed before it travels over the slow USB link.
  * **Mirroring** &#8211; The drives as setup in as a ZFS mirror so that data is stored twice, once on each disk. This helps for two reasons, firstly it means that if ZFS does detect an error on read there is a second copy of the data to repair the error. Secondly as we are mostly reading the backups when we are rsyncing to the ZFS pool we can read from both disks at once so the pool is twice as fast, thus backups happen quicker.
  * **Snapshots** &#8211; We want to be able to &#8220;step back in time&#8221; to load a machine image from last week/month/year but also not to store the same data over and over again. ZFS snapshots is how we do it, as we are using both LVM and ZFS snapshots I&#8217;m covering this is more detail next.

# LVM vs ZFS snapshots

The disk images for the virtual machines are stored on an LVM managed RAID5 array. The only user data on the machine is inside disk images, so we need an efficient way to backup and archive large (100GB) disk images. We can do this by leveraging the power of snapshots, both LVM and ZFS snapshots.

LVM and ZFS snapshots are very different, LVM is a block management layer and so snapshots in LVM are block based where as ZFS is a Copy on Write (CoW) filesystem and so ZFS snapshots are tree snapshots. The differences are show in this slide from a [Sun presentation on ZFS](https://blog.night-shade.org.uk/wp-content/uploads/2013/03/zfslast.pdf). The key difference is that with ZFS snapshots are a map to where the changed blocks are stored where as LVM snapshots are a copy of what has been overwritten.

<a href="https://blog.night-shade.org.uk/wp-content/uploads/2013/03/ZFS-snapshots.png" rel="lightbox[252]" title="ZFS snapshots"><img class="aligncenter size-full wp-image-253" alt="ZFS snapshots" src="https://blog.night-shade.org.uk/wp-content/uploads/2013/03/ZFS-snapshots.png" width="1027" height="728" srcset="https://blog.night-shade.org.uk/wp-content/uploads/2013/03/ZFS-snapshots.png 1027w, https://blog.night-shade.org.uk/wp-content/uploads/2013/03/ZFS-snapshots-300x212.png 300w, https://blog.night-shade.org.uk/wp-content/uploads/2013/03/ZFS-snapshots-1024x725.png 1024w, https://blog.night-shade.org.uk/wp-content/uploads/2013/03/ZFS-snapshots-423x300.png 423w" sizes="(max-width: 1027px) 100vw, 1027px" /></a>You don&#8217;t need to understand the exact reason why things are different, just that they are and we going to make use of them, now on to the meat of the backup process.

# Implementation

First of all we need to set some variables, different people like the date in different formats here we are using %s or number of seconds since the [UNIX epoch](http://en.wikipedia.org/wiki/Unix_time) in 1970.

<pre># These are the VMs that are sync'd before backup
vm_targets="Server-Tim MySQL"
# Get the date in UNIX time
date=$(date +%s)
# These are the LVM volume groups we are backing up
storage_targets="/dev/SSD/images /dev/raid5/VM.images"
# Where are we backing up to, needs to be ZFS
backup_target="archives/backups"
# Where we mount the LVM snapshots
mountpoint=/run/backup</pre>

As we are backing up virtual machines (VMs) it really helps if we can tell the machine we are backing up that it&#8217;s about to have a backup taken. There are a number of approaches to this such as logging in with an ssh key or using an agent, but because QEMU doesn&#8217;t have much support for agents yet and ssh logins are just another thing to setup I&#8217;ve settled on a different way. I have made use of the fact that virsh can send a raw key press to the VM just like someone sitting at the keyboard has pressed a key, by sending alt+sysrq+s we can trigger Linux&#8217;s emergency sync mechanisms which flush all waiting disk buffers from memory to disk, perfect for a backup.

One second after requesting the disk flush we tell QEMU to suspend the machine so that nothing changes while we sync the other machines and trigger an LVM snapshot. This happens very quickly and the machine is normally suspended for less than 5 seconds.

<pre>for VM in $vm_targets ; do
  virsh send-key $VM KEY_LEFTALT KEY_SYSRQ KEY_S
  sleep 1 ; sync
  virsh suspend $VM
done</pre>

Now that we have suspended all the machines we care about and made sure all of the disk images are consistent we need to make sure that we can get a consistent backup of the disk images so we take an LVM snapshot. Later on we mount this snapshot and take an rsync backup of the disk images.

<pre>for storage in $storage_targets ; do
  shortname=$(basename $storage)
  /sbin/lvm lvcreate --quiet -L 10G --chunksize 512k -s -n ${shortname}.${date} $storage
done</pre>

We have now got a snapshot on the LVM storage so we can release the machines to carry on working while we run the backups.

<pre>for VM in $vm_targets ; do
  virsh resume $VM
done</pre>

We also need to take a ZFS snapshot so we can roll back to this backup in the future.

<pre>/sbin/zfs snapshot $backup_target@daily.$date</pre>

We now have 2 snapshots frozen in time, the LVM and ZFS one, we are planning to keep the ZFS one but we need to discard the LVM one as soon as we can because it&#8217;s lowering the performance of the disks. Now we need to actually make a copy of the files from the LVM snapshot to the ZFS storage.

This loop of the backup script is kind of complex, what it&#8217;s doing is making a temporary mount point, checking the LVM snapshots and mounting them and using the command rsync to copy any changes from the snapshot to the ZFS backup target. The flags &#8211;no-whole-file and &#8211;inplace are worth mentioning, they force rsync to only copy over changed blocks from the LVM storage to the ZFS storage. This makes the ZFS snapshot very space efficient as well as improving the speed of the backups. Finally the loop un-mounts the LVM snapshots and removes them.

<pre>for storage in $storage_targets ; do
  shortname=$(basename $storage)
  mountname=$(echo $storage | sed -e s,^/dev/,,g -e s,/,.,g )
  mkdir -p $mountpoint/$date/$mountname
  /sbin/fsck -p ${storage}.${date}
  if ! mount -o ro ${storage}.${date} $mountpoint/$date/$mountname ; then
    echo failed to mount ${storage}.${date}
  else
    /usr/bin/rsync -axH --no-whole-file --inplace --delete $mountpoint/$date/$mountname/ /$backup_target/$mountname/
  fi
  sleep 10 ; sync
  umount ${storage}.${date}
  sleep 10 ; sync
  /sbin/lvm lvremove --quiet --force ${storage}.${date}
  rmdir $mountpoint/$date/$mountname
done</pre>

Just in case grab a copy of the root filesystem as it contains the configuration of the server and VMs.

<pre>/usr/bin/rsync -axH --no-whole-file --inplace --delete / /$backup_target/root/</pre>

# And finally&#8230;

Yes it would be easier if the main VM data store was run on ZFS but it&#8217;s not, however I think that I&#8217;ve designed this backup solution to get the best from both LVM and ZFS snapshots.