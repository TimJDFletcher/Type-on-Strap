Ansible vault is the built in tool for encrypting entire YAML files, single variables (as of 2.3) and in ansible 2.4 arbitrary files. The downside to Ansible vault is that all vault files in a play need to be protected with the same password, this makes team working complex. Single passwords for a team normally mean poor password choices for efficiency reasons, especially as teams grow beyond 2 or 3 people.

Fortunately ansible vault does support the concept of a vault password script, which ansible calls and expects to spit out a single line containing the password to vault files. We use ansible both on local systems and from managed pipelines and ideally want this to be seamless. Using this concept we have built a fairly effective tool for managing vault passwords for within in teams, all via the standard playbook directory and git.

We have recently been issuing Yubikeys to all our developers, having trailed them our operations team. We are using our yubikeys in this case as OpenPGP cards to securely store GPG keys for both ssh and gpg. 

The design we are using for ansible vault is a script that looks for in order:

An environment variable (by default ANSIBLE_VAULT_PASSWORD) this is for running in a pipeline, these variables are protected by the CI/CD server and set in the environment before ansible is called.

A playbook wide GPG protected key file

A per user protected key file

Push to rancher secrets, add a test for /run/secrets/VAULT_PASSWORD

Submit to uri if needed 
Allows add / remove user without sharing password / private keys
Scales for teams with multi user wrapping
Random string -> gpg -> encrypted file
Detect keys, add / remove encryption key
No plain secrets in source control
Source control for all changes
Signing your github commits 
Makes vault access transparent to team users

CI/CD Servers could have a key to target too, maybe hardware backed 

Works with OpenSSL/gpg/piv tooling 

Can PIV tooling work with multi user?

https://disjoint.ca/til/2016/12/14/encrypting-the-ansible-vault-passphrase-using-gpg/

https://gist.github.com/Roman2K/3238fb441e298369198e

https://github.com/ansible/ansible/issues/18247
