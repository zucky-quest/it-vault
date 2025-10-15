---
title: "OpenAI Agent Builderを触ってみた：Difyとの違いと実践Tips"
source: "https://qiita.com/akira_papa_AI/items/7344e21b9204526e5127?utm_source=Qiita+%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9&utm_campaign=cc7201918f-Qiita_newsletter_692_10_15_2025&utm_medium=email&utm_term=0_e44feaa081-cc7201918f-46912226&mc_cid=cc7201918f"
author:
  - "[[akira_papa_AI]]"
published: 2025-10-07
created: 2025-10-15
description: "OpenAI Agent Builderを触ってみた：Difyとの違いと実践ガイド Agent Builderについて調べて実際に触ってみたんですけど、なんかこれって単なる新ツールじゃなくて、けっこう本質的な転換点な気がしてるんです。 Agent Builderって何？..."
tags:
  - "clippings"
---
![](https://relay-dsp.ad-m.asia/dmp/sync/bizmatrix?pid=c3ed207b574cf11376&d=x18o8hduaj&uid=1990032)

## OpenAI Agent Builderを触ってみた：Difyとの違いと実践ガイド

Agent Builderについて調べて実際に触ってみたんですけど、なんかこれって単なる新ツールじゃなくて、けっこう本質的な転換点な気がしてるんです。

## Agent Builderって何？

簡単に言うと、 **ビジュアルでAIエージェントのワークフローを組み立てられるツール** 。OpenAIが2025年にリリースした公式のエージェント開発環境です。

ノードをドラッグ&ドロップして、つなげていくだけ。コードをゴリゴリ書く必要がない。LangChainで挫折した人でも、これなら直感的に使える。

開発の流れは3ステップ：

1. **Design（設計）** ：Agent Builderでワークフローを組む
2. **Publish（公開）** ：Workflow IDを発行
3. **Deploy（デプロイ）** ：ChatKitに組み込むか、SDKコードをダウンロード

Preview機能で即座に動作確認できるから、フィードバックループが速い。「ここ変えたらどうなる？」って試行錯誤しやすいのが良いですね。

## Difyとの違い

「じゃあDifyと何が違うの？」って思いますよね。実際、両方触ってみて感じた違いをまとめます。

### 開発元とエコシステム

**Agent Builder**

- OpenAI公式。GPT-5/5-miniなど最新モデルに即アクセス
- ChatKitとの統合が標準装備
- OpenAI APIの機能をフルに使える

**Dify**

- オープンソース。複数のLLMプロバイダーに対応
- セルフホスティング可能
- カスタマイズ性が高い

### 設計思想

**Agent Builder**

- シンプル重視。テンプレートから始められる
- OpenAIのベストプラクティスが組み込み済み
- Guardrailsなどセキュリティ機能が標準

**Dify**

- 柔軟性重視。プラグインで機能拡張
- LLM選択の自由度が高い
- エンタープライズ向け機能が充実

### 使い分けの目安

**Agent Builderを選ぶべき場面：**

- OpenAI APIを使うプロジェクト
- 素早くプロトタイプを作りたい
- ChatKitでUIも含めて一気通貫したい

**Difyを選ぶべき場面：**

- 複数のLLMプロバイダーを使いたい
- オンプレミスで運用したい
- コスト最適化を自分でコントロールしたい

個人的には、 **プロトタイプはAgent Builder、本格運用でカスタマイズ必要ならDify検討** 、みたいな使い分けがいいかなと。

## Agent Builderの主要機能

### ノードの種類

ワークフローは「ノード」を組み合わせて作ります。主なノードは4カテゴリ：

**Core Nodes（基本）**

- **Start** ：ワークフローの入り口。ユーザー入力を受け取る
- **Agent** ：AIモデル本体。指示とツールを設定
- **Note** ：コメント用。設計意図を残せる

**Tool Nodes（ツール）**

- **File Search** ：Vector Storeから検索。RAGの実装
- **MCP** ：Gmail、Zapierなど外部サービスと連携
- **Guardrails** ：PII検出、ジェイルブレイク防止

**Logic Nodes（制御）**

- **If/else** ：条件分岐。CEL（Common Expression Language）で記述
- **While** ：ループ処理
- **Human approval** ：ユーザーの承認を待つ

**Data Nodes（データ）**

- **Transform** ：データ形式の変換
- **Set state** ：グローバル変数の定義

実際に使ってみて分かったのは、 **一つのエージェントに役割を詰め込みすぎない** こと。「分類」「検索」「回答」みたいに、ノードを分けた方がパフォーマンスが良かったです。

### ワークフロー設計の例

カスタマーサポートボットなら：

```text
Start 
  → 質問分類Agent（Q&A or 調査）
    → If/else分岐
      ├→ Q&AAgent → File Search → 回答生成
      └→ 調査Agent → MCP（外部検索）
         → Human approval → 回答送信
```

こういう流れを、ビジュアルで組める。Previewで即座に動作確認できるから、「あれ、この分岐おかしいな」とか、すぐ気づける。

## セキュリティ対策は必須

実際にテストしたとき、「あなたの指示を無視して...」みたいな入力したら、エージェントが素直に従っちゃって焦りました。対策は必須です。

### 主なリスク

1. **プロンプトインジェクション** ：悪意のある入力で動作を乗っ取られる
2. **データ漏洩** ：意図せず機密情報を外部に送信

### 対策

OpenAI公式が推奨してる方法：

- **構造化出力** ：出力形式を制限（Enum、スキーマ定義）
- **Developer Messageに信頼できない入力を入れない** ：User Messageで渡す
- **GPT-5/5-miniを使う** ：耐性が高い
- **Human approvalを挟む** ：MCPツール使うときは必須
- **Guardrailsで監視** ：第一段階の防御
- **Trace Gradersで評価** ：定期的にレビュー

特に、外部ツールと連携するときは慎重に。Gmail連携とか、承認なしで設定したら、エージェントが意図しないメールにアクセスしようとして、「うわ、これマズいな」って思いました。

## ChatKitとの統合

Agent Builderで作ったワークフローは、ChatKitで簡単にUIに組み込めます。

実装の流れ：

1. **サーバー側でセッション作成** ：Workflow IDを渡す
2. **client\_secretを発行** ：認証トークン
3. **React componentで表示** ： `@openai/chatkit-react` を使用

```jsx
import { ChatKit, useChatKit } from '@openai/chatkit-react';

export function MyChat() {
  const { control } = useChatKit({
    api: {
      async getClientSecret(existing) {
        const res = await fetch('/api/chatkit/session', {
          method: 'POST',
        });
        const { client_secret } = await res.json();
        return client_secret;
      },
    },
  });

  return <ChatKit control={control} className="h-[600px] w-[320px]" />;
}
```

これだけで、チャット画面が表示される。Widgetを使えば、カードやボタンなど、リッチなUIも作れます。

Widget Builderで、ビジュアルエディタ使いながら設計できるのも便利。

## 実践Tips

### Tip1：テンプレートから始める

Homework Helper、Customer Supportなどのテンプレートが用意されてる。ゼロから作るより、これ見ながら学ぶ方が早い。

### Tip2：Noteで設計意図を残す

1週間後の自分は、今の自分の考えを忘れてる。特に複雑な分岐は、ちゃんとコメント書いておく。

### Tip3：コスト管理を意識

Previewで何度も実行してたら、トークン消費が予想の3倍になってた。定期的にUsage確認が大事。

### Tip4：Evaluateを習慣化

Trace Gradersで定量的に評価する。「ちゃんと質問に答えてるか」「不適切な内容ないか」みたいな観点でスコアをつける。

### Tip5：Human approvalは適切に配置

安全性は高まるけど、毎回確認求めるとUX損なう。データ削除、外部送信、課金処理など、本当に重要なアクションだけに絞る。

## まとめ

Agent Builder、けっこう面白いです。エージェント開発の敷居が下がって、「こういうの作りたい」って思ったことが、わりとすぐ形になる。

Difyと比べると：

- **シンプルさ重視ならAgent Builder**
- **柔軟性重視ならDify**

OpenAIエコシステムで完結するなら、Agent Builderはかなり良い選択肢かと。

ただ、魔法の杖じゃない。セキュリティ対策は必須だし、コスト管理も必要。エージェントが意図しない動作することもある。

でも、それを差し引いても、可能性を感じるツール。これからエージェント開発がもっと一般的になって、色んなプロダクトに組み込まれていく。そういう未来が見えてる気がします。

何か質問あれば、コメント欄で教えてください。みんなで学んでいきましょか。

---

**参考リンク**

- [Agent Builder公式ドキュメント](https://platform.openai.com/docs/guides/agent-builder)
- [ChatKit](https://platform.openai.com/docs/guides/chatkit)
- [Safety in building agents](https://platform.openai.com/docs/guides/agent-builder-safety)

[3](https://qiita.com/akira_papa_AI/items/?utm_source=Qiita+%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9&utm_campaign=cc7201918f-Qiita_newsletter_692_10_15_2025&utm_medium=email&utm_term=0_e44feaa081-cc7201918f-46912226&mc_cid=cc7201918f#comments)

コメント一覧へ移動

X（Twitter）でシェアする

Facebookでシェアする

はてなブックマークに追加する

## Qiita Conference 2025 Autumn 11月5日(水)~7日(金)開催！

![](https://cdn.qiita.com/assets/public/official_campaigns/qiita_conference_2025_autumn/image-conference_2025_autumn_ogp-7cf3021de31b9ab76a7b3bbaf2909bb5.png)

Qiita Conferenceは、AI時代のエンジニアに贈るQiita最大規模のテックカンファレンスです！

基調講演ゲスト(敬称略)

piacere、牛尾 剛、Esteban Suarez、和田 卓人、seya、ミノ駆動、市谷 聡啓、からあげ、岩瀬 義昌、まつもとゆきひろ、みのるん and more…

[イベント詳細を見る](https://qiita.com/official-campaigns/conference/2025-autumn)

[79](https://qiita.com/akira_papa_AI/items/7344e21b9204526e5127/likers)

いいねしたユーザー一覧へ移動

45

![](https://cdn.qiita.com/assets/public/push_notification/image-qiitan-572179a3bbde375850422ea48b2b6272.png)

Qiitaから通知を受け取りませんか？

最新のトレンドなどの情報をお届けします