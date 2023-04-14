# Spring Boot環境を構築
[Spring Boot環境を構築](https://specially198.com/build-a-spring-boot-environment-with-docker/)  
Docker環境にて、Spring Bootを利用できるようにする  
Spring Initializrで作成したプロジェクトを、Docker上でビルド、起動する  
IDEはVS Codeを利用して、デバッグもできるようにする  
ビルドには、Gradle を使用

## 目次
1. 環境
2. ディレクトリ構成
3. Docker環境  
  3.1. アプリケーションサーバー（app）コンテナ  
  3.2 データベースサーバー（db）コンテナ  
  3.3 コンテナの起動  
4. Spring Bootのプロジェクトを作成
5. コンテナ上でビルド
6. DB検索機能を作成する
  6.1. モデルの実装  
  6.2. コントローラーの実装  
  6.3. サービスクラスの実装  
  6.4. リポジトリクラスの実装  
  6.5. ビューの実装  
  6.6. ビルドと起動
7. コンテナに接続する

## 1. 環境
* Java：17
* Spring Boot：3.0.1
* MySQL：8.0

## 2. ディレクトリ構成
以下のディレクトリ構成としている
```
.
├── docker-compose.yml
├── mysql
│   ├── Dockerfile
│   └── my.cnf
└── workspace (Spring Bootプロジェクトのディレクトリ)
```

## 3. Docker環境
Docker環境を作成する  
構築するサーバーはアプリケーションサーバー（app）、データベースサーバー（db）の2つ
docker-compose.yml を作成

### 3.1. アプリケーションサーバー（app）コンテナ
アプリケーションサーバーについては、Docker HubがOpenJDKイメージの廃止を決定したそうなので、Eclipse Temurinの公式イメージを使用  
[廃止について参考](https://rheb.hatenablog.com/entry/updating-docker-hubs-openjdk-image)  
[Eclipse Temurinの公式イメージ](https://hub.docker.com/_/eclipse-temurin)

### 3.2. データベースサーバー（db）コンテナ
データベースサーバーについては、Dockerfileを作成

### 3.3. コンテナの起動
コンテナ起動できることを確認する
```
docker-compose up
```

## 4.Spring Bootのプロジェクトを作成
[SpringInitializr](https://start.spring.io/)を利用  

## 5. コンテナ上でビルド
コンテナログイン
```
docker-compose exec app bash
```
mvnコマンド確認
```
./mvnw --version
```
コンパイル
```
./mvnw compile
```

