---
id: 184
title: Tidying up old kernels on Debian and Ubuntu
date: 2013-01-20T22:15:51+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=184
permalink: /2013/01/tidying-up-old-kernels-on-debian-and-ubuntu/
categories:
  - Linux
---
I&#8217;ve never found a good way from the command line to clear out old kernels on Debian or Ubuntu systems, I know there are systems like computer janitor for GUIs but nothing as useful or simple as [package-cleanup](http://docs.fedoraproject.org/en-US/Fedora/14/html/Software_Management_Guide/ch07s03.html) for rpm based systems.

I&#8217;ve hacked up a bash script that works for me, and hopefully other people might find it useful. The script works by figuring out what the running kernel and the latest kernels are and then removing any kernels that don&#8217;t match that, and at the end of the script there is a forced dkms module rebuild to ensure that dkms modules are current for all installed kernels.

<pre>#!/bin/sh
sudo apt-get update

runningversion=$(dpkg -l 'linux-image*' | grep ^ii.*`uname -r` | awk '{print $3}')
latestversion=$(dpkg -l 'linux-image*'| awk '{print $3}' | grep -- - | sort -V | tail -n 1)
metapackage=generic

dpkg -l 'linux-image-*'| grep ^ii |\
egrep -v "$runningversion|$latestversion|linux-image-$metapackage" |\
awk '{print $2}' |\
xargs sudo apt-get -y purge

dpkg -l 'linux-headers-*'| grep ^ii |\
egrep -v "$runningversion|$latestversion|linux-headers-$metapackage" |\
awk '{print $2}' |\
xargs sudo apt-get -y purge

sudo apt-get autoremove
sudo apt-get autoclean

# Force a rebuild of all dkms modules
if [ -f /usr/sbin/dkms ] ; then
dkms status | sed s/,//g | awk '{print "-m",$1,"-v",$2}' | uniq |\
while read line; do
ls /var/lib/initramfs-tools | xargs -n 1 sudo dkms install $line -k
done
fi</pre>

The script can also downloaded from here: <http://www.night-shade.org.uk/~tim/Ubuntu/ubuntu-kernel-tidy.sh.gz>