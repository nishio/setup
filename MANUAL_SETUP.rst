==============
 MANUAL SETUP
==============

Not automated setup instructions


 Cygwin
========


Allow Ctrl+Left/Right

Add to ~/.inputrc

  "\e[1;5C": forward-word   # ctrl + right
  "\e[1;5D": backward-word  # ctrl + left


VirtualBox
==========

Install "Guest Additions"

- デスクトップにログイン
- ホスト側のメニューの「デバイス」「Guest AdditionsのCDイメージを挿入」を選択
- autorun.shが走る(こいつがDISPLAYを要求するのでXなしだとうまくいかない)

共有フォルダなどに必要。vboxsfがUnknown filesystemだ、などと言われた場合はこれを忘れている。

共有フォルダはvboxsfグループの権限になっているので自分が読み書きするためには自分をグループに追加する必要がある。

  sudo adduser nishio vboxsf


Hyper-V
=======

共有フォルダ的機能はない。Windowsのファイル共有をSambaで読む。
パスワードでの認証が必要で、ホストのnishioアカウントはICカード認証なので使えず、別途sambaアカウントを作成し読み書き権限を付与した。
/etc/fstabに下記を追記してsudo mount -a -vすることでマウントできる。

//192.168.137.1/Users/nishio    /home/nishio/winhome     cifs    username=samba,password=*****,iocharset=utf8,sec=ntlm,file_mode=0777,dir_mode=0777 0 0

パスワードを直書きせずに別ファイルにくくりだす方法もあるが、1人使用なので省略。

make sambaしてcifs-utilsを入れることが必要。これはcifs.mountというヘルパープログラムを作り、mountでWindowsファイル共有をファイルシステムとしてマウントできるようにする。


PyTTY
=====

★や●などの記号が半角で表示されてしまいEmacs編集時にカーソル位置が実際の位置とずれる問題は、「Window→Translation→RemoteCharcode: Unicode(CJK)」を選択することで解決できる。


ipython
=======

ipython profile create

c.InteractiveShellApp.extensions = ['autoreload']
c.InteractiveShellApp.exec_lines = ['%autoreload 2']

not automated yet
=================

EC2やRasPiなどデフォルトユーザがnishioでないケース

sudo useradd nishio
sudo usermod -G sudo nishio
sudo passwd nishio
id
id nishio
# もしグループの指定が足りてなければさらにusermodする

cd /home
sudo mkdir nishio
sudo chown nishio:nishio nishio


# Python.h: No such file or directory
sudo apt-get install python-dev

# Pillow

sudo apt-get install zlib1g-dev
sudo apt-get install libjpeg8-dev
