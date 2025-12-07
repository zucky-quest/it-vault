---
title: "AWS CDK を使用した Lambda 関数のデプロイ - AWS Lambda"
source: "https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/lambda-cdk-tutorial.html"
author:
published:
created: 2025-12-07
description: "AWS Cloud Development Kit (AWS CDK) を使用して Lambda 関数をデプロイする方法について説明します。"
tags:
  - "clippings"
---
AWS CDK を使用した Lambda 関数のデプロイ - AWS Lambda

AWS Cloud Development Kit (AWS CDK) は、選択したプログラミング言語を使用して、AWS クラウドインフラストラクチャの定義に使用できる、Infrastructure as Code (IaC) フレームワークです。独自のクラウドインフラストラクチャを定義するには、最初に、(CDK でサポートされている言語のいずれかで) 1 つ以上のスタックが含まれるアプリケーションを記述します。次に、それを CloudFormation テンプレートに合成して、AWS アカウント にリソースをデプロイします。このトピックの手順に従って、Amazon API Gateway エンドポイントからイベントを返す Lambda 関数をデプロイします。

CDK に含まれる AWS 構成ライブラリは、AWS のサービス が提供するリソースのモデル化に使用できるモジュールを提供します。一般的なサービスでは、ライブラリが、スマートなデフォルトとベストプラクティスを持つ厳選された構成を提供します。 [aws\_lambda](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_lambda-readme.html) モジュールを使用して、数行のコードで関数とサポートリソースを定義できます。

## 前提条件

このチュートリアルを開始する前に、次のコマンドを実行して AWS CDK をインストールします。

```
npm install -g aws-cdk
```

## ステップ 1:AWS CDK プロジェクトを設定する

新しいAWS CDKアプリケーションのディレクトリを作成し、プロジェクトを初期化します。

anchor anchor anchor anchor anchor

###### 注記

AWS CDKアプリケーションテンプレートは、プロジェクトディレクトリの名前を使用し、ソースファイルとクラスの名前を生成します。この例では、ディレクトリ名は `hello-lambda` です。別のプロジェクトディレクトリ名を使用する場合、アプリケーションはこれらの指示と一致しません。

AWS CDK v2 は、 `aws-cdk-lib` と呼ばれる単一パッケージですべての AWS のサービス の安定した構成を含んでいます。このパッケージは、プロジェクト開始時に依存関係としてインストールされます。特定のプログラミング言語で作業する場合、パッケージはプロジェクトを初めて構築するときにインストールされます。

## ステップ 2: AWS CDK スタックを定義する

CDK *スタック* は、AWS リソースを定義する 1 つ以上のコンストラクトのコレクションです。各 CDK スタックは、CDK アプリ内の CloudFormation スタックを表します。

CDK スタックを定義するには、希望するプログラミング言語の手順に従います。このスタックでは、以下を定義します。

