---
title: アイコンだけのボタンは axe を素通りする - jsdom の単体テストに axe-core を直接組み込み、独自ルールで穴を埋める
emoji: ♿
type: tech
topics:
  - accessibility
  - axe
  - Vitest
  - React
  - テスト
published: true
url:
---
## TL;DR

- React の単体テスト（Vitest + jsdom）に、a11y（アクセシビリティ）の自動検査ツール **axe** を組み込みました
- 定番の `vitest-axe` は使わず、**axe-core を直接呼ぶ約 100 行のヘルパー**を作りました。保守が止まっていて、新しい jsdom で動かない報告もあるためです
- jsdom はレイアウトを持たないので、**既定のルールを jsdom に合わせて調整**しています。色のコントラストは常に無効、ページ全体が要るルールはページのテストでだけ有効です
- 目玉は**独自ルール**です。アイコンをフォントのリガチャで描いていると、アイコンだけのボタンで `aria-label` を付け忘れても、`more_vert` という文字が名前とみなされて **axe の標準ルールを素通りします**
- 導入と同時に、既存の画面から **4 種類の違反**を見つけて直しました

## この記事の対象読者

- Vitest や Jest のコンポーネントテストで、a11y を自動で検査したい方
- Material Symbols などのアイコンフォント（リガチャで描くアイコン）を使っている方
- 検査ツールを入れたいが、例外の管理で形骸化させたくない方

## 環境

- React + TypeScript + Vite
- Vitest + Testing Library（jsdom）
- axe-core 4.14（開発依存）

## 背景：名前の無い入力欄が、E2E を書くまで見つからなかった

アクセシビリティは、これまで規約とレビューで担保していました。ところがあるとき、**名前の無い入力欄**が見つかりました。見つけたのはレビューではなく、後から E2E を書いたときです。それまでは、規約にもレビューにも引っかかっていませんでした。

名前の無い入力欄やボタン、空の列見出しは、機械的に見つけられる種類の問題です。人の目に頼らず、**PR の時点で単体テストが落ちる**ようにしたいと考えました。

## vitest-axe を使わない理由

Vitest で axe を使うなら、`vitest-axe` という橋渡しのライブラリが定番です。しかし採用しませんでした。

