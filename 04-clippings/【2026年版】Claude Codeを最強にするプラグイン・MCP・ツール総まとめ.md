---
title: "【2026年版】Claude Codeを最強にするプラグイン・MCP・ツール総まとめ"
source: "https://qiita.com/shatolin/items/ca1810e419fee5fd963b"
author:
  - "[[shatolin]]"
published: 2026-02-06
created: 2026-02-22
description: "Claude Codeがやってきた！ Claude Codeは2025年2月のリリース以来、ターミナルから直接AIにコーディングを任せられるツールとして広く使われるようになりました。 2025年10月にプラグインシステムが公開ベータになり、MCP（Model Contex..."
tags:
  - "clippings"
---
![](https://relay-dsp.ad-m.asia/dmp/sync/bizmatrix?pid=c3ed207b574cf11376&d=x18o8hduaj&uid=1990032)

## Claude Codeがやってきた！

Claude Codeは2025年2月のリリース以来、ターミナルから直接AIにコーディングを任せられるツールとして広く使われるようになりました。  
2025年10月にプラグインシステムが公開ベータになり、 **MCP（Model Context Protocol）サーバー** による外部ツール連携も増えたことで、単なるAIチャットではなく開発の中核ツールとしてのポジションを確立しつつあります。

本記事では、Claude Codeのエコシステムを **MCPサーバー** 、 **プラグイン** 、 **周辺ツール** の3カテゴリに分けて、よく使われている定番ツールをまとめて紹介します。

2026年2月時点で9,000以上のプラグインが公開されており、エコシステムは日々拡大しています。本記事では利用者が多く、実用性の高いものを中心に取り上げています。

## MCPってそもそも何？

**Model Context Protocol（MCP）** はAnthropicが策定したオープンプロトコルで、AIモデルが外部ツールやデータソースと安全に通信するための標準規格です。

MCPサーバーを接続すると、たとえばこんなことが自然言語で指示できます

- 「JIRAチケット1234の機能を実装して、GitHubにPRを作成して」
- 「チケットのエラーを確認して、修正できそうなものを直して」
- 「DBから先月の売上をカテゴリ別に集計して」

### MCPサーバーの追加方法

```bash
# HTTP（リモート）サーバーの追加（推奨）
claude mcp add --transport http github https://api.github.com/mcp

# SSEサーバーの追加
claude mcp add --transport sse sentry https://mcp.sentry.dev/sse

# stdioサーバーの追加（ローカル実行）
claude mcp add --transport stdio context7 -- npx -y @upstash/context7-mcp

# サーバー一覧の確認
claude mcp list

# Claude Code内でステータス確認
/mcp
```

### スコープの使い分け

| スコープ | 対象 | 保存先 | 用途 |
| --- | --- | --- | --- |
| `local` （デフォルト） | 現在のプロジェクト | `.claude.json` | プロジェクト固有のツール |
| `project` | プロジェクト共有 | `.mcp.json` | チームで共有したいツール |
| `user` | 全プロジェクト共通 | `~/.claude.json` | 常に使いたいツール |

## 定番MCPサーバー

### Tier 1：ほぼ必須級

#### 1\. GitHub MCP Server

**GitHub公式連携**

GitHub公式のMCPサーバー。リポジトリ管理、PR作成、Issue操作、CI/CDワークフローをClaude Codeから直接操作できます。OAuth認証対応でAPIキーの手動管理も不要。

```bash
claude mcp add --transport sse github https://api.github.com/mcp
```

**できること：** PR作成・レビュー、Issue管理、ブランチ操作、CI/CDステータス確認

#### 2\. Context7 MCP

**最新ドキュメント参照**

ライブラリやフレームワークの最新ドキュメントをプロンプトに自動注入してくれます。Claude Codeが古い情報をもとに間違ったコードを吐く問題を防げるので、地味ですが効果は大きいです。

```bash
claude mcp add context7 -s user -- npx -y @upstash/context7-mcp
```

**できること：** 最新のAPIドキュメントを参照したコード生成、バージョン間の差異の把握

#### 3\. Playwright MCP

**ブラウザ自動化・テスト**

ブラウザの操作やテストをClaude Codeから自動化できます。E2Eテストの作成やUIのスクリーンショット取得で重宝します。

```bash
claude mcp add playwright -s project -- npx -y @playwright/mcp@latest
```

**できること：** E2Eテスト自動化、スクリーンショット取得、Webスクレイピング

#### 4\. Sentry MCP

**エラー監視**

Sentryと連携して、プロジェクトのエラーやパフォーマンス問題を取得し、Claude Codeでそのまま修正まで持っていけます。

```bash
claude mcp add --transport sse sentry https://mcp.sentry.dev/sse
```

**できること：** エラー一覧の取得、スタックトレース分析、修正コードの生成

### Tier 2：用途に応じて入れたい

#### 5\. Firecrawl

**Webデータ取得**

任意のWebサイトをクリーンなMarkdownやLLMが扱いやすい形式に変換。JSレンダリングが必要なページにも対応しており、従来のスクレイピングで起きがちな問題を回避できます。

**できること：** Webページの取得・変換、サイトクロール、競合調査

#### 6\. PostgreSQL MCP

**データベース連携**

自然言語でSQLクエリを実行できます。「先月の売上をカテゴリ別に集計して」と言うだけでクエリが走ります。

**できること：** 自然言語→SQL変換、データ分析、スキーマ確認

#### 7\. Linear MCP

**プロジェクト管理連携**

Linearのチケットをコーディングフロー内で直接操作。チケットの取得→実装→ステータス更新がシームレスにつながります。

**できること：** チケット取得・作成・更新、スプリント管理、サブタスク分解

#### 8\. Brave Search MCP

**Web検索**

Claude CodeにWeb検索機能を追加します。最新情報の調査やファクトチェックに。

```bash
claude mcp add brave-search -s user -- npx -y @anthropic/mcp-brave-search
```

#### 9\. Memory MCP / Memory Bank

**永続メモリ**

ナレッジグラフベースの永続メモリ。長期プロジェクトで過去の会話や決定事項をClaude Codeに覚えさせておけます。

**できること：** 過去のコンテキスト保持、プロジェクト知識の蓄積

### その他の注目MCPサーバー

| サーバー名 | 用途 | 一言コメント |
| --- | --- | --- |
| **Markitdown MCP** | PDF/pptx等→Markdown変換 | ドキュメント読み込みに便利 |
| **YouTube MCP** | YouTube字幕取得・要約 | 動画の内容調査に |
| **Figma MCP** | デザインデータ→コード変換 | Figmaデザインからコンポーネント生成 |
| **Slack MCP** | Slack連携 | チャンネル参照・メッセージ送信 |
| **Backlog MCP** | Backlog連携 | 日本のチームに人気 |
| **AWS MCP Servers** | AWS各種サービス連携 | CDK/Bedrock/S3等 |
| **Firebase MCP** | Firebase連携 | モバイル・Web開発向け |
| **Zapier MCP** | マルチサービス自動化 | 500+サービスとの連携ハブ |
| **Puppeteer MCP** | ヘッドレスブラウザ | スクレイピング・UI確認 |

## 定番プラグイン

2025年10月のプラグインシステム公開以降、Claude Codeではスラッシュコマンド、サブエージェント、フック、MCPサーバーをパッケージとして配布・共有できるようになりました。

### メモリ系（いま最も注目されている領域）

Claude Codeを使っていて多くの人がぶつかるのが **「セッション間のコンテキスト消失」** 問題です。昨日あれだけ説明したプロジェクト構成も、セッションを閉じたら全部消える。毎朝「DBはMySQLじゃなくてPostgresだって」と説明し直す、いわゆる"おじいちゃんさっき食べたでしょ問題"は開発者あるあるでしょう。

2026年に入って、この問題を解決するメモリ系プラグインが一気に盛り上がっています。

#### Claude-Mem（話題沸騰中）

**GitHub ★20,000超 — 2026年2月時点で勢いのあるプラグイン**

セッション中にClaudeが行ったすべてのツール使用を自動キャプチャし、Agent SDKでAI圧縮してセマンティックな要約を生成。次回セッション開始時に関連コンテキストを自動で差し込んでくれます。

```bash
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem
```

**特徴**

- **5つのライフサイクルフック** で自動記録（SessionStart → UserPromptSubmit → PostToolUse → Summary → SessionEnd）
- **3層の段階的検索** でトークン効率10倍（手動コンテキスト管理比）
- SQLite + ChromaベクトルDBによるセマンティック検索
- Web UIビューア（ `http://localhost:37777` ）で過去の記録を閲覧・検索
- **Endless Mode** （ベータ）：長時間セッション向けのバイオミメティックなメモリアーキテクチャ

**向いているケース：** 数週間〜数ヶ月に渡る長期プロジェクト、複雑なコードベース、頻繁にセッションが中断する環境

ライセンスはAGPL-3.0です。企業環境ではコピーレフト条項の確認をお忘れなく。

**どこから始めるか：** まずは標準の `CLAUDE.md` で運用してみて、コンテキスト消失がつらくなってきたらClaude-Memを入れるのが良いです。シンプルなプロジェクトなら `CLAUDE.md` だけで十分なことも多いです。他にもSupermemory（クラウド型）やMemory Bank（ファイルベース型）といった選択肢もあります。

### 開発ワークフロー系（急成長中）

#### Superpowers（★43,000超）

**開発方法論をまるごとプラグインにしたもの**

2026年1月にAnthropic公式マーケットプレイスに採択。AI tooling界で知られるSimon Willisonが作者のJesse Vincent氏を「私が知る限り、コーディングエージェントを最も創造的に活用しているユーザーの一人」と評したことでも注目を集めました。

Superpowersは単なるツール集ではなく、 **ソフトウェア開発のワークフローそのもの** をClaude Codeに組み込むプラグインです。以下の7フェーズで構成されています

1. **ブレインストーミング** — いきなりコードを書かず、対話で要件を深掘り
2. **詳細な設計仕様の策定**
3. **実装計画の作成**
4. **TDD（テスト駆動開発）**
5. **サブエージェント駆動開発**
6. **コードレビュー**
7. **統合・検証**

```bash
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

使い方の例

```bash
# Superpowersのワークフローを有効化
/using-superpowers

# 計画を立てる
/superpowers:write-plan

# 計画を実行（サブエージェントが並列で動く）
/superpowers:execute-plan
```

普通にClaude Codeを使うと「とりあえずコードを書く→不完全→手戻り」になりがちですが、Superpowersは **計画→テスト→実装の順番を強制する** ので、出力の品質がかなり上がります。数時間の自律作業でも計画から外れにくいのが一番の強みです。

完全無料のOSS（MITライセンス）。Anthropic製ではなくJesse Vincent氏によるコミュニティプロジェクトです。

#### Ralph Wiggum Loop（Anthropic公式リポジトリ入り）

**「完了するまで自分の出力を自分に食わせ続ける」自律ループ**

シンプソンズのラルフ・ウィガムにちなんだ名前のこの手法は、Geoffrey Huntley氏が考案しました。やっていることは **「while trueのbashループでAIに自分の出力を食わせ続ける」** という力技です。

Claude Codeは「まあこれでいいか」と判断した時点で止まってしまう傾向があります。Ralph Loopはその早期終了をフックで防ぎ、タスクが本当に完了するまで何度でも反復させます。

```bash
# 1回実行するだけ。あとはClaude Codeが自律的にループする
/ralph-loop "Feature Xを実装して" --max-iterations 20 --completion-promise "DONE"

# Claude Codeが自動的に
# 1. タスクに取り組む
# 2. 終了しようとする
# 3. Stopフックが終了をブロック
# 4. 同じプロンプトを再投入
# 5. 完了条件を満たすまで繰り返し
```

Y Combinatorのスタートアップで広く使われており、Claude Codeの生みの親であるBoris Cherny氏も使用を公言しています。The Register等の海外メディアにも取り上げられました。

Huntley氏いわく、AIコーディングは **時給約$10のコンピュート費用** で回せる。ファストフード店員の時給に近いコストでソフトウェア開発の一部が自動化できるわけで、SaaS業界への影響は小さくないだろう、とのこと。

ループはトークンを大量に消費します。必ず `--max-iterations` で上限を設定し、行き詰まった場合の指示もプロンプトに含めておきましょう。

### コードレビュー・品質管理系

#### code-review / pr-review-toolkit

複数の専門エージェント（バグ検出、テスト分析、型設計分析、コード品質等）を並列で走らせてPRレビューを自動化。 `/code-review` や `/pr-review-toolkit:review-pr` で起動します。

#### TDD Guard

テスト駆動開発を強制するプラグイン。多言語対応で検証ルールのカスタマイズも可能です。

### 開発支援系

#### dev-toolkit

セキュリティスキャン（ `/security-scan` ）、テスト実行（ `/test` ）、コードレビューなどをまとめた総合ツールキット。

#### ccpm

**Claude Code向けプロジェクト管理ツール。** GitHub Issues + Git worktreeを組み合わせて、タスク管理とブランチ運用をClaude Code内で完結させます。

### ユーティリティ系

#### CC Usage

トークン使用量とAPIコストをリアルタイムで表示。コスト管理に便利です。

#### Context Logger

セッション中のClaudeの行動を自動記録・圧縮し、次回セッションに関連コンテキストを差し込みます。

## 周辺ツール・拡張

Claude Code本体と組み合わせてよく使われる周辺ツールです。

| ツール名 | カテゴリ | 説明 |
| --- | --- | --- |
| **Repomix** | コンテキスト準備 | リポジトリ全体を1ファイルにまとめてLLMに渡せる形式に変換 |
| **claude-code.nvim** | エディタ統合 | Neovimとの統合 |
| **Cursor** | エディタ統合 | VS Code派生。ネイティブMCPサポート |
| **Cline** | エディタ統合 | VS Code拡張。MCP対応のAIコーディング |
| **Claudia** | GUI | Claude Code用GUIツールキット。エージェント管理・使用量分析 |
| **ccflare** | ダッシュボード | 使用量のWeb UIダッシュボード |
| **CC Statusline** | ターミナル表示 | ステータスラインのカスタマイズ（コンテキスト使用率等の表示） |

## おすすめの初期セットアップ

Claude Codeを導入したらまず入れておきたい構成の例です。

### 最小構成（個人開発）

```bash
# 最新ドキュメント参照
claude mcp add context7 -s user -- npx -y @upstash/context7-mcp

# ブラウザテスト
claude mcp add playwright -s project -- npx -y @playwright/mcp@latest

# Web検索
claude mcp add brave-search -s user -- npx -y @anthropic/mcp-brave-search
```

### チーム開発向け追加構成

```bash
# GitHub連携
claude mcp add --transport sse github https://api.github.com/mcp

# エラー監視
claude mcp add --transport sse sentry https://mcp.sentry.dev/sse

# プロジェクト管理（Linearの場合）
claude mcp add --transport sse linear https://mcp.linear.app/sse
```

### CLAUDE.mdに書いておくと便利な設定例

```markdown
# 基本方針
- 必ず日本語で応対してください
- 調査やデバッグにはサブエージェントを活用してコンテキストを節約してください
- 重要な決定事項は定期的にマークダウンファイルに記録してください

# コード規約
- TypeScriptを使用
- テストはVitestで書く
- コミットメッセージは日本語で簡潔に
```

## Tips：コンテキスト節約のコツ

MCPサーバーやWeb検索を多用すると、大量の情報がコンテキストを食います。以下が効果的です。

1. **サブエージェントに任せる** — 調査タスクをサブエージェントに委任し、要約だけメインセッションに返してもらう
2. **MCP Tool Searchを有効にする** — 必要なときだけツールを遅延読み込みして、コンテキスト使用量を最大95%削減
3. **スコープを適切に分ける** — 全プロジェクトで使うものは `user` 、特定プロジェクトだけのものは `local` か `project` に

## まとめ

Claude Codeのエコシステムは、MCPサーバー・プラグイン・周辺ツールの3層で構成されています。

| レイヤー | 役割 | 代表例 |
| --- | --- | --- |
| **MCPサーバー** | 外部ツール・データソースとの接続 | GitHub, Context7, Playwright, Sentry |
| **プラグイン** | ワークフローのカスタマイズ・共有 | Superpowers, Claude-Mem, Ralph Loop, Legal Plugin |
| **周辺ツール** | エディタ統合・可視化 | Repomix, claude-code.nvim, Claudia |

2026年2月現在のトレンドとしては

1. **メモリ基盤** - Claude-Memの爆発的人気が示す通り、「セッション間の記憶」が最重要テーマ
2. **構造化ワークフロー** - Superpowersのように「いきなりコードを書かない」やり方が広まっている
3. **自律ループ** - Ralph Loopに代表される「完了まで自律的に繰り返す」パターン
4. **業種特化** - Coworkプラグインが切り開いた、コーディング以外の領域への展開

まずはContext7 + Playwright + GitHubあたりから始めて、必要に応じてSuperpowersやClaude-Memを足していくのがおすすめです。

エコシステムは日々動いているので、 [Claude Code公式プラグインリポジトリ](https://github.com/anthropics/claude-code/tree/main/plugins) や [awesome-claude-code-plugins](https://github.com/ccplugins/awesome-claude-code-plugins) も定期的にチェックしてみてください。

---

**参考リンク**

- [Claude Code公式ドキュメント - MCP](https://code.claude.com/docs/ja/mcp)
- [Claude Codeプラグイン公式ブログ](https://www.anthropic.com/news/claude-code-plugins)
- [awesome-claude-code-plugins](https://github.com/ccplugins/awesome-claude-code-plugins)
- [awesome-claude-plugins（採用メトリクス付き）](https://github.com/quemsah/awesome-claude-plugins)

[0](https://qiita.com/shatolin/items/#comments)

コメント一覧へ移動

X（Twitter）でシェアする

Facebookでシェアする

はてなブックマークに追加する

[308](https://qiita.com/shatolin/items/ca1810e419fee5fd963b/likers)

いいねしたユーザー一覧へ移動

298