---
title: "launchdから~/Documentsは見えない - Obsidian Vault自動バックアップで踏んだmacOS TCCの壁"
emoji: "🔒"
type: "tech"
topics: ["macOS", "launchd", "TCC", "Obsidian", "Bash"]
published: false
---

## TL;DR

- Obsidian Vault を Google Drive からローカルへ移し、**launchd で日次バックアップ**を組んだ
- 移設先に `~/Documents` を選んだら、**launchd から起動したプロセスが一切アクセスできなかった**。macOS の TCC（プライバシー保護）が理由で、**許可ダイアログすら出ずに黙って失敗する**
- 移設先を変えても今度は保存先の `~/Library/CloudStorage`（Google Drive のマウント）で詰まった。ここも TCC 対象
- 実験して権限の境界を測ったところ、**launchd は「自分が作ったファイル」なら作成・上書き・削除できるが、`ls` によるディレクトリ一覧と他プロセスが作ったファイルの削除ができない**とわかった
- `ls` を使わない世代管理に書き換えて解決。フルディスクアクセスの付与は不要
- おまけで、**バックアップが「成功」とログに記録されながら中身が更新されていない**という失敗と、`find -iname '*ログイン*'` が日本語ファイル名に一致しない NFD 問題も踏んだ

## この記事の対象読者

- macOS で launchd / cron によるバックアップや定期処理を組んでいる方
- クラウドストレージのマウント（`~/Library/CloudStorage`）をスクリプトから触りたい方
- Obsidian Vault の置き場所とバックアップ構成を検討している方
- 「スクリプトを手で実行すると動くのに、自動実行だと動かない」に心当たりのある方

## 環境

- macOS 15（Darwin 25.5.0）
- Google Drive デスクトップ版（ストリーミングモード）
- Obsidian（Markdown 約 120 ファイル、12MB）
- bash / launchd（`StartCalendarInterval`）

## 背景：Vault をクラウド同期から外したかった

Obsidian の Vault を Google Drive のマイドライブ直下に置いて運用していました。これを見直した理由は 2 つあります。

1 つは実用上の理由です。Google Drive のストリーミングモードはファイルをローカルキャッシュから退避（evict）することがあり、オフラインで開けなくなります。Obsidian が頻繁に書き換える `workspace.json` が同期競合の原因にもなります。

もう 1 つは、**Vault を読むものが増えた**ことです。クラウド同期に加えて、コミュニティプラグインは Vault 内の全ファイルを読めますし、Claude Code のような AI エージェントを Vault で起動すればそこが作業ディレクトリになります。「自分の Mac の中のテキストファイル」という前提はもう成り立ちません。

そこで Vault をローカルへ移し、代わりに **Google Drive へ日次でアーカイブを書き出す**構成に変えることにしました。同期で実体を置くのをやめ、バックアップ先としてだけ使う形です。

構成はこうです。

```text
~/obsidian/business-vault     ← Vault 本体（ローカル、git 管理）
        ↓ launchd で毎日 12:30
マイドライブ/backups/business-vault/business-vault-YYYY-MM-DD.tar.gz（30世代）
```

問題はここから起きました。

## 壁 1：移設先を `~/Documents` にしたら launchd から見えなかった

最初、Vault の移設先を `~/Documents/obsidian/business-vault` にしました。macOS の標準的な書類置き場ですし、Time Machine の対象にも標準で含まれます。

バックアップスクリプトを書いて手動実行すると、問題なく動きました。

```bash
$ ~/bin/backup-business-vault.sh
$ tail ~/Library/Logs/backup-business-vault.log
2026-09-13 15:10:13 アーカイブ作成: business-vault-2026-09-13.tar.gz (13M)
```

ところが launchd に登録して実行させると、こうなりました。

```bash
$ launchctl kickstart -k "gui/$(id -u)/com.example.backup-business-vault"
```

```text
tar: Could not pack extended attributes: Operation not permitted
tar: business-vault: Couldn't visit directory: Operation not permitted
tar: Error exit delayed from previous errors.
```