- **保守が止まっている**
- **jsdom 28 以降で動かないという報告**がある（[chaance/vitest-axe#30](https://github.com/chaance/vitest-axe/issues/30)）

やりたいことは「axe を実行して、違反があればテストを落とす」だけです。そこで axe-core を直接呼ぶ小さなヘルパーを自分で書きました。axe-core は開発依存に入れ、テストからだけ使います。ビルドの成果物には入りません。

使い方は 1 行です。

```tsx
// 部品・画面の検査
await expectNoA11yViolations();

// シェル（ヘッダーやナビゲーション）まで含むページ全体の検査
await expectNoA11yViolations(document.body, { scope: 'page' });
```

違反があると、ルール名・説明・対象の要素を並べてテストが落ちます。

## ヘルパーの設計

ヘルパーの本体は次のとおりです（独自ルールの部分は後述）。

```ts
import type { Result, RuleObject } from 'axe-core';
import axe from 'axe-core';

/** jsdom では正しく判定できないため、常に無効にするルール */
const JSDOM_UNSUPPORTED_RULES = ['color-contrast'];

/** ページ全体を描画したときにだけ意味を持つルール */
const PAGE_LEVEL_RULES = ['region', 'landmark-one-main', 'page-has-heading-one', 'bypass'];

export type A11yCheckOptions = {
  scope?: 'component' | 'page';
  /** そのテストでだけ外すルールと、外す理由（直すチケット番号を書く） */
  disabledRules?: Record<string, string>;
};

export async function expectNoA11yViolations(
  context: Element = document.body,
  { scope = 'component', disabledRules = {} }: A11yCheckOptions = {},
): Promise<void> {
  const disabled = [
    ...JSDOM_UNSUPPORTED_RULES,
    ...(scope === 'page' ? [] : PAGE_LEVEL_RULES),
    ...Object.keys(disabledRules),
  ];
  const rules: Record<string, RuleObject[string]> = Object.fromEntries(
    disabled.map((id) => [id, { enabled: false }]),
  );

  const { violations } = await axe.run(context, { rules });
  if (violations.length > 0) {
    throw new Error(`a11y の違反が ${violations.length} 件あります。\n${formatViolations(violations)}`);
  }
}
```

設計で決めたことは 4 つです。

### 1. container ではなく document.body を検査する

Testing Library の `render` は `container` を返すので、そこだけを検査したくなります。しかしダイアログやメニューは、多くの UI ライブラリで **`body` の直下にポータルで描画**されます。`container` だけを見ると、開いたダイアログの中身が検査されません。既定の検査範囲は `document.body` にしました。

### 2. 色のコントラストは常に無効にする

jsdom はレイアウトも描画も持たず、文字色と背景色の重なりを計算できません。`color-contrast` は正しく判定できないので、常に無効にしています。

### 3. ページ全体が要るルールは、ページのテストでだけ有効にする

`region`（すべての内容がランドマークの中にあること）や `page-has-heading-one`（見出し 1 があること）は、ページ全体を描画したときにだけ意味を持ちます。ヘッダーやナビゲーションは画面の外側（シェル）が持つので、部品や画面単体のテストでは**必ず違反**になります。

既定は `scope: 'component'` でこれらを外し、シェルを含むテスト（`scope: 'page'`）でだけ検査します。

### 4. incomplete では落とさない

axe には、自動では判定しきれなかった項目（`incomplete`）があります。jsdom ではこれがよく出ます。落とすとテストが不安定になるので、違反（`violations`）だけで落としています。

## 目玉：アイコンだけのボタンは axe を素通りする

導入して一番驚いたのがこれです。

私たちのデザインシステムのアイコン部品は、アイコンフォントの**リガチャ**で描いています。`more_vert` という文字列をアイコンフォントで表示すると、縦の三点リーダーのアイコンになる仕組みです。

```html
<button>
  <span class="font-icon-outline">more_vert</span>
</button>
```

このボタンには `aria-label` がありません。本来は「名前の無いボタン」として axe の `button-name` ルールで落ちるはずです。ところが落ちません。**ボタンの中に `more_vert` という文字があるので、axe はそれを名前とみなします**。スクリーンリーダーは「more_vert、ボタン」と読み上げます。

ラベルと並べたアイコンでも同じことが起きます。リンクの名前が「お知らせopen_in_new」になっていた箇所がありました。

### 独自ルールで穴を埋める

axe は独自のルールを足せます。操作要素の名前に、隠していないアイコンの文字が含まれていたら違反にするルールを作りました。

```ts
/** アイコン部品の描画要素のクラス */
const ICON_SELECTOR = '.font-icon-outline, .font-icon-fill';

axe.configure({
  checks: [
    {
      id: 'no-icon-ligature-in-name',
      evaluate(node) {
        const name = axe.commons.text.accessibleText(node);
        const ligatures = Array.from(node.querySelectorAll(ICON_SELECTOR))
          .filter((icon) => icon.closest('[aria-hidden="true"]') === null)
          .map((icon) => icon.textContent?.trim() ?? '')
          .filter((text) => text !== '');
        return !ligatures.some((text) => name.includes(text));
      },
    },
  ],
  rules: [
    {
      id: 'icon-ligature-name',
      selector: 'button, a[href], [role="button"], [role="link"], [role="tab"], [role="menuitem"]',
      any: ['no-icon-ligature-in-name'],
      metadata: {
        description: '操作要素の名前にアイコンのリガチャ名が混ざっていないこと',
        help: 'アイコンの文字（リガチャ名）が名前になっています。aria-label を付けるか、アイコンを aria-hidden にしてください',
      },
    },
  ],
});
```

仕組みは単純です。操作要素ごとに、axe が計算したアクセシブルネームを取ります。その中に、`aria-hidden` で隠されていないアイコンの文字が含まれていたら違反です。

直し方は 2 つです。

- アイコンだけのボタンには `aria-label` を付ける
- ラベルと並べるアイコンには `aria-hidden="true"` を付ける

**標準ルールの穴は、自分たちの描画のしかたから生まれます。** リガチャのアイコンを使うかどうかは、axe には分かりません。分かっているのは自分たちだけなので、ルールも自分たちで足す必要がありました。

## 例外は、理由とチケットを添えたときだけ

すぐには直せない違反のために、テスト単位でルールを外せるようにしています。

```tsx
await expectNoA11yViolations(document.body, {
  disabledRules: { label: 'XXXX-123: 〇〇の入力欄に名前が無い' },
});
```

`disabledRules` は、ルール名と**外す理由**の組です。理由には、直す予定のチケット番号を書く決まりにしました。外せるのはそのテストの、そのルールだけです。直したら外します。

ルール名を間違えると、axe が例外で止まります。存在しないルールを外したつもりで、何も外れていない、ということが起きません。

導入時には、既存の問題で 1 件だけ外していました。今は直して解除済みで、**除外は 0 件**です。

## 状態ごとに検査する

閉じた状態のドロップダウンを検査しても、開いたパネルの中の違反は見つかりません。そこで、データを表示した後の状態に加えて、**操作で現れる描画**も検査しています。

- 編集中のフォーム
- ダイアログを開いた状態
- ドロップダウンを開いた状態

規約には「**描画の状態を足したら、axe の検査も足す**」と書きました。今は 8 つのテストファイルから、計 15 回呼んでいます。

## 導入と同時に直した 4 種類の違反

ヘルパーを入れて既存の画面を検査すると、違反が見つかりました。導入と同じ変更で、10 ファイルを直しています。

| 違反 | どこで | 直し方 |
| --- | --- | --- |
| 列見出しが空 | 行末の操作列や、先頭の登録列（3 つの表） | 視覚には出さない見出し（`sr-only`）を置く。見出しが空だと支援技術に列の意味が伝わらない |
| ポップアップに名前が無い | 絞り込み付きのドロップダウンと複数選択 | 開くパネルに `aria-label`（「企業の選択肢」など）を付ける。同じ画面に複数並ぶので、項目名を含む名前にする |
| リンクの中の画像が読み上げ対象 | ヘッダーのロゴ | 名前はリンクの `aria-label` が持つので、ロゴは `aria-hidden` の要素で包む |
| アイコンの文字が名前に混ざる | 外部リンクのアイコン | アイコンに `aria-hidden` を付ける（独自ルールで検出） |

ポップアップの名前付けには、ひとつ罠がありました。絞り込み欄を持つパネルは支援技術にダイアログとして伝わるので、名前が要ります。一方、**絞り込み欄を持たないパネルは役割の無い枠**になり、名前を付けると逆に違反になります。名前は絞り込み付きのときだけ付けるようにしました。

## 限界：jsdom の axe で見えないもの

単体テストの axe で、a11y がすべて担保できるわけではありません。分かっている限界を規約に書いています。

- **色のコントラストは見られない。** jsdom がレイアウトを持たないため
- **CSS が実際の画面どおりには効かない。** 画面では隠れている要素を、見えていると判定することがある
- **自動で判定しきれない項目は落とさない。** そのため素通りするルールがほかにもある
- **axe では検出できない問題がある。** たとえば見出しと値の関連付けは、機械的には判定できない。これは従来どおり規約とレビューで担保する

今後は、Playwright などの**実際のブラウザ上で axe を動かす**検査も足したいと考えています。コントラストやレイアウトに依存する問題は、そこで拾えます。

## まとめ

| やったこと | 理由 |
| --- | --- |
| vitest-axe を使わず、axe-core を直接呼ぶ | 保守が止まり、新しい jsdom で動かない報告がある。やりたいことは 100 行で書ける |
| `document.body` を検査する | ダイアログやメニューはポータルで body 直下に描画される |
| 既定のルールを jsdom に合わせる | コントラストは判定できず、ページ全体のルールは部品単体で必ず落ちる |
| 独自ルールでリガチャ名を検出する | アイコンだけのボタンが、標準の `button-name` を素通りする |
| 除外は理由とチケット付き、テスト単位に限る | 例外を残したまま忘れないため。今は 0 件 |
| 操作で現れる状態も検査する | 閉じた状態だけでは、開いたパネルの違反が見つからない |

学びは 2 つです。

1. **道具の既定値を、自分たちの描画のしかたに合わせて直す。** ポータル、アイコンフォント、jsdom。どれも axe の既定値は知りません
2. **標準ルールの穴は、独自ルールで埋める。** 検査ツールが「通った」と言っても、自分たちの作り方によっては通るべきでないものが通っています

## 参考

- [axe-core](https://github.com/dequelabs/axe-core)
- [axe-core API: axe.configure（独自ルールの追加）](https://github.com/dequelabs/axe-core/blob/develop/doc/API.md#api-name-axeconfigure)
- [chaance/vitest-axe#30](https://github.com/chaance/vitest-axe/issues/30)
- [Material Symbols（リガチャで描くアイコンフォントの例）](https://fonts.google.com/icons)
