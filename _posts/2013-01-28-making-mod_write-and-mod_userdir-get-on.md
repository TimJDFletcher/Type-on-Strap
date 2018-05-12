---
id: 196
title: Making mod_write and mod_userdir work together
date: 2013-01-28T16:34:39+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=196
permalink: /2013/01/making-mod_write-and-mod_userdir-get-on/
categories:
  - Linux
---
After fighting with Apache for a while I&#8217;ve finally managed to get a redirect from a users public_html to a new domain.

The main problem is how mod\_rewrite and mod\_userdir interact, but the magic syntax to put in the .htaccess inside the user&#8217;s public_html is this:

<pre>RewriteEngine On
RewriteBase /~user
RewriteRule ^(.*)$ http://newdomain.example.com/$1</pre>