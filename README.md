# aws-health-notify

AWS Service Health Dashboard (http://status.aws.amazon.com) の RSS に新しいエントリーリーが追加された時にメール送信します。  
Thunderbird の RSS リーダー機能、feedly 等を使えばいいのだが、社内のMLに流したいケースもあるので。  

## 動作環境

現状 Heroku へのデプロイのみ対応。 
  
必要な Heroku Add-one

* Mongolab
* Scheduler
* Sendgrid
  
## 設定

### 設定ファイル

settings.yml に購読したい RSS Feed 情報、送信者アドレス、送信先アドレスを記述します。

    rss_feeds:
        (Feedキー名): (RSS Feed URL)
    
    mail_from: (送信元メールアドレス)
    
    mail_to:
        - (送信先メールアドレス)

※(Feedキー名)は"cloudfront"や"s3"といったサービスを識別できる任意の英数字の文字列。
  
settings.yml を修正後、Heroku へのデプロイを行います。

### Heroku Scheduler

Heroku Scheduler にて登録された　RSS のエントリーを取得し、新規のエントリーがあれば送信先メールアドレスに送信します。  
  
Heroku Scheduler のタスクに登録するコマンドには以下を指定します。

    bundle exec ruby task.rb

初回の Heroku Scheduler タスク実行時には RSS のエントリーの取得のみを行い、送信先メールアドレスに送信しません。
２回目以降タスク実行時に新規の RSS エントリーがあればそれを送信先メールアドレスに送信します。

## 送信されるメール内容

タイトル:  
[aws-health-notify Feedキー名] RSS エントリーのタイトル  

送信者:  
settings.yml で指定した送信元メールアドレス  
  
本文:  
RSS のエントリーのサマリー  
RSS のエントリーの URL
