---
title: 本番稼働中の生成AIシステムを4ステップで段階移行する - 「MCP経由で遅い」を解くアーキテクチャ移行ADR
emoji: 🧭
type: tech
topics:
  - アーキテクチャ
  - ADR
  - AWS
  - MCP
  - 生成AI
published: false
---

## TL;DR

- 生成AIアシスタントで **「画面表示のデータ取得まで MCP を経由して遅い」** という課題を抱えていた
- **本番稼働中**なので一気に作り替えられない。そこで **4 ステップの段階移行**を ADR（Architecture Decision Record）に整理して合意した
- 移行の骨子は **① API アクセス層の Library 化 → ② WebSocket を SSE 化 → ③ Backend と MCP を統合 → ④ 全部を 1 つの Lambda リポジトリへ統合**
- 最終形では経路が **Flutter ↔ Lambda ↔ Library ↔ API** だけになり、レイテンシと運用負荷を最小化する

## この記事の対象読者

- 生成AI/エージェントのシステムで**レイテンシや構成の複雑さ**に悩んでいる方
- **本番稼働中のシステムを、止めずに段階移行**する進め方を知りたい方
- ADR（設計判断の記録）を**チームの合意形成**にどう使うか興味がある方

## 背景：画面表示まで MCP を経由していて遅い

私たちの生成AIアシスタントは、当初こんな構成でした。

```mermaid
flowchart LR
    Flutter -->|WebSocket| Lambda
    Flutter -.->|HTTP| Lambda
    Lambda --> Backend((Backend))
    Backend -->|MCP| MCPServer[MCP Server]
    MCPServer --> API
    Lambda -->|REST API<br/>打刻のみ| API
```

エージェントの推論には MCP（Model Context Protocol）が向いています。しかし私たちは、**エージェント判断が不要な「ただの画面表示データ取得」まで Backend → MCP Server 経由**で API を叩いていました。ここに2つの問題がありました。

- **遅い**: Backend も MCP Server も AgentCore Runtime 上で動いており、**起動・呼び出しのオーバーヘッド**が大きい。画面表示のたびに MCP を挟むので体感が悪い
- **切れる**: Flutter ↔ Lambda が API Gateway の **WebSocket**。30 秒のアイドルタイムアウトがあり、エージェントの長考中に接続が切れる

かといって、**本番運用が始まっている以上、一気に大胆な変更はできません**。ユーザーへの影響を抑えながら、少しずつ確実に良くする必要がありました。

## なぜ ADR に残すのか

こういう「大きくて、順序が重要で、リスクを伴う」意思決定こそ、**ADR（Architecture Decision Record）**の出番です。私たちは移行プランを ADR として書き、リファインメントの場で合意（Accepted）を取りました。

ADR にする狙いは3つです。

- **順序と理由を明文化**する（なぜこの順番か、を後から追える）
- **各ステップのリスクを事前に洗い出す**（想定リスク / 検討事項を必ず併記）
- **チーム横断の合意の記録**にする（口頭合意で流れないように）

「動くコード」だけでなく「なぜそう決めたか」を残すのは、採用・オンボーディングの観点でも効きます。

## 4 ステップの段階移行プラン

### Step1: API アクセスロジックを Library に切り出す

まず、**API アクセスロジックだけを共通 Library として切り出し**、REST API 経由のデータ取得を増やします。

```mermaid
flowchart LR
    Flutter -->|WebSocket| Lambda
    Lambda --> Backend((Backend))
    Backend -->|MCP| MCPServer[MCP Server]
    Lambda -->|REST API| Lib(("API アクセス<br/>用 Library"))
    MCPServer --> Lib
    Lib --> API
    Dev([他チーム開発者]) -.->|開発に協力| Lib
```

- MCP Server と Lambda の**双方が同じ Library 経由**で API を叩く構成にする
- エージェント判断が不要な画面表示は **Lambda → Library → API** の経路に寄せ、MCP を外す
- 既存の打刻 REST API も Library 経由に移植し、**API アクセスを一本化**

**期待効果**: 画面表示の応答改善（MCP を経由しない）、ロジック重複の解消、AI チームと他チームの責務境界の明確化。Library を別リポジトリにすることで、他チームの開発者も参加しやすくなります。

Step1 を最初に置くのは、**後続の Step3・Step4 が前提とする「API アクセス層の共通化」を提供する土台**だからです。

### Step2: WebSocket を SSE に変える

次に、Flutter ↔ Lambda の通信を WebSocket から **HTTP（SSE 含む）** に切り替え、30 秒アイドル切断を解消します。

- SSE（Server-Sent Events）なら keep-alive コメントで接続を維持でき、**長時間のレスポンス生成に耐える**
- 双方向通信が不要な用途では SSE のほうがシンプルで運用コストが低い
- HTTP 系に統一することで、インフラ・認証・監視の経路が一本化される

