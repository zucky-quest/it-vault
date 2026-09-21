---
title: "Playwright MCP を使ってAIにブラウザ操作をさせてみる（GitHub Copilot / Cline 環境構築手順付）"
source: "https://qiita.com/t-kurasawa/items/fc47a9133dd6cfe1ae7b"
author:
  - "[[t-kurasawa]]"
published: 2025-04-08
created: 2025-07-01
description: "はじめに Microsoft が 2025/3/29 に Playwright MCP を発表してから盛り上がっていますね。 「MCP」は「Model Context Protocol」の略です。生成AIにとってのUSBポートのようなもので、様々なデータリソースやツールと..."
tags:
  - "clippings"
---
![](https://relay-dsp.ad-m.asia/dmp/sync/bizmatrix?pid=c3ed207b574cf11376&d=x18o8hduaj&uid=1990032)

## はじめに

Microsoft が 2025/3/29 に Playwright MCP を発表してから盛り上がっていますね。

「MCP」は「Model Context Protocol」の略です。生成AIにとってのUSBポートのようなもので、様々なデータリソースやツールとつなぐことが出来るものだと考えてください。

Playwright はブラウザを操作する E2E テストツールです。E2Eテストコードを人が書いて（またはブラウザ操作を記録して）プログラムがブラウザを操作するツールというものでした。Playwright MCP が登場したことで、 **生成AIがブラウザを操作することが出来る** ようになります。

## Cline で Playwright MCP の環境準備

※環境構築手順は Cline と GitHub Copilot 両方書きました。お好きな方を使ってください。

Playwright MCP と Cline を繋げていきます。

VSCode で Cline をインストールします。モデルは OpenAI や Azure OpenAI などを選択してください。APIエンドポイントとAPIキーで設定が完了するので手頃で簡単です。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/127260/b5d71892-da72-47f1-a014-b3e4e739ab13.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F127260%2Fb5d71892-da72-47f1-a014-b3e4e739ab13.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=f5a3427d8546991cf90a862723cb45a2)

次に、Cline の MCP Servers で Playwright MCP をインストールします。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/127260/4de138f6-4697-48f9-a669-1d2048880656.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F127260%2F4de138f6-4697-48f9-a669-1d2048880656.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=35777cd8643c24f9fd81b27468f10fdf)

Cline の指示に沿って環境構築を行います。

```bash
npm install -g @executeautomation/playwright-mcp-server
```

（追記：上記はコミュニティ版でした。Microsoft 公式版は以下です。）

```bash
npm install -g @playwright/mcp
```

MCP Servers（三のアイコン） > Installed > Configure MCP Servers に設定します。

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/127260/4b4180c6-1878-4b76-b3e1-5321ce15fe12.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F127260%2F4b4180c6-1878-4b76-b3e1-5321ce15fe12.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=a7610aed528cbd717fb721c38e1acd04)

※私の環境は Windows + WSL2 Ubuntu なので以下のように設定しています。

cline\_mcp\_settings.json

```json
{
  "mcpServers": {
    "playwright": {
      "disabled": false,
      "timeout": 60,
      "command": "wsl",
      "args": [
        "bash",
        "-ic",
        "node /home/t-kurasawa/.nvm/versions/node/v22.14.0/lib/node_modules/@executeautomation/playwright-mcp-server/dist/index.js"
      ],
      "transportType": "stdio"
    }
  }
}
```

（追記：以下のように記載するとちょっとスッキリ書けます）

```text
"source ~/.nvm/nvm.sh && npx -y @executeautomation/playwright-mcp-server"
```

## GitHub Copilot で Playwright MCP の環境準備

Playwright MCP サーバーを入れてください。

```bash
npm install -g @executeautomation/playwright-mcp-server
```

（追記：上記はコミュニティ版でした。Microsoft 公式版は以下です。）

```bash
npm install -g @playwright/mcp
```

VSCode に GitHub Copilot をいれます。VSCode のバージョンは [v1\_99 以降](https://code.visualstudio.com/updates/v1_99) にしてください。

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/127260/d0b087ef-7ff4-445e-bdf0-9fc9b9a44b25.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F127260%2Fd0b087ef-7ff4-445e-bdf0-9fc9b9a44b25.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=29765f1b3bb63931fc6d268fd73da325)

[VSCode の Agent モードを有効](https://code.visualstudio.com/blogs/2025/04/07/agentMode) にします。  
chat.agent.enabled を開き、チェックをいれて有効にします。

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/127260/65a63b77-3885-45cb-a130-68a5107f6076.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F127260%2F65a63b77-3885-45cb-a130-68a5107f6076.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=a0575e0db5633775a02a9dfea99fadcc)

