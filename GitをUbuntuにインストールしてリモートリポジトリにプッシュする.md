# GitをUbuntuにインストールしてリモートリポジトリにプッシュする
https://qiita.com/studio_meowtoon/items/719e6765dd11f17a0b19  

## 環境
Windows 11 Home 23H2 を使用  
詳細
```
PS C:\Users\s.higuchi> wsl --version
WSL バージョン: 2.3.24.0
カーネル バージョン: 5.15.153.1-2
WSLg バージョン: 1.0.65
MSRDC バージョン: 1.2.5620
Direct3D バージョン: 1.611.1-81528511
DXCore バージョン: 10.0.26100.1-240331-1435.ge-release
Windows バージョン: 10.0.22631.4460
PS C:\Users\s.higuchi> wsl -l
Linux 用 Windows サブシステム ディストリビューション:
Ubuntu-24.04 (既定)
docker-desktop
PS C:\Users\s.higuchi>
```

## Git のインストールと設定
* インストール
```
ubuntu@FBC-PC63:~$ sudo apt update
[sudo] password for ubuntu:
～略～
Fetched 2661 kB in 2s (1164 kB/s)
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
6 packages can be upgraded. Run 'apt list --upgradable' to see them.
ubuntu@FBC-PC63:~$ sudo apt install git
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  git-man
Suggested packages:
  git-daemon-run | git-daemon-sysvinit git-doc git-email git-gui gitk gitweb git-cvs git-mediawiki git-svn
The following packages will be upgraded:
  git git-man
2 upgraded, 0 newly installed, 0 to remove and 4 not upgraded.
Need to get 0 B/4779 kB of archives.
After this operation, 2048 B of additional disk space will be used.
Do you want to continue? [Y/n] Y
(Reading database ... 40820 files and directories currently installed.)
Preparing to unpack .../git-man_1%3a2.43.0-1ubuntu7.2_all.deb ...
Unpacking git-man (1:2.43.0-1ubuntu7.2) over (1:2.43.0-1ubuntu7.1) ...
Preparing to unpack .../git_1%3a2.43.0-1ubuntu7.2_amd64.deb ...
Unpacking git (1:2.43.0-1ubuntu7.2) over (1:2.43.0-1ubuntu7.1) ...
Setting up git-man (1:2.43.0-1ubuntu7.2) ...
Setting up git (1:2.43.0-1ubuntu7.2) ...
Processing triggers for man-db (2.12.0-4build2) ...
ubuntu@FBC-PC63:~$ 
```

* バージョン確認
```
ubuntu@FBC-PC63:~$ git --version
git version 2.43.0
ubuntu@FBC-PC63:~$
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
core.autocrlf=false
core.ignorecase=false
core.quotepath=false
color.ui=auto
color.diff=auto
color.status=auto
color.branch=auto
merge.conflictstyle=diff3
ubuntu@FBC-PC63:~$
```

