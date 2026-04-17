
##################################################
# Locale / Basic Environment
##################################################

export LANG=ja_JP.UTF-8     # 全体の言語設定
export LC_TIME=en_US.UTF-8  # 日付・時刻の表記


##################################################
# PATH Settings
##################################################

# path の重複を自動削除
typeset -U path

path=(
  $HOME/bin
  $HOME/local/bin
  /usr/bin
  /usr/local/bin
  /bin
  /opt/local/bin
  /opt/local/sbin
  $path
)


##################################################
# History Settings
##################################################

HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

setopt share_history         # 複数シェル間で履歴を共有
setopt extended_history      # 履歴に実行時刻・時間を記録

setopt hist_ignore_dups      # 直前と同じコマンドは履歴に追加しない
setopt hist_ignore_all_dups  # 履歴中の重複コマンドは古い方を削除
setopt hist_ignore_space     # 行頭がスペースのコマンドは履歴に残さない
setopt hist_reduce_blanks    # 余分な空白を詰めて履歴に記録


##################################################
# Shell Options
##################################################

setopt auto_cd            # ディレクトリ名だけ入力したとき cd として扱う
setopt auto_pushd         # cd 時に移動前のディレクトリを自動で pushd
setopt pushd_ignore_dups  # directory stack 内の重複登録を避ける
setopt pushd_silent       # pushd/popd 実行時にスタック内容を非表示

setopt extended_glob      # ^ ~ などを使った拡張グロブを有効化
setopt numeric_glob_sort  # ファイル名中の数字を数値として解釈して並び替える
setopt multios            # 複数リダイレクトを同時に扱えるようにする

setopt ignore_eof         # Ctrl-D だけではシェルを終了しない
setopt noclobber          # > による既存ファイルの上書きを禁止

setopt no_beep            # エラー時などのビープ音を鳴らさない
setopt nolistbeep         # 補完候補一覧表示時のビープ音を鳴らさない

setopt prompt_subst       # PROMPT 内で変数展開やコマンド置換を有効化
setopt bg_nice            # バックグラウンドジョブを低優先度で実行

unset correct_all         # 引数のスペル補正を無効化
setopt correct            # コマンド名補正を行う


##################################################
# Completion System
##################################################

autoload -Uz compinit
compinit

# 小文字と大文字を同一視
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# メニュー選択モード利用
zstyle ':completion:*' menu select=1
# 補完候補の色指定 (緑，赤，紫)
zstyle ':completion:*' list-colors 'di=32' 'ex=31' 'ln=35'
# sudo の後ろでコマンドを補完
zstyle ':completion:*:sudo:*' command-path /usr/local/bin /usr/bin /bin

# Shift+Tab で逆順に巡回
bindkey "^[[Z" reverse-menu-complete

setopt auto_list    # 補完候補を一覧で表示
setopt auto_menu    # 補完キー連打で補完候補を順に表示
setopt list_packed  # 補完候補をできるだけ詰めて表示
setopt list_types   # 補完候補にファイルの種類も表示


##################################################
# Prompt
##################################################

# collor support
autoload -U colors
colors

# 通常プロンプト
PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~ %# "
# 複数行入力時
PROMPT2='[%m]> '

# コマンド補正プロンプト
SPROMPT="correct '%R' to '%r' [nyae]? "

# git
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats "%F{red}%c%u[%b]%f"

_update_vcs_info_msg() {
  LANG=en_US.UTF-8 vcs_info
  RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg


##################################################
# Alias
##################################################

alias po='popd'
alias pu='pushd'

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias cl='clear'

alias ll='ls -laphG'
alias l='ls -phG'

alias relogin='exec $SHELL -l'


##################################################
# Suffix Alias (open by extension)
##################################################

alias -s plt=gnuplot
alias -s gp=gnuplot

alias -s gz=gzcat
alias -s tgz=gzcat
alias -s bz2=bzcat
alias -s zip=zipinfo

alias -s txt=cat
alias -s dat=cat

alias -s tex=em

alias -s ps=gv
alias -s eps=gv


##################################################
# Functions
##################################################

# safe delte -> move to trash
del () {
  mv "$@" "$HOME/.TRASH/"
}
