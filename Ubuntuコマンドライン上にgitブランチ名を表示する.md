# Ubuntuコマンドライン上にgitブランチ名を表示する  
https://qiita.com/hiroki-harada/items/cc9ecdd2f704e111d57f

イメージ  
```
user@:/home/username/my-repository # 
↓
user@:/home/username/my-repository (main) # 
```

コマンドライン上にブランチ名を表示するには、  
```
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1) \$ '
# or
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(__git_ps1)\$ '
```
*.bashrc* に *$(__git_ps1)* を指定する  
*__git_ps1: command not found.* が発生した場合は、*git-completion.bash* と *git-prompt.sh* を事前に読み込ませる。  

.bashrc に追記
```
source ~/.git-prompt.sh
source ~/.git-completion.bash

PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(__git_ps1)\$ '
```

※上記2ファイルが存在なければ、[git](https://github.com/git/git/tree/master/contrib/completion)のソースから取得。  
凡そ、下記のどこかに存在するみたいです（自分の環境では最後者）。  
```
/usr/local/etc/bash_completion.d/
/usr/share/bash-completion/
```

1. .bashrc を確認
編集前
```
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# (中略)

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# (以下略)
```

*PS1* という変数が、コマンドラインの表示内容を決めているらしい。
自分の場合は、デフォルトだとカラー表示されていなかったので、 else の方が適用されているようでした。  

${...} は一旦無視するとして、 *\u@\h:\w\$*  という部分に注目②すると、  
②末尾に半角スペースあり  
```
\u : ユーザー名
\h : ホスト名
\W : 今いるディレクトリ名
\$ : 一般ユーザーの時$, rootの時#を表示
```

なので、 *user* というユーザでログインしていて、 */home/username* というディレクトリにいる場合、  
```
user@:/home/username$ 
```

と表示される事になる。  

1. .bashrc を編集
```
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# (中略)

if [ "$color_prompt" = yes ]; then
-   PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
+   PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1) \$ '
else
-   PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
+   PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(__git_ps1) \$ '
fi
unset color_prompt force_color_prompt

# (以下略)
```

保存後、設定を反映
```
source ~/.bashrc
```