## 暗号キー の作成及び設定
* ディレクトリ作成及びファイル設定 
mkdir ~/.ssh
touch ~/.ssh/config
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
```
ubuntu@FBC-PC63:~$ mkdir ~/.ssh
ubuntu@FBC-PC63:~$ ll -a
total 68
drwxr-x--- 10 ubuntu ubuntu 4096 Jan 18 14:36 ./
drwxr-xr-x  3 root   root   4096 Jan 17 11:44 ../
lrwxrwxrwx  1 ubuntu ubuntu   27 Jan 17 16:58 .aws -> /mnt/c/Users/s.higuchi/.aws/
lrwxrwxrwx  1 ubuntu ubuntu   29 Jan 17 16:58 .azure -> /mnt/c/Users/s.higuchi/.azure/
-rw-------  1 ubuntu ubuntu  735 Jan 18 12:11 .bash_history
-rw-r--r--  1 ubuntu ubuntu  220 Jan 17 11:44 .bash_logout
-rw-r--r--  1 ubuntu ubuntu 3771 Jan 17 11:44 .bashrc
drwx------  2 ubuntu ubuntu 4096 Jan 17 11:44 .cache/
drwxr-xr-x  4 ubuntu ubuntu 4096 Jan 17 16:58 .docker/
-rw-r--r--  1 ubuntu ubuntu  222 Jan 18 14:22 .gitconfig
drwxr-xr-x  2 ubuntu ubuntu 4096 Jan 18 00:56 .landscape/
-rw-------  1 ubuntu ubuntu   20 Jan 18 14:34 .lesshst
-rw-r--r--  1 ubuntu ubuntu    0 Jan 18 00:56 .motd_shown
-rw-------  1 ubuntu ubuntu   42 Jan 18 10:19 .mysql_history
-rw-r--r--  1 ubuntu ubuntu  807 Jan 17 11:44 .profile
drwxr-xr-x  2 ubuntu ubuntu 4096 Jan 18 14:36 .ssh/
-rw-r--r--  1 ubuntu ubuntu    0 Jan 18 02:13 .sudo_as_admin_successful
drwxr-xr-x  4 ubuntu ubuntu 4096 Jan 17 23:35 .vscode-remote-containers/
drwxr-xr-x  2 ubuntu ubuntu 4096 Jan 18 13:47 fbc/
drwxr-xr-x  3 ubuntu ubuntu 4096 Jan 17 21:34 meitetsu/
drwxr-xr-x  4 ubuntu ubuntu 4096 Jan 18 10:19 wk/
ubuntu@FBC-PC63:~$ touch ~/.ssh/config
ubuntu@FBC-PC63:~$ ll .ssh/
total 8
drwxr-xr-x  2 ubuntu ubuntu 4096 Jan 18 14:39 ./
drwxr-x--- 10 ubuntu ubuntu 4096 Jan 18 14:36 ../
-rw-r--r--  1 ubuntu ubuntu    0 Jan 18 14:39 config
ubuntu@FBC-PC63:~$ chmod 700 ~/.ssh
ubuntu@FBC-PC63:~$ chmod 600 ~/.ssh/*
ubuntu@FBC-PC63:~$
```

* 暗号キーの作成
```
ubuntu@FBC-PC63:~$ cd .ssh/
ubuntu@FBC-PC63:~/.ssh$ pwd
/home/ubuntu/.ssh
ubuntu@FBC-PC63:~/.ssh$ ll
total 8
drwx------  2 ubuntu ubuntu 4096 Jan 18 14:39 ./
drwxr-x--- 10 ubuntu ubuntu 4096 Jan 18 14:36 ../
-rw-------  1 ubuntu ubuntu    0 Jan 18 14:39 config
ubuntu@FBC-PC63:~/.ssh$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ubuntu/.ssh/id_rsa): wsl_ubuntu_fbc_github
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in wsl_ubuntu_fbc_github
Your public key has been saved in wsl_ubuntu_fbc_github.pub
The key fingerprint is:
～略～
ubuntu@FBC-PC63:~/.ssh$ ll
total 28
drwx------  2 ubuntu ubuntu 4096 Jan 18 14:58 ./
drwxr-x--- 10 ubuntu ubuntu 4096 Jan 18 14:55 ../
-rw-------  1 ubuntu ubuntu  306 Jan 18 14:55 config
-rw-------  1 ubuntu ubuntu 2602 Jan 18 14:47 wsl_ubuntu
-rw-r--r--  1 ubuntu ubuntu  569 Jan 18 14:47 wsl_ubuntu.pub
-rw-------  1 ubuntu ubuntu 2602 Jan 18 14:58 wsl_ubuntu_fbc_github
-rw-r--r--  1 ubuntu ubuntu  569 Jan 18 14:58 wsl_ubuntu_fbc_github.pub
ubuntu@FBC-PC63:~/.ssh$
```

* 暗号キーの設定
```
ubuntu@FBC-PC63:~/.ssh$ vi config
ubuntu@FBC-PC63:~/.ssh $ cat config
Host *
  StrictHostKeyChecking no
#  UserKnownHostsFile=/dev/null
  ServerAliveInterval 15
  ServerAliveCountMax 30
  AddKeysToAgent yes
#  UseKeychain yes
#  IdentitiesOnly yes

# fbc_mail_delivery_github
Host fbc_github github.com
  HostName github.com
  IdentityFile ~/.ssh/wsl_ubuntu_fbc_github
  User git
ubuntu@FBC-PC63:~/.ssh $
```

* 暗号キーのgitへ登録
* 接続テスト  
※Hi～ のメッセージが出ればok  
```
ubuntu@FBC-PC63:~/.ssh$ ssh -T fbc_github
Warning: Permanently added 'github.com' (ED25519) to the list of known hosts.
Hi fbc-syunhigu! You've successfully authenticated, but GitHub does not provide shell access.
ubuntu@FBC-PC63:~/.ssh$ 
```