`~/Documents` は macOS Catalina 以降 **TCC（Transparency, Consent, and Control）の保護対象**です。アプリがアクセスするには利用者の許可が要ります。

ここで重要なのは、**対話的なアプリと非対話的なプロセスで挙動が違う**点です。

| 実行元 | 挙動 |
| --- | --- |
| Obsidian、ターミナル | 初回に許可ダイアログが出る。1 回許可すれば以降は通る |
| launchd から起動したプロセス | **ダイアログが出ない。黙って `Operation not permitted` で失敗する** |

手動実行が通ったのは、ターミナルに既に許可が与えられていたからでした。自動化した瞬間に破綻する、という分かりにくい壊れ方をします。

### 使い捨てエージェントで境界を測る

推測で対処すると時間を溶かすので、最小のエージェントを作って実測しました。

```bash
cat > /tmp/tcc-probe.sh <<'EOF'
#!/bin/bash
OUT="$HOME/Library/Logs/tcc-probe.log"
: > "$OUT"
echo "[~/Documents]  $(ls "$HOME/Documents" 2>&1 | head -1)" >> "$OUT"
echo "[~/tcc-probe]  $(ls "$HOME/tcc-probe" 2>&1 | head -1)" >> "$OUT"
EOF
chmod 755 /tmp/tcc-probe.sh
```

plist を書いて `launchctl bootstrap` → `kickstart` で走らせ、ログを見ます。

```text
[~/Documents]  ls: /Users/xxx/Documents: Operation not permitted
[~/tcc-probe]  file.txt
```

ホーム直下の任意のフォルダ（`~/tcc-probe`）は問題なく読めました。つまり **TCC 対象ディレクトリを避ければ解決する**とわかります。

Vault を `~/obsidian/business-vault` へ移しました。ホーム直下は TCC の対象外です。

## 壁 2：`~/Library/CloudStorage` も TCC 対象だった

Vault 側は解決しましたが、次は保存先で止まりました。

```text
rm: /Users/xxx/Library/CloudStorage/GoogleDrive-xxx/マイドライブ/backups/.../business-vault-2026-09-13.tar.gz: Operation not permitted
cp: /Users/xxx/Library/CloudStorage/.../business-vault-2026-09-13.tar.gz: Operation not permitted
```

Google Drive のマウントポイントである `~/Library/CloudStorage` も TCC の保護対象でした。`~/Documents` を避けただけでは足りなかったわけです。

ここで妙なことに気づきます。**その前の実行では、同じディレクトリに新規ファイルを作れていた**のです。作成はできて削除はできない、という非対称性があります。

### 実測：launchd から CloudStorage に何ができるのか

もう一度プローブを書きました。ターミナル（許可あり）で作ったファイルを 1 つ置いておき、launchd から 5 通りの操作を試します。

```bash
cat > /tmp/drive-probe.sh <<'EOF'
#!/bin/bash
D="$HOME/Library/CloudStorage/GoogleDrive-xxx/マイドライブ/backups/business-vault"
O="$HOME/Library/Logs/drive-probe.log"
: > "$O"
echo "[1 新規作成]     $(echo hi  > "$D/probe-new.txt" 2>&1 && echo OK || echo NG)" >> "$O"
echo "[2 自作を上書き] $(echo hi2 > "$D/probe-new.txt" 2>&1 && echo OK || echo NG)" >> "$O"
echo "[3 自作を削除]   $(rm -f "$D/probe-new.txt" 2>&1 && echo OK || echo NG)" >> "$O"
echo "[4 他作を削除]   $(rm -f "$D/probe-by-terminal.txt" 2>&1 && echo OK || echo NG)" >> "$O"
echo "[5 一覧取得]     $(ls "$D" 2>&1 | head -1)" >> "$O"
EOF
```

結果です。

```text
[1 新規作成]     OK
[2 自作を上書き] OK
[3 自作を削除]   OK
[4 他作を削除]   rm: ...: Operation not permitted / NG
[5 一覧取得]     ls: ...: Operation not permitted
```

表にするとこうなります。

