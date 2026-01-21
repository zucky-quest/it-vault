---
title: "Flutterってどうなん？実際に商用アプリ開発で使ってみた感想"
source: "https://qiita.com/allJokin/items/35a486c82815e0070f34"
author:
  - "[[allJokin]]"
published: 2023-09-25
created: 2026-01-21
description: "これまで3年ほどWebエンジニアとして働いており、いろいろあって今年からFlutterでモバイルアプリを開発しています。 Flutterを使い始めて半年が経ったので実際に使ってみて感じたいいと思ったところとイマイチだと思ったところを紹介したいと思います。 Flutter ..."
tags:
  - "clippings"
---
![](https://relay-dsp.ad-m.asia/dmp/sync/bizmatrix?pid=c3ed207b574cf11376&d=x18o8hduaj&uid=1990032)

この記事は最終更新日から1年以上が経過しています。

これまで3年ほどWebエンジニアとして働いており、いろいろあって今年からFlutterでモバイルアプリを開発しています。

Flutterを使い始めて半年が経ったので実際に使ってみて感じたいいと思ったところとイマイチだと思ったところを紹介したいと思います。

## Flutter とは？

Flutter は 複数のプラットフォームに対応したオープンソースなフレームワークです。現在では、Android・iOS・Web・Windows・MacOS・Linuxに対応しており、単一のコードで複数のプラットフォーム上で動作可能なアプリケーションを作成することができます。

## 実際に使って感じたいいところ、イマイチなところ

## いいところ

### 学習コストは意外と高くない

Flutterでは、Dartという言語を使います。

個人的な感想としては、Javascript, Typescript に似ているなーと思っています。  
なので、Webをずっと触っていた私はすんなりと入ることができました。

型定義ができることとnull safetyであるのはうれしいポイントです。

```dart
// if文
if (year >= 2001) {
  print('21st century');
} 

// for文
for (int month = 1; month <= 12; month++) {
  print(month);
}

// 関数
int fibonacci(int n) {
  if (n == 0 || n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}
var result = fibonacci(20);

// 型定義
String name = 'Bob';

// null safety
String? name
```

また、FlutterでのUIの組み方も公式が言っているようにReactを参考にしているので、理解しやすいです。

> Flutter widgets are built using a modern framework that takes inspiration from React.

プロパティ名もCSSっぽくてなんとなくこれかな？という感じで実装できちゃいます。

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    const Center(
      child: Text(
        'Hello, world!',
        textDirection: TextDirection.ltr,
      ),
    ),
  );
}
```

### Android と iOS の画面を同時に実装できる

これがやはりFlutterを使う一番のメリットです。  
例えば、以下のコードを１つでAndroidとiOSで画像のような画面を作成できます。  
従来であればそれぞれに対してコードを書く必要があったので、単純に作業量が半分になって効率が上がります。

```dart
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
```

[![](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/600358/e52dc5b0-ec2d-4f89-d33d-11772a2686c0.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F600358%2Fe52dc5b0-ec2d-4f89-d33d-11772a2686c0.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=e263949ed7785edb02a9dd09f6425c03)

### Android 用のデザインと iOS 用のデザインが用意されている

Android 風デザインの Material widgetsとiOS 風デザインの Cupertino widgets というものが用意されています。

AndroidアプリでiOS風のデザインを使うこともできますし、その逆、もしくは両方を組み合わせるということもできます。  
デフォルトで用意されているのでそれらを組み合わせるだけでいい感じにレイアウトが組めるというのはとてもいいと思いました。

[![スクリーンショット 2023-09-14 0.20.34.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/600358/c1430374-e758-f782-c51b-0d6f259966cd.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F600358%2Fc1430374-e758-f782-c51b-0d6f259966cd.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=d834a28490175c1cde2674579c149216)

また、AndroidではMaterial、iOSではCupertinoを表示したい場合にはflutter\_platform\_widgetsというパッケージを使うとプラットフォームに応じて自動的に出し分けてくれるので非常に便利です。

### Hot Reload と Hot Restart で開発体験が良い

Hot Reloadを利用することでファイルを変更して保存する と即座に反映されて確認することができます。

[![output.gif](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F600358%2Fbbbf6cea-405e-1fa6-c75f-5065cc543ff2.gif?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=47b3f821730324d178613ee902896610)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F600358%2Fbbbf6cea-405e-1fa6-c75f-5065cc543ff2.gif?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=47b3f821730324d178613ee902896610)

また、アプリを最初から実行したい場合には Hot Restart が利用できます。

Hot Reload と Hot Restartを活用することでビルド時間を短縮できるので効率よく開発ができます。

### 公式が提供しているパッケージで E2E テストができる

UTはもちろん実施できますが、E2Eテストを実施するためのパッケージも公式から提供されています。  
ビルド済みのAndroid/iOSアプリに対してテストを実施できます。  
入力、タップ、スワイプ、ドラッグなどの操作が再現でき、直感的にコードを実装できます。  
描画待ちもできるは嬉しいです。

```dart
// テキスト入力
await tester.enterText(find.byType(TextField), 'hi');

// ボタンをタップ
await tester.tap(find.byType(FloatingActionButton));

// ドラッグ
await tester.drag(find.byType(Dismissible), const Offset(500, 0));

// 描画待ち
await tester.pumpAndSettle();

// テキストがなくなっているか確認
expect(find.text('hi'), findsNothing);
```

### ライブラリが豊富

pub.dev(nodejsで言うnpm)で様々なパッケージが用意されているので非常に便利です。  
位置情報やBluetoothなどのネイティブのAPIを使う場合にも困らないかなと思います。

## イマイチなところ

### 情報が多くない

Flutterはすごく流行っているわけではないので、日本語の記事はあまり出てきません。  
ライブラリの公式ドキュメントや英語の記事を読むことが多くなるので、初心者にとってはちょっと大変かも知れません。

### プラットフォームごとに処理を書き分けなければいけないことがある

AndroidとiOSを同時に開発しているので仕方がないことですが、どちらかのプラットフォームでしか対応していない処理に遭遇することがあります。  
そういった場合、以下のように条件分岐で書き分ける必要があります。  
頻繁にこういったコードを書いてしまうと可読性が下がってしまいます。

```dart
if(Platform.isAndroid) {
  // Androidのときの処理
} else if(Platform.isIOS) {
  // iOSのときの処理
}
```

### プラットフォーム固有のバグを調べるのが大変

Flutterでは、ネイティブのコードを実行する際にMethodChannelという仕組みを使ってKotlinやSwiftのコードを実行します。  
これ自体は非常に便利なのですが、実際にどのコードが呼び出されているのかがすぐに特定しづらいです。  
ライブラリを使っていると実際にどんなネイティブのコードを実行しているのかをライブラリの中を辿って読みに行く必要があります。

## まとめ

個人的には使いやすくて良いフレームワークかなと思いました。  
Android/iOS両方のアプリを開発する必要がある場合にはもちろんですが、AndroidだけやiOSだけで開発する場合にも採用するのはアリかなと思います。

気になった人は是非Flutterを試してみてください。  
codelabsで気軽に試せるので最初はこれをやってみるのがオススメです！

[3](https://qiita.com/allJokin/items/#comments)

コメント一覧へ移動

X（Twitter）でシェアする

Facebookでシェアする

はてなブックマークに追加する

[408](https://qiita.com/allJokin/items/35a486c82815e0070f34/likers)

いいねしたユーザー一覧へ移動

345