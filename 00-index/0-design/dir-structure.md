# ディレクトリ構造

この Vault は、学習・アウトプット・転職準備を一貫して管理するための構成です。役割ごとにフォルダを分けることで、情報の再利用と検索性を高めています。

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
│   ├── 0-design/ (設計方針や構造の説明)
│   ├── 1-operation/ (運用ルールや作業手順)
│   ├── inbox/ (未整理のメモ)
│   └── kanban.md (TODO 管理)
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
├── README.md (Vault の概要)
└── ...
```

## 役割の整理

- `00-index`: Vault 全体の入口と設計・運用の整理
- `01-journal`: 日々の思考・振り返り・ToDo
- `02-projects`: 資格勉強、転職準備、学習の深掘り
- `03-work`: ブログ記事や公開向けのアウトプット
- `04-clippings`: 参考にした記事やインプットの保管
- `05-assets`: 画像・図・スクリーンショットなどのファイル

この設計では、情報の種類ごとに保管先を分離しています。これにより、毎日の記録や学習メモ、公開用の文章、参考記事が混ざらず、再利用しやすくなります。

- [Edit](https://tree.nathanfriend.com/)
