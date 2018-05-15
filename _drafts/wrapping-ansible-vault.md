---
title: Integrating Ansible vault with Lastpass or Yubikeys
date: Tue 15 May 22:05:53 2018
author: Tim Fletcher
layout: post
permalink: /2018/05/integrating-ansible-vault-with-lastpass
feature-img: "wp-content/uploads/2016/02/thumb_IMG_9188_1024.jpg"
thumbnail: "assets/img/thumbnails/ansible.png"
tags:
  - Tech
  - Security
  - Ansible
---

Ansible vault used by Ansible to encrypt entire YAML files, single variables (as of 2.3) and in ansible 2.4 arbitrary files. The downside to Ansible vault is that all vault files in a play need to be protected with the same password, this makes team working complex. Single passwords for a team normally mean poor password choices for efficiency reasons, especially as teams grow beyond 2 or 3 people.

Fortunately ansible vault does support the concept of a vault password script, which ansible calls and expects to spit out a single line containing the password to vault files. We use ansible both on local systems and from managed pipelines and ideally want this to be seamless. Using this concept we have built a fairly effective tool for managing vault passwords for within in teams, all via the standard playbook directory and git.

This blog post is about how you can intergrate GPG or Lastpass as secure password storage for a team working with ansible. The design we are using for ansible vault is a script that looks for in order:

## Password storage with Yubikeys and GPG

Somewhere I recently worked issued Yubikeys to all developers, having trailed them in the operations team. They are using yubikeys as OpenPGP cards to securely store GPG keys for both ssh and gpg. 

## Password storage in Lastpass

Shared between the team
Find by repo name
simple template

## Working in CI/CD Pipelines

An environment variable (by default ANSIBLE_VAULT_PASSWORD) this is for running in a pipeline, these variables are protected by the CI/CD server and set in the environment before ansible is called.

## Advantages

Allows add / remove user without sharing password / private keys
Scales for teams with multi user wrapping
Random string -> gpg -> encrypted file
Detect keys, add / remove encryption key
No plain secrets in source control
Source control for all changes
Signing your github commits 
Makes vault access transparent to team users

## Future Steps

A playbook wide GPG protected key file

A per user protected key file

Push to rancher secrets, add a test for /run/secrets/VAULT_PASSWORD

CI/CD Servers could have a key to target too, maybe hardware backed 

## Further Reading

* https://disjoint.ca/til/2016/12/14/encrypting-the-ansible-vault-passphrase-using-gpg/
* https://gist.github.com/Roman2K/3238fb441e298369198e
* https://github.com/ansible/ansible/issues/18247
