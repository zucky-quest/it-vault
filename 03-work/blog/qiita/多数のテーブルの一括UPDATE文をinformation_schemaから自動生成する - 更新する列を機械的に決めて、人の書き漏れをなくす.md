---
title: "多数のテーブルの一括 UPDATE 文を information_schema から自動生成する - 更新する列を機械的に決めて、人の書き漏れをなくす"
emoji: "🛠️"
type: "tech"
topics: ["MySQL", "Go", "information_schema", "バッチ処理", "テスト"]
published: false
---
## TL;DR

- テナント単位で、多数のテーブルの値を一括で書き換えるバッチを作りました。その **UPDATE 文を、人が 1 本ずつ書かない**仕組みにしています
- 更新する列は、MySQL の **`information_schema` から機械的に決めます**。主キー・ユニークキー・外部キーと、行を特定する列、日時の列を除いた残りが、すべて書き換えの対象です
- 書き換える値も、列の**デフォルト値・NULL を許すか・型**から自動で決めます
- 人が決めるのは「どのテーブルを、どの条件で、どの順に更新するか」だけです
- 新しいテーブルが増えたら、**対象か対象外かを決めるまで CI が落ちる**ようにしました。列だけでなく、テーブルの書き漏れも防いでいます

## この記事の対象読者

- 多数のテーブルを一括で書き換えるバッチや、データを初期値へ戻す処理を書いている方
- 対象の列を手書きで並べていて、テーブルや列の追加に追従できるか不安な方
- MySQL の `information_schema` を、実務でどう使えるか知りたい方

## 環境

- Go で書いたバッチ（`database/sql`）
- MySQL

## 背景：手で書いた UPDATE 文は、列の追加に追従できない

多数のテーブルの値を一括で書き換えるとき、UPDATE 文を手で書くと、こうなります。

```sql
UPDATE users
SET name = '', email = NULL, note = NULL, ...
WHERE tenant_id IN (...);
```

最初に書くときは丁寧に列を確かめます。問題は、その後です。

- テーブルに列が増えても、UPDATE 文は誰も直さない
- 直すべきだと気付けるのは、その列の存在を知っている人だけ
- 書き換え損ねた列があっても、テストは通る

テーブルも列も、プロダクトの開発に合わせて増え続けます。手書きの UPDATE 文は、**書いた時点のスキーマでしか正しくありません**。

そこで、更新する列を人が並べるのをやめ、**スキーマから機械的に決める**ことにしました。

## 考え方：「書き換える列」ではなく「残す列」を決める

書き換える列を探して並べると、列が増えるたびに漏れが生まれます。そこで発想を逆にし、**残す列**を決めて、それ以外をすべて書き換えることにしました。

残す列の方が、ずっと少なく、決まった形をしています。キーや、行を特定する列、日時の列といった、どのテーブルにも共通する列だからです。

## 残す列：キーと、行を特定する列だけ

| 残す列 | 理由 |
| --- | --- |
| 主キー（`PRI`）とユニークキー（`UNI`） | 書き換えると、行を特定できなくなる。一意性の制約にも引っかかる |
| 外部キー | 書き換えると、テーブル間の関係が壊れる |
| 複数の列で作るユニークキーの構成列 | 同じ値にそろえると、一意性の制約に引っかかる |
| 行を特定する列（`tenant_id`・`user_id` など）と、コードの列 | 書き換える行を絞り込む条件に使う |
| 日時の列（`created_at`・`updated_at`・`deleted_at`） | いつのデータかは残す |

それ以外の列は、すべて書き換えます。

## 実装：information_schema から更新する列を取る

更新する列は、テーブルごとに `information_schema` へ問い合わせて取ります。