- 関数の論理名: `MyFunction`
- `code` プロパティで指定された関数コードの場所。詳細については、「 *AWS Cloud Development Kit (AWS CDK) API リファレンス* 」の「 [Handler code](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_lambda-readme.html#handler-code) 」を参照してください。
- REST API の論理名: `HelloApi`
- API Gateway エンドポイントの論理名: `ApiGwEndpoint`

このチュートリアルのすべての CDK スタックは、Lambda 関数に Node.js [ランタイム](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/lambda-runtimes.html) を使用することに注意してください。CDK スタックと Lambda 関数に異なるプログラミング言語を使用して、各言語の長所を活用できます。例えば、CDK スタックに TypeScript を使用して、インフラストラクチャコードの静的型付けの利点を活用できます。Lambda 関数に JavaScript を使用すると、動的に型付けされた言語の柔軟性と迅速な開発を活用できます。

anchor anchor anchor anchor anchor

## ステップ 3: Lambda 関数コードを作成する

1. プロジェクトのルート (`hello-lambda`) から、Lambda 関数コードの `/lib/lambda-handler` ディレクトリを作成します。このディレクトリは、AWS CDK スタックの `code` プロパティで指定されます。
2. `/lib/lambda-handler` ディレクトリに、 `index.js` という名前の新しいファイルを作成します。ファイルに次のコードを貼り付けます。関数は API リクエストから特定のプロパティを抽出し、JSON レスポンスとして返します。
	```javascript
	exports.handler = async (event) => {
	  // Extract specific properties from the event object
	  const { resource, path, httpMethod, headers, queryStringParameters, body } = event;
	  const response = {
	    resource,
	    path,
	    httpMethod,
	    headers,
	    queryStringParameters,
	    body,
	  };
	  return {
	    body: JSON.stringify(response, null, 2),
	    statusCode: 200,
	  };
	};
	```

## ステップ 4: AWS CDK スタックをデプロイする

1. プロジェクトのルートから、 [cdk synth](https://docs.aws.amazon.com/cdk/v2/guide/ref-cli-cmd-synth.html) コマンドを実行します。
	```nginx
	cdk synth
	```
	このコマンドは、CDK スタックから AWS CloudFormation テンプレートを合成します。テンプレートは、次のような約 400 行の YAML ファイルです。
	###### 注記
	次のエラーが発生した場合は、プロジェクトディレクトリのルートにいることを確認してください。
	```nginx
	--app is required either in command-line, in cdk.json or in ~/.cdk.json
	```
	###### 例 CloudFormation テンプレート
	```yaml
	Resources:
	  MyFunctionServiceRole3C357FF2:
	    Type: AWS::IAM::Role
	    Properties:
	      AssumeRolePolicyDocument:
	        Statement:
	          - Action: sts:AssumeRole
	            Effect: Allow
	            Principal:
	              Service: lambda.amazonaws.com
	        Version: "2012-10-17"                   
	      ManagedPolicyArns:
	        - Fn::Join:
	            - ""
	            - - "arn:"
	              - Ref: AWS::Partition
	              - :iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
	    Metadata:
	      aws:cdk:path: HelloLambdaStack/MyFunction/ServiceRole/Resource
	  MyFunction1BAA52E7:
	    Type: AWS::Lambda::Function
	    Properties:
	      Code:
	        S3Bucket:
	          Fn::Sub: cdk-hnb659fds-assets-${AWS::AccountId}-${AWS::Region}
	        S3Key: ab1111111cd32708dc4b83e81a21c296d607ff2cdef00f1d7f48338782f92l3901.zip
	      Handler: index.handler
	      Role:
	        Fn::GetAtt:
	          - MyFunctionServiceRole3C357FF2
	          - Arn
	      Runtime: nodejs22.x
	      ...
	```
2. [cdk デプロイ](https://docs.aws.amazon.com/cdk/v2/guide/ref-cli-cmd-deploy.html) コマンドを実行します。
	```nginx
	cdk deploy
	```
	リソースが作成されるまで待ちます。最終出力には、API Gateway エンドポイントの URL が含まれます。例:
	```nginx
	Outputs:
	HelloLambdaStack.ApiGwEndpoint77F417B1 = https://abcd1234.execute-api.us-east-1.amazonaws.com/prod/
	```

## ステップ 5: 関数をテストする

Lambda 関数を呼び出すには、API Gateway エンドポイントをコピーしてウェブブラウザに貼り付けるか、 `curl` コマンドを実行します。

```
curl -s https://abcd1234.execute-api.us-east-1.amazonaws.com/prod/
```

レスポンスは、元のイベントオブジェクトから選択されたプロパティの JSON 表現であり、API Gateway エンドポイントに対して行われたリクエストに関する情報が含まれています。例:

```json
{
  "resource": "/",
  "path": "/",
  "httpMethod": "GET",
  "headers": {
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
    "Accept-Encoding": "gzip, deflate, br, zstd",
    "Accept-Language": "en-US,en;q=0.9",
    "CloudFront-Forwarded-Proto": "https",
    "CloudFront-Is-Desktop-Viewer": "true",
    "CloudFront-Is-Mobile-Viewer": "false",
    "CloudFront-Is-SmartTV-Viewer": "false",
    "CloudFront-Is-Tablet-Viewer": "false",
    "CloudFront-Viewer-ASN": "16509",
    "CloudFront-Viewer-Country": "US",
    "Host": "abcd1234.execute-api.us-east-1.amazonaws.com",
     ...
```

## ステップ 6: リソースをクリーンアップする

API Gateway エンドポイントはパブリックにアクセスできます。予期しない料金が発生しないようにするには、 [cdk destroy](https://docs.aws.amazon.com/cdk/v2/guide/ref-cli-cmd-destroy.html) コマンドを実行して、スタックと関連するすべてのリソースを削除します。

```
cdk destroy
```

選択した言語で AWS CDK アプリケーションを記述する方法については、以下を参照してください。

anchor anchor anchor anchor anchor anchor