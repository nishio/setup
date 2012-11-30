SETUP = $(shell pwd)

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

emacs:
	sudo apt-get install -y emacs23-nox
	cd $(HOME); \
		ln -s $(SETUP)/dot.emacs.el .emacs.el; \
		ln -s $(SETUP)/dot.emacs.d .emacs.d

pip:
	easy_install pip


zsh:
	sudo apt-get install -y zsh
	git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
	cd ~/.oh-my-zsh/custom; ln -s $(SETUP)/ascii.zsh-theme
	cd $(HOME); ln -s $(SETUP)/dot.zshrc .zshrc

send_privkey:
	python run.py "scp ~/.ssh/id_rsa <target_address>:id_rsa"

# pubkey login
# この設定をしていないとtramp-modeで編集して保存した際に毎回パスワードを聞かれてしまう
# 社内githubからのcloneも失敗する
pubkey-login:
	mkdir -p ~/.ssh
	cat ~/id_rsa.pub >> ~/.ssh/authorized_keys
	chmod 600 ~/.ssh/authorized_keys


ack:
	sudo apt-get install ack-grep
	sudo cp /usr/bin/ack-grep /usr/bin/ack
