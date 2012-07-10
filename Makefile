SETUP = $(shell pwd)

all: minimum git-config python

# install all
minimum:
	sudo apt-get install -y screen

git-config:
	git config --global user.name "NISHIO Hirokazu"
	git config --global user.email nishio.hirokazu@gmail.com

emacs:
	sudo apt-get install -y emacs23-nox
	cd $(HOME); \
		ln -s $(SETUP)/dot.emacs.el .emacs.el
		ln -s $(SETUP)/dot.emacs.d .emacs.d

python:
	easy_install pip

sshd:
	sudo apt-get install -y openssh-server

git:
	sudo apt-get install -y git-core

zsh:
	git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
	cd ~/.oh-my-zsh/custom; ln -s $(SETUP)/ascii.zsh-theme
	cd $(HOME); ln -s $(SETUP)/dot.zshrc .zshrc
