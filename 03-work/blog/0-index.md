# ブログ記事一覧

Qiita / Zenn 向けの技術記事を管理しています。

記事の追加・削除や `published` プロパティの変更は、下の Bases ビューに自動反映されます。

## 記事一覧

```base
filters:
  and:
    - file.ext == "md"
    - or:
        - file.inFolder("03-work/blog/qiita")
        - file.inFolder("03-work/blog/zenn")
formulas:
  status: 'if(published, "公開済み", "下書き")'
  platform: 'if(file.folder.contains("qiita"), "Qiita", "Zenn")'
properties:
  file.name:
    displayName: 記事
  formula.platform:
    displayName: プラットフォーム
  published:
    displayName: 公開
  formula.status:
    displayName: ステータス
  topics:
    displayName: トピック
  file.mtime:
    displayName: 更新日
views:
  - type: table
    name: すべて
    order:
      - file.name
      - formula.platform
      - published
      - formula.status
      - topics
      - file.mtime
    sort:
      - property: file.mtime
        direction: DESC
    groupBy:
      property: formula.platform
      direction: ASC
    summaries:
      published: Checked
  - type: table
    name: Qiita
    filters:
      and:
        - file.inFolder("03-work/blog/qiita")
    order:
      - file.name
      - published
      - formula.status
      - topics
      - file.mtime
    sort:
      - property: file.mtime
        direction: DESC
  - type: table
    name: Zenn
    filters:
      and:
        - file.inFolder("03-work/blog/zenn")
    order:
      - file.name
      - published
      - formula.status
      - topics
      - file.mtime
    sort:
      - property: file.mtime
        direction: DESC
  - type: table
    name: 公開済み
    filters:
      and:
        - published == true
    order:
      - file.name
      - formula.platform
      - published
      - formula.status
      - topics
      - file.mtime
    sort:
      - property: file.mtime
        direction: DESC
  - type: table
    name: 下書き
    filters:
      and:
        - published != true
    order:
      - file.name
      - formula.platform
      - published
      - formula.status
      - topics
      - file.mtime
    sort:
      - property: file.mtime
        direction: DESC
```

### ビューの使い方

| ビュー | 内容 |
| ------ | ------ |
| **すべて** | Qiita / Zenn 全記事（プラットフォームでグループ化） |
| **Qiita** | `03-work/blog/qiita` 配下のみ |
| **Zenn** | `03-work/blog/zenn` 配下のみ |
| **公開済み** | `published: true` の記事のみ |
| **下書き** | 未公開（`published` が true でない）記事のみ |

### 運用メモ

- 記事は `qiita/` または `zenn/` 配下に置く
- 各記事の frontmatter に `published: true` / `false` を設定する
- テーブル上の「公開」チェックボックスからも直接編集できる
- コアプラグイン Bases が有効であること
