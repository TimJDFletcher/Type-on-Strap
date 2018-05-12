---
id: 201
title: GlusterFS and cloned systems
date: 2013-01-29T15:09:03+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=201
permalink: /2013/01/glusterfs-and-cloned-systems/
categories:
  - Linux
  - Red Hat
---
I&#8217;ve been playing with RedHat storage server which runs GlusterFS under the hood and cloned the nodes from a single master but got an error about &#8220;overlapping export directories from the same peer&#8221; when creating a new volume on GlusterFS.

Turns out if you have cloned the nodes then you need to make sure you have updated the UUID in /etc/glusterd/glusterd.info to actually be unique again.

Quick cheat is to do:

<pre>service glusterd stop
echo "UUID=$(uuidgen)" &gt; /etc/glusterd/glusterd.info
service glusterd start</pre>