```sql
-- 説明用に簡略化したクエリ。? にはスキーマ名・テーブル名・残す列の名前を渡す
SELECT c.COLUMN_NAME, c.COLUMN_DEFAULT, c.IS_NULLABLE, c.DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS AS c
WHERE c.TABLE_SCHEMA = ? AND c.TABLE_NAME = ?
  -- 1 列だけの主キーとユニークキーを除く
  AND c.COLUMN_KEY NOT IN ('PRI', 'UNI')
  -- 行を特定する列と日時の列を除く
  AND c.COLUMN_NAME NOT IN ('tenant_id', 'user_id', 'code', 'created_at', 'updated_at', 'deleted_at')
  -- 外部キーの列を除く
  AND NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS fk
    WHERE fk.TABLE_SCHEMA = c.TABLE_SCHEMA AND fk.TABLE_NAME = c.TABLE_NAME
      AND fk.COLUMN_NAME = c.COLUMN_NAME
      AND fk.REFERENCED_TABLE_NAME IS NOT NULL
  )
  -- 複数の列で作るユニークキーの構成列を除く
  AND NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
    JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS k
      ON k.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA
     AND k.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
     AND k.TABLE_NAME = tc.TABLE_NAME
    WHERE tc.TABLE_SCHEMA = c.TABLE_SCHEMA AND tc.TABLE_NAME = c.TABLE_NAME
      AND tc.CONSTRAINT_TYPE = 'UNIQUE'
      AND k.COLUMN_NAME = c.COLUMN_NAME
      AND (SELECT COUNT(*) FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS k2
           WHERE k2.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA
             AND k2.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
             AND k2.TABLE_NAME = tc.TABLE_NAME) > 1
  );
```

ポイントは、複数の列で作るユニークキーの扱いです。`COLUMN_KEY` が `UNI` になるのは、1 列だけのユニークキーです。複数の列で作るユニークキーの構成列は `COLUMN_KEY` に現れないので、`TABLE_CONSTRAINTS` と `KEY_COLUMN_USAGE` から別に拾っています。これを見落とすと、複数の行が同じ値になり、一意性の制約で UPDATE が失敗します。

## 書き換える値も、列の定義から決める

取れた列ごとに、書き換える値を列の定義から決めます。

```go
// 列の定義から、書き換える値を決める（説明用に簡略化したコード）
func resetValue(col Column) string {
	if col.Default != nil {
		return "DEFAULT" // デフォルト値があれば、それに戻す
	}
	if col.Nullable {
		return "NULL" // NULL を許すなら NULL にする
	}
	// どちらも無ければ、型ごとの空の値にする
	switch col.DataType {
	case "int", "bigint", "tinyint", "smallint", "decimal":
		return "0"
	case "datetime", "timestamp":
		return "'1970-01-01 00:00:00'"
	case "json":
		return "'{}'"
	default: // varchar・text など
		return "''"
	}
}
```

優先順位は、デフォルト値 → NULL → 型ごとの空の値です。

- **デフォルト値があれば、それに戻す。** アプリが「初期状態」として扱える値なので、一番安全です
- **NULL を許すなら NULL にする。** 値が無い状態を表せます
- **どちらも無ければ、型ごとの空の値にする。** NOT NULL の制約を満たしつつ、元の値を消せます

この処理は通信をしない純粋な関数にしてあるので、型の組み合わせごとに単体テストで確かめています。

## 人が決めるのは、テーブルと条件と順番だけ

人が書くのは、テーブルごとの次の 3 つだけです。

```go
// 人が書くのは、テーブルごとのこの 3 つだけ（説明用に簡略化したコード）
type Target struct {
	Table string // テーブル名
	Where string // 書き換える行の条件
	Order int    // 更新の順番
}
```

条件は、テナントとの関係の持ち方で 3 つの型に分かれます。

| テナントとの関係 | 条件の形 |
| --- | --- |
| テナント ID を直接持つ | `tenant_id IN (@tenant_ids)` |
| ユーザーを経由する | `EXISTS (SELECT 1 FROM users u WHERE {table}.user_id = u.id AND u.tenant_id IN (@tenant_ids))` |
| 親テーブルを経由する | `EXISTS (SELECT 1 FROM {parent} p ... WHERE {table}.{fk} = p.id AND ... tenant_id IN (@tenant_ids))` |

`@tenant_ids` は、実行時に対象のテナント ID に置き換えます。順番は、テーブルの依存関係に合わせて 1 つのトランザクションの中で処理する順を決めるためのものです。

UPDATE 文は、この 3 つと、自動で決めた更新する列を組み合わせて作ります。

```go
stmt := fmt.Sprintf("UPDATE %s SET %s WHERE %s;", target.Table, strings.Join(assignments, ", "), where)
```

更新する列が 1 つも残らないテーブル（すべてキーと除外の列）は、UPDATE 文を作らずにログを出します。

## テーブルごとに並列で生成する

テーブルの数が多いと、`information_schema` への問い合わせも多くなります。生成はテーブル単位で並列にしました。

