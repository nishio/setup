# put recently modified entry last
SETUP = $(shell pwd)

others: apt-update sshd pubkey-login git-config emacs fix-locale apt-upgrade

in-docker: apt-update git-config emacs fix-locale apt-upgrade-noninteractive

sshd:
	sudo apt-get install -y openssh-server

git:
	sudo apt-get install -y git-core

git-config:
	-rm $(HOME)/.gitconfig
	-rm $(HOME)/.gitignore_global
	cd $(HOME); \
		ln -s $(SETUP)/dot.gitconfig .gitconfig; \
		ln -s $(SETUP)/dot.gitignore_global .gitignore_global


screen:
	sudo apt-get install -y screen
	cd; ln -s $(SETUP)/dot.screenrc .screenrc

apt-update:
	sudo apt-get update -y

apt-upgrade:
	sudo apt-get upgrade -y

# Usual upgrade may block.
# see: http://askubuntu.com/questions/146921/how-do-i-apt-get-y-dist-upgrade-without-a-grub-config-prompt
apt-upgrade-noninteractive:
	sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

# fix: "perl: warning: Setting locale failed."
fix-locale:
	sudo locale-gen "ja_JP.UTF-8"
	sudo dpkg-reconfigure locales

## Emacs

emacs:
	sudo apt-get install -y emacs24-nox

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

pip:
	sudo apt-get install -y python-pip


boost:
	sudo apt-get install libbz2-dev
	-rm download
	wget http://sourceforge.net/projects/boost/files/boost/1.55.0/boost_1_55_0.tar.bz2/download
	tar --bzip2 -xf download
	mv boost_1_55_0/ ~
	cd ~/boost_1_55_0/; \
	./bootstrap.sh && sudo ./b2 install


mecab:
	sudo apt-get install -y mecab mecab-naist-jdic python-mecab


zsh:
	sudo apt-get install -y zsh

zsh-config:
	git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
	cd ~/.oh-my-zsh/custom; ln -s $(SETUP)/ascii.zsh-theme
	cd $(HOME); ln -s $(SETUP)/dot.zshrc .zshrc

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
	echo "\n\n\n\n\n\n\n\n\n\n/usr/src/linux-headers-`uname -r`/include/\n\n\n\n\n\n\n\n\n\n" | sudo ./vmware-install.pl
	-rm -rf cd vmware-tools-distrib

vmware_fix:
	# need some fix http://communities.vmware.com/thread/297787?start=0&tstart=0
	cd /usr/src/linux-headers-`uname -r`/include/linux; \
	sudo chmod 666 version.h; cat ../generated/utsrelease.h >> version.h; sudo ln -s ../generated/autoconf.h

edit_hotst:
	sudo e /private/etc/hosts

java:
	# add-apt-repositoryがないので入れる
	sudo apt-get install python-software-properties
	# oracleのJDKがデフォルトのリポジトリには含まれていないので追加する
	sudo add-apt-repository ppa:webupd8team/java
	sudo apt-get update
	sudo apt-get install -y oracle-java7-installer

# Ubuntuではデフォルトで/usr/local/libを読まないのでMeCabやKyTeaのsoが読まれない
ldconfig:
	sudo echo /usr/local/lib >> /etc/ld.so.conf
	sudo ldconfig

samba:
	sudo apt-get install -y smbclient cifs-utils


ml:
	sudo apt-get install -y gcc g++ gfortran build-essential
	sudo apt-get install -y linux-image-generic libopenblas-dev
	sudo apt-get install -y libatlas-dev libatlas3gf-base liblapack3gf
	sudo apt-get install -y python-dev python-setuptools python-pip
	sudo apt-get install -y python-nose python-numpy python-scipy
	sudo apt-get install -y python-matplotlib
	sudo apt-get install -y ipython python-pandas python-sklearn

nfs-server:
	sudo apt-get install nfs-kernel-server

nfs-client:
	sudo apt-get install nfs-common
	sudo groupadd nfs
	sudo groupmod -g 1001 nfs
	id ec2-user
	# usermod -G wheel,nfs ec2-user
	# ※既に別のサブグループに所属している場合は、所属済みのグループの最後に指定する。
	sudo mkdir -p -m 775 /mnt/nfs
	sudo chown root:nfs /mnt/nfs

nfs-showmount:
	showmount -e <NFS server name>

nfs-autorun:
	sudo chkconfig --level 345 nfs on
	sudo chkconfig --list | grep nfs

cuda8:
	# http://qiita.com/yukoba/items/3692f1cb677b2383c983
	sudo apt update
	sudo apt upgrade

	wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
	cat 7fa2af80.pub | sudo apt-key add -

	wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
	sudo dpkg -i cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
	sudo apt update

	sudo apt install -y linux-generic
	sudo apt install -y cuda nvidia-367
	sudo reboot

	sudo apt remove linux-virtual
	sudo apt autoremove

	rm 7fa2af80.pub cuda-repo-ubuntu1604_8.0.44-1_amd64.deb


