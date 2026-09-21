---
title: "Gitでよく使うコマンド一覧"
source: "https://qiita.com/uhooi/items/c26c7c1beb5b36e7418e"
published: 2020-03-12
created: 2025-06-26
description: "Gitでよく使うコマンドは2部構成です。 Gitでよく使うコマンド一覧 ←イマココ Git Submodulesでよく使うコマンド一覧 はじめに 最近はGitをSourceTreeでなくCLIで操作することが増えました。 しかし、いつまで経ってもGitのコマンドが覚..."
tags:
  - "clippings"
---
![](https://relay-dsp.ad-m.asia/dmp/sync/bizmatrix?pid=c3ed207b574cf11376&d=x18o8hduaj&uid=1990032)

Gitでよく使うコマンドは2部構成です。

- Gitでよく使うコマンド一覧　 **←イマココ**
- [Git Submodulesでよく使うコマンド一覧](https://qiita.com/uhooi/items/2c138df52aa78667442f)

## はじめに

最近はGitをSourceTreeでなくCLIで操作することが増えました。  
しかし、いつまで経ってもGitのコマンドが覚えられず、毎回ググっています。  
ググるのは手間なので、よく使うコマンドをまとめることにします。

## 環境

- Git：2.27.0

## Gitでよく使うコマンド

### git version

| コマンド | 説明 |
| --- | --- |
| `git version` | Gitのバージョンを出力する |

### git clone

| コマンド | 説明 |
| --- | --- |
| `git clone {リポジトリのURL}` | 対象リポジトリのデフォルトブランチをクローンする |
| `git clone --depth {深さ} {リポジトリのURL}` | 対象リポジトリのデフォルトブランチを指定したコミット数で切り詰めてクローンする |
| `git clone -b {ブランチ名} {リポジトリのURL}` | 対象リポジトリの対象ブランチをクローンする |
| `git clone --recursive {リポジトリのURL}` | サブモジュールを含む対象リポジトリのデフォルトブランチをクローンする |

`git clone --depth 1 {リポジトリのURL}` で、履歴が多いリポジトリをクローンする時間を短縮できます。

### git remote

| コマンド | 説明 |
| --- | --- |
| `git remote` | リモートリポジトリの一覧を出力する |
| `git remote add {リモートリポジトリ名} {リポジトリのURL}` | 対象リポジトリをローカルのリモートリポジトリに追加する |
| `git remote rename {旧リモートリポジトリ名} {新リモートリポジトリ名}` | ローカルの対象リモートリポジトリをリネームする |
| `git remote remove {リモートリポジトリ名}` | 対象リモートリポジトリをローカルから削除する |

### git branch

| コマンド | 説明 |
| --- | --- |
| `git branch` | ローカルブランチの一覧を出力する（チェックアウト中のブランチに `*` が付く） |
| `git branch -a` | ローカルブランチとリモートブランチの一覧を出力する |
| `git branch {ブランチ名}` | 対象ブランチを新規作成する（チェックアウトしない） |
| `git branch -d {ブランチ名}` | 対象ブランチを削除する |
| `git branch -d -f {ブランチ名}` | 対象ブランチを **強制** 削除する |
| `git branch -D {ブランチ名}` | 対象ブランチを **強制** 削除する |
| `git branch -m {旧ブランチ名} {新ブランチ名}` | 対象ブランチをリネームする |

### git checkout

| コマンド | 説明 |
| --- | --- |
| `git checkout {ブランチ名}` | 対象ブランチに切り替える |
| `git checkout -b {ブランチ名}` | 対象ブランチを新規作成し、切り替える |
| `git checkout {ファイルパス}` | ワークツリーにある対象ファイルの変更を取り消す |
| `git checkout .` | ワークツリーにある全ファイルの変更を取り消す |

2.23.0で `git switch` と `git restore` コマンドが追加され、 `git checkout` コマンドを使わなくても済むようになりました。

### git switch

| コマンド | 説明 |
| --- | --- |
| `git switch {ブランチ名}` | 対象ブランチに切り替える |
| `git switch -c {ブランチ名}` | 対象ブランチを新規作成し、切り替える |
| `git switch --detach refs/tags/{タグ名}` | 対象タグに切り替える |
| `git switch --detach {コミットID}` | 対象コミットに切り替える |

### git restore

| コマンド | 説明 |
| --- | --- |
| `git restore {ファイルパス}` | ワークツリーにある対象ファイルの変更を取り消す |
| `git restore .` | ワークツリーにある全ファイルの変更を取り消す |
| `git restore --source {コミットID} {ファイルパス}` | 対象ファイルの変更を対象コミットに戻す |

### git diff

| コマンド | 説明 |
| --- | --- |
| `git diff` | **ワークツリー** にあるファイルの差分を出力する |
| `git diff --cached` | **インデックス** にあるファイルの差分を出力する |

### git status

| コマンド | 説明 |
| --- | --- |
| `git status` | 変更したファイルの一覧を出力する |
| `git status -s` | `git status` を短い形式で出力する |
| `git status -s -b` | 短い形式でもブランチとトラッキングを出力する |

### git add

| コマンド | 説明 |
| --- | --- |
| `git add {ファイルパス1} {ファイルパス2}...` | 対象ファイルをインデックス（コミット対象）に追加する |
| `git add -A` | 変更した全ファイルをインデックスに追加する |
| `git add -p {ファイルパス}` | 対象ファイルをハンク単位でインデックスに追加する |

### git reset

| コマンド | 説明 |
| --- | --- |
| `git reset HEAD {ファイルパス}` | ステージングにある対象ファイルをワークツリーに戻す（ `git add {ファイルパス}` を取り消す） |
| `git reset HEAD` | ステージングにある全ファイルをワークツリーに戻す（ `git add -A` を取り消す） |

### git commit

| コマンド | 説明 |
| --- | --- |
| `git commit` | 指定したエディタでメッセージを書き、インデックスにある全ファイルをコミットする |
| `git commit -m "{メッセージ}"` | メッセージを付け、インデックスにある全ファイルをコミットする |

「指定したエディタ」とは、 `.gitconfig` の `editor` で指定しているエディタのことです。

.gitconfig

```ini
[core]
    editor = nvim
```

### git revert

| コマンド | 説明 |
| --- | --- |
| `git revert HEAD` | 直前のコミットを元に戻すコミットを作成する |
| `git revert {コミットID}` | 対象コミットを元に戻すコミットを作成する |

### git push

| コマンド | 説明 |
| --- | --- |
| `git push origin {ローカルブランチ名}` | 対象ローカルブランチを `origin` にプッシュする |
| `git push -d origin {リモートブランチ名}` | 対象リモートブランチを `origin` から削除する |
| `git push origin {タグ名}` | 対象タグを `origin` にプッシュする |
| `git push -d origin {タグ名}` | 対象タグを `origin` から削除する |
| `git push -f` | 強制プッシュする |
| `git push --force-with-lease` | 強制プッシュする（ブランチのアップストリームが変更されている場合などは拒否する） |

### git fetch

| コマンド | 説明 |
| --- | --- |
| `git fetch origin` | `origin` から最新の履歴を取得する |
| `git fetch --prune origin` | リモートリポジトリ上に存在しなくなったブランチなどの参照を削除し、 `origin` から最新の履歴を取得する |

### git rebase

| コマンド | 説明 |
| --- | --- |
| `git rebase origin/{ブランチ名}` | `origin` にある対象ブランチを、チェックアウト中のブランチへリベースする |
| `git rebase --continue` | リベースを続ける |
| `git rebase --abort` | リベースを強制終了する |
| `git rebase --quit` | リベースを中止する |

### git merge

| コマンド | 説明 |
| --- | --- |
| `git merge origin/{ブランチ名}` | `origin` にある対象ブランチを、チェックアウト中のブランチへマージする |
| `git merge --squash origin/{ブランチ名}` | `origin` にある対象ブランチのコミットをひとつにまとめ、チェックアウト中のブランチへマージする |
| `git merge --continue` | マージを続ける |
| `git merge --abort` | マージを強制終了する |
| `git merge --quit` | マージを中止する |

### git cherry-pick

| コマンド | 説明 |
| --- | --- |
| `git cherry-pick {コミットID}` | 対象コミットをチェリーピックする |
| `git cherry-pick {始点の1つ前のコミットID}..{終点のコミットID}` | 始点から終点までのコミットをチェリーピックする |
| `git cherry-pick {始点のコミットID}^..{終点のコミットID}` | 始点から終点までのコミットをチェリーピックする |
| `git cherry-pick --skip` | 現在のコミットをスキップして、残りのシーケンスを続ける |
| `git cherry-pick --quit` | 失敗したチェリーピックを取り消す |

### git stash

| コマンド | 説明 |
| --- | --- |
| `git stash list` | スタッシュの一覧を出力する |
| `git stash show` | スタッシュの変更を出力する |
| `git stash push -m "{メッセージ}"` | メッセージを付け、変更をスタッシュにプッシュする |
| `git stash pop` | スタッシュの変更をワークツリーに戻す（スタッシュから **消える** ） |
| `git stash apply` | スタッシュの変更をワークツリーに戻す（スタッシュから **消えない** ） |
| `git stash drop` | スタッシュから変更を削除する |

2020/03/12現在、 `git stash save` は非推奨です。  
代わりに `git stash push` を使いましょう。

スタッシュについては、以下の記事が参考になります。  
[https://qiita.com/chihiro/items/f373873d5c2dfbd03250](https://qiita.com/chihiro/items/f373873d5c2dfbd03250)

### git log

| コマンド | 説明 |
| --- | --- |
| `git log` | ログを出力する |
| `git log --graph --name-status --pretty=format:"%C(red)%h %C(green)%an %C(Cyan)%ad %Creset%s %C(yellow)%d%Creset"` | ぼくのかんがえたさいきょうのぎっとろぐ |

### git blame

| コマンド | 説明 |
| --- | --- |
| `git blame {ファイルパス}` | 対象ファイル全体の各行ごとに、最後に編集したリビジョンと作者を表示する |
| `git blame -L {開始行} {ファイルパス}` | 対象ファイルの開始行から末尾までを各行ごとに、最後に編集したリビジョンと作者を表示する |
| `git blame -L ,{終了行} {ファイルパス}` | 対象ファイルの先頭から終了行までを各行ごとに、最後に編集したリビジョンと作者を表示する |
| `git blame -L {開始行},{終了行} {ファイルパス}` | 対象ファイルの開始行から終了行までを各行ごとに、最後に編集したリビジョンと作者を表示する |

### git show

| コマンド | 説明 |
| --- | --- |
| `git show {コミットID}` | 対象コミットのメッセージとテキストの差分を表示する |

### git tag

| コマンド | 説明 |
| --- | --- |
| `git tag {タグ名}` | タグを付ける |
| `git tag -d {タグ名}` | タグを削除する |

### git rm

| コマンド | 説明 |
| --- | --- |
| `git rm {ファイルパス}` | 対象ファイルを **削除し** 、Gitの管理外にする |
| `git rm --cached {ファイルパス}` | 対象ファイルを **削除せず** 、Gitの管理外にする |
| `git rm -r {フォルダパス}` | 対象フォルダ以下を全削除し、Gitの管理外にする |

## Gitでよく使うテクニック

### 対象ファイルを一部分のみインデックスに追加する

`git add {ファイルパス}` で対象ファイルの全変更をインデックスに追加できます。  
一部の変更のみ追加したいときは `git add -p {ファイルパス}` を使います。

```shell-session
$ git add -p {ファイルパス}
…
(1/3) Stage this hunk [y,n,q,a,d,j,J,g,/,e,?]?
```

変更は「hunk （ハンク）」という単位で扱います。  
ハンクごとに対話式で聞かれるので、基本的には 「 `y` （追加する）」と「 `n` （追加せずそのまま）」を入力します。

各操作の意味を載せます。

```shell-session
(1/3) Stage this hunk [y,n,q,a,d,j,J,g,/,e,?]? ?
y - stage this hunk
n - do not stage this hunk
q - quit; do not stage this hunk or any of the remaining ones
a - stage this hunk and all later hunks in the file
d - do not stage this hunk or any of the later hunks in the file
g - select a hunk to go to
/ - search for a hunk matching the given regex
j - leave this hunk undecided, see next undecided hunk
J - leave this hunk undecided, see next hunk
e - manually edit the current hunk
? - print help
```

### rebase時に発生したコンフリクトを解消する

`rebase` 時に発生したコンフリクトは、手動で解消後に `rebase --continue` を実行する必要があります。

```bash
# 1. fetch→rebaseする
$ git fetch origin
$ git rebase origin/master

# 2.コンフリクトが発生したら、手動で解消してaddする
$ git add Foo.swift

# 3. \`rebase --continue\` を実行する
$ git rebase --continue

# 4. 対象ブランチを強制プッシュする
$ git push -f origin master
```

強制プッシュしているので、タイミングにはご注意ください。

### 間違えてプッシュしたコミットを取り消す

```shell-session
$ git reset --hard HEAD^
$ git push -f
```

強制プッシュしているので、タイミングにはご注意ください。

### 直前のコミットメッセージを変更する

直前のコミットメッセージは `git commit --amend` で変更できます。  
テキストエディタが開くので、コミットメッセージを変更して保存します。

```shell-session
$ git commit --amend
$ git push -f
```

すでにプッシュしている場合、強制プッシュする必要があります。  
コミットIDが変わる点も注意です。

### 過去のコミットのAuthorとCommitterを一括で変更する

Gitでコミットするユーザーを間違え、まとめて修正したい場合に使えるテクニックです。  
私はSourceTreeが `.gitconfig` にユーザー名とメールアドレスを追加したことに気づかずコミットし、修正するために使いました。

以下はコミッターが特定のメールアドレスのコミットのみ変更しています。  
必要に応じてif文の条件を変更してください。

```shell-session
$ git filter-branch --commit-filter ' 
if [ "$GIT_COMMITTER_EMAIL" = "{変更したいコミッターのメールアドレス}" ];
  then
    GIT_COMMITTER_NAME="{変更後のコミッター名}";
    GIT_AUTHOR_NAME="{変更後の作者名}";
    GIT_COMMITTER_EMAIL="{変更後のコミッターのメールアドレス}";
    GIT_AUTHOR_EMAIL="{変更後の作者のメールアドレス}";
    git commit-tree "$@";
  else
    git commit-tree "$@";
  fi'  HEAD
$ git push -f
```

コミットの取り消しと同様、強制プッシュしているので、タイミングにはご注意ください。

2021/05/11現在、 **`git filter-branch` は安全性とパフォーマンスの問題により非推奨** です。  
`git filter-repo` などを代わりに使いましょう。  
[https://github.com/newren/git-filter-repo/](https://github.com/newren/git-filter-repo/)

### タグを付け替える

タグを直接付け替えることはできないので、タグを削除して同名で付け直します。

```bash
# ローカルでタグを削除して付け直す
$ git tag -d {タグ名}
$ git tag {タグ名}

# リモートリポジトリからも削除し、付け直したタグをプッシュする
$ git push -d origin {タグ名}
$ git push origin {タグ名}
```

ちなみにGitHubでリリース済みのタグを付け直すと、リリースがドラフトになりました。

### リモートトラッキングの参照が残ってフェッチできない

`git fetch origin` を実行すると、以下のエラーが発生することがあります。

```shell-session
$ git fetch origin 
error: cannot lock ref 'refs/remotes/origin/feature/foo': 'refs/remotes/origin/feature' exists; cannot create 'refs/remotes/origin/feature/foo'
```

`feature` ブランチがあって `feature/foo` ブランチを作成できないためです。

`git branch -d feature` を実行するのみだと、リモートトラッキングの参照が残ってしまいます。

```shell-session
$ git branch -d feature
$ git branch -a
remotes/origin/feature
```

`git fetch --prune origin` を実行することで、フェッチ前にリモートに存在しなくなったリモートトラッキングの参照を削除するため、エラーが解消されます。

```shell-session
$ git fetch --prune origin
 - [deleted]           (none)     -> origin/feature
 * [new branch]        feature/foo     -> origin/feature/foo
```

### 壊れたrefを無視する警告を解消する

強制プッシュ後に `git branch -a` を実行すると、以下の警告が発生することがあります。

```shell-session
$ git branch -a
warning: ignoring broken ref refs/remotes/origin/HEAD
* main
  remotes/origin/main
```

処理はまだ理解していませんが、私は以下のコマンドを実行することで解消しました。

```shell-session
$ git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main
$ git fetch --prune
$ git gc
Enumerating objects: 663, done.
Counting objects: 100% (663/663), done.
Delta compression using up to 8 threads
Compressing objects: 100% (257/257), done.
Writing objects: 100% (663/663), done.
Total 663 (delta 392), reused 653 (delta 386), pack-reused 0
$ git branch -a
* main
  remotes/origin/HEAD -> origin/main
  remotes/origin/main
```

### GitHubでフォーク元のリポジトリにアクセスする

リモートリポジトリにフォーク元のリポジトリを追加することで、アクセスできるようになります。

```shell-session
$ git remote add upstream {フォーク元のリポジトリのURL}
```

あとは `origin` と同様、 `fetch` → `rebase` or `merge` などを実行すれば、フォーク元のリポジトリの変更を取得できます。

```shell-session
$ git fetch upstream
$ git checkout develop
$ git rebase upstream/develop
```

## おまけ：エイリアスの設定

`.gitconfig` の `[alias]` セクションでエイリアスを設定できます。  
私は `diff --cached` を `dfc` に設定するなど、短いコマンドで実行できるようにしています。  
私の `.gitconfig` は以下にアップロードしており、随時更新しているので、よかったら参考にしてください。  
[https://github.com/uhooi/dotfiles/blob/master/.gitconfig](https://github.com/uhooi/dotfiles/blob/master/.gitconfig)

余談ですが、私は `.bashrc` で `git` を `g` で実行できるように設定しています。  
つまり先ほどのコマンドは `g dfc` で実行できます。  
[https://github.com/uhooi/dotfiles/blob/master/.bashrc#L13](https://github.com/uhooi/dotfiles/blob/master/.bashrc#L13)

Gitコマンドは補完が効くので、覚えていないうちはエイリアスを設定せず、ある程度覚えたら設定するのがオススメです。

## おわりに

これでGitのコマンドを忘れたときは、本記事を見ればだいたいは解決できます！

## 参考リンク

- [Git - Reference](https://git-scm.com/docs)
- [【Git】あなたが知らない新コマンドswitch/restoreの世界にご招待 - Qiita](https://qiita.com/rebi/items/5a23f8cf904271bb5452)
- [\[Git\] blameコマンドで特定の行がいつ変更されたのか調べて、バグの混入を見つける - YoheiM.NET](https://www.yoheim.net/blog.php?q=20160709)
- [git ローカルの変更を元に戻す方法 - Qiita](https://qiita.com/macer_fkm/items/ea2337a9b504b982c295)
- [gitで特定ファイルを特定のcommitに戻す - Qiita](https://qiita.com/ritukiii/items/5bc8f74dbf4dc5d1384c)
- [git の add を取り消す - Qiita](https://qiita.com/nabezokodaikon/items/7ee4900d28d8d863978e)
- [Git commit 取り消したい - Qiita](https://qiita.com/maejimayuto/items/30bfab250186a00ae884#%E7%9B%B4%E5%89%8D%E3%82%92%E6%89%93%E3%81%A1%E6%B6%88%E3%81%99-commit-%E3%82%92%E3%81%99%E3%82%8B)
- [【Git】git rm --cached \[ファイル名\]：ファイルを管理対象から除外する - Qiita](https://qiita.com/megu_ma/items/a438a71c84145f14d04e)
- [複数のコミットを一括でcherry-pickする - Qiita](https://qiita.com/growsic/items/c45f1daa7196e862aea6)
- [gitの不要なブランチを消すコマンド - Qiita](https://qiita.com/mather314/items/a1536c52a2eb0426b2b5)
- [https://twitter.com/tarumzu/status/1296353937931419648?s=20](https://twitter.com/tarumzu/status/1296353937931419648?s=20)
- [https://twitter.com/tokorom/status/1337235380819529731?s=20](https://twitter.com/tokorom/status/1337235380819529731?s=20)
- [git コンフリクト解決 (rebase)](https://m-tmatma.github.io/git/ResolveConflictByRebase.html)
- [git add -p 使ってますか？ - Qiita](https://qiita.com/cotton_desu/items/bf08ac57d59b37dd5188)
- [【Git】pullしようとしたら、error: cannot lock ref ～ が出る… Output48](https://www.out48.com/archives/3603/)
- [リモートで消されたブランチが手元で残ってしまう件を解消する - Qiita](https://qiita.com/yuichielectric/items/84cd61915a1236f19221)
- [GitのCommitユーザを修正する方法 - Qiita](https://qiita.com/y10exxx/items/dcea0e39788d649ca8ba)
- [git gc の仕組みを原理から理解してサイズを 136MB → 7.2MB(95%減)まで削減した時の勉強メモ](https://zenn.dev/ulwlu/articles/cc2443d32e2444)
- [コミットメッセージの変更 - GitHub ヘルプ](https://help.github.com/ja/github/committing-changes-to-your-project/changing-a-commit-message)
- [gitで warning: ignoring broken ref refs/remotes/origin/HEAD ってエラーが出た時の対処法 - Qiita](https://qiita.com/Kazuhiro23/items/c64e0a7b75da7767d684#%E8%A7%A3%E6%B1%BA%E6%96%B9%E6%B3%95)
- [フォークにリモートを設定する - GitHub ヘルプ](https://help.github.com/ja/github/collaborating-with-issues-and-pull-requests/configuring-a-remote-for-a-fork)
- [フォークを同期する - GitHub ヘルプ](https://help.github.com/ja/github/collaborating-with-issues-and-pull-requests/syncing-a-fork)
- [\--force は有害だという考え; git の --force-with-lease を理解する | Atlassian Japan 公式ブログ | アトラシアン株式会社](https://www.atlassian.com/ja/blog/force-with-lease)

[0](https://qiita.com/uhooi/items/#comments)

コメント一覧へ移動

[315](https://qiita.com/uhooi/items/c26c7c1beb5b36e7418e/likers)

315