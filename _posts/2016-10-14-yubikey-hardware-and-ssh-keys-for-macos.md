---
id: 739
title: Yubikey hardware and SSH keys for macOS
date: 2016-10-14T11:49:29+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=739
permalink: /2016/10/yubikey-hardware-and-ssh-keys-for-macos/
categories:
  - Travel
---
Setting up Yubikey hardware backed SSH keys for Linux was a total pain, but setting it up on macOS was actually very simple. Note this is for command line, I&#8217;ve not looked at setting this up for GUI applications.

I am assuming that you already have a working GPG key on your Yubiky and want to set it up for SSH login.

First you will need to install [GPGTools](https://gpgtools.org/)

Next you will need to set up the gpg-agent config file, add the following lines to the file $HOME/<span class="s1">.gnupg/gpg-agent.conf</span>

<pre class="p1"><span class="s1">enable-ssh-support</span>
<span class="s1">use-standard-socket
</span><span class="s1">write-env-file</span></pre>

<p class="p1">
  The final change you need to make is in $HOME/.bash_profile to add these lines:
</p>

<pre class="p1"><span class="s1">unset SSH_AUTH_SOCK</span>
<span class="s1">export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh</span></pre>