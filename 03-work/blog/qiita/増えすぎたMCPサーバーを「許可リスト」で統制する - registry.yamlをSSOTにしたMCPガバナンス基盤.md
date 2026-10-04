---
title: 増えすぎたMCPサーバーを「許可リスト」で統制する - registry.yamlをSSOTにしたMCPガバナンス基盤
emoji: 📖
type: tech
topics:
  - MCP
  - ClaudeCode
  - AI
  - Renovate
  - ガバナンス
published: false
---

## TL;DR

- 社内で使う **MCP サーバーが 17 個**（AWS 系だけで 7 個）まで増え、Confluence 手動管理が破綻しかけた
- **`registry.yaml` を SSOT（唯一の正）にした専用リポジトリ**を作り、MCP の「種類・採用バージョン・役割」を一元管理。**この台帳を"許可リスト（allowlist）"として運用**し、「記載の無いサーバー／バージョン／使い方は使わない」を原則にした
- **PR レビュー導線**（`/mcp-review` スキル + チェックリスト）と **Renovate による自動バージョン更新 PR** で、属人的だった運用を仕組み化
- 権限は **allow / ask / deny の 3 段階ポリシー**で標準化。書き込み系は原則 `ask`（実行時確認）に倒す

## この記事の対象読者

- チームや組織で **MCP サーバーを複数運用**していて、管理が煩雑になってきた方
- 「どの MCP を・どのバージョンで・どんな権限で使ってよいか」を**統制**したい方
- AIエージェントの利用を、セキュリティ・ガバナンスの観点から整理したい方

