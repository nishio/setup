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

- Mac: /sudo::/private/etc/hosts
- sudo kill -HUP `cat /var/run/lookupd.pid`

screen
======

- C-b/C-d: half-up/down


misc
====

- confirm Ubuntu version: cat /etc/lsb-release