```go
// テーブル単位で並列に生成し、最後に人が決めた順番で並べ直す（説明用に簡略化したコード）
g, ctx := errgroup.WithContext(ctx)
g.SetLimit(10) // 同時に information_schema へ問い合わせる数を絞る

stmts := make([]Statement, len(targets))
for i, t := range targets {
	g.Go(func() error {
		stmt, err := buildUpdate(ctx, db, t, tenantIDs)
		stmts[i] = stmt
		return err
	})
}
if err := g.Wait(); err != nil {
	return nil, err
}
sort.SliceStable(stmts, func(a, b int) bool { return stmts[a].Order < stmts[b].Order })
```

並列で作ると、出来上がる順番はばらばらになります。集めた後で、人が決めた順番で並べ直してから実行します。

## テーブルの一覧も、外部キーから自動で作れないか

外部キーが宣言されていれば、テーブルの一覧も `information_schema` から集められそうに見えます。実際、外部キーを辿れば、テナントにつながるテーブルの候補を洗い出せます。更新の順番も、外部キーのつながりから決められます。

それでも、一覧は人が決めることにしました。理由は 2 つです。

1 つは、**すべてのつながりが外部キーとして宣言されているとは限らない**ことです。列の名前の約束だけでつながっているテーブルは、外部キーを辿っても見つかりません。

もう 1 つは、**つながっていることと、処理の対象にすべきことは別の問題**だからです。対象にするかどうかは、人が判断する必要があります。

そこで、新しいテーブルを見つけるのは CI、対象にするかを決めるのは人、という分担にしました。次の節が、その CI の仕組みです。

## テーブルの書き漏れは、CI で止める

列は自動で決まるようになりました。しかし、テーブルそのものを対象に入れ忘れたら、そのテーブルは丸ごと書き換わりません。

そこで、**スキーマにある全テーブルが「対象」か「対象外」のどちらかに分類されているか**を、テストで確かめるようにしました。

```go
// スキーマの全テーブルが「対象」か「対象外リスト」のどちらかに入っていることを確かめる。
// どちらにも無い「未分類」のテーブルがあれば失敗させ、CI でマージを止める（説明用の概要）
func TestEveryTableIsClassified(t *testing.T) { ... }
```

開発で新しいテーブルが増え、参照用のスキーマを更新すると、そのテーブルは「未分類」として検出されます。対象に入れるか、理由を書いて対象外のリストに入れるまで、CI が通りません。

**列は機械で決め、テーブルは人が決めるが、決め忘れは CI が止める。** この 2 段で、書き漏れが入り込む余地をなくしています。

新しいテーブルを調べる作業は、手順を AI エージェントのスキルにしてあります。判定の基準と調査の手順を読み込ませ、テーブルを対象にするか、どの条件で絞るかの案を作らせます。最後に判断するのは人です。

## 実行前に、生成した UPDATE 文を確かめる

自動で作る仕組みは、何が作られたかを確かめられないと怖くて使えません。そこでドライランのモードを用意しました。

```text
batch --dry-run
```

ドライランでは、対象を選び、UPDATE 文を生成して JSON のファイルに書き出したところで止まります。DB は書き換えません。本番で実行する前に、どのテーブルのどの列が、どの値に書き換わるかを、生成物で確かめられます。

## まとめ

| 仕組み | 防いでいること |
| --- | --- |
| 更新する列を `information_schema` から決める | 列の追加に UPDATE 文が追従しない |
| 「残す列」を決め、それ以外をすべて書き換える | 書き換える列を探して並べる手間と、その漏れ |
| 書き換える値を列の定義から決める | NOT NULL やデフォルト値に合わない値での失敗 |
| 複数の列で作るユニークキーの構成列も除く | 一意性の制約による UPDATE の失敗 |
| 全テーブルの分類を CI で確かめる | テーブルそのものの入れ忘れ |
| ドライランで生成物を確かめる | 自動生成の中身が見えない不安 |

学びは 2 つです。

1. **書き漏れは、人の注意ではなく仕組みで防ぐ。** 「列を追加したら UPDATE 文も直す」という取り決めは、いずれ漏れます。スキーマから機械的に決めれば、取り決め自体が要らなくなります
2. **「何を書き換えるか」より「何を残すか」を決める。** 書き換える対象は増え続けますが、残す列は少なく、形が決まっています。決める側を小さくすると、仕組みにしやすくなります

## 参考

- [MySQL: The INFORMATION_SCHEMA COLUMNS Table](https://dev.mysql.com/doc/refman/8.0/en/information-schema-columns-table.html)
- [MySQL: The INFORMATION_SCHEMA KEY_COLUMN_USAGE Table](https://dev.mysql.com/doc/refman/8.0/en/information-schema-key-column-usage-table.html)
