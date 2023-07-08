# Memo App

就職用ポートフォリオの１つとして作成した Web アプリケーションです。フロントエンドは [React](https://react.dev/), バックエンドは [Laravel](https://laravel.com/), デプロイ先として [AWS](https://aws.amazon.com/jp/) を使用しています。また、ローカル環境および本番環境構築のため、コンテナ型仮想化技術として [Docker](https://www.docker.com/) を使用しています。アプリケーション自体は現在は稼働していません。

フロントエンドとバックエンドのソースコードは、それぞれ別のリポジトリで管理しています。使用技術やこだわった点について README に記載していますので、ご参照ください。

- [フロントエンド ( React )](https://github.com/Taichiro-S/MemoApp_frontend_react-ts)
- [バックエンド ( Laravel )](https://github.com/Taichiro-S/MemoApp_backend_laravel-10)

#### 📕 目次

1. [アプリの概要](#what)
2. [このアプリを作ったモチベーション](#why)
3. [ローカル環境について](#local)
4. [本番環境について](#prod)
5. [アプリの機能](#function)


<a id="what"></a>

## どんなアプリ？

フロントエンドを React 、バックエンドを Laravel で構築した SPA です。中身は最低限の機能を備えたメモアプリです。

<a id="why"></a>

## 何のために？

フロントエンドとバックエンドを分離した SPA 開発、Docker を使用したローカルでの開発環境の構築、および AWS での本番環境の構築、アプリケーションの運用について勉強するために作成しました。
<a id="local"></a>

## ローカル環境について

ローカルでの開発にはコンテナ型仮想化技術として Docker を使用しています。Docker を使用することで、使用する OS に依存することなくアプリケーションを動作させることができ、Docker が動作する環境さえ作ってしまえば、ローカルからそのまま本番環境に移植することもできます。

本プロジェクトではdocker-compose を利用して、以下のようなコンテナ構成としました。

- Webコンテナ : リバースプロキシサーバ ( Nginx 1.22 )
- Frontend コンテナ : Node サーバ ( React 18 )
- Backend コンテナ : REST API サーバ ( Laravel 10 )
- Database コンテナ : RDB サーバ ( MySQL 8.0 )

![ローカル環境イメージ図](https://github.com/Taichiro-S/MemoApp-docker/assets/119518065/219083b5-8803-4c68-89c6-a35c3a168372)

### こだわった点

- **フロントエンドとバックエンドの分離**
  Laravel 
- **最新のバージョンを使用すること**
  

### それぞれのコンテナの機能

|コンテナ名 | 使用イメージ | 機能 |
| :---: | :---: | :--- |
| Web コンテナ | nginx:1.22 | <ul><li>`/` へのリクエストを Frontend コンテナ(`localhost:3000`)へ転送</li><li> `/sanctum/csrf-cookie` および `/api` へのリクエストを Backend コンテナ (`localhost:9000`) へ転送</li></ul> |
| Frontend コンテナ | node:18-alpine | <ul><li>`create-react-app`により作成した Reactプロジェクトテンプレートを使用してUIを実装</li><li>Web コンテナに対して API リクエストを送信する ( Backend コンテナに転送される )</li></ul> |
| Backend コンテナ | php:8.1-fpm-bullseye | <ul><li>フレームワークとして Laravel を使用し、REST API サーバとして使用</li><li>Database コンテナからのデータ取得、保存を行う</li></ul> |
| Database コンテナ | mysql/mysql-server:8.0 | <ul><li>MySQL を使用した RDB</li></ul> |

<a id="prod"></a>

## 本番環境について

インフラ環境の構築には AWS を使用し、フロントエンドは S3 と CloudFront, バックエンドは EC2, データベースは RDS で構成しています。少々イレギュラーではありますが、ローカルで構築した Web コンテナと Backend コンテナを、全く同様に EC2 で動かし、REST API サーバとして使用しています ( これができてしまうのが Docker のすごいところです ) 。
![本番環境イメージ図](https://github.com/Taichiro-S/MemoApp-docker/assets/119518065/e5b04444-aadb-4b98-9768-bde694c51a91)

### こだわった点

- **S3とCloudFrontによる静的サイトホスティング**
  ローカル環境ではフロントエンド部分を Docker コンテナの Node サーバで稼働させていましたが、本番環境ではビルドした静的ファイルをS3に配置し、CloudFrontで配信することにより高速でグローバルなコンテンツ配信を可能にしました。
- **マルチAZによるAPサーバ、DBサーバの冗長化**
  複数の AZ ( Availability Zone ) にリソースを分散させることで高可用性と耐障害性を実現しました。一つのエリアで障害が発生した場合でも、アプリケーションを継続して稼働させることができます。

### 使用した主なサービス

#### フロントエンド部分

|サービス名 | アイコン | 機能など |
| :---: | :---: | :--- |
| WAF | <img width="40" alt="WAF" src="https://github.com/Taichiro-S/MemoApp-docker/assets/119518065/5b4e6b1e-d5c6-4163-867d-119adfccdfed"> | CloudFront の前段に設置することで、セキュリティ侵害や bot によるリソースの消費からサーバを保護します。 |
| S3 | <img width="40" alt="S3" src="https://github.com/Taichiro-S/MemoApp-docker/assets/119518065/9d69a301-e102-4e32-a013-923e1247f160"> | 高い耐久性を持つオブジェクトベースのストレージサービスです。本プロジェクトでは、React のビルドアーティファクトをそのままアップロードしています。 |
| CloudFront | <img width="40" alt="cloudfront" src="https://github.com/Taichiro-S/MemoApp-docker/assets/119518065/6be67de5-5f28-49f2-9e62-748ef16a20ba"> | エッジサーバを使用して、世界中に高速でコンテンツを配信するためのサービスです。ビヘイビアを設定することで、動的ファイルへのリクエストは ALB ( 後述 ) へ、静的ファイルへのリクエストはS3へと振り分けることが可能です。 |
| Route53 | <img width="40" alt="Route53" src="https://github.com/Taichiro-S/MemoApp-docker/assets/119518065/0a3cb8fd-c7ca-4c23-a62f-b06f4b0c1c40"> | 取得した独自ドメインを AWS 内の IP に割り当てることができます。 |
| ACM | <img width="40" alt="ACM" src="https://github.com/Taichiro-S/MemoApp-docker/assets/119518065/ad12181e-6740-4a98-b08e-5a0fdcd5b999"> | SSL/TLS証明書を発行し、通信のHTTPS化を可能にします。ACMは、証明書の更新を自動的に行うため、証明書の有効期限切れによるサービス中断を防ぐことができます。 |

#### バックエンド部分

|サービス名 | アイコン | 機能など |
| :---: | :---: | :--- |
| ALB | <img width="40" alt="WAF" src="https://github.com/Taichiro-S/MemoApp-docker/assets/119518065/5b4e6b1e-d5c6-4163-867d-119adfccdfed"> |  |
| EC2 | <img width="40" alt="EC2" src="https://github.com/Taichiro-S/MemoApp-docker/assets/119518065/a41a4012-23a4-4705-a980-869389ed6924"> |  |
| Auto Scaling | <img width="40" alt="AutoScaling" src="https://github.com/Taichiro-S/MemoApp-docker/assets/119518065/3aa93a09-91b8-414b-8379-db38bc8560e8"> |  |

#### その他

|サービス名 | アイコン | 機能など |
| :---: | :---: | :--- |
| RDS | <img width="40" alt="RDS" src="https://github.com/Taichiro-S/MemoApp-docker/assets/119518065/563243c2-17ea-44c0-939b-fc435f1c0e45"> |  |
| CloudWatch | <img width="40" alt="CloudWatch" src="https://github.com/Taichiro-S/MemoApp-docker/assets/119518065/5c0c62e5-b4b2-41d4-89db-0d6aeceba02b"> |  |
| Systems Manager | <img width="40" alt="SystemsManager" src="https://github.com/Taichiro-S/MemoApp-docker/assets/119518065/46d3e818-2198-4150-8a91-0ec62c29cf6d"> |  |
| Parameter Store | <img width="40" alt="parameterStore" src="https://github.com/Taichiro-S/MemoApp-docker/assets/119518065/7d0b12bc-a422-4c8a-b1ab-a650cf084413"> |  |

<a id="function"></a>

## 主な機能

- ユーザ登録、ログイン、ログアウト
- メモの CRUD 操作
- ページネーション

アプリケーションと呼べるかどうかギリギリのラインですが、最低限の機能はつけたつもりです。
