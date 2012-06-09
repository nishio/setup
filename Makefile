all: all-apt-get git-config

# install all
all-apt-get:
	sudo apt-get install -y emacs23 screen

git-config:
	git config --global user.name "NISHIO Hirokazu"
	git config --global user.email nishio.hirokazu@gmail.com
