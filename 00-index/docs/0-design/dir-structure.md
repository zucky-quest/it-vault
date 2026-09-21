# ディレクトリ構造

この Vault は、知識の整理・学習記録・アウトプット・転職準備を一貫して管理するための構成です。役割ごとにフォルダを分けることで、メモの再利用と検索性を高めています。

```text
.
├── .apm/ (APM ソース: instructions, skills など)
├── .claude/ (Claude Code 向けデプロイ先 — apm install で生成)
├── .cursor/ (Cursor 向けデプロイ先 — apm install で生成)
├── .github/ (GitHub Copilot 向けデプロイ先 — apm install で生成)
├── .obsidian/ (Obsidian の設定・ビュー状態)
├── .vscode/ (ワークスペース設定・Copilot MCP)
├── apm.yml (APM マニフェスト)
├── apm.lock.yaml (APM ロックファイル)
├── 00-index/ (目次・全体設計・運用メモ)
│   ├── docs/ (設計書・運用ルール)
│   └── inbox/ (未整理のメモ)
├── 01-journal/ (日々の記録)
│   ├── 2025/
│   └── 2026/
├── 02-projects/ (資格学習・転職活動・個人プロジェクト)
│   ├── job-change/ (転職関連資料)
│   └── study-notes/ (学習メモ)
├── 03-work/ (成果物・アウトプット)
│   └── qiita/ (Qiita 記事)
├── 04-clippings/ (ウェブクリップ・参考記事)
├── 05-assets/ (画像・スクリーンショットなどの添付ファイル)
└── README.md (Vault の概要)
```

## 使い分けの基本方針

- `01-journal`: 日々の気づき・振り返り・ToDo を記録
- `02-projects`: 資格勉強・転職準備・学習の深掘り
- `03-work`: 技術ブログや記事の執筆
- `04-clippings`: 参考にした記事やインプットの保管
- `05-assets`: 画像や図等の添付ファイルの保管

- [Edit](https://tree.nathanfriend.com/)
