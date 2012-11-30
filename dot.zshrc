# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ascii"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# report spent time when a process spent more than 3 seconds
REPORTTIME=1

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx git-flow)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Uncomment following line if you want to disable colors in ls
DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

function settitle(){ echo -n "]0;$@"; }

alias e="emacsclient"
alias ec="emacsclient"
alias gitlog="git log --graph --oneline"
alias gitmerge="git merge --no-ff"

export LANG=ja_JP.UTF-8
export HGENCODING="UTF-8"
export PATH="/Users/nishio/bin:/opt/local/bin:/usr/local/bin:$PATH"
export PATH="/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH"

export EDITOR="emacsclient"

# aliasを使っている場合、complete_aliasesしないとパラメータのファイル名などが補完されなくなる
setopt complete_aliases

# https://github.com/yoshiori/oh-my-zsh-yoshiori/blob/master/yoshiori.zshrc.zsh
# 履歴の設定, screen でも共有
HISTFILE=$ZSH/.zhistory

# メモリ内の履歴の数
HISTSIZE=100000

# 保存される履歴の数
SAVEHIST=100000

# 既にヒストリにあるコマンドは古い方を削除
setopt hist_ignore_all_dups

#複数の文字の組み合わせをサポートするバイトモード
setopt COMBINING_CHARS

# コマンドラインの余分なスペースを削除
setopt hist_reduce_blanks

#ヒストリの共有 for GNU Screen
setopt share_history

# 複数の zsh を同時に使う時など history ファイルに上書きせず追加する
setopt append_history

# コマンドラインの先頭がスペースで始まる場合ヒストリに追加しない
setopt hist_ignore_space

# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt hist_verify

# history (fc -l) コマンドをヒストリリストから取り除く。
setopt hist_no_store

# emacs keybind
bindkey -e

setopt auto_cd
setopt auto_pushd

#autoload predict-on
#predict-on

# JDK1.6からデフォルトのエンコーディングがSJISになってMacだと化けてしまうのでUTF8にする
export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8