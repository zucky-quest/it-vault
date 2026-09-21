1. releaseブランチを最新状態に(pull)する
2. ローカルで作業ブランチを切り替える(最新する

```bash
git switch ブランチ名
```

1. 他の作業分がrelease(main)マージされている可能性があるため、
作業ブランチにrelease(main)ブランチをマージ
2. 左サイドバーマーク(Git Lens inspect)をクリック

![](https://gyazo.com/10dbc5532a7592fafc463bdc18e6c04b)

1. 「SEARCH & COMPARE」→「+」→「Conpare Reference...」をクリック
2. {作業ブランチ名}(ローカル)とrelease(ローカル)を2つ連続で順序に注意して選択する

![](https://i.gyazo.com/48a02f721f91814da19f2494500af60c.png)
