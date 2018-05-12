---
id: 443
title: Enabling ssh support in gpg-agent on Ubuntu
date: 2015-04-06T17:10:06+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=443
permalink: /2015/04/ssh-support-in-gpg-agent-on-ubunt/
categories:
  - Linux
  - Security
  - Ubuntu
---
I recently replaced my old Yubikey with one of the new Yubikey NEO&#8217;s, I wanted a simple and secure way of storing my GPG key as well 2 factor authentication.

This post is about setting up and fixing Ubuntu 14.04 and 14.10 to enable ssh-agent functionality in gpg-agent. I assume that you have already securely generated and stored a gpg key in the Yubikey and have imported the key stubs into gpg.

This post is rather complex because Seahorse the gnome-keyring manager &#8220;supports&#8221; ssh and gpg agent type functionality and takes over ssh-agent and gpg-agent. The problem with Seahorse is that it doesn&#8217;t work with OpenPGP cards and a secondary problem is that you need to disable a number of other ssh key services.

First you will need to install the following packages, gnupg-agent and pcscd the smart card management service.

<pre>sudo apt-get install gnupg-agent pcscd</pre>

<p id="yui_3_10_3_1_1428335783492_465">
  You need to disable gnome-keyring&#8217;s ssh and gpg agent functionality, bug id <a href="https://bugs.launchpad.net/ubuntu/+source/gnome-keyring/+bug/1387303">1387303</a> contains a fix allow this which has now been released as gnome-keyring &#8211; 3.10.1-1ubuntu7.1. Once this is installed you can disable the ssh and gpg agents in Unity&#8217;s startup applications found under the settings menu.
</p>

You will need to enable both gpg-agent support in gpg and then ssh-agent support in gpg-agent. In the $HOME/.gnupg directory add the line _use-agent_ to gpg.conf  and _enable-ssh-support_ gpg-agent.conf you may need to create the files.

Next you need to install a [fixed version](http://www.programmierecke.net/howto/gpg-agent.conf) of the gnupg-agent upstart init script so that it starts gpg-agent correctly with ssh key support. Install this script into the .init directory in your home directory this overrides the system wide one.

<pre>mkdir $HOME/.init
wget -O $HOME/.init/gnupg-agent.conf http://www.programmierecke.net/howto/gpg-agent.conf</pre>

Finally you need to disable the &#8220;real&#8221; ssh-agent by commenting out the line in /etc/X11/Xsession.options, there aren&#8217;t any override options that I know of.

After restarting X or a reboot you should find that ssh-agent -L prints out a long ssh key string, you are looking for the one that ends in card:XXXXX this is the public half of your Yubikey gpg key in ssh key format.

With gnupg-agent providing ssh-agent services, you can use ssh-add to import existing SSH private keys into gpg&#8217;s key secure storage.

Hints and methods taken from: <http://www.programmierecke.net/howto/gpg-ssh.html>