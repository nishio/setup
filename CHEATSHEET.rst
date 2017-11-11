============
 cheatsheet
============

It is my cheat sheet for unix commands etc.
It is valuable to share what I and you want to remember.

less
====

- </>: page top/bottom
- b: back a page
- n/N: jump to next/previous match
- ?<key>: search backword
- n/N: jump to next/previous match

emacs
=====

- C-r: search backword
- C-x r k: kill rectangle region
- C-x r y: yank-rectangle
- C-x RET f: set-buffer-file-coding-system
- hexl-mode: C-M-x to input hex
- M-x delete-trailing-space


tramp-mode
----------

- /remotehost:filename
- /user@host#port:/home/foo
- /method:user@remotehost:filename
- /multi:ssh:nishio@remote:sudo:root@localhost:/etc/apache2/someconf

bookmark
--------

- C-x r m: add
- C-x r b: open
- C-x r l: list


hosts
=====

- Mac: sudo e /private/etc/hosts
- sudo kill -HUP `cat /var/run/lookupd.pid`

screen
======

- C-b/C-d: half-up/down


zsh
====

- replace extention of files
  for i in *.PNG;
  mv $i ${i%.*}.png


misc
====

- confirm Ubuntu version: cat /etc/lsb-release
- disk usage: df -hT, du -h | sort -h
- show cmdline: less /proc/<pid>/cmdline
- which port are listened?: netstat -tln
- Ubuntu Desktop, show virtual console: C-M-F1~6
- VirtualBox mount shared folder: sudo mount -t vboxsf <name of shared folder:XXX> /media/sf_XXX
- sudo ntpdate ntp.nict.jp
- less: F <-> Ctrl-C
 
git
===

::
  42.42.42.42$ git init --bare <repos_name>.git

  local$ git remote add origin 42.42.42.42:/home/nishio/<repos_name>.git
  local$ git push -u origin master


boost python
============

- install: http://www.boost.org/doc/libs/1_55_0/libs/python/doc/building.html

plot
====

- plt.hist(xs)
- plt.scatter(xs, ys)
- plt.plot(xs, ys)


sklearn on EC2
==============

::

   sudo yum -y install gcc-c++ python27-devel atlas-sse3-devel lapack-devel
   wget https://pypi.python.org/packages/source/v/virtualenv/virtualenv-1.11.6.tar.gz
   tar xzf virtualenv-1.11.6.tar.gz
   python27 virtualenv-1.11.6/virtualenv.py sk-learn
   . sk-learn/bin/activate
   pip install numpy
   pip install scipy
   pip install scikit-learn



sudo fdisk /dev/sdf
n w
sudo mkfs -t ext4 /dev/sdf
df -h