| 操作 | launchd から | 備考 |
| --- | --- | --- |
| 新規ファイルの作成 | ✅ 可 | |
| 自分が作ったファイルの上書き | ✅ 可 | |
| 自分が作ったファイルの削除 | ✅ 可 | |
| 他プロセスが作ったファイルの削除 | ❌ 不可 | ターミナルで作ったものは触れない |
| `ls` によるディレクトリ一覧 | ❌ 不可 | **これが世代管理を壊す** |

**「自分が作ったものだけ触れる」**という境界です。この挙動はドキュメントで明示されているのを見つけられず、実測して初めてわかりました。

### `ls` を使わない世代管理

最初の実装は、よくある形で書いていました。

```bash
# Before: ls で一覧を取って古い順に削除する
cd "$DEST"
ls -1t business-vault-*.tar.gz | tail -n +$((KEEP+1)) | while read -r old; do
  rm -f "$old"
done
```

`ls` が使えないので、この方針自体が成立しません。代わりに、**日付から削除対象のファイル名を直接組み立てる**方式にしました。ファイル名が `business-vault-YYYY-MM-DD.tar.gz` と決まっているので、一覧を取らなくても「30 日前のファイル名」は計算できます。

```bash
# After: ls を使わず、日付から対象を組み立てる
# 起動していない日があっても取りこぼさないよう 15 日分の幅で掃除する
for d in $(seq "$KEEP" $((KEEP + 15))); do
  old="$DEST/business-vault-$(date -v-"${d}"d '+%Y-%m-%d').tar.gz"
  [ -f "$old" ] && rm -f "$old" 2>/dev/null && echo "削除: $(basename "$old")"
done
```

存在しないファイルへの `rm -f` は成功扱いなので、素直に書けます。

あわせて、**保存先のファイルをすべて launchd に作らせる**必要があります。動作確認のつもりでターミナルから手動実行してファイルを置くと、launchd がそれを上書きも削除もできなくなり、世代管理が壊れます。最初にターミナルで作ったアーカイブは消して、launchd に作り直させました。

この制約はスクリプトのコメントに残しています。半年後の自分は絶対に忘れるためです。

### 検討した他の選択肢

`/bin/bash` にフルディスクアクセスを与えれば解決はします。ただ、**bash 経由で動くすべてのスクリプトが全ディスクにアクセスできるようになる**ので、権限を絞る作業の最中にやることではないと判断しました。専用の `.app` を作ってそれだけに付与する方法もありますが、`ls` を避ける数行の変更で済むなら、そちらのほうが軽いです。

## 壁 3：「成功」とログに出るのに中身が更新されない

これがいちばん危険な失敗でした。

最初の実装は、破損対策として一時ファイルに書いてから `mv` で置き換えていました。定石のつもりでした。

```bash
tar czf "$TMP" ... && mv -f "$TMP" "$ARCHIVE"
log "アーカイブ作成: $(basename "$ARCHIVE")"
```

ログは「作成」と出ます。終了コードも 0 です。ところが**アーカイブの中身が更新されていませんでした**。

気づいたのは、展開して git のログを見たときです。

```bash
$ tar xzf business-vault-2026-09-13.tar.gz -C /tmp/verify
$ git -C /tmp/verify/business-vault log --oneline
35b1210 business-vault: ローカル管理への移行と秘密情報の分離
```

直前に作ったはずのコミットが入っていません。Drive のマウント上では `mv` による既存ファイルの置き換えが効かず、しかも**そのエラーがスクリプトの制御に反映されていませんでした**（`set -e` なしで `mv` の戻り値を見ていなかった）。ファイルサイズもタイムスタンプも、File Provider 越しだと直感に反する見え方をします。

対処として、**転送後に検証する**構成に変えました。

