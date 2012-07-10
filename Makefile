all: minimum git-config python

# install all
minimum:
	sudo apt-get install -y emacs23-nox screen

git-config:
	git config --global user.name "NISHIO Hirokazu"
	git config --global user.email nishio.hirokazu@gmail.com

python:
	easy_install pip

sshd:
	sudo apt-get install -y openssh-server

git:
	sudo apt-get install -y git-core