settings.json

```json
{
  "mcp": {    
    "inputs": [],
    "servers": {
      "playwright": {
        "command": "wsl",
        "args": [
          "bash",
          "-ic",
          "node /home/t-kurasawa/.nvm/versions/node/v22.14.0/lib/node_modules/@executeautomation/playwright-mcp-server/dist/index.js"
        ]
      }      
    }
  },
  "chat.agent.enabled": true,
}
```

（追記：以下のように記載するとちょっとスッキリ書けます）

```text
"source ~/.nvm/nvm.sh && npx -y @executeautomation/playwright-mcp-server"
```

MCP を起動するには `Start` をクリックします。正しく動けば `Running` と表示されます。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/127260/070f031c-6539-4104-b685-686d30338f36.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F127260%2F070f031c-6539-4104-b685-686d30338f36.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=5591bff864e0388178bc3fdefa96e794)

環境準備は以上です。

## GitHub Copilot をエージェントモードに切り替え

GitHub Copilot をエージェントモードに切り替えます。

右下の `Ask` を `Agent` に変更してください。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/127260/aaf297c2-0b1e-486d-ac55-f86613a37c24.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F127260%2Faaf297c2-0b1e-486d-ac55-f86613a37c24.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=ae1eee805442d084493fd6250932c97b)

## 生成AIにブラウザを操作させてみる（GitHub Copilot）

GitHub Copilot に日本語指示をして Playwrihgt MCP 経由でブラウザを操作させてみます。

私：  
playwright で、 [https://finance.yahoo.co.jp/](https://finance.yahoo.co.jp/) を開き、今日の主要なニュースを3つ抜粋して。日本語で出力して。

GitHub Copilot：  
以下は、Yahoo!ファイナンスの今日の主要なニュースから抜粋した3つのトピックです：

日経平均VIは大幅に低下  
株価の大幅上昇により、投資家の警戒感が一時的に和らいでいます。

東京エレクトロンのアナリスト評価  
レーティングが強気に変更され、注目を集めています。

ドル・円の為替動向  
海外株高を受けて、ドル・円がやや値を戻しています。

これらのニュースは、現在の市場動向や投資家心理を反映しています。

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/127260/7747e2d0-43f5-47ba-a952-72bced688bcb.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F127260%2F7747e2d0-43f5-47ba-a952-72bced688bcb.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=f441ca84058cb4d3b697d414e5850f6a)

（出典：2025年04月08日の [https://finance.yahoo.co.jp/](https://finance.yahoo.co.jp/) より）

## 生成AIにブラウザを操作させてみる（Cline）

同じことを Cline にやらせてみます。

私：  
playwright で、Yahoo Japan Finance を開き、今日の主要なニュースを3つ抜粋して。日本語で出力して。

Cline：

取得したテキストから主要なニュースを3つ抜粋する必要があります。テキストにはいくつかのニュースが含まれているので、重要な情報を選び出して日本語で整理します。

不登校で母の2割離職、月5万の出費増も。不登校認めようの裏で  
熊本地震から9年、あなたの防災力は?  
日経平均は大幅反落、円高や米株価指数先物の影響  
これらのニュースを日本語でまとめました。次に、結果を出力します。

Task Completed

Yahoo Japan Financeから取得した今日の主要なニュースは以下の通りです：

不登校で母の2割離職、月5万の出費増も。不登校認めようの裏で  
熊本地震から9年、あなたの防災力は?  
日経平均は大幅反落、円高や米株価指数先物の影響

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/127260/94a818a5-5806-4e92-85b3-714d4bb205b6.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F127260%2F94a818a5-5806-4e92-85b3-714d4bb205b6.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=d4bbf50c25f24bd6eca30bea54c8689c)

Playwright MCP が Chromium を立ち上げてブラウザ操作する様子も確認できます。

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/127260/b1e7b1e1-56ad-459f-bd8a-9211a8082d6e.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F127260%2Fb1e7b1e1-56ad-459f-bd8a-9211a8082d6e.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=82d01dc4560a25d29e8190ba3fbf2367)

（出典：2025年04月09日の [https://finance.yahoo.co.jp/](https://finance.yahoo.co.jp/) より）

## おわりに

Playwright は E2E テストツールでしたが MCP で生成AIとつなげることでブラウザ操作を AI に任せることが出来るようになるわけですね。システム開発の領域から一歩踏み出して、さまざまなユースケースで活用できるようになると思います。

今後もアップデートがあればお伝えします。

[0](https://qiita.com/t-kurasawa/items/#comments)

コメント一覧へ移動

[282](https://qiita.com/t-kurasawa/items/fc47a9133dd6cfe1ae7b/likers)

219