```bash
# 1) ローカルで作成し、その場で整合性を確認
tar czf "$LOCAL" -C "$(dirname "$VAULT")" --exclude='.DS_Store' "$(basename "$VAULT")" || die "tar に失敗"
tar tzf "$LOCAL" >/dev/null 2>&1 || die "作成したアーカイブが壊れています"
SRC_SIZE=$(stat -f%z "$LOCAL")

# 2) Drive へ転送（rename の置き換えは信用しない）
cp -f "$LOCAL" "$ARCHIVE" 2>>"$LOG" || die "Drive への転送に失敗"

# 3) 転送後にサイズ照合と展開可否を再確認
DST_SIZE=$(stat -f%z "$ARCHIVE" 2>/dev/null || echo 0)
[ "$SRC_SIZE" = "$DST_SIZE" ] || die "転送後のサイズ不一致 ($SRC_SIZE / $DST_SIZE)"
tar tzf "$ARCHIVE" >/dev/null 2>&1 || die "Drive 上のアーカイブが読めません"
```

ポイントは 3 つです。

- **アーカイブはローカルで作る。** ネットワーク越しのファイルシステムに `tar` で直接書かない
- **`mv` による置き換えを前提にしない。** `rm` してから `cp` する
- **終了コードを信じない。** サイズ照合と `tar tzf` まで通って初めて「成功」とログに書く

この変更後、同じ失敗は再現しなくなりました。ログの「成功」が実際の成功と一致するようになったのが、いちばんの収穫です。

## おまけ：`find -iname '*ログイン*'` が日本語ファイル名に一致しない

TCC とは別件ですが、同じ作業中に踏んだので書いておきます。

Vault 内の秘密情報を洗い出すため、ファイル名で検索をかけました。

```bash
$ find . -name '*.md' -iname '*ログイン*'
./hr-signals/ログイン情報.md
```

1 件だけヒットしました。ところが実際には 3 件ありました。

```bash
$ python3 -c "
import unicodedata, pathlib
for p in pathlib.Path('.').rglob('*.md'):
    if 'ログイン' in unicodedata.normalize('NFC', p.name):
        form = 'NFD' if p.name != unicodedata.normalize('NFC', p.name) else 'NFC'
        print(f'{form}: {p}')
"
NFD: ./AI Assistant/ログイン情報.md
NFC: ./hr-signals/ログイン情報.md
NFD: ./memo/ログイン情報.md
```

macOS はファイル名を **NFD（分解形）** で保存します。「グ」は「ク」＋濁点として格納されるため、NFC（合成形）で書いた検索語とはバイト列が一致しません。同じディレクトリツリー内で NFC と NFD が混在することもあります（作成経路によって変わります）。

シェルの `find` や `grep` は正規化してくれないので、**日本語ファイル名を対象にした検索は、正規化を挟める言語で書くのが安全**です。この取りこぼしのせいで、秘密情報を含むノートを 1 件見逃しかけました。

## まとめ

macOS で launchd による自動処理を組むときは、**TCC 対象ディレクトリを触らない設計にするのが最も確実**です。

| 場所 | launchd から |
| --- | --- |
| `~/Documents` `~/Desktop` `~/Downloads` | ❌ 一切アクセス不可 |
| `~/Library/CloudStorage` | ⚠️ 自分が作ったファイルのみ操作可。`ls` 不可 |
| `~/obsidian` などホーム直下の任意のフォルダ | ✅ 制約なし |

得られた指針は 3 つです。

1. **自動処理の対象は TCC 対象ディレクトリの外に置く。** フルディスクアクセスの付与は最後の手段
2. **ネットワークファイルシステム上で `mv` の置き換えを前提にしない。** `rm` してから `cp`
3. **終了コードを成功の定義にしない。** 転送後の検証まで含めて初めて成功

3 つ目がいちばん重要だと思っています。「成功とログに出ているのに中身が古い」バックアップは、必要になるまで誰も気づきません。**検証がないバックアップは、バックアップがあるという思い込みでしかない**というのを、今回はっきり体験しました。

権限で行き詰まったときに、推測を重ねず 20 行のプローブを書いて実測したのも良い判断でした。ドキュメントに書かれていない挙動は、測れば 5 分でわかります。

## 参考

- [Apple Platform Security - Protecting user data](https://support.apple.com/guide/security/protecting-user-data-sec6cb52c8a7/web)
- [launchd.plist(5) man page](https://keith.github.io/xcode-man-pages/launchd.plist.5.html)
- [Unicode Normalization Forms (UAX #15)](https://unicode.org/reports/tr15/)
