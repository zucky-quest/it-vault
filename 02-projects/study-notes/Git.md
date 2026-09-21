# Git

## ブランチ関連

### ブランチ名の検索(絞り込み)方法

- ブランチ名の検索(絞り込み)方法

    以下のコマンドを実行ブランチ名（-aオプションでリモートブランチも対象にできる）

    ```bash
    git branch -a | grep '例）suzuki'
    ```

- どちらのブランチから切ったのか調べる方法
  - `git log --oneline --graph --decorate`
- 頻繁に使用するコマンド

    Gitを使用する際に頻繁に使うコマンドを以下にリストアップします。

    1. **リポジトリの初期化・クローン**
        - `git init`: 現在のディレクトリに新しいGitリポジトリを初期化する。
        - `git clone [url]`: リモートリポジトリをローカルにクローンする。
    2. **変更の追跡・ステージング**
        - `git status`: 変更のステータスを確認する。
        - `git add [file-name]`: 特定のファイルの変更をステージングエリアに追加する。
        - `git add .`: すべての変更をステージングエリアに追加する。
        - `git add -p`: 対話形式でステージングエリアに追加する**便利！**
  - **コミット**
    - `git commit -m "Commit message"` ステージングエリアの変更をコミット
    - `git commit —amend` 直前のコミットを修正
    - `git commit -a -m “Commit message”` ワーキングエリアの変更を全てコミット
    1. **ブランチ関連**
        - `git branch`: ローカルのブランチを一覧表示する。
        - `git branch [branch-name]`: 新しいブランチを作成する。
        - `git checkout [branch-name]`: 指定したブランチに切り替える。
        - `git checkout -`: ひとつ前のブランチに切り替える。
        - `git checkout -b [branch-name]`: 新しいブランチを作成し、そのブランチに切り替える。
        - `git branch -m [branch-name]`: ブランチ名を変更する。
        - `git branch -D [branch-name]`: ブランチを削除する。
    2. **リモート関連**
        - `git remote -v`: リモートリポジトリを一覧表示する。
        - `git push [remote-name] [branch-name]`: リモートリポジトリに変更をプッシュする。
        - `git pull [remote-name] [branch-name]`: リモートリポジトリから変更をプルする。
        - `git push --delete origin [branch-name]`: リモートリポジトリからブランチを削除する
    3. **マージとリベース**
        - `git merge [branch-name]`: 指定したブランチを現在のブランチにマージする。
        - `git rebase [base-branch-name]`: 現在のブランチのコミットを指定したブランチの上にリベースする。
    4. **履歴の表示**
        - `git log`: コミット履歴を表示する。
        - `git log --oneline`: コミット履歴を1行で表示する。
        - `git log --graph --oneline`: ブランチとマージの視覚的なグラフとともにコミット履歴を表示する。
    5. **その他**
        - `git diff`: ステージング前の変更を表示する。
        - `git diff --staged`: ステージング後の変更を表示する。
        - `git reset [file-name]`: 特定のファイルのステージングを取り消す。
        - `git reset --hard [commit-hash]`: HEADとワーキングディレクトリを特定のコミットにリセットする。

    この他にも多くのGitコマンドやオプションがありますが、上記のコマンドは日常の開発で頻繁に使われるものです。

