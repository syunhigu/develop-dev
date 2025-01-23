# wsl2のubuntuにmysqlコマンドをインストール
https://ponsuke-tarou.hatenablog.com/entry/2020/02/27/214335

* リポジトリ一覧を更新
* mysql-clientのパッケージを検索
* mysql-client-coreをインストール

## リポジトリ一覧を更新
```
sudo apt update
```

## mysql-clientのパッケージを検索
```
ubuntu@FBC-PC63:~$ apt search mysql-client
Sorting... Done
Full Text Search... Done
default-mysql-client/noble 1.1.0build1 all
  MySQL database client binaries (metapackage)

default-mysql-client-core/noble 1.1.0build1 all
  MySQL database core client binaries (metapackage)

mysql-client/noble-updates,noble-security 8.0.40-0ubuntu0.24.04.1 all
  MySQL database client (metapackage depending on the latest version)

mysql-client-8.0/noble-updates,noble-security 8.0.40-0ubuntu0.24.04.1 amd64
  MySQL database client binaries

mysql-client-core-8.0/noble-updates,noble-security 8.0.40-0ubuntu0.24.04.1 amd64
  MySQL database core client binaries

ubuntu@FBC-PC63:~$ 
```

## mysql-client-coreをインストール
```
ubuntu@FBC-PC63:~/wk$ sudo apt install mysql-client-core-8.0
[sudo] password for ubuntu:
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following NEW packages will be installed:
  mysql-client-core-8.0
0 upgraded, 1 newly installed, 0 to remove and 6 not upgraded.
Need to get 0 B/2765 kB of archives.
After this operation, 61.6 MB of additional disk space will be used.
Selecting previously unselected package mysql-client-core-8.0.
(Reading database ... 40794 files and directories currently installed.)
Preparing to unpack .../mysql-client-core-8.0_8.0.40-0ubuntu0.24.04.1_amd64.deb ...
Unpacking mysql-client-core-8.0 (8.0.40-0ubuntu0.24.04.1) ...
Setting up mysql-client-core-8.0 (8.0.40-0ubuntu0.24.04.1) ...
Processing triggers for man-db (2.12.0-4build2) ...
ubuntu@FBC-PC63:~/wk$ 
```

## 対象のmysqlサーバーに接続
```
ubuntu@FBC-PC63:~/wk$ mysql -h 127.0.0.1 -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 6341
Server version: 5.7.44 MySQL Community Server (GPL)

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| maas_admin         |
| maas_cmn           |
| maas_mst           |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
7 rows in set (0.01 sec)

mysql>
```
