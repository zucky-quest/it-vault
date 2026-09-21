---
title: "AWS CDKのLambda Pythonがuvをサポートしました | DevelopersIO"
source: "https://dev.classmethod.jp/articles/aws-cdk-lambda-python-supported-uv/"
author:
  - "[[武田隆志]]"
published: 2025-07-07
created: 2025-12-07
description:
tags:
  - "clippings"
---
こんにちは。サービス開発室の武田です。

AWS CDKでLambda関数をデプロイする際、 `aws-lambda` モジュールを使うのが基本的な方法です。ですが、それをラップしている `aws-lambda-python-alpha` モジュールを使うと便利です。

`aws-lambda-python-alpha` を使用すると、ビルド時にLambda関数を自動的にパッケージングしてくれます。具体的には同じディレクトリにある依存関係のファイルを読み取り、Dockerを使ってパッケージを作成します。

これまで自動的に検出される依存関係ファイルは次の3種類でした。

- requirements.txt
- Pipfile.lock
- poetry.lock

今回のアップデートで、ここに `uv.lock` が追加されました。

## 前提

今回の手順を進めるにあたって、Node.js、Python、AWS CLI、uvはインストール済みとします。

```bash
$ node --version
v22.16.0
$ python -V
Python 3.13.5
$ aws --version
aws-cli/2.27.33 Python/3.13.3 Darwin/24.4.0 exe/x86_64
$ uv --version
uv 0.7.13 (62ed17b23 2025-06-12)
```

## やってみた

それでは簡単なプロジェクトを作成して動作確認をしてみましょう。

### 環境構築

まず、新しいCDKプロジェクトを作成します。

```bash
mkdir test_cdk_uv && cd $_
npx cdk init app --language typescript
```

Python Lambdaの依存関係を追加します。 `2.204.0-alpha.0` がuvのサポートが追加されたバージョンです。

```bash
npm install @aws-cdk/aws-lambda-python-alpha@^2.204.0-alpha.0
```

Lambda関数用のディレクトリを作成します。

```bash
mkdir -p lambda/hello && cd $_
```

このLambda関数用の `pyproject.toml` を作成します。 `requests` を使用するために依存関係を追加しています。

lambda/hello/pyproject.toml

```toml
[project]
name = "hello-lambda"
version = "0.1.0"
description = "Sample Lambda function with uv"
requires-python = ">=3.13"
dependencies = [
    "requests>=2.32.0",
]

[tool.uv]
dev-dependencies = [
    "ruff>=0.8.0",
]
```

依存関係をインストールする場合には `uv sync` を使用しますが、今回は `uv.lock` が欲しいだけなので `uv lock` を実行します。

```bash
uv lock
```

あとはLambda関数を実装します。

lambda/hello/index.py

```python
import json

import requests

def handler(event, context):
    try:
        response = requests.get("https://api.github.com/zen")
        zen_message = response.text

        return {
            "statusCode": 200,
            "body": json.dumps(
                {
                    "message": "Hello from Lambda with uv!",
                    "zen": zen_message,
                    "event": event,
                }
            ),
        }
    except Exception as e:
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}
```

最後に、作ったLambda関数をデプロイするためにCDKのスタックを更新します。

lib/test\_cdk\_uv-stack.ts

```
--- a/lib/test_cdk_uv-stack.ts
+++ b/lib/test_cdk_uv-stack.ts
@@ -1,9 +1,22 @@
+import * as lambda from "@aws-cdk/aws-lambda-python-alpha";
 import * as cdk from "aws-cdk-lib";
-import { Construct } from "constructs";
+import * as lambdaCore from "aws-cdk-lib/aws-lambda";
+import type { Construct } from "constructs";

 export class TestCdkUvStack extends cdk.Stack {
   constructor(scope: Construct, id: string, props?: cdk.StackProps) {
     super(scope, id, props);
+
+    new lambda.PythonFunction(this, "HelloFunction", {
+      entry: "lambda/hello",
+      runtime: lambdaCore.Runtime.PYTHON_3_13,
+      index: "index.py",
+      handler: "handler",
+    });
   }
 }
```

### デプロイして動作確認

それでは作成したCDKスタックをデプロイしましょう。初回の場合は `bootstrap` も忘れずに。

```bash
cd ../..
npx cdk bootstrap aws://$account_id/ap-northeast-1
npx cdk deploy --require-approval never
```

デプロイ時のログをよく見ていると依存関係をダウンロードしていることが確認できます。

ではデプロイが完了したら、Lambda関数を実行してみましょう。今回はAWS CLIでやってみます。

```bash
# 関数名取得
fname=$(aws lambda list-functions --query 'Functions[?contains(FunctionName, \`TestCdkUvStack\`)].FunctionName' --output text)

# 関数実行
aws lambda invoke \
  --function-name "$fname" \
  --cli-binary-format raw-in-base64-out \
  /tmp/response.json > /dev/null && cat /tmp/response.json | jq
```

実行結果が表示されれば成功です！なお `zen` のメッセージは実行ごとに変わる可能性があるため、何回か実行してみてください。

```json
{
  "statusCode": 200,
  "body": "{\"message\": \"Hello from Lambda with uv!\", \"zen\": \"Requests may be slow, but they are atomic.\", \"event\": {}}"
}
```

## まとめ

これまでuvを使いたくてもCDKでサポートされていないという理由で移行できなかった方には朗報ですね！ぜひ使っていきましょう！

この記事をシェアする