- 作業内容を一時的に保存(stash)

    Gitのスタッシュ機能は、作業中の変更を一時的に保存し、後で取り出せるようにするものです。以下に、スタッシュの基本的な使い方を説明します。

    1. **スタッシュの作成**: 現在の変更をスタッシュに保存します。

        ```
        git stash
        
        ```

    2. **スタッシュのリスト表示**: 保存されたスタッシュのリストを表示します。

        ```
        git stash list
        
        ```

    3. **スタッシュの適用**: 最後に保存したスタッシュを適用します。

        ```
        git stash apply
        
        ```

        特定のスタッシュを適用したい場合は、スタッシュの名前（例: `stash@{0}`）を指定します。

        ```
        git stash apply stash@{0}
        
        ```

    4. **スタッシュの削除**: 最後に保存したスタッシュを削除します。

        ```
        git stash drop
        
        ```

        特定のスタッシュを削除する場合は、スタッシュの名前を指定します。

        ```
        git stash drop stash@{0}
        
        ```

    5. **スタッシュのポップ**: スタッシュを適用し、そのスタッシュをリストから削除します。

        ```
        git stash pop
        
        ```

        特定のスタッシュをポップする場合は、スタッシュの名前を指定します。

        ```
        git stash pop stash@{0}
        
        ```

    6. **スタッシュの内容を表示**: 特定のスタッシュの内容を確認します。

        ```
        git stash show
        
        ```

        詳細な差分を表示するには `-p` オプションを使用します。

        ```
        git stash show -p
        
        ```

    7. **スタッシュを含む新しいブランチの作成**: スタッシュを新しいブランチに適用し、そのブランチで作業を続けます。

        ```
        git stash branch new_branch_name
        
        ```

        特定のスタッシュを新しいブランチに適用する場合は、スタッシュの名前を指定します。

        ```
        git stash branch new_branch_name stash@{0}
        
        ```

    8. **すべてのスタッシュの削除**: すべてのスタッシュを削除します。

        ```
        git stash clear
        
        ```

    スタッシュを使う際には、どのスタッシュがどの作業に関連しているかを把握しておくことが重要です。`git stash list` を定期的に使って、スタッシュされた内容を確認しましょう。また、スタッシュは一時的な保存のためのものなので、必要ないスタッシュは定期的に削除することをお勧めします。

- 以前の状態に戻す(restore, clean)
  - `git restore .` 　変更をワーキングディレクトリから削除
  - `git restore --staged .`　変更をステージングエリアから削除
  - clean
        1. `git clean -n` cleanコマンドは強力なコマンドであり復元もできないため、削除される対象をドライランで確認
        2. `git clean -fdx` ワーキングディレクトリから未追跡のファイルやディレクトリを再帰的に削除
- 他のブランチのコミットを取り込み方(cherry-pick)
    1. `git log`でcommit IDを調べる
    2. コミットしたいブランチで以下のコマンドを実行

    ```bash
    git cherry-pick 例）95adcc68aff15f4f83b7f8707f03b4b895a3afd9
    ```

- Gitコマンド以外で度々使用するコマンド
  - `history | grep (string)`コマンドの履歴を確認
  - `!(int)`コマンドの履歴番号を使用して過去のコマンドを再度実行
- 間違えてマージしてしまった場合の復元手順
    1. `git log` でcommit IDを調べる

    ```sql
    h.suzuki@D4NY0J3:~/gitSource/ranking-deli_jp_local_docker/cocoa-job-jp-src$ git log
    commit ae887b568c9363e94c22de149289b3cbad6001c1 (HEAD -> release, origin/CCA-1269_improvement_review_suzuki, CCA-1269_improvement_review_suzuki)
    Author: h.suzuki <h.suzuki@core-tech.jp>
    Date:   Tue Dec 12 17:32:34 2023 +0900
    
        間違えてマージ
    
    commit 8a8f1ac6cfb7a4127ef7747518e93750c6902e9a (origin/release)
    Author: h.suzuki <h.suzuki@core-tech.jp>
    Date:   Tue Dec 12 13:27:10 2023 +0900
    
        fix initial display dekasegi review
    ```

    1. `git reset --hard 8a8f1ac6cfb7a4127ef7747518e93750c6902e9a`
- コンフリクト対応
    1. エディタでコンフリクト解決
    2. `git status`
    3. `git add .` or `git add -p`
    4. `git commit -m "Resolve merge conflicts"`

[VSCodeを用いたソースレビュー(ブランチ間の差分を確認)](https://www.notion.so/VSCode-d7c451213f304882b3b9f9451598be6c?pvs=21)
