---
title: "MermaidでAWS構成図を作成するテクニック"
source: "https://qiita.com/b-mente/items/0172289e5b62645e550c?utm_source=Qiita+%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9&utm_campaign=7f491c9005-Qiita_newsletter_678_07_09_2025&utm_medium=email&utm_term=0_e44feaa081-7f491c9005-46912226&mc_cid=7f491c9005&mc_eid=e8227aa520"
author:
  - "[[b-mente]]"
published: 2025-06-30
created: 2025-07-12
description: "はじめに テキストからダイアグラムを生成できるMermaidを使ってAWS構成図を作成する際のテクニックを、いくつかピックアップしてご紹介します。 Mermaidを使えば、構成図内のテキスト検索はもちろん、アイコンを使って見やすく表現したり、アイコンをクリックしてマネジメ..."
tags:
  - "clippings"
---
![](https://relay-dsp.ad-m.asia/dmp/sync/bizmatrix?pid=c3ed207b574cf11376&d=x18o8hduaj&uid=1990032)

## はじめに

テキストからダイアグラムを生成できるMermaidを使ってAWS構成図を作成する際のテクニックを、いくつかピックアップしてご紹介します。

Mermaidを使えば、構成図内のテキスト検索はもちろん、アイコンを使って見やすく表現したり、アイコンをクリックしてマネジメントコンソールなどに遷移させたりすることもできるため、実用性の高い構成図が作成できます。

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/1a345e16-1204-4feb-8564-90efa44a0342.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2F1a345e16-1204-4feb-8564-90efa44a0342.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=5a11ab098cf35b7103ef79e09bacd437)

本記事が、Mermaidを活用したAWS構成図の作成に少しでもお役に立てば幸いです。

## AWS構成図の使用例

Mermaidで作成したAWS構成図の使用例を紹介します。  
例えばQiitaでも以下のように表示できます。(リンクはサンプルです)

mermaid記法

```text
---
title: 000000000000-xxxxxxxx環境
config:
  theme: neutral
  flowchart:
    nodeSpacing: 10
    rankSpacing: 30
---
flowchart LR

internet@{img: "https://api.iconify.design/material-symbols/globe-asia.svg",label: "internet",pos: "b",w: 60,h: 60,constraint: "on"}

subgraph aws["aws(ap-northeast-1)"]
  subgraph vpc-vvvv1["vpc:v1"]
    subgraph group-1-vpc-vvvv1[" "]
      elb-xxxx1@{img: "https://api.iconify.design/logos/aws-elb.svg",label: "elb:<br>test_elb",pos: "b",w: 60,h: 60,constraint: "on"}
    end
    subgraph group-2-vpc-vvvv1[" "]
      ec2-i-xxxx1@{img: "https://api.iconify.design/logos/aws-ec2.svg",label: "ec2:<br>admin",pos: "b",w: 60,h: 60,constraint: "on"}
      ecs-cluster/api1@{img: "https://api.iconify.design/logos/aws-ecs.svg",label: "ecs:<br>cluster/api",pos: "b",w: 60,h: 60,constraint: "on"}
    end
    subgraph group-3-vpc-vvvv1[" "]
      rds-xxxx1@{img: "https://api.iconify.design/logos/aws-rds.svg",label: "rds:<br>xxxx",pos: "b",w: 60,h: 60,constraint: "on"}
    end
  end
  subgraph group-4[" "]
     s3-xxxx1@{img: "https://api.iconify.design/logos/aws-s3.svg",label: "s3:<br>xxxx",pos: "b",w: 60,h: 60,constraint: "on"}
  end
end

group-1-vpc-vvvv1 ~~~ group-2-vpc-vvvv1 ~~~ group-3-vpc-vvvv1 ~~~ group-4

internet ----- |"admin.test.co.jp"| elb-xxxx1 --- ec2-i-xxxx1
internet ----- |"api.test.co.jp"| elb-xxxx1 --- ecs-cluster/api1

click ec2-i-xxxx1 href "https://aws.amazon.com/" _blank
click ecs-cluster/api1 href "https://aws.amazon.com/" _blank
click elb-xxxx1 href "https://aws.amazon.com/" _blank
click rds-xxxx1 href "https://aws.amazon.com/" _blank
click s3-xxxx1 href "https://aws.amazon.com/" _blank

classDef default fill:#fff
style aws fill:#fff,color:#345,stroke:#345
classDef group fill:none,stroke:none
classDef vpc fill:#fff,color:#0a0,stroke:#0a0
class vpc-vvvv1 vpc
class group-1-vpc-vvvv1,group-2-vpc-vvvv1,group-3-vpc-vvvv1,group-4 group
```

