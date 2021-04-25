FROM php:7.4.13-fpm-buster
COPY php.ini /usr/local/etc/php/
# composerをインストール
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');" \
  && mv composer.phar /usr/local/bin/composer
# cakephpを実行するために必要なソフトウェアをインストール
RUN apt-get update \
  && apt-get install -y git libzip-dev zip unzip \
  && docker-php-ext-install zip \
  && docker-php-ext-install pdo_mysql \
  && apt-get install -y libicu-dev \
  && docker-php-ext-configure intl \
  && docker-php-ext-install intl \
  && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
  && docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install gd
# cakephpをインストール
RUN cd /var/www/html \
  && composer create-project --prefer-dist cakephp/app:4.* app
