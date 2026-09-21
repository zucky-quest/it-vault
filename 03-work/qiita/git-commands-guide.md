# Gitでよく使うコマンド一覧と使い方【初心者向け】

## はじめに

この記事では、Gitを日常的に使用する際によく使うコマンドを一覧で紹介し、それぞれの使い方を初心者向けに分かりやすく解説します。

### 対象読者

- Gitを始めたばかりの初心者
- 基本的なコマンドは知っているが、より効率的な使い方を知りたい方
- チーム開発でGitを使用している方

### この記事で学べること

- 日常的に使用するGitコマンドの使い方
- 各コマンドの具体的な使用例
- トラブル時の対処法

### 用語解説

#### commit-hash（コミットハッシュ）とは？

`commit-hash`は、Gitの各コミットに割り当てられる一意の識別子です。

**特徴：**

- **形式**: 40文字の英数字（例：`95adcc68aff15f4f83b7f8707f03b4b895a3afd9`）
- **一意性**: 世界中で重複しない一意の値
- **短縮形**: 最初の7文字程度でも識別可能（例：`95adcc6`）

**確認方法：**

```bash
# コミット履歴を表示（ハッシュ付き）
git log

# 短縮形で表示
git log --oneline

# 特定のコミットの詳細を表示
git show commit-hash
```

**使用例：**

- `git revert 95adcc6` - 特定のコミットを取り消す
- `git checkout 95adcc6` - 特定のコミットの状態に戻る
- `git cherry-pick 95adcc6` - 特定のコミットを現在のブランチに取り込む

---

## 1. 基本的な操作コマンド

### 1.1 リポジトリの初期化とクローン

```bash
# 新しいリポジトリを初期化
git init

# リモートリポジトリをクローン
git clone https://github.com/username/repository.git
```

### 1.2 ファイルの状態確認

```bash
# 現在の状態を確認
git status

# 変更内容の詳細を確認
git diff

# コミット履歴を確認
git log
```

---

## 2. ファイルの管理

### 2.1 ファイルの追加とコミット

```bash
# 特定のファイルをステージングエリアに追加
git add filename.txt

# すべての変更をステージングエリアに追加
git add .

# 対話形式でステージングエリアに追加（便利！）
git add -p

# 変更をコミット
git commit -m "コミットメッセージ"

# ワーキングエリアの変更を全てコミット
git commit -a -m "コミットメッセージ"
```

### 2.2 ファイルの削除と名前変更

```bash
# ファイルを削除（ステージングエリアからも削除）
git rm filename.txt

# ファイルの名前を変更
git mv old-name.txt new-name.txt
```

---

## 3. ブランチ操作

### 3.1 ブランチの作成と切り替え

```bash
# 新しいブランチを作成
git checkout feature-branch

# ブランチに切り替え
git switch feature-branch

# ブランチを作成して切り替え（上記2つのコマンドを同時実行）
git checkout -b feature-branch
```

### 3.2 ブランチの管理

```bash
# ブランチ一覧を表示
git branch

# リモートブランチも一覧を表示
git branch -r

# リモートブランチも含めて表示
git branch -a

# ブランチを削除
git branch -d branch-name

# ブランチ名を変更
git branch -m old-branch-name new-branch-name

# ひとつ前のブランチに切り替え
git switch -
```

---

## 4. リモートリポジトリとの連携

### 4.1 変更のプッシュとプル

```bash
# ローカルの変更をリモートにプッシュ
git push origin branch-name

# リモートの変更をローカルにプル
git pull origin branch-name

# リモートの変更を取得（マージはしない）
git fetch origin
```

### 4.2 リモートリポジトリの管理

```bash
# リモートリポジトリを追加
git remote add origin https://github.com/username/repository.git

# リモートリポジトリ一覧を表示
git remote -v

# リモートブランチを削除
git push --delete origin branch-name
```

---

## 5. 変更の取り消しと復元

### 5.1 コミット前の変更を取り消し

```bash
# ステージングエリアの変更を取り消し
git reset HEAD filename.txt

# 作業ディレクトリの変更を取り消し
git checkout -- filename.txt

# 変更をワーキングディレクトリから削除（Git 2.23以降）
git restore .

# 変更をステージングエリアから削除（Git 2.23以降）
git restore --staged .
```

### 5.2 コミットの取り消し

```bash
# 直前のコミットを取り消し（変更は保持）
git reset --soft HEAD~1

# 直前のコミットを完全に削除
git reset --hard HEAD~1

# 特定のコミットを取り消す（安全な方法）
git revert commit-hash

# 複数のコミットを一度に取り消す
git revert commit-hash1 commit-hash2

# マージコミットを取り消す
git revert -m 1 merge-commit-hash

# 実際の使用例
git revert 95adcc6  # 短縮形のハッシュを使用
git revert 95adcc68aff15f4f83b7f8707f03b4b895a3afd9  # 完全なハッシュを使用
```

**`git revert`と`git reset`の違い：**

- **`git revert`**: 新しいコミットを作成して変更を取り消す（履歴を保持）
- **`git reset`**: コミット履歴自体を変更する（履歴を書き換え）

