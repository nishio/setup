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