| 使用例 |  |
| --- | --- |
| HTML化してブックマーク | Notionに記載して設計書管理 |
| [![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/3846189b-b52d-4aa5-bc85-a2dc797b7fdc.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2F3846189b-b52d-4aa5-bc85-a2dc797b7fdc.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=db8d8818916c910aca369082e12423c4) | [![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/15b6f93d-1df2-459e-af13-9c27d5141b64.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2F15b6f93d-1df2-459e-af13-9c27d5141b64.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=74288e8d93cae270b81c25b20c2e6947) |
| PDF化して共有 | 生成AIで自動作成 |
| [![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/a9b7ad4a-0340-4866-8522-86915b32688c.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2Fa9b7ad4a-0340-4866-8522-86915b32688c.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=2ca1ad9dcfefe3853ae2dec245ba9fea) | [![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/4c071e09-409c-492d-afbb-b102fb944363.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2F4c071e09-409c-492d-afbb-b102fb944363.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=a1536e9829759999799ae32df63e7dab) |

GithubでMermaidの記述を管理するとバージョン管理、PRでのレビューや差分の確認ができて便利ですが、Readmeなどに記載した場合はアイコンが表示されず、クリック機能も使えない点ので注意が必要です。

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/e7d40a1e-78ad-4a0d-8884-9b664fa56366.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2Fe7d40a1e-78ad-4a0d-8884-9b664fa56366.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=5a23295897b64f9a3209d0d81a499465)

v11.3.0から追加された拡張表現は表示できるので拡張表現のimgだけダメそう

```text
Unable to render rich display
The source image cannot be decoded.

For more information, see https://docs.github.com/get-started/writing-on-github/working-with-advanced-formatting/creating-diagrams#creating-mermaid-diagrams
```

## 基本方針

### AWS公式の構成図ガイドライン

AWSで構成図を作成する際のルールやアイコンについては、下記の資料を参考にしています。

完全に準拠することは難しいですが、できるだけ公式のガイドラインに沿う形でMermaidを使って表現しています。

### 構成図の記法選定

MermaidでAWS構成図を書く際はArchitectureとFlowchartが候補として上がりますが、Architectureはクリック機能が無く、NotionやGithubなどのWebサービスでアイコン表示ができないため、汎用的に使用するのであればFlowchartがおすすめです。

クリック機能のない構成図をHTMLや画像として限定的に利用する場合は、Architectureでもアイコンパックを指定してAWS構成図を作成でき、配置なども柔軟に調整できるため、Architectureで記載するのがおすすめです。

### 記述範囲と粒度の考え方

- グループ記載範囲  
	1つのAWS構成図でどこまで詳細に描くか悩むことも多いと思います。  
	  
	特にリージョンについては、複数をまたいで記載することもできますが、外部アクセスを経由させると構成が複雑になりやすいため、基本的には1つのリージョンに絞って構成図を作成するのがおすすめです。  
	  
	以下は、グループの記載分けの例になります。

| グループ | 記載有無 | 理由 | スタイル |
| --- | --- | --- | --- |
| AWS | ⚪︎ | AWS領域明示 | `fill:#fff,color:#345,stroke:#345` |
| Region | × | 単一リージョンのみ | \- |
| VPC | ⚪︎ | リソース領域明示 | `fill:#fff,color:#0a0,stroke:#0a0` |
| AZ | × | 複雑化防止 | \- |
| Subnet | × | 汎用性重視 | \- |

グループのMermaidでのスタイルは、以前紹介した以下を参考にしています。

- ノード記載範囲  
	AWSアーキテクチャアイコンでは、サービスとリソースなどのサービス内の詳細項目を明確に区別しています。  
	  
	しかし、ノードの数が多くなる、サービスとそれ以外でアイコンサイズが揃わない、そもそもサービス以外のアイコンが用意されていないこともあるため、基本的にはサービスとしてノードを記載します。  
	  
	また、用途によってはサービスよりもリソースや詳細項目の方が重要になるケースもあると思いますので、その場合は適宜変更してご利用ください。
[![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/b829e5c7-3ff6-4e1e-9f22-cd9f497f8bb9.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2Fb829e5c7-3ff6-4e1e-9f22-cd9f497f8bb9.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=6169b25be0b38c16cc3cec4e75c69cd5)

### レイアウトの考え方

AWSの構成図では、外部から内部への流れを `上から下` もしくは `左から右` の方向で描くことが多いかと思います。

ただ、ノードが増えてきたときに、 `横方向(右方向)` へ広げていくか `縦方向(下方向)` へ増やしていくかがポイントになります。

多くのWebサービスでは横幅に制限がありますが、縦幅は比較的自由がきくため `左から右` に外部から内部の流れを描きつつ、ノードが増えた場合は `縦方向(下方向)` に追加していくレイアウトがおすすめです。

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/cea5313d-d0a8-4c44-a6b7-ff3b2a923c7d.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2Fcea5313d-d0a8-4c44-a6b7-ff3b2a923c7d.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=b4d055283f48ee40a0a5b7cda81e7d20)

## Mermaidの記述方法

### レイアウトの記述方法

- Flowchartの方向  
	Flowchartを用いて外部から内部への流れを `左から右` に表現するため、方向は `LR` を選択します。

mermaidの記述

```text
flowchart LR
```

- グループの表現  
	AWSとVPCのグループの記載については `subgraph` を用いて表現します。  
	  
	スタイルの記述については、AWSグループは構成図内に1つ、VPCグループは構成図内に複数ある可能性があるため、AWSは `style` 、VPCは `class` でまとめて `classDef` で定義します。

mermaidの記述

```text
flowchart LR

subgraph aws["aws"]

  subgraph vpc-vvvv1["vpc1"]
  end

  subgraph vpc-vvvv2["vpc2"]
  end

end

style aws fill:#fff,color:#345,stroke:#345

classDef vpc fill:#fff,color:#0a0,stroke:#0a0
class vpc-vvvv1,vpc-vvvv2 vpc
```

- ノード拡張層の追加  
	ノードが増えたときの拡張方向を統一するために、見えない層のグループをあらかじめ追加しておくと便利です。  
	  
	たとえば、インターネットの受け口となる前段の層、処理を担当する中段の層、Databaseなどデータソースを配置する後段の層、そしてVPC外に配置されるノードの層、といった4つの層に分けておくと、比較的柔軟に対応できます。
- 層の非表示化と接続  
	これらの層については、タイトルを空白(`[" "]`)にし、スタイルを無効（ `fill:none,stroke:none` ）にしておくことで、構成図上では見えないグループとして扱うことができます。  
	  
	また、internetノードと各層を順番に非表示の線(`~~~`)で繋ぐと、外部から内部への流れを `左から右` に表現することができます。  
	  
	VPCが複数ある場合は、internetノードとVPC外層も含めそれぞれの各層の接続を記述することで、全体的なバランスがとりやすいレイアウトとなります。

mermaidの記述

```text
flowchart LR

internet

subgraph aws["aws"]

  subgraph vpc-vvvv1["vpc1"]
    subgraph group-1-vpc-vvvv1[" "]
    end
    subgraph group-2-vpc-vvvv1[" "]
    end
    subgraph group-3-vpc-vvvv1[" "]
    end
  end

  subgraph vpc-vvvv2["vpc2"]
    subgraph group-1-vpc-vvvv2[" "]
    end
    subgraph group-2-vpc-vvvv2[" "]
    end
    subgraph group-3-vpc-vvvv2[" "]
    end
  end

  subgraph group-4[" "]
  end

end

internet ~~~ group-1-vpc-vvvv1 ~~~ group-2-vpc-vvvv1 ~~~ group-3-vpc-vvvv1 ~~~ group-4
internet ~~~ group-1-vpc-vvvv2 ~~~ group-2-vpc-vvvv2 ~~~ group-3-vpc-vvvv2 ~~~ group-4

style aws fill:#fff,color:#345,stroke:#345

classDef vpc fill:#fff,color:#0a0,stroke:#0a0
class vpc-vvvv1,vpc-vvvv2 vpc

classDef group fill:none,stroke:none
class group-1-vpc-vvvv1,group-2-vpc-vvvv1,group-3-vpc-vvvv1,group-1-vpc-vvvv2,group-2-vpc-vvvv2,group-3-vpc-vvvv2,group-4 group
```

同じ層に複数の接続のないノードを配置すると横方向に伸びてしまうため、その場合はノード同士を非表示の線(`~~~`)で繋ぐと縦方向に伸びてくれます。

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/fdbe6394-0091-48cd-b022-f92265d93234.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2Ffdbe6394-0091-48cd-b022-f92265d93234.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=b215ce4d9012b8fbda8b2f3118517cca)

mermaid記法

```text
flowchart LR

internet@{img: "https://api.iconify.design/material-symbols/globe-asia.svg",label: "",pos: "b",w: 60,h: 60,constraint: "on"}

subgraph aws["aws"]
  subgraph vpc-vvvv1["vpc"]
    subgraph group-1-vpc-vvvv1["前段層"]
      elb-xxxx1@{img: "https://api.iconify.design/logos/aws-elb.svg",label: "",pos: "b",w: 60,h: 60,constraint: "on"}
      elb-xxxx2@{img: "https://api.iconify.design/logos/aws-elb.svg",label: "",pos: "b",w: 60,h: 60,constraint: "on"}
    end
    subgraph group-2-vpc-vvvv1["中段層"]
      ecs-cluster/api1@{img: "https://api.iconify.design/logos/aws-ecs.svg",label: "",pos: "b",w: 60,h: 60,constraint: "on"}
      ecs-cluster/api2@{img: "https://api.iconify.design/logos/aws-ecs.svg",label: "",pos: "b",w: 60,h: 60,constraint: "on"}
    end
    subgraph group-3-vpc-vvvv1["後段層"]
      rds-xxxx1@{img: "https://api.iconify.design/logos/aws-rds.svg",label: "",pos: "b",w: 60,h: 60,constraint: "on"}
      rds-xxxx2@{img: "https://api.iconify.design/logos/aws-rds.svg",label: "",pos: "b",w: 60,h: 60,constraint: "on"}
    end
  end
  subgraph group-4["vpc外層"]
     s3-xxxx1@{img: "https://api.iconify.design/logos/aws-s3.svg",label: "",pos: "b",w: 60,h: 60,constraint: "on"} ~~~
     s3-xxxx2@{img: "https://api.iconify.design/logos/aws-s3.svg",label: "",pos: "b",w: 60,h: 60,constraint: "on"}
  end
end

internet ~~~ group-1-vpc-vvvv1 ~~~ group-2-vpc-vvvv1 ~~~ group-3-vpc-vvvv1 ~~~ group-4

ecs-cluster/api1 --- rds-xxxx1

classDef default fill:#fff
style aws fill:#fff,color:#345,stroke:#345
classDef group fill:none,stroke:#e22,stroke-width:3px
classDef vpc fill:#fff,color:#0a0,stroke:#0a0
class vpc-vvvv1 vpc
class group-1-vpc-vvvv1,group-2-vpc-vvvv1,group-3-vpc-vvvv1,group-4 group
```

### ノードの記述方法

- AWSサービスアイコンの記述方法  
	ノードをAWSサービスのアイコンで分かりやすく表現するために、Mermaidの拡張記法を使ってアイコン画像のURLを指定します。  
	  
	また、アイコンの下にサービス名とリソース名をラベルとして表示し、画像のアスペクト比も維持するようにします。

拡張表現のフォーマット

```text
(ノードID)@{
    img: (画像URL),
    label: (テキストラベル),
    pos: (ラベル位置 t/b),
    w: (画像横幅),
    h: (画像縦幅),
    constraint: (アスペクト比維持 on/off)
}
```

- AWSサービス画像の取得先  
	AWSサービスアイコンは、 [Icônes](https://icones.js.org/) のアイコンパック(SVG Logos)にSVG画像が用意されており、 [Iconify API](https://iconify.design/docs/api/) 経由で取得できるため、ありがたくこちらのURLを使用させていただきます。  
	  
	SVG Logosで提供されているAWSアイコンの一覧やURLについては下記で紹介していますので、よければ参考にしてください。
- ノードIDの選定方法  
	ノードIDは、Mermaidの記述内で一意である必要があります。分かりやすいのはARNを使う方法ですが、記述が長くなりすぎると文字数超過で構成図が正しく表示されない場合があります。  
	  
	サービスごとに一意で短い名称をノードIDとして指定するのがポイントです。以下はその例になります。

| サービス | ノードID |
| --- | --- |
| ELB | DNSName |
| EC2 | InstanceId |
| ECS | ClusterName/ServiceName |
| RDS | DBClusterIdentifier |
| S3 | BucketName |

### クリックの記述方法

Mermaidではノードにクリック機能を追加することができ、これを利用してノードがクリックされた際に、該当サービスのマネージメントコンソール画面を表示させる事ができます。

mermaidの記述

```text
click (ノードID) href (URL) _blank
```

また、マネージメントコンソールの多くのURLでは下記の構成を取っています。  
`AWSアカウント` や `リージョン` については、実際にマネージメントコンソールにログインしてご確認ください。

```text
https://(AWSアカウント).(リージョン).console.aws.amazon.com/(サービス)/(サービス毎のパス)
```

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/5b8dd57f-f8ce-4694-967b-b89a6a0b8f19.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2F5b8dd57f-f8ce-4694-967b-b89a6a0b8f19.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=d66a05e70e63790d399a75550dfea42c)

初回にマネージメントコンソールのURLに直接アクセスするとセッションが無効と怒られてしまうので、事前にマネージメントコンソールにログインしてからご利用ください。

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/967d964b-0f62-4eef-9c71-9a1c8d7a715a.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2F967d964b-0f62-4eef-9c71-9a1c8d7a715a.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=025cd8a8f725036d5f185a08a2989584)

下記はサービス毎のURL構成の例になります。

- ELBのURL
	- ARN:ELBのARN

mermaidの記述

```text
click (ノードID) href "https://(AWSアカウント).(リージョン).console.aws.amazon.com/ec2/home?region=(リージョン)#LoadBalancer:loadBalancerArn=(ARN)" _blank
```

- EC2のURL
	- instanceId:EC2のインスタンスID

mermaidの記述

```text
click (ノードID) href "https://(AWSアカウント).(リージョン).console.aws.amazon.com/ec2/home?region=(リージョン)#InstanceDetails:instanceId=(instanceId)" _blank
```

- ECSのURL
	- cluster:ECSのクラスター名
	- service:ECSのサービス名

mermaidの記述

```text
click (ノードID) href "https://(AWSアカウント).(リージョン).console.aws.amazon.com/ecs/v2/clusters/(cluster)/services/(service)/health?region=(リージョン)" _blank
```

- RDSのURL
	- cluster:RDSのクラスター名

mermaidの記述

```text
click (ノードID) href "https://(AWSアカウント).(リージョン).console.aws.amazon.com/rds/home/?region=(リージョン)#database:id=(cluster);is-cluster=true" _blank
```

- S3のURL
	- bucket:S3のバケット名

mermaidの記述

```text
click (ノードID) href "https://(AWSアカウント).(リージョン).console.aws.amazon.com/s3/buckets/(bucket)?region=(リージョン)&bucketType=general&tab=objects" _blank
```

クリック機能ではJavaScriptのコールバック関数が使えるので、マネージメントコンソールへ遷移するだけでなく、ノードの付属情報を表示させることもできます。

詳細は下記の公式ドキュメントを参照してください。

[https://mermaid.js.org/syntax/flowchart.html#interaction](https://mermaid.js.org/syntax/flowchart.html#interaction)

### 見栄え調整

- Mermaidのテーマ選定  
	Mermaidでは種類に関わらずテーマを指定できます。　  
	今回のAWS構成図では、主にノードの枠線や接続線の色、ラベルの背景色などが変わります。  
	AWS構成図の場合はシンプルなデザインの方が見やすいため、テーマは `neutral` を指定するのがおすすめです。

| テーマ | イメージ |
| --- | --- |
| default | [![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/6f4b4232-685a-474d-b5d3-2d5de252a649.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2F6f4b4232-685a-474d-b5d3-2d5de252a649.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=d7b936163786bb95d85f4f4116ab9380) |
| neutral | [![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/f1675c44-48ca-40d8-aabe-27b3b755252d.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2Ff1675c44-48ca-40d8-aabe-27b3b755252d.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=670bc055ecccef9bca04a7f502aa43ca) |
| dark | [![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/791d137f-65dd-462e-b7f8-c7e62ce94ba3.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2F791d137f-65dd-462e-b7f8-c7e62ce94ba3.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=3988cc52945180ed2c374f46ee537247) |
| forest | [![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/8235c0ad-3c0c-4bc0-bb13-477f36d8924d.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2F8235c0ad-3c0c-4bc0-bb13-477f36d8924d.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=669e72dd54a6c38f1ff06bb9de370ce3) |
| base | [![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/f09d761f-2387-434e-ad49-520b9e21c0be.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2Ff09d761f-2387-434e-ad49-520b9e21c0be.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=f2a1a6a2f5eec79264a7278b123638dd) |

- ノード・ランク間隔選定  
	Flowchartではノード間隔(`nodeSpacing`)やランク間隔(`rankSpacing`)を指定することができ、デフォルトでは間隔が大きく、AWS構成図が全体的に縮小してしまいます。  
	  
	おすすめの設定ですが、ノード間隔（ `nodeSpacing` ）が10（デフォルトは50）、ランク間隔（ `rankSpacing` ）が30（デフォルトは50）になります。

| 間隔 | イメージ |
| --- | --- |
| デフォルト | [![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/b86f5b64-380e-4142-86e3-cb673436718b.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2Fb86f5b64-380e-4142-86e3-cb673436718b.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=3651b4842517b9f593ee923adbd60721) |
| 変更後 | [![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/15535ad6-f219-4e58-b977-5d4cf79ac16d.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2F15535ad6-f219-4e58-b977-5d4cf79ac16d.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=de54390c90e1bf38cbf63b6489594353) |

これらの設定は、Mermaidの記述の一番はじめに以下のように追記することで指定できます。

設定の記載方法1

```text
---
config:
  theme: neutral
  flowchart:
    nodeSpacing: 10
    rankSpacing: 30
---
```

設定の記載方法2

```text
%%{init:{"theme":"neutral",'flowchart':{'nodeSpacing': 10,'rankSpacing': 30}}}%%
```

- ノード接続線長の選定(Link長)  
	internetからELBへ接続する線についてですが、線の長さが短いとラベルのドメイン名と線がずれてしまい、接続が多くなるとどの線がどのラベルなのか分かりづらくなり、見た目もあまり良くありません。  
	  
	そのため、internetからELBへ接続する線については一番長い設定にするのがおすすめです。  
	  
	ただ、ELBからEC2やECSへの接続線は、長さが短くても特に問題はなく、逆に長くするとサービス間が間延びしてしまうため、短い線の方が見やすくなります。

| 間隔 | イメージ | `-` 個数 |
| --- | --- | --- |
| 短い | [![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/be8038c6-f345-425c-80e4-76932aeff209.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2Fbe8038c6-f345-425c-80e4-76932aeff209.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=e2af40e525756e50f546499e378b161c) | 3つ |
| 中間 | [![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/10c44bb9-35ef-40b8-a191-ce70020648fa.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2F10c44bb9-35ef-40b8-a191-ce70020648fa.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=4c9ef35280d241db1c26a04cec5e14d3) | 4つ |
| 長い | [![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/6adce35f-013b-4053-95bb-dc436cba30f5.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2F6adce35f-013b-4053-95bb-dc436cba30f5.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=1c47851791f7bb946422032f60ff6c2a) | 5つ |
| おまけ   両方長い | [![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/699056/84838678-da2b-4c30-ad39-f56a6835c00f.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F699056%2F84838678-da2b-4c30-ad39-f56a6835c00f.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=1971ce503005b6236b04b3b1faadff51) | 5つ |

線の長さの指定方法

```text
flowchart LR
  A1 ---|短い| B1
  A2 ----|中間| B2
  A3 -----|長い| B3
```

## AWS CLIで情報取得

AWS CLIやAWS SDKを使用すればAWSの情報を取得できるので、取得した情報をもとにAWS構成図を自動生成することができます。

ここでは簡単のためAWS CLIを使用して情報取得する方法を紹介します。

実際に自動生成する際には複数の情報を組み合わせる必要があるので、スクリプトを作成するなどしてご利用ください。

### リソース一覧取得

AWSアカウントで利用しているリソースの一覧を確認したい場合は、以下のコマンドを実行することで、概ね把握できます。また、各リソースのARNだけでなく、Nameタグもあわせて取得できます。

指定したリージョンのARNとNameタグをTSV形式で出力

```bash
AWS_REGION="ap-northeast-1"
aws resourcegroupstaggingapi get-resources --query "ResourceTagMappingList[].[ResourceARN,Tags[?Key=='Name']|[0].Value]" --output text --region $AWS_REGION
```

また、ARNの構造は以下のようになっており、これによりどのサービスを利用しているかを特定することができます。

```text
arn:partition:service:region:account-id:resource
```

| 項目 | 説明 |
| --- | --- |
| arn | 固定文字列 `arn` |
| partition | 通常は `aws` 。中国リージョンは `aws-cn` 、AWS GovCloudは `aws-us-gov` |
| service | サービス名（例： `s3` 、 `ec2` 、 `rds` など） |
| region | リージョン名（例： `us-east-1` 、 `ap-northeast-1` など）グローバルサービスの場合は空 |
| account-id | AWSアカウントID（12桁の数字） |
| resource | リソース識別子。サービスごとに形式が異なる。サブリソースやパスが含まれることもある |

また、公式ドキュメントは下記になります。AWS構成を調査する際にも重宝するので、よければご活用ください。

### ELB一覧取得

```bash
AWS_REGION="ap-northeast-1"
aws elbv2 describe-load-balancers --query "LoadBalancers[].[VpcId,DNSName,LoadBalancerName,LoadBalancerArn]" --output text --region $AWS_REGION
```

| 項目 | 用途 |
| --- | --- |
| VpcId | 所属するVPCグループに使用 |
| DNSName | ノードIDに使用 |
| LoadBalancerName | ノードのラベルに使用 |
| LoadBalancerArn | クリックURLに使用 |

### EC2一覧取得

```bash
AWS_REGION="ap-northeast-1"
aws ec2 describe-instances --query "Reservations[].Instances[].[VpcId,InstanceId,Tags[?Key=='Name']|[0].Value]" --output text --region $AWS_REGION
```

| 項目 | 用途 |
| --- | --- |
| VpcId | 所属するVPCグループに使用 |
| InstanceId | ノードIDとクリックURLに使用 |
| Tags | ノードのラベルに使用 |

### ECS一覧取得

```bash
AWS_REGION="ap-northeast-1"
for cluster in $(aws ecs list-clusters --query "clusterArns[*]" --output text --region $AWS_REGION); do
  for service in $(aws ecs list-services --cluster $cluster --query "serviceArns[*]" --output text --region $AWS_REGION); do
    while read -r subnetId serviceArn targetGroupArn; do
      aws ec2 describe-subnets --subnet-ids $subnetId --query "Subnets[].[VpcId,'$serviceArn','$targetGroupArn']" --output text --region $AWS_REGION
    done < <(aws ecs describe-services --cluster $cluster --services $service --query "services[].[networkConfiguration.awsvpcConfiguration.subnets[0],serviceArn,join(',',loadBalancers[].targetGroupArn)]" --output text --region $AWS_REGION)
  done
done
```

| 項目 | 用途 |
| --- | --- |
| VpcId | 所属するVPCグループに使用 |
| serviceArn | ノードID、ラベル、クリックURLに使用(`s/^.*?service\///`) |
| targetGroupArn | 接続情報を特定するために使用(ELBのターゲットグループ) |

### RDS一覧取得

```bash
AWS_REGION="ap-northeast-1"
while read -r DBClusterIdentifier DBSubnetGroup; do
  aws rds describe-db-subnet-groups --db-subnet-group-name $DBSubnetGroup --query "DBSubnetGroups[].[VpcId,'$DBClusterIdentifier']" --output text --region $AWS_REGION
done < <(aws rds describe-db-clusters --query "DBClusters[].[DBClusterIdentifier,DBSubnetGroup]" --output text --region $AWS_REGION)
```

| 項目 | 用途 |
| --- | --- |
| DBSubnetGroup | 所属するVPCグループを特定するために使用 |
| DBClusterIdentifier | ノードID、ラベル、クリックURLに使用 |

### S3一覧取得

```bash
aws s3 ls | awk '{print $3}'
```

| 項目 | 用途 |
| --- | --- |
| 標準出力 | ノードID、ラベル、クリックURLに使用 |

### Route53のエイリアス一覧取得

```bash
AWS_REGION="ap-northeast-1"
for zid in $(aws route53 list-hosted-zones --query "HostedZones[].Id" --output text --region $AWS_REGION); do
  aws route53 list-resource-record-sets --hosted-zone-id $zid --query "ResourceRecordSets[?AliasTarget].[Name,AliasTarget.DNSName]" --output text --region $AWS_REGION
done
```

| 項目 | 用途 |
| --- | --- |
| Name | インターネットからの接続テキストに使用(登録されているレコード名) |
| DNSName | インターネットの接続ノードID(エイリアスのDNSName(`s/dualstack.//`)) |

## おわりに

本記事では、現場で役立つMermaidによるAWS構成図作成のテクニックをご紹介しました。

Mermaidを活用することで、AWS構成図の共有や管理がしやすくなり、設計やドキュメント作成の効率化にもつながります。

また、使用例でも触れた通り、生成AIと組み合わせることで、構成図の自動作成やレビュー、改善提案をしてもらうなど、構成図作成の効率化にとどまらない効果が期待できますので、ぜひ試してみてください。

AWSから [AWS Diagram MCP Server](https://awslabs.github.io/mcp/servers/aws-diagram-mcp-server/) というPythonのDiagramsライブラリを使用してAWSの構成図を自動生成してくれるMCPサーバーが公開されています。

普通に利用するとGraphvizを用いた静的な画像を出力するため、テキスト検索やクリックなどのインタラクティブな機能は使えませんが、生成されたPythonコードなどをMermaid形式に変換するなど工夫して使ってみても面白そうです。

[0](https://qiita.com/b-mente/items/?utm_source=Qiita+%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9&utm_campaign=7f491c9005-Qiita_newsletter_678_07_09_2025&utm_medium=email&utm_term=0_e44feaa081-7f491c9005-46912226&mc_cid=7f491c9005&mc_eid=e8227aa520#comments)

コメント一覧へ移動

[285](https://qiita.com/b-mente/items/0172289e5b62645e550c/likers)

335