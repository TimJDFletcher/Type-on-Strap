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

Next you will need to set up the gpg-agent config file, add the following lines to the file `$HOME/.gnupg/gpg-agent.conf`

```
enable-ssh-support
use-standard-socket
write-env-file
```

The final change you need to make is in $HOME/.bash_profile to add these lines:

```
unset SSH_AUTH_SOCK
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
```
