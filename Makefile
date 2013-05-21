SETUP = $(shell pwd)

others: apt-update pubkey-login git-config emacs zsh


sshd:
	sudo apt-get install -y openssh-server

git:
	sudo apt-get install -y git-core

git-config:
	cd $(HOME); \
		ln -s $(SETUP)/dot.gitconfig .gitconfig; \
		ln -s $(SETUP)/dot.gitignore_global .gitignore_global


screen:
	sudo apt-get install -y screen


apt-update:
	sudo apt-get update

## Emacs

emacs:
	sudo apt-get install -y emacs23-nox
	make yasnippet emacs-settings

e_for_mac:
	mkdir -p ~/bin
	cd ~/bin; ln -s `which emacsclient` e

e_for_linux:
	mkdir -p ~/bin
	cd ~/bin; ln -s `which emacs` e

yasnippet:
	mkdir -p dot.emacs.d/plugins
	cd dot.emacs.d/plugins; git clone https://github.com/capitaomorte/yasnippet

emacs-settings:
	cd $(HOME); \
		ln -s $(SETUP)/dot.emacs.d .emacs.d

##


pip:
	easy_install pip


zsh:
	sudo apt-get install -y zsh
	git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
	cd ~/.oh-my-zsh/custom; ln -s $(SETUP)/ascii.zsh-theme
	cd $(HOME); ln -s $(SETUP)/dot.zshrc .zshrc

scipy:
	sudo apt-get install python-numpy python-scipy -y

send_privkey:
	python run.py "scp ~/.ssh/id_rsa <target_address>:id_rsa"

# 秘密鍵を置く
# これをしないと社内githubからのcloneが失敗する
recv_privkey:
	mkdir -p ~/.ssh
	mv ~/id_rsa ~/.ssh
	chmod 600 ~/.ssh/id_rsa

# リポジトリに入れてあるpubkeyを適切に配置
# この設定をしていないとこのマシンにtramp-modeで接続した場合に
# 保存するたびに毎回パスワードを聞かれてしまう
pubkey-login:
	mkdir -p ~/.ssh
	cat id_rsa.pub >> ~/.ssh/authorized_keys
	chmod 600 ~/.ssh/authorized_keys


ack:
	sudo apt-get install ack-grep
	sudo cp /usr/bin/ack-grep /usr/bin/ack

vmwaretools:
	-rm VMwareTools*.gz
	# kernel headerなどを入れる。さもないと以下のエラーになる場合がある
	# The path "/usr/src/linux-headers-3.2.0-23/include" is a kernel header file
	# directory, but it does not contain the file "linux/version.h" as expected.
	-sudo apt-get install -y build-essential
	-sudo mkdir /usr/lib64
	cp "/media/VMware Tools/VMwareTools-4.0.0-208167.tar.gz" .
	tar -xvf VMwareTools-4.0.0-208167.tar.gz
	[ `uname -r` != 3.2.0-23-generic ] || make vmware_fix
	cd vmware-tools-distrib; \
	echo "\n\n\n\n\n\n\n\n\n\n/usr/src/linux-headers-`uname -r`/include/" | sudo ./vmware-install.pl

vmware_fix:
	# need some fix http://communities.vmware.com/thread/297787?start=0&tstart=0
	cd /usr/src/linux-headers-`uname -r`/include/linux; \
	sudo chmod 666 version.h; sudo cat ../generated/utsrelease.h >> version.h; sudo ln -s ../generated/autoconf.h
