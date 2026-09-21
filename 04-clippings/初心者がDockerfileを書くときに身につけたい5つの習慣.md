---
title: "初心者がDockerfileを書くときに身につけたい5つの習慣"
source: "https://qiita.com/shota0616/items/8adad18c983f4e8301c0?utm_source=Qiita+%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9&utm_campaign=f7141e2964-Qiita_newsletter_686_09_03_2025&utm_medium=email&utm_term=0_e44feaa081-f7141e2964-46912226&mc_cid=f7141e2964&mc_eid=e8227aa520"
author:
  - "[[shota0616]]"
published: 2025-08-23
created: 2025-09-03
description: "概要 突然ですが、Dockerfile適当に書いていませんか？ ほんの少しの工夫で、軽量になったり可読性が上がったりするので、今回はそんなTipsを紹介します。 この記事は人力で書きました。 その1 : マルチステージビルドを使う Dockerのマルチステ..."
tags:
  - "clippings"
---
![](https://relay-dsp.ad-m.asia/dmp/sync/bizmatrix?pid=c3ed207b574cf11376&d=x18o8hduaj&uid=1990032)

## 概要

突然ですが、Dockerfile適当に書いていませんか？  
ほんの少しの工夫で、軽量になったり可読性が上がったりするので、今回はそんなTipsを紹介します。

この記事は人力で書きました。

## その1: マルチステージビルドを使う

Dockerのマルチステージビルドとは、ビルドと実行用のイメージに分割することで最終的なイメージをコンパクトにできるものです。  
実際に `go` のコンテナを作成するときの例を挙げてどのようなメリットがあるか確認してみます。

**NG例**

```dockerfile
FROM golang:1.25
WORKDIR /app
COPY . .
RUN go build -o myapp .
CMD ["./myapp"]
```

**OK例**

```dockerfile
# Stage 1: Build
FROM golang:1.25 AS builder
WORKDIR /app
# ソースコード全体をコピーするのではなく、ビルド時にマウントする
RUN --mount=type=bind,source=.,target=/src,readonly \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    cd /src && go build -o /app/myapp .

# Stage 2: Run
FROM alpine:3.22.1
WORKDIR /app
COPY --from=builder /app/myapp .
CMD ["./myapp"]
```

では、実際に上記の2ファイルをbuildしてみて、どれくらいの容量差分が出てくるのか確認してみます。一旦の構成で `main.go` と `go.mod` でgoアプリを構成します。

main.go

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, Docker!")
}
```

go.mod

```ampl
module myapp

go 1.21
```

```text
# それぞれbuildビルド
docker build -f Dockerfile.junior -t myapp-junior .

