# Qiita 記事一覧

このディレクトリには、Qiita に投稿する技術記事を管理しています。

記事の追加・削除や `published` プロパティの変更は、下の Bases ビューに自動反映されます。

## 記事一覧

![[qiita-articles.base]]

### ビューの使い方

| ビュー | 内容 |
| ------ | ------ |
| **すべて** | 全記事。`published` とステータス（公開済み / 下書き）を表示 |
| **公開済み** | `published: true` の記事のみ |
| **下書き** | 未公開（`published` が true でない）記事のみ |

### 運用メモ

- 各記事の frontmatter に `published: true` / `false` を設定する
- テーブル上の「公開」チェックボックスからも直接編集できる
- Bases 定義は [[qiita-articles.base]] を参照（コアプラグイン Bases が有効であること）
