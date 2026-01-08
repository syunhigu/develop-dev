# GitをUbuntuにインストールしてリモートリポジトリにプッシュする
https://qiita.com/studio_meowtoon/items/719e6765dd11f17a0b19  

## 環境
Windows 11 Pro 25H2 を使用  
詳細
```
PS C:\Users\syunhigu> wsl --version
WSL バージョン: 2.6.1.0
カーネル バージョン: 6.6.87.2-1
WSLg バージョン: 1.0.66
MSRDC バージョン: 1.2.6353
Direct3D バージョン: 1.611.1-81528511
DXCore バージョン: 10.0.26100.1-240331-1435.ge-release
Windows バージョン: 10.0.26200.7462
PS C:\Users\syunhigu> wsl -l
Linux 用 Windows サブシステム ディストリビューション:
Ubuntu-24.04 (既定値)
docker-desktop
PS C:\Users\syunhigu>
```

## Git のインストールと設定
* インストール
```
ubuntu@syunhigu-carbon:~$ sudo apt update
[sudo] password for ubuntu:
～略～
Fetched 39.3 MB in 8s (5145 kB/s)
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
198 packages can be upgraded. Run 'apt list --upgradable' to see them.
ubuntu@syunhigu-carbon:~$ sudo apt install git
[sudo] password for ubuntu:
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  git-man
Suggested packages:
  git-daemon-run | git-daemon-sysvinit git-doc git-email git-gui gitk gitweb git-cvs git-mediawiki git-svn
The following packages will be upgraded:
  git git-man
2 upgraded, 0 newly installed, 0 to remove and 196 not upgraded.
Need to get 0 B/4780 kB of archives.
After this operation, 1024 B of additional disk space will be used.
Do you want to continue? [Y/n] Y
(Reading database ... 40794 files and directories currently installed.)
Preparing to unpack .../git-man_1%3a2.43.0-1ubuntu7.3_all.deb ...
Unpacking git-man (1:2.43.0-1ubuntu7.3) over (1:2.43.0-1ubuntu7.1) ...
Preparing to unpack .../git_1%3a2.43.0-1ubuntu7.3_amd64.deb ...
Unpacking git (1:2.43.0-1ubuntu7.3) over (1:2.43.0-1ubuntu7.1) ...
Setting up git-man (1:2.43.0-1ubuntu7.3) ...
Setting up git (1:2.43.0-1ubuntu7.3) ...
Processing triggers for man-db (2.12.0-4build2) ...
ubuntu@syunhigu-carbon:~$
```

* バージョン確認
```
ubuntu@syunhigu-carbon:~$ git --version
git version 2.43.0
ubuntu@syunhigu-carbon:~$
```

* 設定
※必要に応じて実施
```
$ git config --global user.name "YOUR NAME"
$ git config --global user.email awesome@company.com
```

* Git のオプションを設定
```
$ git config  --global core.autocrlf false
$ git config  --global core.quotepath false

core.autocrlf は、Git が自動的に改行コードを変換するかどうかを設定するもの
→Linux では改行コードが LF のみであるため、この設定を false にすることで、Git が改行コードを変換しないようにすることができる
core.quotepath は、ファイル名をクオートする必要がある場合に、Git がそれを行うかどうかを設定するもの
→この設定を false にすることで、Git がファイル名をクオートしないようにすることができる
個人では以下を設定
git config --global color.ui auto
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
#ファイル名の大文字・小文字の変更を検知する。
git config --global core.ignorecase false
#日本語ファイル名をエスケープせずに表示
git config --global core.quotepath false
#濁点つきのディレクトリ・ファイルが分けて表示されてしまう UTF8-MAC 問題の解決方法
git config --global core.precomposeunicode true
#マージコンフリクトを見やすくする
git config --global merge.conflictStyle diff3
```
## 設定確認
```
ubuntu@FBC-PC63:~$ git config -l
user.name=example
user.email=example@example.com
color.ui=auto
color.diff=auto
color.status=auto
color.branch=auto
core.ignorecase=false
core.quotepath=false
core.precomposeunicode=true
core.autocrlf=false
merge.conflictstyle=diff3
ubuntu@syunhigu-carbon:~$
```

