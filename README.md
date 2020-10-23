## 概要

[Paizaスキルチェック](https://paiza.jp/challenges)での勉強をサポートするアプリです。

## URL

https://paizaworkbook.com/

## 制作の背景

以前、[AtCoder](https://atcoder.jp/?lang=ja)や[Codeforces](https://codeforces.com/)などのコンテストサイトで、競技プログラミングに取り組んでいました。それらのサイトにあった、問題を絞り込んだり、進捗を把握したりする機能がPaizaには無く、少し不便に感じたので、自分で作ってみることにしました。

## 機能一覧

- 問題一覧の表示
  - https://paiza.jp/challenges/ranks/d/infoなどからスクレイピングしています。
- 解いた問題の取得
  - フォームからPaizaに登録してあるメールアドレスとパスワードを送信すると、マイページ(https://paiza.jp/career/mypage/results)から解いた問題を取得します。
- 問題絞り込み機能
  - ランク(S、A、B、C、D)で絞り込み
  - 難易度での絞り込み
  - 解いた問題の非表示
- 問題ソート機能
  - 問題名以外のカラムでソート可能
- 進捗把握機能
  - 各ランクごとに円グラフで、解いた割合を表示
  - 難易度200区切りの表で、解いた問題数を表示

## 