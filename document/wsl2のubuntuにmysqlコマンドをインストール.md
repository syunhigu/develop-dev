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
ubuntu@syunhigu-carbon:~$ apt search mysql-client
Sorting... Done
Full Text Search... Done
default-mysql-client/noble 1.1.0build1 all
  MySQL database client binaries (metapackage)

default-mysql-client-core/noble 1.1.0build1 all
  MySQL database core client binaries (metapackage)

mysql-client/noble-updates 8.0.44-0ubuntu0.24.04.2 all
  MySQL database client (metapackage depending on the latest version)

mysql-client-8.0/noble-updates 8.0.44-0ubuntu0.24.04.2 amd64
  MySQL database client binaries

mysql-client-core-8.0/noble-updates 8.0.44-0ubuntu0.24.04.2 amd64
  MySQL database core client binaries

ubuntu@syunhigu-carbon:~$
```

## mysql-client-coreをインストール
```
ubuntu@syunhigu-carbon:~$ sudo apt install mysql-client-core-8.0
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following NEW packages will be installed:
  mysql-client-core-8.0
0 upgraded, 1 newly installed, 0 to remove and 196 not upgraded.
Need to get 2740 kB of archives.
After this operation, 61.7 MB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu noble-updates/main amd64 mysql-client-core-8.0 amd64 8.0.44-0ubuntu0.24.04.2 [2740 kB]
Fetched 2740 kB in 2s (1126 kB/s)
Selecting previously unselected package mysql-client-core-8.0.
(Reading database ... 40794 files and directories currently installed.)
Preparing to unpack .../mysql-client-core-8.0_8.0.44-0ubuntu0.24.04.2_amd64.deb ...
Unpacking mysql-client-core-8.0 (8.0.44-0ubuntu0.24.04.2) ...
Setting up mysql-client-core-8.0 (8.0.44-0ubuntu0.24.04.2) ...
Processing triggers for man-db (2.12.0-4build2) ...
ubuntu@syunhigu-carbon:~$
```

## 対象のmysqlサーバーに接続
```
ubuntu@syunhigu-carbon:~ $ mysql -h 127.0.0.1 -P 33306 -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 5.5.5-10.4.28-MariaDB-1:10.4.28+maria~ubu2004 mariadb.org binary distribution

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| syunhigubrwp       |
| syunhigugmwp       |
| test               |
+--------------------+
6 rows in set (0.00 sec)

mysql>
```