## 暗号キー の作成及び設定
* ディレクトリ作成及びファイル設定 
mkdir ~/.ssh
touch ~/.ssh/config
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
```
ubuntu@syunhigu-carbon:~$ ll -a
total 44
drwxr-x--- 5 ubuntu ubuntu 4096 Jan  9 00:01 ./
drwxr-xr-x 3 root   root   4096 Nov 29 23:05 ../
lrwxrwxrwx 1 ubuntu ubuntu   26 Nov 30 00:57 .aws -> /mnt/c/Users/syunhigu/.aws/
lrwxrwxrwx 1 ubuntu ubuntu   28 Nov 30 00:57 .azure -> /mnt/c/Users/syunhigu/.azure/
-rw------- 1 ubuntu ubuntu  561 Dec  6 17:19 .bash_history
-rw-r--r-- 1 ubuntu ubuntu  220 Nov 29 23:05 .bash_logout
-rw-r--r-- 1 ubuntu ubuntu 3771 Nov 29 23:05 .bashrc
drwx------ 2 ubuntu ubuntu 4096 Nov 29 23:05 .cache/
drwxr-xr-x 4 ubuntu ubuntu 4096 Nov 30 00:57 .docker/
-rw-r--r-- 1 ubuntu ubuntu  239 Jan  9 00:00 .gitconfig
-rw------- 1 ubuntu ubuntu   20 Jan  9 00:01 .lesshst
-rw-rw-r-- 1 ubuntu ubuntu    0 Jan  8 23:07 .motd_shown
-rw-r--r-- 1 ubuntu ubuntu  807 Nov 29 23:05 .profile
drwx------ 2 ubuntu ubuntu 4096 Nov 29 23:22 .ssh/
-rw-r--r-- 1 ubuntu ubuntu    0 Dec  6 17:19 .sudo_as_admin_successful
ubuntu@syunhigu-carbon:~$
ubuntu@syunhigu-carbon:~$ ll .ssh/
total 8
ubuntu@syunhigu-carbon:~$ chmod 700 ~/.ssh
ubuntu@syunhigu-carbon:~$ chmod 600 ~/.ssh/*
ubuntu@syunhigu-carbon:~$
```

* 暗号キーの作成
```
ubuntu@syunhigu-carbon:~$ cd .ssh/
ubuntu@syunhigu-carbon:~/.ssh$ ll
total 8
drwx------ 2 ubuntu ubuntu 4096 Nov 29 23:22 ./
drwxr-x--- 5 ubuntu ubuntu 4096 Jan  9 00:01 ../
-rw------- 1 ubuntu ubuntu    0 Nov 29 23:22 config
ubuntu@syunhigu-carbon:~/.ssh$ pwd
/home/ubuntu/.ssh
ubuntu@syunhigu-carbon:~/.ssh$ ll
total 8
drwx------ 2 ubuntu ubuntu 4096 Nov 29 23:22 ./
drwxr-x--- 5 ubuntu ubuntu 4096 Jan  9 00:01 ../
-rw------- 1 ubuntu ubuntu    0 Nov 29 23:22 config
ubuntu@syunhigu-carbon:~/.ssh$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ubuntu/.ssh/id_rsa): wsl_ubuntu_github
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in wsl_ubuntu_github
Your public key has been saved in wsl_ubuntu_github.pub
The key fingerprint is:
～略～
ubuntu@syunhigu-carbon:~/.ssh$ ll
total 16
drwx------ 2 ubuntu ubuntu 4096 Jan  9 00:16 ./
drwxr-x--- 5 ubuntu ubuntu 4096 Jan  9 00:01 ../
-rw------- 1 ubuntu ubuntu    0 Nov 29 23:22 config
-rw------- 1 ubuntu ubuntu 2610 Jan  9 00:16 wsl_ubuntu_github
-rw-r--r-- 1 ubuntu ubuntu  576 Jan  9 00:16 wsl_ubuntu_github.pub
ubuntu@syunhigu-carbon:~/.ssh$
```

* 暗号キーの設定
```
ubuntu@syunhigu-carbon:~/.ssh$ vi config
ubuntu@syunhigu-carbon:~/.ssh$ cat config
Host *
  StrictHostKeyChecking no
#  UserKnownHostsFile=/dev/null
  ServerAliveInterval 15
  ServerAliveCountMax 30
  AddKeysToAgent yes
#  UseKeychain yes
#  IdentitiesOnly yes

# github-private
Host github-private
  HostName github.com
  IdentityFile ~/.ssh/wsl_ubuntu_github
  User git
ubuntu@syunhigu-carbon:~/.ssh$
```

* 暗号キーのgitへ登録
* 接続テスト  
※Hi～ のメッセージが出ればok  
```
ubuntu@syunhigu-carbon:~/.ssh$ ssh -T github-private
Warning: Permanently added 'github.com' (ED25519) to the list of known hosts.
Hi syunhigu! You've successfully authenticated, but GitHub does not provide shell access.
ubuntu@syunhigu-carbon:~/.ssh$
```