:::message
本記事は **AI開発基盤シリーズ（全3回）の第2回**です。
1. [Claude Code と Codex の設定を1つのSSOTに統一する](#) — APMでエージェント設定を統一
2. **増えすぎたMCPサーバーを「許可リスト」で統制する**（本記事）
3. [API GatewayでSSEはできる、本当の壁はLambdaがPythonだったこと](#) — 生成AIランタイムの技術調査
:::

## 背景：MCP が 17 個に増えて、Confluence 管理が限界に

MCP（Model Context Protocol）は、AIエージェントに外部ツールやデータソースを接続する仕組みです。便利なので、気づけばどんどん増えます。私たちのチームでも、AWS 系（ドキュメント参照・API 操作・CloudWatch・DynamoDB・請求など 7 個）、Atlassian、Figma、Firebase、Playwright、Terraform……と、**17 個**まで膨らみました。

最初は Confluence のページで「使っている MCP の一覧とバージョン」を手動管理していました。しかし、数が増えるにつれ次の問題が噴出しました。

- **バージョン更新が属人的**で、最新化のタイミングが誰にも分からない
- **変更履歴（誰がいつ何の理由で入れたか）が追えない**
- **設定変更をレビューする導線がない**（勝手に増える）
- **似たスコープの MCP の棲み分け判断が個人依存**（特に AWS 系は紛らわしい）

さらに MCP はセキュリティ的にも無視できません。ファイルを削除できたり、認証情報を外部送信しうるものもあります。**「誰でも・どんな MCP でも・どんな権限でも使える」状態は、統制の観点で危うい**わけです。

そこで、MCP を**組織の資産として台帳管理する専用リポジトリ**を立てました。

## 解決策：registry.yaml を SSOT 兼「許可リスト」にする

中核は、機械可読な 1 ファイル **`registry.yaml`** です。ここに MCP サーバーの「種類・採用バージョン・役割（スコープ）」だけを一元管理します。

```yaml
# registry.yaml（抜粋）
schema_version: 1
servers:
  - id: apidog
    summary: 自社 API 仕様（OpenAPI）の検索・参照
    category: api-spec
    status: active
    ecosystem: npm
    package: apidog-mcp-server
    version: 0.0.17          # ← バージョンは固定（@latest 禁止）
    transport: stdio
    official: true
    source: https://docs.apidog.com/apidog-mcp-server
    docs: docs/servers/apidog.md

  - id: terraform
    summary: Terraform Registry の provider / module 仕様参照
    category: iac
    status: active
    ecosystem: docker
    package: hashicorp/terraform-mcp-server
    version: 1.0.0
    official: true
    notes: >-
      Public Registry 参照のみに限定するため --toolsets=registry で起動し、
      破壊的操作（ENABLE_TF_OPERATIONS）は無効のまま運用する。
```

ポイントは、**この台帳が単なる一覧ではなく「許可リスト（allowlist）」を兼ねる**ことです。

> **ここに記載の無いサーバー／バージョン／使用方法は使用しない。**

「使ってよい MCP」を明示的にホワイトリスト化する発想です。これにより「いつの間にか野良 MCP が増える」を防ぎます。

各エントリには `ecosystem`（npm / pypi / remote / git / local / docker）を持たせ、**バージョン管理対象かどうか**を機械的に区別しています。npm/pypi/docker はバージョン固定＆自動更新の対象、remote/local は対象外、といった具合です。

## 実装のポイント

### 1. JSON Schema でエディタ補完・検証

`registry.yaml` の冒頭に `# yaml-language-server: $schema=...` を書き、専用の [JSON Schema](https://json-schema.org/) を用意しました。エントリ追加時にエディタが補完・検証してくれるので、フォーマット崩れを防げます。「台帳を機械可読にする」効果はここで効きます。

### 2. すべての変更を PR + `/mcp-review` でレビュー

MCP の追加・更新・廃止は**すべて PR** で行い、レビュー観点をチェックリスト化しました。Claude Code のカスタムスキル `/mcp-review` がこのチェックリストを参照します。観点は大きく6つ。

```text
1. セキュリティ … 破壊的操作の可否、機密の外部送信、アクセス範囲、書き込み系は ask/deny か
2. 信頼性     … 公式/信頼できるソースか、メンテ継続（1年以上停止は却下）、採用実績
3. 機能性・棲み分け … 既存MCPと重複しないか（重複時は overlap.md に明記）
4. 互換性     … Node.js/Python バージョン、他MCPとの競合
5. バージョン管理 … @latest 禁止、Schema 準拠
6. 脆弱性     … OSV / GitHub Advisory で報告なしか
```

脆弱性チェックは具体的に、[OSV](https://osv.dev/) と [GitHub Advisory](https://github.com/advisories) を叩いて確認します。

```bash
# OSV Database で該当バージョンの脆弱性を確認
curl -s "https://api.osv.dev/v1/query" \
  -H "Content-Type: application/json" \
  -d '{"package":{"name":"<package-name>","ecosystem":"npm"},"version":"<version>"}'
```

「破壊的操作が無制限」「認証情報を外部送信」「1年以上メンテ停止」「脆弱性報告あり」のいずれかに該当したら**却下**、という明確な却下基準も設けています。

### 3. Renovate でバージョン更新を自動 PR 化

「バージョン更新が属人的」問題は **Renovate** で解決しました。毎週、`registry.yaml` の npm / PyPI パッケージと GitHub Actions を監視し、更新があれば**固定バージョンへ上げる PR を自動作成**します。

人間は「自動で作られた PR を、脆弱性・互換性の観点でレビューしてマージするだけ」。更新の起点が「気づいた人が手で調べる」から「CI が検出して PR を出す」に変わり、最新化が仕組みで回るようになりました。

### 4. 権限は allow / ask / deny の 3 段階で標準化

MCP ツールを副作用の有無で 3 段階に分けるポリシーを定めました。

| 区分 | 対象 | 例 |
| --- | --- | --- |
| **allow**（自動許可） | 副作用のない読み取り専用 | 検索・参照・一覧 |
| **ask**（実行時確認） | 作成・更新・削除・状態遷移 | issue 作成、リソース変更、書き込み |
| **deny**（禁止） | 復元不可能な破壊的操作 | 本番リソース削除 等 |

原則は**「書き込み・操作系は `ask` に倒す」「迷ったら安全側（ask）」**。たとえば Jira/Confluence を扱う MCP は機密情報を含み、MCP 側にスペース単位のスコープ制限が無いため、`allow` を一切置かず**参照系も含めて確認プロンプトに委ねる**、という判断にしています。

### 5. 紛らわしい MCP の棲み分けを明文化

AWS 系のように似たスコープの MCP が複数あると、「どれを使えばいいの？」が個人依存になります。これを `overlap.md` で明文化しました。

| MCP | スコープ | 棲み分け |
| --- | --- | --- |
| `aws-knowledge` | AWS 公式ドキュメント参照（読み取り・認証不要） | ドキュメント検索はこれ |
| `aws-api` | AWS API/CLI 相当の操作（認証必要） | 実リソース照会/操作はこれ |
| `aws-cloudwatch` | メトリクス/ログ参照 | 可観測性 |
| `aws-mcp` | 上記を統合した公式マネージド版 | 後継候補（統合を検討中） |

「`aws-api` があっても `aws-knowledge` は不要にならない（目的が違う）」といった判断指針まで書いておくことで、PR レビューの拠り所になります。

## ハマったところ・学び

### MCP 権限ルールに前方一致ワイルドカードは使えない

権限ポリシーを書くとき、「`mcp__atlassian__create*` で書き込み系をまとめて `ask` に」としたくなります。ところが Claude Code の仕様では、MCP ツールの権限ルールに使える書式は **2 つだけ**でした。

- `mcp__<server>__*`（そのサーバーの**全ツール**）
- `mcp__<server>__<完全一致のツール名>`（単一ツール）

`create*` のような**前方一致ワイルドカードはサポートされず**、読み込み時にスキップされます（`Invalid permission rule ... was skipped` の警告が出る）。

対策として、

- 読み取り系だけを `allow` したい場合は、**参照系ツール名を完全一致で列挙**する
- 確実に止めたいものは**完全一致名で `deny`** にする
- `ask` 側の `create*` は「意図を示す防御マーカー」として残すが、実効は `allow` 非該当ツールが従う既定の確認プロンプトに委ねる

と割り切りました。「書けるけど効かないルール」に気づかず安心してしまう罠があるので、要注意ポイントです。

### 「即削除」しない廃止フロー

MCP を廃止するときは、いきなり消さず `status: deprecated` にして移行期間を設けます。各リポジトリの設定から除去されたことを確認してからエントリを削除する。台帳が許可リストを兼ねるからこそ、状態遷移を丁寧にする必要がありました。

## 成果：Before / After

| 項目 | Before（Confluence 手動） | After（registry.yaml + PR + Renovate） |
| --- | --- | --- |
| 正の所在 | Confluence ページ（手動） | **`registry.yaml`（機械可読・Schema 検証）** |
| 変更履歴 | 追えない | **git の履歴で完全に追える** |
| レビュー | なし | **PR + `/mcp-review` 観点で必須** |
| バージョン更新 | 属人的・タイミング不明 | **Renovate が毎週自動 PR** |
| 使ってよい MCP | 暗黙 | **許可リストで明示（記載外は使わない）** |
| 権限設計 | 個人依存 | **allow/ask/deny の標準ポリシー** |
| 棲み分け判断 | 個人依存 | **`overlap.md` で明文化** |

Confluence は廃止せず、「本リポジトリへの入口リンク + 概要」として残すハイブリッド運用にしています。一次情報は git、周知は Confluence、という役割分担です。

## まとめ

- MCP が増えたら、**設定を台帳化して SSOT を 1 つに**する。`registry.yaml` を機械可読にし、JSON Schema で守る
- 台帳を**「許可リスト」として運用**すると、野良 MCP の増殖とバージョンの野放図さを同時に抑えられる
- **PR レビュー（`/mcp-review`）＋ Renovate 自動更新**で、属人的だった運用を仕組みに落とし込む
- 権限は **allow / ask / deny の 3 段階**で標準化し、書き込み系は `ask` に倒す。ただし**前方一致ワイルドカードは効かない**ので完全一致で書く

MCP は「便利だから入れる」フェーズから、「組織としてどう統制するか」のフェーズへ移りつつあります。AIエージェントを本格的にチームで使うなら、**MCP のガバナンス基盤**は早めに整えておく価値があります。同じように MCP が増えて困っている方の参考になれば幸いです。

## 関連記事（AI開発基盤シリーズ）

- 第1回: **Claude Code と Codex の設定を1つのSSOTに統一する - APMでAIエージェント設定をコード管理した話**
- 第3回: **API GatewayでSSEはできる、本当の壁はLambdaがPythonだったこと - 生成AIチャットのWebSocket→SSE移行 技術調査**

## 参考リンク

- [Model Context Protocol（MCP）公式](https://modelcontextprotocol.io/)
- [Claude Code - Permissions](https://code.claude.com/docs/en/permissions.md)
- [Renovate](https://docs.renovatebot.com/)
- [OSV（Open Source Vulnerabilities）](https://osv.dev/)
- [GitHub Advisory Database](https://github.com/advisories)
