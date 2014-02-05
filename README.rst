=======
 setup
=======

Setup my favorite environment.

状況は変わるものだから全自動は求めても仕方がない。
何をする必要があるのかを自然言語ではなく実行可能な形式で書くことに意味がある。

Ubuntu
======

::

   # on new machine's terminal
   sudo apt-get install -y openssh-server git-core make && ifconfig

::
   # name easy rememberable name to the host
   make edit_hosts

   # on favorite machine's terminal
   make send_privkey
   (it asks target address and password)
   ssh .....
   git clone https://github.com/nishio/setup.git
   cd setup
   make recv_privkey
   cd ..
   rm -rf setup
   git clone git@github.com:nishio/setup.git
   cd setup
   make screen
   screen
   make others  # it will do make apt-update pubkey-login git-config emacs zsd

Linux on VirtualBox
===================

To connect via ssh:

- 1: Create new 'host-only network' from configuration of ViatualBox itself.
- 2: Add new network adapter to the VM form VM's configuration.

Some blog entry said we need to edit /etc/network/interfaces, however we doesn't.


TODO
====

- fix yasnipet
