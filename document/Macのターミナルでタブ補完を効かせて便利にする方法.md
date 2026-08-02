# Macのターミナルでタブ補完を効かせて便利にする方法

* 最新のzshのインストール
* ~/.zshrcの記述
* zshのタブ補完でできること
* まとめ

## 最新のzshのインストール
```
$ echo $SHELL               
/bin/zsh
$ brew install zsh

$ sudo vi /etc/shells

$ chsh -s /usr/local/bin/zsh

$ echo $SHELL
/bin/zsh
$ zsh --version             
zsh 5.9 (x86_64-apple-darwin22.0)

$ brew install zsh-completions
```

## ~/.zshrcの記述
```
$ vi ~/.zshrc
```
下記追記
```
# 補完機能を有効にする
autoload -Uz compinit
compinit -u
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完候補を詰めて表示
setopt list_packed

# 補完候補一覧をカラー表示
autoload colors
zstyle ':completion:*' list-colors ''

# コマンドのスペルを訂正
setopt correct
```
保存したらターミナルを開き直すか、下記コマンドを実行
```
$ source ~/.zshrc
```