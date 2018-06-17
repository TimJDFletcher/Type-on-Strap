---
title: Teams, MFA and AWS root accounts
date: 2018-06-17
author: Tim Fletcher
layout: post
permalink: /2018/05/google-authenticator-paper-backup/
feature-img: "XXXX"
thumbnail: "https://en.wikipedia.org/wiki/Google_Authenticator#/media/File:Google_Authenticator_for_Android_icon.png"
tags:
  - Tech
  - Security
---
Enabling two factor authentication is one of the best ways to keep your AWS and other accounts secure. There are a lots of ways to do this and one of the popular tools for this is Google Authenticator, which shows a 6 number rolling code that changes over time. [Behind the scenes](https://en.wikipedia.org/wiki/Google_Authenticator) this code is generated from a shared secret between your phone and the service you are logging into, hashed with the current time.

The root account of an AWS account isn't like a normal account. It is rarely used after inital setup, needs to be kept secure but accessible in a crisis for a team of people. This makes MFA configuration more complex especially as team members come and go.

An MFA workflow a former team used successfully is:

* Generate and print the MFA QR code
* Scan and activate the QR code using a cheap android mobile phone
* Securely store the mobile phone, maybe turned off to save power
* Security store the MFA QR code printed out in an envelope separately from the android phone

You could also use a shared Yubikey to store the MFA code rather than a mobile phone by using [Yubico Authenticator
](https://www.yubico.com/products/services-software/download/yubico-authenticator/).

This solves in a fairly secure way the following:

* Continuing access to an AWS root account when personal change
* Quick access to the root account if needed
* Retain access to MFA when technology fails
* Separation of password and MFA tokens
