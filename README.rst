=======
 setup
=======

Setup my favorite environment.

状況は変わるものだから全自動は求めても仕方がない。
何をする必要があるのかを自然言語ではなく実行可能な形式で書くことに意味がある。

Ubuntu on vCenter.in.labs
=========================

::
   # on new machine's terminal
   sudo apt-get install -y openssh-server git-core && ifconfig

::
   # on favorite machine's terminal
   ssh .....
   git clone git@github.com:nishio/setup.git
   cd setup
   make screen
   screen
   make apt-update

::
   # on favorite machine's another terminal
   make send_privkey

::
   # on ssh
   make recv_privkey
   make pubkey-login
   make git-config # TODO fix Mac/Linux divert
   make emacs # TODO fix emacs.el
   make zsh

Linux on VirtualBox
===================

To connect via ssh:

- 1: Create new 'host-only network' from configuration of ViatualBox itself.
- 2: Add new network adapter to the VM form VM's configuration.

Some blog entry said we need to edit /etc/network/interfaces, however we doesn't.


TODO
====

- fix yasnipet