docker build -f Dockerfile.senior -t myapp-senior .
```

実際にbuildして比べてみた結果、なんと **80倍** も変わりました。今回小さい構成で実施したのですが、これくらいの差が出ていますが、ガッツリ使用した場合はもっと大きくなりそうですね。。

```text
isoda@shota-mac senior % docker image ls | grep myapp
myapp-senior    latest    953f175978a5   13 seconds ago   16.9MB
myapp-junior    latest    8a57b08592c6   32 seconds ago   1.3GB
isoda@shota-mac senior %
```

## その2: ベースイメージは必ずバージョンを固定する

これを怠ると今日動いたbuildが明日動かなくなるかもしれません。

**NG例**

```dockerfile
FROM golang:latest
```

今日、上記の記載方法でbuildが成功したとしても、明日latestが更新されたらどうなるでしょう？  
急にbuildが失敗してしまうかもしれません。

**OK例**

```dockerfile
FROM golang:1.25-alpine
```

ポイントとしては、以下になります。

- **LTSの特定バージョンを明示的に指定する**
- **可能なら軽量イメージ（alpineやbullseye-slimなど）を使用する**

バージョン指定することで、思わぬトラブルを防ぐのとイメージの軽量化にも貢献してくれます。4倍くらいイメージ容量が変わってきますね。

```text
isoda@shota-mac junior % docker image ls | grep golang
golang                         latest        d7e6adee7899   7 days ago       855MB
golang                         1.25-alpine   6ea50bc9f564   7 days ago       211MB
```

## その3: レイヤーはできるだけ減らす

続いてのポイントとしては、レイヤはできるだけ減らすということです。そうすることで以下のようなメリットがあります。

- イメージサイズ削減（不要ファイルを残さない）
- キャッシュ効率アップ（再ビルド時間の短縮）
- 配布・展開の高速化（レイヤが少ないほどpush/pullが速い）

**NG例**

```dockerfile
FROM debian:bullseye
RUN apt-get -y update
RUN apt-get install -y python
```

**OK例**

```dockerfile
FROM debian:bullseye
RUN apt-get -y update && apt-get install -y python && rm -rf /var/lib/apt/lists/*
```

今回の例では、イメージサイズの削減は見られませんが、大きなDockerfileになれば差も大きくなってくると思います。

```text
isoda@shota-mac junior % docker images | grep myapp               
myapp-junior                   latest        c30825b58d07   19 seconds ago   216MB
myapp-senior                   latest        818501d91809   34 seconds ago   198MB
```

## その4:.dockerignoreを活用する

これは、`.gitignore` と同じような感覚でイメージに含まないファイルを指定することができます。

例えばですが、以下のようなDockerfileがあり

```dockerfile
COPY . /app
```

もしも、ディレクトリに以下のような不要なファイルが含まれていたとしたらどうでしょうか？  
その不要ファイルを`.dockerignore` に記載すればその分の容量を節約できます。

```text
venv/
.git/
logs
node_modules
...etc
```

`.dockerignore` の記載方法は簡単で、プロジェクトルートに`.dockerignore` というファイルを作成して、不要なファイルを記載するだけです。

```text
node_modules 
.git 
*.log
Dockerfile
...etc
```

※以下のようにbuild時にオプションを指定すると実際どのようなファイルが送られているか確認できるので、試してみてください。

```text
docker build . --no-cache --progress=plain
```

## その5: セキュリティを意識したDockerfileを構築する

Dockerのセキュリティのベストプラクティスとして、以下の4点を意識しましょう。

- 信頼できる正しいベースイメージを使用し軽量化させる
- マルチステージビルドを使う
- イメージは定期的に再構築をする
- イメージの脆弱性を確認する

それぞれ詳しく解説していきます。

### 信頼できる正しいベースイメージを使用し軽量化させる

まずは、信頼できるベースイメージを使用することが大切です。  
Docker Hubにはかなりの量のイメージが公開されていますが、その中でも `Official Image` や `Verified Publisher` を使用すると良いです。  
Docker Official Imagesは、以下のようなマークがついています。

[![スクリーンショット 2025-08-23 12.12.36.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2620245/573fade8-54ed-4f9e-9e80-fb70cd00123e.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2620245%2F573fade8-54ed-4f9e-9e80-fb70cd00123e.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=f5358a51f8c8622684ae831c6a443520)

また、攻撃対象や脆弱性を減らすためにも、できるだけ小さなイメージ（ `alpine` や `slim` ）を使用するようにしましょう。

### マルチステージビルドを使う

前述もしましたが、マルチステージビルドを活用することによって「最終イメージには 不要なツールやファイルを含めない」ということができます。  
それによって、不要なツールの脆弱性を回避できたり、攻撃対象を減らすということに繋がります。

### イメージは定期的に再構築をする

例えば、何年も前に構築されたイメージを使用し続ける場合もしそのイメージ内で使用しているソフトウェアの脆弱性が発見および対応された場合でも再構築しない場合、脆弱性が対応されていないイメージを使い続けることになってしまいます。  
そこで、定期期的に以下のようにイメージの再構築をしましょう。

```text
docker build --no-cache -t myImage:myTag myPath/
```

※ `--no-cache` を使用することで、キャッシュが使用されなくなります。（確実に新しいものをインストールするためにこのオプションを利用しましょう）

### イメージの脆弱性を確認する

脆弱性を定期的にスキャンして、もし脆弱性が見つかった時はイメージの更新/再構築をするというのも大切です。

一番手軽に診断できるツールとしては、 `docker scout` があります。これは、公式から提供されているツールで、現時点では、ローカルイメージは無料でスキャンできるようです。

```text
docker scout cves <image-name>
```

実際に作成したイメージに対して、動作させて出力を確認してみました。（一部割愛）

```text
✓ Image stored for indexing
    ✓ Indexed 356 packages
    ✓ Provenance obtained from attestation
    ✗ Detected 29 vulnerable packages with a total of 106 vulnerabilities

## Overview

                    │               Analyzed Image                
────────────────────┼─────────────────────────────────────────────
  Target            │  <image-name>:latest                       
    digest          │  XXXXXXXXXXXXX                               
    platform        │ linux/arm64                                 
    provenance      │ git@github.com:XXXXXXXXXXXXX/XXXXXXXXXXXXX.git      
                    │  XXXXXXXXXXXXXXXXXXXXXXXXXXX   
    vulnerabilities │    0C     1H     3M   102L                  
    size            │ 249 MB                                      
    packages        │ 356                                         

## Packages and Vulnerabilities

   0C     1H     0M    11L  XXXXXXXXXXXXX XXXXXXXXXXXXX
pkg:deb/debian/XXXXXXXXXXXXX
os_distro=XXXXXXXXXXXXX

    ✗ HIGH CVE-2025-55154
      https://scout.docker.com/v/CVE-2025-55154
      Affected range : >=8:7.1.1.43+dfsg1-1  
      Fixed version  : not fixed             

--- 略 ---

106 vulnerabilities found in 29 packages
  CRITICAL  0    
  HIGH      1    
  MEDIUM    3    
  LOW       102  

What's next:
    View base image update recommendations → docker scout recommendations XXXXXXXXXXXXX:latest
```

こういったスキャンを定期的に実行して、検出された脆弱性に対処していきましょう。

## まとめ

今回紹介したTipsは、難しいものではなく日々の開発で少し意識するだけで取り入れることができると思います。振り返ると以下の5つです。

- マルチステージビルドを活用する → イメージを軽量化し、不要な依存を排除できる
- ベースイメージは必ずバージョン固定 → 再現性を高め、予期せぬビルドエラーを防ぐ
- レイヤーを減らす → キャッシュ効率やビルド速度、イメージサイズを改善
- `.dockerignore` を活用する → 不要ファイルを含めず、効率的なビルドを実現
- セキュリティを意識する → 信頼できるイメージを選び、定期的に再構築＆脆弱性チェック

これらを少しずつ取り入れていくだけで、イメージは軽く・速く・安全になります。  
次にDockerfileを書くときは、ぜひ一つでも試してみてください。

[3](https://qiita.com/shota0616/items/?utm_source=Qiita+%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9&utm_campaign=f7141e2964-Qiita_newsletter_686_09_03_2025&utm_medium=email&utm_term=0_e44feaa081-f7141e2964-46912226&mc_cid=f7141e2964&mc_eid=e8227aa520#comments)

コメント一覧へ移動

X（Twitter）でシェアする

Facebookでシェアする

はてなブックマークに追加する

[314](https://qiita.com/shota0616/items/8adad18c983f4e8301c0/likers)

いいねしたユーザー一覧へ移動

295