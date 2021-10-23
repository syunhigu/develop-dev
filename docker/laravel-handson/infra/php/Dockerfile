#FROM命令はイメージビルドのためのベースイメージを設定
#FROM イメージ名:タグ名 で指定
#https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/builder/#from
FROM php:8.0-fpm-buster
#SHELL命令は何も指定しない場合は SHELL ["/bin/sh", "-c"] がデフォルト値
#パイプ中のあらゆる段階でエラーがあれば失敗とするため、pipefailオプションを明示的に指定
#https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/builder/#shell
SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]

#ENV命令はコンテナ内のサーバー環境変数を設定
#https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/builder/#env
ENV COMPOSER_ALLOW_SUPERUSER=1 \
  COMPOSER_HOME=/composer

#https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/builder/#copy
COPY --from=composer:2.0 /usr/bin/composer /usr/bin/composer

#Debian系のパッケージ管理ツールは apt-get, apt とあるが、Dockerfile内で apt を実行するとCLIインターフェース向けではないと警告が表示されるため、apt-getを使用
#https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/builder/#run
RUN apt-get update && \
#apt-get -y install xxx Laravelのインストールに必要なパッケージをインストール
  apt-get -y install git unzip libzip-dev libicu-dev libonig-dev && \
#パッケージインストールで使用したキャッシュファイルを削除
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
#PHPの拡張ライブラリをインストール
  docker-php-ext-install intl pdo_mysql zip bcmath

#https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/builder/#copy
COPY ./php.ini /usr/local/etc/php/php.ini

#https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/builder/#workdir
WORKDIR /work