この Step2 には別途「API Gateway で SSE が実用できるか」の技術調査を先行させました。結論だけ言うと **「API Gateway REST API は 2025-11 にレスポンスストリーミング対応となり致命的なブロッカーは無い。ただし本当の壁は Python Lambda がネイティブストリーミング非対応なこと」** でした。詳細は別記事に切り出しています（本記事末尾のリンク参照）。

### Step3: Backend と MCP を 1 つのリポジトリに統合する

MCP Server として外部化していた機能を、**Backend の Tool（関数呼び出し）として実装し直し**、同じリポジトリに統合します。

```mermaid
flowchart LR
    Flutter -->|HTTP（SSE含む）| Lambda
    Lambda -->|エージェント呼び出し| Backend
    subgraph BackendRepo[Backend リポジトリ]
        Backend((Backend))
        Tool[Tool]
        Backend --- Tool
    end
    Lambda -->|REST API| Lib(("API アクセス<br/>用 Library"))
    Tool --> Lib
    Lib --> API
```

- Tool は Backend と同居し、**プロセス内で直接呼び出す**（MCP のプロトコル変換・プロセス越えを排除）
- API への経路は Step1 の Library に集約

**期待効果**: MCP プロトコル分のオーバーヘッドと実装コストの削減、Backend ↔ MCP 間のレイテンシ削減。

### Step4: Lambda / Backend / MCP を 1 つの Lambda リポジトリに統合する

最終的に、Lambda・Backend・（Tool 化した）MCP を **1 つの Lambda リポジトリに統合**します。

```mermaid
flowchart LR
    Flutter -->|HTTP（SSE含む）| Lambda
    subgraph LambdaRepo[Lambda リポジトリ]
        Lambda
        Backend((Backend))
        Tool[Tool]
        Lambda --- Backend
        Backend --- Tool
    end
    Lambda --> Lib(("API アクセス<br/>用 Library"))
    Tool --> Lib
    Lib -->|REST API| API
```

経路が **Flutter ↔ Lambda ↔ Library ↔ API** だけになり、AgentCore Runtime への依存も解消。背景で挙げた起動・呼び出しオーバーヘッドの問題が根本から消えます。

## 移行順序の根拠

「なぜこの順番か」を ADR に明記しました。ここが段階移行の肝です。

- **Step1（Library 化）を最初に**: Step3・Step4 が前提とする「API アクセス層の共通化」を提供する土台だから
- **Step2（SSE 化）は独立タスク**: WebSocket 切断問題を解く。技術的には Step1 と並行可能だが、影響範囲を抑えるため Step1 完了後を推奨
- **Step3 は Step1 の Library がある前提**で実施
- **Step4 は最終形**なので最後

一気に Step4 の姿を目指さず、**各ステップ単独でも価値が出る（＝いつ中断しても改善が残る）順序**にしているのがポイントです。

## Consequences（この決定の帰結）

- 最終形の経路は **Flutter ↔ Lambda ↔ Library ↔ API のみ**になり、レイテンシが最小化される
- **AgentCore Runtime への依存が解消**される
- AI チームは Lambda リポジトリ内に閉じた開発フローで進められる
- **他チームの貢献経路は Library に集約**し、Lambda リポジトリへの直接コミットは閉じる運用にする

各ステップには「想定リスク / 検討事項」も必ず添えました。たとえば Step1 では Library のバージョニング戦略（破壊的変更時の影響範囲）、Step3 では MCP を外部公開インタフェースとして使う他クライアントの有無、といった具合です。

## まとめ

- 生成AIシステムで**「エージェント判断が不要な処理まで MCP を経由して遅い」**なら、経路の見直しは効果が大きい
- 本番稼働中の移行は、**各ステップ単独で価値が出る順序**に分解する。いつ止めても改善が残る形にするのが安全
- 大きな移行こそ **ADR に「順序・理由・リスク」を明文化**して合意を取る。設計判断の記録はチームの資産になる
- 最終的に **AgentCore への依存を外し、Flutter ↔ Lambda ↔ Library ↔ API のシンプルな経路**に収束させる

「作り直したい」を「止めずに段階移行する」に変換する——その設計思考の一例として参考になれば幸いです。

## 関連記事

- **API GatewayでSSEはできる、本当の壁はLambdaがPythonだったこと - 生成AIチャットのWebSocket→SSE移行 技術調査**（本記事 Step2 の前提調査）

## 参考リンク

- [Architecture decision record（ADR） - GitHub adr/madr](https://adr.github.io/)
- [Model Context Protocol（MCP）公式](https://modelcontextprotocol.io/)
- [Amazon Bedrock AgentCore](https://docs.aws.amazon.com/bedrock-agentcore/)