`git revert`は共有リポジトリで安全に使用できる方法です。

---

## 6. マージとコンフリクト解決

### 6.1 ブランチのマージ

```bash
# 現在のブランチに別のブランチをマージ
git merge branch-name

# マージコミットを作成せずにマージ
git merge --no-ff branch-name

# リベースでブランチを統合
git rebase base-branch-name
```

### 6.2 コンフリクトの解決

コンフリクトが発生した場合：

1. コンフリクトファイルを編集
2. コンフリクトマーカー（`<<<<<<<`, `=======`, `>>>>>>>`）を削除
3. 変更をステージングエリアに追加
4. マージを完了

```bash
# コンフリクト解決後
git add .
git commit -m "コンフリクトを解決"
```

---

## 7. 便利なコマンド

### 7.1 ログと履歴

```bash
# グラフィカルにログを表示
git log --graph --oneline --all

# 特定のファイルの変更履歴を確認
git log -p filename.txt

# ブランチの分岐点を確認
git log --oneline --graph --decorate

# ブランチ名で検索・絞り込み
git branch -a | grep '検索したい文字列'
```

### 7.2 一時的な変更の保存

```bash
# 現在の変更を一時的に保存
git stash

# 保存した変更を復元
git stash pop

# 保存した変更一覧を表示
git stash list

# 特定のスタッシュを適用
git stash apply stash@{0}

# スタッシュを削除
git stash drop stash@{0}

# スタッシュの内容を詳細表示
git stash show -p

# スタッシュから新しいブランチを作成
git stash branch new-branch-name
```

---

## 8. 高度な操作

### 8.1 特定のコミットを取り込む（cherry-pick）

```bash
# 他のブランチの特定コミットを現在のブランチに取り込み
git cherry-pick commit-hash

# 実際の使用例
git cherry-pick 95adcc6  # 短縮形のハッシュを使用
git cherry-pick 95adcc68aff15f4f83b7f8707f03b4b895a3afd9  # 完全なハッシュを使用
```

### 8.2 未追跡ファイルの削除

```bash
# 削除対象を確認（ドライラン）
git clean -n

# 未追跡のファイルやディレクトリを再帰的に削除
git clean -fdx
```

### 8.3 差分の詳細確認

```bash
# ステージング前の変更を表示
git diff

# ステージング後の変更を表示
git diff --staged

# 特定のファイルのステージングを取り消し
git reset filename.txt
```

---

## 9. トラブルシューティング

### 9.1 よくある問題と対処法

#### 問題：間違ったブランチで作業してしまった

```bash
# 変更を一時保存
git stash

# 正しいブランチに切り替え
git checkout correct-branch

# 変更を復元
git stash pop
```

#### 問題：コミットメッセージを間違えた

```bash
# 直前のコミットメッセージを修正
git commit --amend -m "正しいメッセージ"
```

#### 問題：間違えてマージしてしまった場合の復元

```bash
# 1. コミット履歴を確認
git log

# 2. マージ前のコミットに戻す（履歴を書き換える場合）
git reset --hard commit-hash

# 3. 安全にマージを取り消す場合（推奨）
git revert -m 1 merge-commit-hash

# 実際の使用例
git reset --hard 95adcc6  # 特定のコミットに戻す
git revert -m 1 a1b2c3d  # マージコミットを取り消す
```

#### 問題：コンフリクトが発生した場合

```bash
# 1. エディタでコンフリクト解決
# 2. 状態確認
git status

# 3. 変更をステージング
git add .  # または git add -p

# 4. マージを完了
git commit -m "Resolve merge conflicts"
```

---

## 10. 便利なコマンドとTips

### 10.1 コマンド履歴の活用

```bash
# コマンド履歴から特定の文字列を検索
history | grep "git"

# 履歴番号を使用して過去のコマンドを再実行
!123  # 履歴番号123のコマンドを実行
```

### 10.2 効率的な作業のためのTips

- **対話形式のステージング**: `git add -p` を使用して、変更を細かく選択してステージング
- **ブランチ名の検索**: `git branch -a | grep '検索文字列'` でブランチを素早く見つける
- **一時的な作業保存**: `git stash` を活用して、急なブランチ切り替えに対応
- **コミット前の確認**: `git diff --staged` でステージングした内容を必ず確認

---

## まとめ

この記事では、Gitでよく使うコマンドをカテゴリ別に紹介しました。これらのコマンドを覚えておくことで、効率的なGit操作が可能になります。

### 重要なポイント

- 基本的なコマンド（`add`, `commit`, `push`, `pull`）をしっかり覚える
- ブランチ操作を理解して、安全な開発フローを構築する
- トラブル時の対処法を知っておく

### 次のステップ

- チーム開発でのGitワークフローを学ぶ
- Gitの内部構造について理解を深める
- CI/CDパイプラインとの連携を学ぶ

---

## 参考リンク

- [Git公式ドキュメント](https://git-scm.com/doc)
- [GitHub公式ガイド](https://guides.github.com/)
- [Pro Git Book](https://git-scm.com/book/ja/v2)

---

*この記事がGitの学習に役立つことを願っています。質問や改善点があれば、コメントでお知らせください。*
