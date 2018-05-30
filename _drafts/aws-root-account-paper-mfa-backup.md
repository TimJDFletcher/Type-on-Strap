---
title: Backup Google authenticator codes on paper
date: YYYYY
author: Tim Fletcher
layout: post
permalink: /2018/05/google-authenticator-paper-backup/
feature-img: "XXXX"
thumbnail: "https://en.wikipedia.org/wiki/Google_Authenticator#/media/File:Google_Authenticator_for_Android_icon.png"
tags:
  - Tech
  - Security
---
Enabling two factor authentication is one of the best ways to keep your accounts secure. There are a lots of ways to do this one of the popular ones is Google Authenticator, which shows a 6 number rolling code that changes over time. [Behind the scenes](https://en.wikipedia.org/wiki/Google_Authenticator)  this code is generated from a shared secret between your phone and the service you are logging into, hashed with the current time.

Modern mobiles phones are pretty secure devices, but the problem with using a mobile phone is that you can lose them, upgrade them or change the software on them and lose your copy of the shared key. 

The challenage when working in a team is keeping track of the MFA device and making sure it's available when you need it.

The design my previous team came up with is following:

- Cheap andriod mobile phone, this is basically acting as a TOTP authtication token.
- Print out of the QR code shown on the 

Shared mobile phone or Yubikey
Print out MFA QR code and store in safe
