---
id: 487
title: Linux Capabilities and rsync, from presentation to practice
date: 2015-04-30T15:31:25+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=487
permalink: /2015/04/linux-capabilities-and-rsync-from-presentation-to-practice/
categories:
  - Backup
  - Linux
  - Security
---
[Hazel Smith](https://twitter.com/hazelesque) gave an excellent [talk](http://www.slideshare.net/Hazelesque/rsync-setcap) at [FLOSSUK&#8217;s](http://www.flossuk.org/) Unconference in London about Linux Capabilities and using them as part of &#8220;[least privilege](http://en.wikipedia.org/wiki/Principle_of_least_privilege)&#8221; when running backups of Linux systems.

Hazel explained that by using [Capabilities](http://linux.die.net/man/7/capabilities) you can allow a single user (in this example backuphelper) when running a single binary (rsync) to read any file on the system. Hazel stressed in the presentation that this isn&#8217;t a privilege to give out lightly, however the ability to read any file isn&#8217;t a direct path to root. This level of privilege will allow access to for example hashed passwords or contents of any user&#8217;s files.

My personal backups use [BackupPC](http://backuppc.sourceforge.net/) which can pull backups with tar, smbclient or as I use rsync over ssh.

The second half of this post documents how I put Hazel&#8217;s talk into practice on my Debian based systems. I have also uploaded to GitHub an example [Ansible](https://github.com/TimJDFletcher/personal-scripts/blob/master/Ansible/rsync-caps.yaml) task I used to roll out the changes to my systems.

## Target System Setup

First off install the support packages for capabilities.

<pre>sudo apt-get install libcap2-bin libpam-cap
sudo pam-auth-update</pre>

Run  pam-auth-update and enable &#8220;Inheritable Capabilities Management&#8221;, if you prefer to manually manage the pam config files then add the line &#8220;auth optional pam_cap.so&#8221; to /etc/pam.d/common-auth

You will also need to add following line to /etc/security/capability.conf to allow backuphelper to retain cap\_dac\_read_search. The rules applied in order so make sure it&#8217;s above the default deny line &#8220;none  *&#8221;

<pre>cap_dac_read_search backuphelper</pre>

This next command sets cap\_dac\_read_search as Inheritable and Effective for the rsync binary. The net effect is that when the backuphelper user runs rsync that process can read any file on the system.

<pre>sudo setcap cap_dac_read_search+ei /usr/bin/rsync</pre>

The &#8220;belt and braces&#8221; setup Hazel recommended both locking down ssh access for the backuphelper user to ssh-keys only and locking the password on the account. To follow this advice add the following lines to /etc/ssh/sshd_config.

<pre>Match User backuphelper
 PasswordAuthentication no</pre>

And run the following command to lock the backuphelper account&#8217;s password

<pre>sudo passwd -l backuphelper</pre>

## BackupPC Server Setup

The change needed here is very simple, you only need to change the user that pulls backups from your other systems. You will need to ensure that you have correctly setup the ssh keys etc for the backuphelper user.

This can be done either via the web UI or by editing the .pl config file directly. You need to change &#8220;-l root&#8221; to &#8220;-l backuphelper&#8221; for the RsyncClientCmd. An example from one of my systems is

<pre>$Conf{RsyncClientCmd} = '$sshPath -q -x -l backuphelper $host $rsyncPath $argList+';</pre>

## Debugging

Always be careful working with PAM, you can lock yourself out! It is worth having a root shell open &#8220;just in case&#8221; until you are familiar with the process.

A simple test is to login via ssh as backuphelper and run &#8220;rsync -avn /root&#8221; and you shouldn&#8217;t get any permission denied errors and should see a list of files.

Something to bear in mind when debugging this is that running sudo from root -> user doesn&#8217;t give the user capabilities, you need to login directly to test things.

If you want to see whether pam_cap is working when logged in you can do this:

<pre>grep CapInh /proc/$$/status</pre>

Use capsh –decode= on the resulting bit string to understand what permissions you’ve got.