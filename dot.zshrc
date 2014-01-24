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

if [ `uname` = "Darwin" ]; then
    alias e="emacsclient"
    export EDITOR="emacsclient"
    OS="Mac"
elif [ `uname` = "Linux" ]; then
    alias e="emacs"
    export EDITOR="emacs"
    OS="Linux"
else
    print "Unknown uname:" `uname`
fi

# git
alias gits="git s"
alias gitcm="git cm"
alias gitl="git l"
alias gitd="git d"
alias gitdc="git dc"
alias gitig="cat >> .gitignore"
alias gitap="git ap"
# 何を変更したか完全に把握している時のための全部入り手抜きコマンド
alias gita="git status --short --branch; git add -u; git commit -m 'update'; git push"

export LANG=ja_JP.UTF-8
export HGENCODING="UTF-8"
if [ $OS = "Mac" ]; then
    export PATH="/Users/nishio/bin:/opt/local/bin:/usr/local/bin:$PATH"
    export PATH="/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH"
    export PATH="/usr/local/texlive/2012/bin/universal-darwin:$PATH"
else
    export PATH="/home/nishio/bin:$PATH"
fi
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



autoload -U add-zsh-hook 2>/dev/null || return

#
# Notification of local host command
# ----------------------------------
#
# Automatic notification via growlnotify / notify-send
#
#
# Notification of remote host command
# -----------------------------------
#
# "==ZSH LONGRUN COMMAND TRACKER==" is printed after long run command execution
# You can utilize it as a trigger
#
# ## Example: iTerm2 trigger( http://qiita.com/yaotti/items/3764572ea1e1972ba928 )
#
#  * Trigger regex: ==ZSH LONGRUN COMMAND TRACKER==(.*)
#  * Parameters: \1
#

__timetrack_threshold=10 # seconds
read -r -d '' __timetrack_ignore_progs <<EOF
less
emacs vi vim
ssh mosh telnet nc netcat
gdb
EOF

export __timetrack_threshold
export __timetrack_ignore_progs

function __my_preexec_start_timetrack() {
    local command=$1

    export __timetrack_start=`date +%s`
    export __timetrack_command="$command"
}

function __my_preexec_end_timetrack() {
    local exec_time
    local command=$__timetrack_command
    local prog=$(echo $command|awk '{print $1}')
    local notify_method
    local message

    export __timetrack_end=`date +%s`

    if test -n "${REMOTEHOST}${SSH_CONNECTION}"; then
        notify_method="remotehost"
    elif which growlnotify >/dev/null 2>&1; then
        notify_method="growlnotify"
    elif which notify-send >/dev/null 2>&1; then
        notify_method="notify-send"
    else
        return
    fi

    if [ -z "$__timetrack_start" ] || [ -z "$__timetrack_threshold" ]; then
        return
    fi

    for ignore_prog in $(echo $__timetrack_ignore_progs); do
        [ "$prog" = "$ignore_prog" ] && return
    done

    exec_time=$((__timetrack_end-__timetrack_start))
    if [ -z "$command" ]; then
        command="<UNKNOWN>"
    fi

    message="Command finished!\nTime: $exec_time seconds\nCOMMAND: $command"

    if [ "$exec_time" -ge "$__timetrack_threshold" ]; then
        case $notify_method in
            "remotehost" )
        # show trigger string
                echo -e "\e[0;30m==ZSH LONGRUN COMMAND TRACKER==$(hostname -s): $command ($exec_time seconds)\e[m"
        sleep 1
        # wait 1 sec, and then delete trigger string
        echo -e "\e[1A\e[2K"
                ;;
            "growlnotify" )
                echo "$message" | growlnotify -n "ZSH timetracker" --appIcon Terminal
                ;;
            "notify-send" )
                notify-send "ZSH timetracker" "$message"
                ;;
        esac
    fi

    unset __timetrack_start
    unset __timetrack_command
}

if which growlnotify >/dev/null 2>&1 ||
    which notify-send >/dev/null 2>&1 ||
    test -n "${REMOTEHOST}${SSH_CONNECTION}"; then
    add-zsh-hook preexec __my_preexec_start_timetrack
    add-zsh-hook precmd __my_preexec_end_timetrack
fi