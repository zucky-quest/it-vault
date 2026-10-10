---
title: "yomiyasu - AI Agents on GitHub (1.8k★)"
source: "https://skillsllm.com/skill/yomiyasu"
author:
  - "[[SkillsLLM]]"
published:
created: 2026-10-10
description: "AI生成の日本語を自然な日本語へ推敲するAgent Skill / Agent Skill for Refining AI-Generated Japanese into Natural Japanese. Open-source AI Agents skill on GitHub with 1.8k★...."
tags:
  - "clippings"
---
## yomiyasu

Verified

AI生成の日本語を自然な日本語へ推敲するAgent Skill / Agent Skill for Refining AI-Generated Japanese into Natural Japanese

1,763stars

40forks

Python

Added 9/30/2026

⚠️ Third-Party Software Notice

This skill is third-party open-source software developed and hosted independently on GitHub. SkillsLLM is an informational directory and does not control or maintain the underlying repository.

Any security checks, ratings, or warnings displayed by SkillsLLM are automated and limited in scope. They do not constitute a security certification or guarantee that the software is safe, error-free, or free from malicious code, vulnerabilities, compromised dependencies, or prompt-injection risks.

Review the source code, permissions, dependencies, and configuration before installing or running any third-party skill. Use is at your own risk. To the maximum extent permitted by applicable law, SkillsLLM is not liable for losses arising from third-party software.

