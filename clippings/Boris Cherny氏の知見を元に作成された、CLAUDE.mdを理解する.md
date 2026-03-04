---
title: "Boris Cherny氏の知見を元に作成された、CLAUDE.mdを理解する"
source: "https://qiita.com/uno_ha07/items/5820d195510861b5be71?utm_source=Qiita+%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9&utm_campaign=0b81e4f133-Qiita_newsletter_712_03_04_2026&utm_medium=email&utm_term=0_e44feaa081-0b81e4f133-46912226&mc_cid=0b81e4f133"
author:
  - "[[uno_ha07]]"
published: 2026-02-23
created: 2026-03-05
description: "【更新履歴：2026年2月27日】 投稿時、本ファイルの作成者を「Boris Cherny氏本人」として紹介しておりましたが、正しくは「同氏がSNSで公開した知見を有志が構造化したもの」でした。内容の正確性を期すため、該当箇所を修正いたしました。 はじめに Cla..."
tags:
  - "clippings"
---
![](https://relay-dsp.ad-m.asia/dmp/sync/bizmatrix?pid=c3ed207b574cf11376&d=x18o8hduaj&uid=1990032)

**【更新履歴：2026年2月27日】**  
投稿時、本ファイルの作成者を「Boris Cherny氏本人」として紹介しておりましたが、正しくは「同氏がSNSで公開した知見を有志が構造化したもの」でした。内容の正確性を期すため、該当箇所を修正いたしました。

## はじめに

Claude Codeの生みの親であるAnthropicのスタッフエンジニア、 ~~**Boris Cherny氏** が公開した~~ Boris Cherny氏の知見を元に作成されたCLAUDE.mdが話題になっています。

英語で書かれているため、なんとなく意味はわかるけど、実際どう使えばいいかピンと来なかったので、

本記事では、 **原文 → 日本語訳 → 解説** の3段構成で、1セクションずつ丁寧に読み解いていきます。

発見したX  
[https://x.com/heygurisingh/status/2025572300658287030?s=20](https://x.com/heygurisingh/status/2025572300658287030?s=20)

---

**CLAUDE.mdとは？**  
Claude Codeがセッション開始時に自動で読み込む設定ファイルです。プロジェクトルートに置くことで、Claudeに対して「チームのルール」「やってはいけないこと」「作業の進め方」などを事前に伝えられます。セッションをまたいでも設定が引き継がれるため、 **AIへの外部メモリ** として機能します。

---

## ワークフロー設計（Workflow Orchestration）

---

### 1\. Plan Mode Default（Planモードを基本とする）

**原文**

```text
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately – don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity
```

**日本語訳**

```text
- 3ステップ以上 or アーキテクチャに関わるタスクは必ずPlanモードで開始する
- 途中でうまくいかなくなったら、無理に進めずすぐに立ち止まって再計画する
- 構築だけでなく、検証ステップにもPlanモードを使う
- 曖昧さを減らすため、実装前に詳細な仕様を書く
```

**解説**

Claude CodeにはShift+Tabを2回押すことで入れる「 **Planモード** 」があります。このモードでは、Claudeがいきなりコードを書き始めるのではなく、まず「どう実装するか」の計画を提示してくれます。

計画なしに動かすと、Claudeが意図しない箇所を書き換えてしまうといったトラブルが起きがちです。 **意図と制約に合意してから実行させる** ことが重要そうです

また、「うまくいかなくなったらすぐ再計画」というのも重要です。Claudeは一度走り出すと突き進もうとする傾向があるため、明示的にブレーキをかけるルールをあらかじめ書いておくわけです。

---

### 2\. Subagent Strategy（サブエージェント戦略）

**原文**

```text
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution
```

**日本語訳**

```text
- メインのコンテキストウィンドウをクリーンに保つためにサブエージェントを積極的に活用する
- リサーチ・調査・並列分析はサブエージェントに任せる
- 複雑な問題には、サブエージェントを使ってより多くの計算リソースを投入する
- 集中して実行するために、サブエージェント1つにつき1タスクを割り当てる
```

**解説**

Claude Codeでは、メインのセッションとは別に **サブエージェント** （別のClaudeインスタンス）を起動できます。これを使う最大の理由は「 **コンテキストの圧迫を防ぐ** 」ためです。

Boris氏のチームでは、例えば「code-simplifier（コードをシンプルにする）」「verify-app（アプリをE2Eテストする）」といったサブエージェントを定義して、役割を分担させています。

**1サブエージェント＝1タスク** という原則も重要で、何でもこなす万能エージェントを作るより、特化した小さなエージェントを組み合わせる方が信頼性が上がります。

> **実践ポイント** ：サブエージェントは「副作用だけが欲しいとき」や「結果だけが必要で過程は気にしないとき」に特に有効です。

---

### 3\. Self-Improvement Loop（自己改善ループ）

**原文**

```text
- After ANY correction from the user: update \`tasks/lessons.md\` with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project
```

**日本語訳**

```text
- ユーザーから修正を受けたら必ず \`tasks/lessons.md\` にそのパターンを記録する
- 同じミスを繰り返さないように、自分へのルールを書く
- ミス率が下がるまで、ルールを徹底的に改善し続ける
- セッション開始時に、そのプロジェクトに関連するlessonsをレビューする
```

**解説**

Claudeはセッションをまたいで学習しないので、指摘したことをセッションで覚えさせるために `tasks/lessons.md` というファイルを活用します。

Claudeが何か間違えるたびに、そのパターンを `lessons.md` に記録させます。そしてCLAUDE.mdからそのファイルを参照するよう設定しておくことで、前回のミスを減らせます。

---

### 4\. Verification Before Done（完了前に必ず検証する）

**原文**

```text
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness
```

**日本語訳**

```text
- 動作を証明できるまで、タスクを完了とマークしない
- 必要に応じてmainブランチと自分の変更の差分を確認する
- 「スタッフエンジニアはこれを承認するか？」と自問する
- テストを実行し、ログを確認し、正しく動作することを示す
```

**解説**  
**動くことを証明するまで完了としない** というルールを明示的に書くことで、Claudeに対して「自己申告完了」を禁止しているわけです。

特に注目すべきは「スタッフエンジニアはこれを承認するか？」という問いかけです。これはClaudeに対して品質基準の参照点を与えるテクニックで、「なんとなく動く」ではなく「プロが見ても問題ない」水準を目指させます。

---

### 5\. Demand Elegance（エレガントさを追求する）

**原文**

```text
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes – don't over-engineer
- Challenge your own work before presenting it
```

**日本語訳**

```text
- 重要な変更をする前に「もっとエレガントな方法はないか？」と一度立ち止まる
- ハック的な修正に感じたら「今知っていることをすべて踏まえて、エレガントな解決策を実装する」
- シンプルで明白な修正にはこのプロセスをスキップする（過剰設計しない）
- 提示する前に自分の作業に自問自答する
```

**解説**

Claudeは「動くコード」を素早く出すのは得意ですが、放っておくと「なんとか動く」だけのハック的なコードになりがちです。

このセクションのポイントは「（バランスよく）」という括弧書きにあります。すべての変更にエレガントさを求めるのではなく、 **重要な変更にだけ適用する** というメリハリが重要です。

「今知っていることをすべて踏まえて、エレガントな解決策を実装する」というプロンプトは、試行錯誤した後に一度リセットして最良の解を出させるための効果的な指示です。

---

### 6\. Autonomous Bug Fixing（自律的なバグ修正）

**原文**

```text
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests – then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how
```

**日本語訳**

```text
- バグレポートを受けたら、手取り足取り教えてもらわずにそのまま修正する
- ログ・エラー・失敗しているテストを見て、自分で解決する
- ユーザーのコンテキスト切り替えをゼロにする
- 言われなくても、失敗しているCIテストを修正しに行く
```

**解説**

AIに何かを頼むとき「どうすればいいですか？」と逆に聞き返されてしまう経験はないでしょうか。これはClaudeのデフォルト動作でよく起きる問題です。

このセクションはその問題に対する処方箋です。「バグレポートをもらったら質問なしに修正する」「CIが落ちていたら自分で直しに行く」というルールを書くことで、 **Claudeの自律性を引き出します** 。

"Zero context switching required from the user" という一文は特に印象的です。開発者がClaudeのために作業を中断しなくていい状態を理想とするという姿勢が表れています。

> **実践ポイント** ：バグ修正を依頼するときはログやエラーメッセージをそのまま貼り付けるだけでOK。「どう直せばいいですか？」ではなく「直してください」と指示するのがコツです。

---

## タスク管理（Task Management）

**原文**

```text
1. Plan First: Write plan to \`tasks/todo.md\` with checkable items
2. Verify Plan: Check in before starting implementation
3. Track Progress: Mark items complete as you go
4. Explain Changes: High-level summary at each step
5. Document Results: Add review section to \`tasks/todo.md\`
6. Capture Lessons: Update \`tasks/lessons.md\` after corrections
```

**日本語訳**

```text
1. まず計画を立てる：チェック可能な項目として tasks/todo.md に計画を書く
2. 計画を確認する：実装を開始する前に確認する
3. 進捗を記録する：完了した項目を随時マークしていく
4. 変更を説明する：各ステップで高レベルのサマリーを提供する
5. 結果をドキュメント化する：tasks/todo.md にレビューセクションを追加する
6. 学びを記録する：修正を受けた後に tasks/lessons.md を更新する
```

**解説**

これはワークフロー全体のチェックリストです。注目すべきは `tasks/` ディレクトリをClaudeの「作業ノート」として使っている点です。

`todo.md` には現在のタスクの計画と進捗を、 `lessons.md` には過去のミスから学んだルールを書いておきます。このファイルをCLAUDE.mdから参照することで、Claudeはセッションをまたいでもコンテキストを持てるようになります。

---

## コア原則（Core Principles）

**原文**

```text
- Simplicity First: Make every change as simple as possible. Impact minimal code.
- No Laziness: Find root causes. No temporary fixes. Senior developer standards.
- Minimal Impact: Changes should only touch what's necessary. Avoid introducing bugs.
```

**日本語訳**

```text
- シンプル第一：すべての変更をできる限りシンプルにする。影響するコードを最小限にする。
- 手を抜かない：根本原因を見つける。一時的な修正は避ける。シニアエンジニアの水準を保つ。
- 影響を最小化する：変更は必要な箇所のみにとどめる。バグを新たに引き込まない。
```

**解説**

この3つは一見シンプルですが、Claudeの行動パターンを深く理解した上でのルールです。

**シンプル第一** はClaudeが過剰実装（過度なコメントや遠回りなコードなど）しやすいという特性への対策です。「最小限の変更で目的を達成する」という制約を明示することで、意図しない変更を防ぎます。

**手を抜かない** はその逆で、応急処置的な修正でその場をしのごうとする動作を抑制します。 `No temporary fixes` （一時的な修正は避ける）という一文が特に重要で、技術的負債の蓄積を防ぐ意図があります。

**影響を最小化する** はリファクタリングや関係ない変更を混入させないためのルールです。「触っていないファイルは変えない」という原則を徹底させます。

---

## まとめ：コピペで使えるCLAUDE.md（日本語版）

以下をそのままコピーして、プロジェクトルートに `CLAUDE.md` として置けば使えます。

```markdown
## ワークフロー設計

### 1. Planモードを基本とする
- 3ステップ以上 or アーキテクチャに関わるタスクは必ずPlanモードで開始する
- 途中でうまくいかなくなったら、無理に進めずすぐに立ち止まって再計画する
- 構築だけでなく、検証ステップにもPlanモードを使う
- 曖昧さを減らすため、実装前に詳細な仕様を書く

### 2. サブエージェント戦略
- メインのコンテキストウィンドウをクリーンに保つためにサブエージェントを積極的に活用する
- リサーチ・調査・並列分析はサブエージェントに任せる
- 複雑な問題には、サブエージェントを使ってより多くの計算リソースを投入する
- 集中して実行するために、サブエージェント1つにつき1タスクを割り当てる

### 3. 自己改善ループ
- ユーザーから修正を受けたら必ず \`tasks/lessons.md\` にそのパターンを記録する
- 同じミスを繰り返さないように、自分へのルールを書く
- ミス率が下がるまで、ルールを徹底的に改善し続ける
- セッション開始時に、そのプロジェクトに関連するlessonsをレビューする

### 4. 完了前に必ず検証する
- 動作を証明できるまで、タスクを完了とマークしない
- 必要に応じてmainブランチと自分の変更の差分を確認する
- 「スタッフエンジニアはこれを承認するか？」と自問する
- テストを実行し、ログを確認し、正しく動作することを示す

### 5. エレガントさを追求する（バランスよく）
- 重要な変更をする前に「もっとエレガントな方法はないか？」と一度立ち止まる
- ハック的な修正に感じたら「今知っていることをすべて踏まえて、エレガントな解決策を実装する」
- シンプルで明白な修正にはこのプロセスをスキップする（過剰設計しない）
- 提示する前に自分の作業に自問自答する

### 6. 自律的なバグ修正
- バグレポートを受けたら、手取り足取り教えてもらわずにそのまま修正する
- ログ・エラー・失敗しているテストを見て、自分で解決する
- ユーザーのコンテキスト切り替えをゼロにする
- 言われなくても、失敗しているCIテストを修正しに行く

---

## タスク管理

1. **まず計画を立てる**：チェック可能な項目として \`tasks/todo.md\` に計画を書く
2. **計画を確認する**：実装を開始する前に確認する
3. **進捗を記録する**：完了した項目を随時マークしていく
4. **変更を説明する**：各ステップで高レベルのサマリーを提供する
5. **結果をドキュメント化する**：\`tasks/todo.md\` にレビューセクションを追加する
6. **学びを記録する**：修正を受けた後に \`tasks/lessons.md\` を更新する

---

## コア原則

- **シンプル第一**：すべての変更をできる限りシンプルにする。影響するコードを最小限にする。
- **手を抜かない**：根本原因を見つける。一時的な修正は避ける。シニアエンジニアの水準を保つ。
- **影響を最小化する**：変更は必要な箇所のみにとどめる。バグを新たに引き込まない。
```

---

## 参考リンク

- [https://x.com/srishticodes/status/2025254119636959701?s=46](https://x.com/srishticodes/status/2025254119636959701?s=46)
- [https://x.com/heygurisingh/status/2025572300658287030?s=20](https://x.com/heygurisingh/status/2025572300658287030?s=20)
- [Boris氏 X](https://x.com/bcherny/status/2007179832300581177)
- [Boris Cherny氏 Threads](https://www.threads.com/@boris_cherny)
- [Claude Code 公式ドキュメント](https://code.claude.com/docs)

---

### 更新履歴

- **2026年2月27日**: ファイルの作成背景に関する記述を修正しました。Boris氏の投稿をソースとして第三者がまとめた経緯を追記。
- **2026年2月20日**: 公開。

[0](https://qiita.com/uno_ha07/items/?utm_source=Qiita+%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9&utm_campaign=0b81e4f133-Qiita_newsletter_712_03_04_2026&utm_medium=email&utm_term=0_e44feaa081-0b81e4f133-46912226&mc_cid=0b81e4f133#comments)

コメント一覧へ移動

X（Twitter）でシェアする

Facebookでシェアする

はてなブックマークに追加する