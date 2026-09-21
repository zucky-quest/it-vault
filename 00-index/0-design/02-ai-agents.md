# AI エージェント設定（APM）

この Vault では、AI エージェント向けのルールと MCP（Model Context Protocol）設定を APM（Agent Package Manager）で管理します。

## 正本と生成物

設定の正本は、次のファイルとディレクトリです。

- `apm.yml`: APM プロジェクト、対象ツール、MCP サーバーの定義
- `.apm/`: 共通ルールなどの APM ソース
- `apm.lock.yaml`: APM の反映内容と生成物のハッシュを記録するロックファイル
- `.apm-version`: 使用する APM CLI のバージョン（現在は `0.31.0`）

APM によって次の生成先へ設定を配備します。

| 対象 | 生成先 | 用途 |
| --- | --- | --- |
| GitHub Copilot | `.github/instructions/` | Copilot の指示ファイル |
| Claude Code | `.claude/rules/` | Claude Code のルール |
| Cursor | `.cursor/rules/` | Cursor のルール |

`apm.yml` の `targets` には `copilot`、`claude`、`cursor`、`agent-skills` を指定しています。`agent-skills` は対象として宣言されていますが、現在の APM では MCP 設定の配備対象外です。

## MCP サーバー

現在は次の MCP サーバーを定義しています。

- `github`: GitHub 連携
- `context7`: ライブラリや技術情報の参照
- `serena`: コードベースの解析・編集支援
- `obsidian`: Obsidian Vault 連携

GitHub MCP では `GITHUB_PERSONAL_ACCESS_TOKEN`、Obsidian MCP では `OBSIDIAN_VAULT_PATH` を実行環境から参照します。認証情報や環境固有のパスはリポジトリへ保存しません。

## 再現性

再現性は次の三層で管理します。

1. `.apm-version` で APM CLI のバージョンを固定する
2. `apm.lock.yaml` で反映内容と生成物のハッシュを固定する
3. `apm audit` で生成物にドリフト（正本との差分）がないことを検査する

なお、`npx` や `uvx` で実行する MCP パッケージ自体の最新版更新は、APM CLI の固定とは別の管理対象です。厳密に依存バージョンを固定する場合は、各 MCP パッケージ側のバージョン指定も固定します。

## 変更手順

設定を変更した場合は、リポジトリのルートで次のコマンドを実行します。

```sh
# APM の生成物を各ツール向けに再生成する
make apm-sync

# 生成物と lockfile の整合性を検査する
make apm-verify
```

APM CLI が未導入の場合は、`.apm-version` の値に合わせて導入します。通常の利用者は生成済みの設定を使用するだけなので、APM CLI の導入は必須ではありません。

## Make ターゲット

| コマンド | 役割 |
| --- | --- |
| `make setup` | `uv` の存在を確認し、APM CLI の導入先を案内する |
| `make apm-install` | `apm.yml` と `.apm/` の設定を各ツールへ配備する |
| `make apm-compile` | APM の instruction からエージェント向け文書を生成する |
| `make apm-sync` | AI エージェント設定をまとめて再生成する |
| `make apm-verify` | 再生成・監査・差分確認を実行する |
| `make apm-orphan-check` | 供給元のない生成物を検出する |

生成先のファイルを直接編集すると、次回の `make apm-sync` で上書きされます。ルールを変更する場合は `.apm/` 側を編集してください。
