---
id: 291
title: Building a pure Debian armhf rootfs
date: 2013-12-16T23:01:31+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=291
permalink: /2013/12/building-a-pure-debian-armhf-rootfs/
categories:
  - Cubietruck
  - Hardware
  - Linux
---
There are lots of filesystems images for various Debian flavours on ARM developer boards like the Cubietruck floating about. Most of these images are large binary files of unknown providence and even compressed take a while to download. There is a better way of making a root image for your new ARM board, just build it on your own normal workstation directly from the Debian repos with debootstrap using the magic of QEMU.

First install the support packages on your workstation:

<pre>sudo apt-get install qemu-user-static debootstrap binfmt-support</pre>

You will need about 500MB of space in a directory for the image, choose the version of Debian in this case we are building a wheezy image.

<pre>targetdir=rootfs
distro=wheezy</pre>

Lets get going building the first stage of the rootfs image from the Debian mirrors, this will take a few minutes and downloads about 200MB.

<pre>mkdir $targetdir
sudo debootstrap --arch=armhf --foreign $distro $targetdir</pre>

Next copy the the qemu-arm-static binary into the right place for the binfmt packages to find it and copy in resolv.conf from the host.

<pre>sudo cp /usr/bin/qemu-arm-static $targetdir/usr/bin/
sudo cp /etc/resolv.conf $targetdir/etc</pre>

We now have a very basic armhf rootfs in a directory, the next stages take place inside a chroot of that directory.

<pre>sudo chroot $targetdir</pre>

Inside the chroot we need to set up the environment again

<pre>distro=wheezy
export LANG=C</pre>

Now we need to complete the second stage of debootstrap to install the packages downloaded earlier

<pre>/debootstrap/debootstrap --second-stage</pre>

Once the package installation has finished, setup some basic support files

<pre>cat &lt;&lt;EOT &gt; /etc/apt/sources.list
deb http://ftp.uk.debian.org/debian $distro main contrib non-free
deb-src http://ftp.uk.debian.org/debian $distro main contrib non-free
deb http://ftp.uk.debian.org/debian $distro-updates main contrib non-free
deb-src http://ftp.uk.debian.org/debian $distro-updates main contrib non-free
deb http://security.debian.org/debian-security $distro/updates main contrib non-free
deb-src http://security.debian.org/debian-security $distro/updates main contrib non-free
EOT

cat &lt;&lt;EOT &gt; /etc/apt/apt.conf.d/71-no-recommends
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOT</pre>

Pull in the latest apt database from the Debian mirrors

<pre>apt-get update</pre>

Install the locales package otherwise dpkg scripts, note in jessie you may need to install the dialog package as well.

<pre>apt-get install locales dialog
dpkg-reconfigure locales</pre>

Install some additional packages inside the chroot, an ssh server for network access and ntp because many boards don&#8217;t have a functional RTC.

<pre>apt-get install openssh-server ntpdate</pre>

Set a root password so you can login via ssh or the console

<pre>passwd</pre>

Build a basic network interfaces file so that the board will DHCP on eth0

<pre>echo &lt;&lt;EOT &gt;&gt; /etc/network/interfaces
allow-hotplug eth0
iface eth0 inet dhcp
EOT</pre>

Set the hostname

<pre>echo debian-armhf &gt; /etc/hostname</pre>

Enable the serial console, Debian sysvinit way

<pre>echo T0:2345:respawn:/sbin/getty -L ttyS0 115200 vt100 &gt;&gt; /etc/inittab</pre>

We are done inside the chroot, so quit the chroot shell

<pre>exit</pre>

Tidy up the support files

<pre>sudo rm $targetdir/etc/resolv.conf
sudo rm $targetdir/usr/bin/qemu-arm-static</pre>

You now have a root file system for pretty much any armhf machine but next you need to make a bootable sd card image. I&#8217;ll cover that in the [next post](https://blog.night-shade.org.uk/2013/12/create-a-bootable-sd-for-a-cubietruck/), there are [other](http://docs.cubieboard.org/tutorials/cb3/start) [howtos](http://docs.cubieboard.org/tutorials/ct1/installation/install_lubuntu_desktop_server_to_sd_card) to assemble the bootable card.