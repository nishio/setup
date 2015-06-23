# wget http://bit.ly/nishiosetup; bash nishiosetup することで最初に諸々必要なものをインストールする
set -x
sudo apt-get install -y git-core make
cd
git clone https://github.com/nishio/setup.git
cd setup
make

