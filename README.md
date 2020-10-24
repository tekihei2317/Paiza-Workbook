## 概要

[Paizaスキルチェック](https://paiza.jp/challenges)での勉強をサポートするアプリです。

## URL

https://paizaworkbook.com/

## 制作の背景

以前、[AtCoder](https://atcoder.jp/?lang=ja)や[Codeforces](https://codeforces.com/)などのコンテストサイトで、競技プログラミングに取り組んでいました。それらのサイトにあった、問題を絞り込んだり、進捗を把握したりする機能がPaizaには無く、少し不便に感じたので、自分で作ってみることにしました。

## 機能一覧

- 問題一覧の表示
  - [https://paiza.jp/challenges/ranks/d/info](https://paiza.jp/challenges/ranks/d/info)などから取得しています
- 解いた問題の取得
  - フォームからPaizaに登録してあるメールアドレスとパスワードを送信すると、[マイページ](https://paiza.jp/career/mypage/results)から解いた問題を取得します
- 問題絞り込み機能
  - ランク(S、A、B、C、D)での絞り込み
  - 難易度での絞り込み
  - 解いた問題の非表示
- 問題ソート機能
  - 問題名以外のカラムでソートすることができます(昇順/降順)
- 進捗把握機能
  - 各ランクごとに円グラフで、解いた割合を表示
  - 難易度200区切りの表で、解いた問題数を表示
  - (実装予定)解いた問題の履歴の表示
  - (実装予定)折れ線グラフで、解いた問題の難易度の総和の推移を表示
- (実装予定)レコメンド機能
  - ユーザーのレーティングや、解いた問題の難易度や平均解答時間をもとに、おすすめの問題を表示

## 環境・使用技術

### フロントエンド

- Bootstrap 4.1.3
- JavaScript

### バックエンド

- Ruby 2.7.1
- Rails 5.2.4.4

### 本番環境

- AWS(EC2、Route53)
- Nginx、Puma

### その他使用技術

- スクレイピング(Nokogiri、Selenium)
- whenever(定時処理)
- Action Cable(非同期処理→通知)
- RSpec(自動テスト)
- Capistrano(自動デプロイ)
- GitHub Actions(CI)