[Read the Terms of Service](https://skillsllm.com/terms)

[AI Agents](https://skillsllm.com/category/ai-agents) agent-skillsai-writingantigravityclaude-codecodexcursorgeminijapaneselinterllmnlpwritingwriting-assistantwriting-tool

```
# Add to your Claude Code skills
git clone https://github.com/nanaism/yomiyasu
```

Getting Started

Guides for using ai agents skills like yomiyasu.

- [
	Caveman: Cut Claude Token Use by 65%
	How agent-side prompt compression works, when to use it, and when not to.
	](https://skillsllm.com/blog/caveman-token-compression-claude-code)
- [
	What is an AI Skills Marketplace?
	Definitions, how marketplaces work, and how to choose between them in 2026.
	](https://skillsllm.com/blog/what-is-ai-skills-marketplace)
- [
	Getting Started with AI Skills
	First-time install walkthrough for Claude Code, Codex CLI, and ChatGPT.
	](https://skillsllm.com/blog/getting-started-with-ai-skills)

Last scanned: 10/1/2026

```
{
  "issues": [],
  "status": "PASSED",
  "scannedAt": "2026-10-01T10:44:19.905Z",
  "npmAuditRan": true,
  "pipAuditRan": true,
  "promptInjectionRan": true
}
```

README.md

## yomiyasu（よみやす）

[![GitHub release](https://img.shields.io/github/v/release/nanaism/yomiyasu)](https://github.com/nanaism/yomiyasu/releases)

## これは何？

『 **yomiyasu（よみやす）** 』は、AIが生成した日本語の不自然な比喩、曖昧な主述関係、不要な装飾を直し、読みやすい文章に整えるスキルです。

主に技術記事、設計書・仕様書、PR説明文、社内レポートなどの実務的な文章を対象として設計されています。

Codex、Claude Code、CursorをはじめとするAIコーディング環境に読み込ませて使用してください。

開発の背景、AI生成文の読みにくさ、コーパスを使った検証については、次の解説記事で紹介しています。

- **解説記事**: [AI-Slopな日本語を構造レベルで読みやすくするSkill『yomiyasu（よみやす）』を作りました（Zenn）](https://zenn.dev/algoartis/articles/0b1c731881b25c)

*Built with curiosity at [ALGO ARTIS](https://www.algo-artis.com/)*

[![ALGO ARTIS](https://skillsllm.com/skill/assets/algo-artis.png)](https://www.algo-artis.com/)

> 株式会社ALGO ARTISは、社会基盤の最適化に取り組むスタートアップです。
> 
> 電力・海運・化学プラントといった現場では、膨大な制約が絡み合う複雑な運用計画を、今なお熟練者が手作業で組み立てています。
> 
> そうした高度な現場業務を数理モデル化し、実用的なヒューリスティック最適化アルゴリズムと業務システムを一貫して開発しています。
> 
> 最適化技術を用いた社会インフラの変革に興味がある方は、 [公式ウェブサイト](https://www.algo-artis.com/) や [採用情報](https://www.algo-artis.com/career/) をご覧ください。

## 背景と課題

AIによる文章生成は日常的な道具となりました。 一方で、AIで生成された文章には独特のクセが残りやすく、そのままでは実務や技術発信に使いにくい場面が多くあります。

これまでに様々な文体調整プロンプトやスキルが試みられてきましたが、依然として「AI特有の読みにくさ」が残るケースが見られます。

従来のアプローチが抱えていた限界は、主に次の4点でした。

1. 禁止語の置き換えにとどまる対処 手触りや解像度、泥臭いといった表層の単語を禁止しても、別の曖昧な語へ置き換わるだけで、不自然な文構造そのものは解消されませんでした。
2. 編集ルールの過剰適用 修辞規範を過度に与えると、モデルが指示を過剰に解釈し、かえって不自然な造語や大げさな文体を招いていました。
3. 主述関係の曖昧さと非生物主語 誰が何をどうするのかが省略されたまま、概念や道具が比喩的な動詞（壊れる、倒す、効くなど）と結びつき、読み手側で過剰な文脈補完が必要でした。
4. 形式の偏重と情報密度の低下 太字や箇条書きが増加する一方で、手順やコードの仕組みといった核心部分が抽象化され、文章量に対して実質的な情報が希薄化していました。

## 本スキルのアプローチ

元の意味を保ち、読み違いや文の関係を追う負担がある箇所を直します。自然に読める部分は残します。

### 7つの変換原則

1. 主述・修飾・条件の点検 主語と述語、修飾語と掛かる先、指示語と指す対象を対応づけます。条件・例外・否定・並列・数量・順序も、書き直す前後で同じように追えるか確かめます。主体や対象を補うのは、原文や提供文脈から確定できる範囲に限ります。
2. 文の働きと文体の保持 文ごとの説明・依頼・助言・予定を区別し、働きに合わない文末だけを直します。完了した変更作業、現在の動作や方針、今後の予定を時制と役割に合わせて書き分け、語尾を散らすこと自体を目的にしません。変更指定がない常体・敬体は保ち、技術記事という分野だけで敬体へ変えません。
3. 擬人化の整理 道具や概念に感情や意志を持たせた表現を直します。道具やシステムの客観的な動作を述べる非生物主語は残します。
4. 比喩を平易な言葉へ `壊れる` 、 `倒す` 、 `効く` 、 `溶かす` などを、元の含みや意味の広さを保って言い換えます。動詞を替えた後も、主体・対象・修飾先を変えず、語順を追いやすくできるか確かめます。
5. 前置き・否定対比の役割の確認 前置きを削るのは、削っても主張や比重が変わらない場合だけです。評価や必要な対比、比較から方針へ移る接続は残します。
6. 情報を勝手に足さない 主張・比重・言い切りの強さ・文の働きを保ち、原文にない主体・原因・条件・数値・感情などを足しません。ルールを「契約」、比較の基準を「正本」と大げさに呼ぶ場合は役割に合う語へ直し、文字どおりの意味や定義済みの専門用語は保ちます。意味を確定できない箇所は、原文にある未確定の状態や既知の動作を本文に残した暫定文とし、推敲理由や確認事項は読者向け本文中ではなく本文の後に添えます。
7. 文長・読点・装飾の調整 平均文長30〜45文字、1文の読点0〜2個を目安にします。読みやすい原文の読点を、数や見た目だけで削りません。不要な文末コロンと、ラベルと値の対応を示すコロンを区別します。過剰な装飾記号を整理し、英単語や数値の前後の空白は元の書式や指定されたスタイルを保ちます。残す太字は表示される形に整えます。

## Before → After 例

### 例1: 業務・仕様解説

#### Before

> ここで **重要なのは、単なるパーツの共通化ではなく、組織の意思決定OSとしてのガバナンス** です。
> 
> 従来の開発では、画面ごとに手触り感を探りながらパーツを作っていました。しかし、片方だけを見て画面を作ると、もう片方のアクセシビリティが **静かに壊れます** 。そこでデザインシステムという **強固な土台** を置くことで、開発者の **解像度が一段上がります** 。
> 
> デザインシステム導入のメリットは、主に次の3点です。
> 
> - **開発速度の加速**: コンポーネントを再利用することで、時間を溶かさずに済みます。
> - **仕様の収斂**: 判断に迷うスタイルは、あらかじめ **共通側に倒します** 。
> - **アクセシビリティの担保**: ガイドラインが規律を要求するため、事故を未然に防ぐことができます。
> 
> もちろん、これは「デザイナーが不要になる」ことを意味しません。日々の開発に **地味に効いてきます** 。ぜひ参考にしてみてください！

#### After

> デザインシステムを導入する目的は、ボタンや入力欄などのUIパーツを一から作成する負担を減らし、画面全体の情報設計に集中することにあります。
> 
> 各コンポーネントの見た目やアクセシビリティ要件があらかじめ定義されていれば、デザイナーと開発者はコードの記述や画面遷移の実装を円滑に進められます。スタイルの指定に迷った場合でも、定義済みの標準コンポーネントを選択すれば表示の不整合を防ぐことが可能です。
> 
> 導入によってデザイン作業そのものが不要になるわけではありません。しかし、単純なパーツ作成にかかる工数を削減することで、本来注力すべき使い勝手の検証や品質向上に時間を充てられるようになります。結果として、利用者が迷わず操作できる高品質な行政サービスの提供につながります。

#### 変更説明

比喩動詞（ `静かに壊れる` 、 `共通側に倒す` 、 `地味に効く` 、 `時間を溶かす` ）を直接的な操作や状態変化へ修正しました。また、 `手触り感` 、 `意思決定OS` 、 `解像度` といった曖昧な流行語を排除し、具体的な作業内容を記述しています。不要な太字や過度な箇条書きを抑え、前後のつながりが自然な地の文へ再構築しました。

### 例2: 技術解説

#### Before

> 非同期処理における **最大の落とし穴** は、ネットワークの瞬断です。
> 
> **依存構造は分割できない。動かしながら引き返す。**
> 
> 単にメッセージを流すだけでは、背後でデータが **静かに壊れます** 。前提を、経路が代わりに添えてくれるわけではありません。
> 
> そこで **地味に効いてくる** のが、以下の3つの原則です。
> 
> - **冪等性の担保**: 重複した処理は **黙ってスキップ** します。
> - **安全なリトライ**: 指数バックオフを挟むことで、DBの負荷を逃がします。
> - **DLQへの退避**: 破綻したメッセージは隔離し、原因を1つずつ **潰していきます** 。
> 
> デバッグで丸一日 **時間を溶かさない** ためにも、この境界線を意識した設計が不可欠です。いかがでしたでしょうか。

#### After

> 非同期キューを用いたメッセージ処理では、通信の切断やサーバーの再起動によって処理が中断されるおそれがあります。メッセージの二重送信が発生しても不整合を起こさないよう、受信側のプログラムで冪等性を担保する設計が不可欠です。
> 
> 具体的な対策として、メッセージの固有IDをデータベースに記録し、同一IDをすでに処理済みであれば追加処理を行わずに終了します。外部APIの呼び出しに失敗した場合は、待機時間を徐々に延ばしながら再試行し、規定回数を超えて失敗したデータはデッドレターキュー（DLQ）へ退避して手動調査に回す構成をとります。エラー時の復旧手順をあらかじめ決めておけば、障害発生時にも迅速な原因究明が可能です。

#### 変更説明

`前提を経路が添える` や `依存構造は分割できない` といった主語のない抽象文を解体し、動作主と対象を明記しました。あわせて `黙ってスキップ` 、 `潰していく` 、 `時間を溶かす` を正確な技術用語や操作へ置き換えています。冒頭と末尾にあった不要な煽り文句や定型文（ `最大の落とし穴` 、 `いかがでしたでしょうか` ）も削除しました。

## インストール

### 1\. npx skills add（推奨）

```bash
# 新規インストール
npx skills add nanaism/yomiyasu

# 最新版へのアップデート
npx skills update yomiyasu
```

Claude Codeなどのエージェント設定ディレクトリへインストール・更新します。すでに導入済みの場合は `npx skills update yomiyasu` で最新版へ更新できます。スキル定義は `skills/yomiyasu/SKILL.md` の1か所に配置しています。

### 2\. GitHub CLI

GitHub CLIの `gh skill` コマンドからインストールできます。

```bash
# 新規インストール
gh skill install nanaism/yomiyasu yomiyasu

# 最新版へのアップデート
gh skill update yomiyasu
```

導入先のエージェントを指定する場合は、 `--agent codex` や `--agent claude-code` を追加してください。

### 3\. npx openskills install

```bash
# 新規インストールとAGENTS.mdへの反映
npx openskills install nanaism/yomiyasu
npx openskills sync

# 最新版へのアップデートとAGENTS.mdへの反映
npx openskills update yomiyasu
npx openskills sync
```

`AGENTS.md` を経由して各エージェントから利用できるようになります。通常のルート指定で導入した環境はそのまま更新・同期できます。過去にネストされたパスを明示指定してインストールした環境では自動再配置が行われないため、元のインストール先やオプションに合わせて `npx openskills install nanaism/yomiyasu` を再実行してメタデータを更新したあと、更新や同期を行ってください。

### 4\. Claude Code プラグイン

```
/plugin marketplace add nanaism/yomiyasu
/plugin install yomiyasu@yomiyasu
```

プラグインマニフェストではスキルの配置先（ `"skills": "./skills/"` ）を明示的に指定しています。

導入済みのプラグインを最新版へ更新する場合は、ターミナルで次のコマンドを実行します。

```bash
# マーケットプレイスの情報を更新
claude plugin marketplace update yomiyasu

# プラグインを最新版へ更新
claude plugin update yomiyasu@yomiyasu
```

更新後はClaude Codeを再起動して反映してください。

### 5\. ZIPファイルからの登録（Claude.ai Web版など）

Claudeのカスタムスキル登録機能（Web版など）には、登録専用のZIPを使ってください。GitHubの「Download ZIP」で取得したリポジトリ全体のZIPには、プラグイン設定や開発用ファイルも含まれ、登録できない場合があります。

登録専用のZIPには、リポジトリルートを起点とする11個のファイル（スキル本体、5つの参照文書、検査スクリプト群、ライセンス）だけを含めています。

1. **専用ZIPのダウンロード**  
	以下のリンクから、登録専用のZIPファイルをダウンロードします。  
	[yomiyasu.zip（最新版ダウンロード）](https://github.com/nanaism/yomiyasu/releases/latest/download/yomiyasu.zip)
2. **そのままアップロード**  
	ダウンロードした `yomiyasu.zip` を解凍せず、Claudeのスキル登録画面にそのままアップロードしてください。

### 他の日本語校正スキルとの干渉について

他の日本語校正スキルと併用すると、指示が食い違う場合があります。出力が乱れる場合は、類似スキルを一時的に無効にして使用してください。

## 使い方

AIチャットやコーディングエージェントに対して、下書きを貼り付けて次のように指示します。

```
この文章を読みやすくして。
（ここに修正したい文章を貼り付け）
```

### ドメインの指定

用途に特化した文体へ調整したい場合は、プロンプト内でドメインを指定してください。自然な文章で「技術記事向けに」と添えるか、「ドメイン tech」と明記して指示できます（省略時は入力内容から自動判別されます）。

```
この文章を技術記事向けに読みやすくして。
（ここに修正したい文章を貼り付け）
```
- tech（技術記事）  
	技術ブログやコード解説向け。手順や仕組みを復元し、箇条書きを抑えます。「技術記事向けに」または「ドメイン tech」と指定してください。
- business（業務文書）  
	仕様書やPR文、提案書向け。比喩表現を排し、境界条件や責任主体を明確にします。「業務仕様向けに」または「ドメイン business」と指定してください。
- essay（エッセイ）  
	個人ブログやnote向け。大げさな教訓化を避け、素直な感情と実感を大切にします。「エッセイ向けに」または「ドメイン essay」と伝えてください。

## 付属ツール

文章の表現やMarkdownの太字を検査するPythonスクリプト群（共有モジュール `markdown_visibility.py` を含む）を同梱しています。外部ライブラリは不要で、Python標準ライブラリだけで動作します。

本ツールは特定の構文を対象とする簡易な検査であり、完全なMarkdownレンダラーではありません。太字が正しく表示されるかは閲覧環境によっても異なります。検出結果は見直し候補であり、検査結果の `[PASS]` も設定されたルールによる指摘がないことを示すだけです。文章の自然さ、意味の保持、あらゆる環境での完全な表示、誤検知がないことを保証するものではありません。指摘がゼロになるまで機械的に直すのではなく、元の文や文脈と照らし合わせて判断してください。

### 1\. yomiyasu\_lint.py（静的検査リンター）

文章内のAIっぽさ（不自然な比喩動詞、過剰な太字・箇条書き、絵文字、文末コロン、同一文末の連続など）に加え、日本語の括弧や句読点に隣接して表示先の規則により太字として表示されない可能性がある候補（ `bold_not_rendered` ）を検査します。複数行にまたがる太字やブロック境界（引用、見出し、リスト、表）も考慮して判定します。すでに適切に表示される場合は変更しません。

```bash
# Markdownファイルを検査
python3 scripts/yomiyasu_lint.py README.md

# 警告があれば終了コード1を返す厳格モード（CIやGitフック用）
python3 scripts/yomiyasu_lint.py article.md --strict

# JSON形式で結果を出力
python3 scripts/yomiyasu_lint.py article.md --json
```

#### 出力例

```
============================================================
AIっぽさ 検査レポート (スコア: 100/100)
============================================================
・文字数: 1420 | 行数: 85
・太字頻度: 1,000字あたり 1.4 個 (推奨: 2.0以下 / 警告: 3.0超)
・箇条書き比率: 8.2% (推奨: 15%以下 / 警告: 25%超)
------------------------------------------------------------
[PASS] 設定された検査ルールによる指摘はありません。
```

### 2\. yomiyasu\_diff.py（推敲差分チェッカー）

推敲前と推敲後を比較し、語の増減、文末の種類や立場（勧め／決まり／説明）の変化、太字の表示を点検するツールです。意図しない意味の変化を見直すための候補を出しますが、意味が同じかどうかを自動で確定するものではありません。

```bash
# 原文と推敲後の差分を検査（文書の立場を指定）
python3 scripts/yomiyasu_diff.py 元の文.md 書き直した文.md --stance=説明

# 文末の種類（敬体・常体・立場）の分布のみを確認
python3 scripts/yomiyasu_diff.py --endings 対象文.md
```

---

## リポジトリ構成

```
.
├── .claude-plugin/                   # Claude Code用プラグイン設定
│   ├── plugin.json
│   └── marketplace.json
├── README.md                         # 本ドキュメント
├── LICENSE                           # ライセンス（MIT）
├── UNICODE-LICENSE.txt               # Unicodeデータの著作権・許諾通知
├── scripts/                          # 付属検査ツール群
│   ├── yomiyasu_lint.py             # 静的検査スクリプト（AIっぽさ・太字構文検査）
│   ├── yomiyasu_diff.py             # 差分検査スクリプト（推敲前後の意味・文末比較）
│   └── markdown_visibility.py       # Markdown構造・表示判定の共有モジュール
├── references/                       # スキル参照ドキュメント
│   ├── gemini-syntax.md              # 構文変換原則
│   ├── slop-catalog.md               # 不自然な語彙・構文カタログ
│   └── domains/                      # ドメイン別指針（tech, business, essay）
├── skills/                           # 配布用スキル（唯一のSKILL.mdと参照文書・検査ツール）
│   └── yomiyasu/
│       ├── SKILL.md
│       ├── references/
│       └── scripts/
├── tests/                            # 単体テスト・回帰テストスイート
│   ├── test_bold_multiline.py        # 複数行太字・境界検査テストスイート
│   └── fixtures/                     # 回帰テスト用フィクスチャ（50ケース）
└── evals/                            # 評価データ
    └── comparison_benchmark.md       # オープンライセンス文章を用いた比較検証データ
```

## 謝辞・参考文献

開発では、ALGO ARTIS 社内でのLLM文章に関する議論、先行調査、学術論文、既存の文体調整ツールを参考にしました。各資料から学んだ点を紹介します。スキルの具体的な編集ルールや数値の目安は独自に決めたものであり、引用した研究がその効果を保証するものではありません。

### 1\. コミュニティの先行調査

- \[AI臭い文章とは何なのか（Speaker Deck）\]([https://speakerdeck.com/nasuvitz/ai-kusai-bunshou-](https://speakerdeck.com/nasuvitz/ai-kusai-bunshou-)

## Frequently Asked Questions

### What is yomiyasu?

yomiyasu is an open-source ai agents skill for AI coding assistants such as Claude Code, Codex CLI, and ChatGPT, built by nanaism. AI生成の日本語を自然な日本語へ推敲するAgent Skill / Agent Skill for Refining AI-Generated Japanese into Natural Japanese. It has 1,763 GitHub stars.

### Is yomiyasu safe to use?

Yes. yomiyasu passed SkillsLLM's automated security scan — a dependency vulnerability audit plus prompt-injection heuristics — with no high-severity issues. You can read the full report in the Security Report section on this page.

### How do I install yomiyasu?

Clone the repository with "git clone https://github.com/nanaism/yomiyasu" and add it to your Claude Code skills directory (see the Installation section above).

### What programming language is yomiyasu written in?

yomiyasu is primarily written in Python. It is open-source under nanaism on GitHub, so you can review or fork the full source.

### Are there alternatives to yomiyasu?

Yes. SkillsLLM lists many other AI Agents skills you can browse and compare side by side. Open the AI Agents category from the badge at the top of this page, or use the Related Skills and comparison links further down to weigh yomiyasu against similar tools.

[Agentic AI for Beginners](https://skillsllm.com/courses/agentic-ai-beginner)

[Build your first AI agent from scratch - tool use, ReAct pattern, memory, deployment](https://skillsllm.com/courses/agentic-ai-beginner)

[

41 minBeginner

](https://skillsllm.com/courses/agentic-ai-beginner)

Comments (0)

to leave a comment.

No comments yet. Be the first to share your thoughts!

## Related Skills

[ECC](https://skillsllm.com/skill/ecc)

by [affaan-m](https://github.com/affaan-m)

The agent harness performance optimization system. Skills, instincts, memory, security, and research-first development for Claude Code, Codex, Opencode, Cursor and beyond.

275,167

41,046

JavaScript

AI Agentsai-agentsanthropic

[View details](https://skillsllm.com/skill/ecc)

[Compare](https://skillsllm.com/compare/ecc-vs-yomiyasu)

[skills](https://skillsllm.com/skill/mattpocock-skills)

by [mattpocock](https://github.com/mattpocock)

Skills for Real Engineers. Straight from my.agents directory.

250,518

21,171

Shell

AI Agents

[View details](https://skillsllm.com/skill/mattpocock-skills)

[Compare](https://skillsllm.com/compare/mattpocock-skills-vs-yomiyasu)

[superpowers](https://skillsllm.com/skill/superpowers)

by [obra](https://github.com/obra)

An agentic skills framework & software development methodology that works.

234,966

20,863

Shell

AI Agentsaibrainstorming

[View details](https://skillsllm.com/skill/superpowers)

[Compare](https://skillsllm.com/compare/superpowers-vs-yomiyasu)

The agent harness performance optimization system. Skills, instincts, memory, security, and research-first development for Claude Code, Codex, Opencode, Cursor and beyond.

185,940

28,768

JavaScript

AI Agentsai-agentsanthropic

[View details](https://skillsllm.com/skill/everything-claude-code)

[Compare](https://skillsllm.com/compare/everything-claude-code-vs-yomiyasu)