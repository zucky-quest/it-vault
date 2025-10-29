---
title: "GitHub Copilotを使っている人は全員\"copilot-instrucions.md\"を作成してください"
source: "https://qiita.com/TooMe/items/873540da84567733d16b?utm_source=Qiita+%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9&utm_campaign=36ec612051-Qiita_newsletter_694_10_29_2025&utm_medium=email&utm_term=0_e44feaa081-36ec612051-46912226"
author:
  - "[[TooMe]]"
published: 2025-10-23
created: 2025-10-29
description: "はじめに GitHub Copilotを使っている開発者の皆さん、.github/copilot-instructions.mdというファイルを作成していますか？ このファイル1つで、Copilotをあなたのプロジェクト専用にカスタマイズし、もっと賢く、便利に使いこなすこ..."
tags:
  - "clippings"
---
![](https://relay-dsp.ad-m.asia/dmp/sync/bizmatrix?pid=c3ed207b574cf11376&d=x18o8hduaj&uid=1990032)

## はじめに

GitHub Copilotを使っている開発者の皆さん、`.github/copilot-instructions.md` というファイルを作成していますか？

このファイル1つで、Copilotをあなたのプロジェクト専用にカスタマイズし、もっと賢く、便利に使いこなすことができます。  
本記事では、その強力な機能と具体的な活用方法を紹介します。

## copilot-instrucions.mdの紹介

一言で言えば、 **GitHub Copilot版の `CLAUDE.md` です。**  
つまり、GitHub Copilotに与える **指示書** です。

このファイルは、GitHub Copilotがユーザーの指示を処理する前に **真っ先に読み込む指示書** として機能します。  
特別な設定は不要で、プロジェクトの`.github` ディレクトリ配下に `copilot-instructions.md` という名前で置くだけで認識されます。

Copilotはこの指示書を読んでからユーザーの指示に応えるため、指示書を作りこむほど、プロジェクトの文脈に沿った理想の回答を得やすくなります。

[とあるSpeaker Deck](https://speakerdeck.com/jyoshise/aigakodoshu-kisugiwen-ti-nihaaideli-tixiang-kae?slide=26) では、AIについてこう言及されています。

> **コンテキストを与えられないAIはその日だけタイミーで来たバイト(優秀ではある)**

`copilot-instructions.md` でプロジェクトのコンテキストをしっかり与えることで、この「優秀なバイト」を「頼れる専属アシスタント」へと育て上げることができるのです。

## copilot-instructions.mdを作成する

プロジェクトコードのある`.github` 配下に `copilot-instructions.md` を作成するだけです。

VS Codeなどのエディタでは、画像のように専用のCopilotアイコンが表示されることがあります（拡張機能の設定によります）。  
[![スクリーンショット 2025-10-22 20.34.04.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3820079/80e24bb1-c43f-4c3f-90bb-1e625348ca10.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F3820079%2F80e24bb1-c43f-4c3f-90bb-1e625348ca10.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=fded303b8495a2cf7281d0655ee10979)

また、VS CodeでGitHub Copilot Chatを開き、 `New Chat` （または `/` コマンド）を使用した際に表示される「指示の生成」（ `@workspace /new` ）のリンクからも作成することができます。  
[![スクリーンショット 2025-10-22 20.35.58.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3820079/633d857b-15bc-4d8e-b143-21234367ae5b.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F3820079%2F633d857b-15bc-4d8e-b143-21234367ae5b.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=2f3eb434e94ba877d6511060fcd55124)

## どんなことを書けばいい？

プロジェクトの「取扱説明書」として、以下の項目を網羅するのがおすすめです。

## 1\. 前提条件

AIへの基本的な指示を定義します。  
「回答は必ず日本語でしてください」「大規模な変更（例: 200行以上）を行う前には、まず変更計画を提案してください」といったルールです。  
これにより、意図しない大量のコード生成を防ぎ、エラーメッセージを投げた際に突然英語で返答されるといった事態も避けられます。

## 2\. アプリの概要

このプロジェクトが何のためのアプリケーションなのか、その **目的** と **主要な機能** を簡潔に説明します。  
AIがプロジェクトの全体像を理解することで、無駄なファイル探索を減らし、より的確な回答を導き出せます。

## 3\. 技術スタック（エコシステム）

使用している **言語** 、 **フレームワーク** 、主要な **ライブラリ** とそれらの **バージョン** を明記します。  
これにより、Copilotがプロジェクトで使われていないライブラリを勝手に `import` したり、古い構文を提案したりするのを防げます。

## 4\. ディレクトリ構成

主要なディレクトリと、それぞれの **役割** を説明します。  
「 `src/features` には機能ごと、 `src/shared` には共通コンポーネント」などと記述することで、Copilotが新しいファイルを適切な場所に作成・提案するようになります。

## 5\. アーキテクチャ・設計指針

プロジェクトで採用している設計指針（例: **MVVM** 、 **Atomic Design** 、 **Clean Architecture** など）を記載します。  
これを定義しないと、AIが既存の設計と一貫性のないコードを生成してしまう可能性があります。チーム開発では特に重要です。

## 6\. テスト方針

使用している **テストフレームワーク** （Vitest, Jest, RSpecなど）や、 **テストの記述方針** （「テストコードは `__tests__` 配下に置く」「カバレッジは80%を目指す」など）を伝えます。  
有名な引用「レガシーコードとは、単にテストの無いコードだ」が示す通り、テストは重要です。

## 7\. アンチパターン

「こう書いてほしい」という指示だけでなく、「 **こう書かないでほしい** 」というルールも有効です。  
例えば、「 `default export` は禁止」「 `any` 型は原則使用しない」といった、プロジェクト固有の禁止事項を明記しましょう。

## 例

ここでは、架空のタスク管理アプリ「TooMe's Task App」を題材に、2つの具体的な `copilot-instructions.md` の例を紹介します。  
非常に長いです。

## 例1: ReactでのWebアプリ

例1: ReactでのWebアプリ (クリックで展開)

```md
# Copilot Instructions for TooMe's Task App (Web)

## このドキュメントについて

- GitHub Copilot や各種 AI ツールが本リポジトリのコンテキストを理解しやすくするためのガイドです。
- 新しい機能を実装する際はここで示す技術選定・設計方針・モジュール構成を前提にしてください。
- 不確かな点がある場合は、リポジトリのファイルを探索し、ユーザーに「こういうことですか?」と確認をするようにしてください。

## 前提条件

- 回答は必ず日本語でしてください。
- コードの変更をする際、変更量が200行を超える可能性が高い場合は、事前に「この指示では変更量が200行を超える可能性がありますが、実行しますか?」とユーザーに確認をとるようにしてください。
- 何か大きい変更を加える場合、まず何をするのか計画を立てた上で、ユーザーに「このような計画で進めようと思います。」と提案してください。この時、ユーザーから計画の修正を求められた場合は計画を修正して、再提案をしてください。

## アプリ概要

**TooMe's Task App (Web)** は、タスク管理とスケジュール管理を統合したWebアプリケーションです。

### 主な機能

- **タスク管理**: Todoリストの作成・編集・削除・完了管理
- **Google Calendar連携**: Googleカレンダーとの同期により、予定とタスクを一元管理
- **プッシュ通知**: Web Push APIを利用した予定の通知
- **リマインダー機能**: 指定時刻にタスクや予定をリマインド
- **カテゴリ管理**: タスクをカテゴリ別に分類
- **繰り返しタスク**: 日次・週次・月次の繰り返しタスク設定
- **レスポンシブデザイン**: デスクトップ・タブレット・モバイルに対応

## 技術スタック概要

- **言語**: TypeScript 5.x
- **フレームワーク**: React 18.x
- **ビルドツール**: Vite 5.x
- **パッケージマネージャー**: pnpm (または npm/yarn)
- **状態管理**: Zustand + React Query (TanStack Query)
- **ルーティング**: React Router v6
- **スタイリング**: Tailwind CSS + CSS Modules (必要に応じて)
- **UIコンポーネント**: Radix UI (Headless UI) + 独自デザインシステム
- **フォーム管理**: React Hook Form + Zod (バリデーション)
- **API通信**: Axios + React Query
- **認証**: Firebase Authentication (Google Sign-In)
- **バックエンド**: Firebase (Firestore, Functions, Hosting)
- **通知**: Firebase Cloud Messaging (FCM) + Web Push API
- **テスト**: Vitest + React Testing Library + MSW (Mock Service Worker)
- **リンター/フォーマッター**: ESLint + Prettier
- **型チェック**: TypeScript strict mode

## プロジェクト構成と役割

本アプリは機能ベースのディレクトリ構成を採用し、関心の分離とスケーラビリティを実現しています。

\`\`\`
src/
├── app/                      # アプリケーションのエントリーポイント
│   ├── App.tsx              # ルートコンポーネント
│   ├── routes.tsx           # ルーティング定義
│   └── providers.tsx        # グローバルプロバイダー
├── features/                 # 機能別モジュール
│   ├── task/                # タスク管理機能
│   │   ├── components/      # タスク関連コンポーネント
│   │   ├── hooks/           # タスク関連カスタムフック
│   │   ├── stores/          # タスク状態管理 (Zustand)
│   │   ├── api/             # タスクAPI呼び出し
│   │   ├── types/           # タスク型定義
│   │   └── utils/           # タスクユーティリティ
│   ├── calendar/            # カレンダー機能
│   ├── reminder/            # リマインダー機能
│   ├── auth/                # 認証機能
│   └── settings/            # 設定機能
├── shared/                   # 共通モジュール
│   ├── components/          # 共通UIコンポーネント
│   │   ├── ui/              # 基本UIパーツ (Button, Input等)
│   │   ├── layout/          # レイアウトコンポーネント
│   │   └── feedback/        # フィードバック (Toast, Modal等)
│   ├── hooks/               # 共通カスタムフック
│   ├── utils/               # ユーティリティ関数
│   ├── types/               # 共通型定義
│   ├── constants/           # 定数定義
│   └── api/                 # API クライアント設定
├── lib/                      # 外部ライブラリのラッパー
│   ├── firebase/            # Firebase 設定
│   ├── google-calendar/     # Google Calendar API
│   └── notification/        # 通知関連
├── styles/                   # グローバルスタイル
│   ├── globals.css          # Tailwind設定含む
│   └── themes/              # テーマ定義
└── tests/                    # テストユーティリティ
    ├── mocks/               # モックデータ
    ├── setup.ts             # テストセットアップ
    └── utils.tsx            # テストヘルパー
\`\`\`

## アーキテクチャ指針

### コンポーネント設計

- **Atomic Design の部分的採用**: \`shared/components/ui\` に基本コンポーネント、feature 内に機能特化コンポーネント
- **Composition Pattern**: 小さなコンポーネントを組み合わせて複雑な UI を構築
- **Container/Presentational Pattern**: ロジックと表示を分離 (hooks でロジックを抽出)

### 状態管理の方針

- **ローカル状態**: \`useState\` / \`useReducer\` で管理
- **グローバル状態**: Zustand で管理 (例: ユーザー情報、UI状態)
- **サーバー状態**: React Query で管理 (API データのキャッシング・同期)
- **フォーム状態**: React Hook Form で管理

### データフロー

1. **UI → Hook**: ユーザーアクションをカスタムフックに通知
2. **Hook → API (React Query)**: API 呼び出しを React Query でラップ
3. **API → Hook → UI**: データを取得し、キャッシュして UI に反映
4. **楽観的更新**: React Query の \`onMutate\` で即座に UI を更新

## ディレクトリ・ファイル命名規則

### コンポーネント

- **ファイル名**: PascalCase (例: \`TaskList.tsx\`, \`TaskCard.tsx\`)
- **ディレクトリ**: ケバブケース (例: \`task-list/\`, \`calendar-view/\`)
- **index.ts**: 各ディレクトリに配置し、外部へのエクスポートを集約

### フック

- **ファイル名**: camelCase + \`use\` プレフィックス (例: \`useTaskList.ts\`, \`useAuth.ts\`)

### ユーティリティ

- **ファイル名**: camelCase (例: \`formatDate.ts\`, \`validateEmail.ts\`)

### 型定義

- **ファイル名**: camelCase または PascalCase (例: \`task.types.ts\`, \`Task.ts\`)
- **型名**: PascalCase (例: \`Task\`, \`User\`, \`ApiResponse<T>\`)

## UI 実装ガイド

### コンポーネント設計原則

- **Single Responsibility**: 1つのコンポーネントは1つの責務のみ
- **Props の型定義**: 全ての props に明示的な型を定義
- **デフォルトエクスポートを避ける**: Named export を使用し、リファクタリングを容易に
- **children パターン**: 柔軟性が必要な場合は \`children\` を活用

### スタイリング

- **Tailwind CSS をベースに使用**: ユーティリティファーストのアプローチ
- **共通スタイルの定義**: \`styles/globals.css\` でカスタムユーティリティクラスを定義
- **CSS Modules**: コンポーネント固有の複雑なスタイルが必要な場合のみ使用
- **レスポンシブ対応**: Tailwind のブレークポイント (\`sm:\`, \`md:\`, \`lg:\`) を活用

### アクセシビリティ (a11y)

- **セマンティック HTML**: 適切な HTML タグを使用 (\`<button>\`, \`<nav>\`, \`<main>\` 等)
- **aria 属性**: 必要に応じて \`aria-label\`, \`aria-describedby\` 等を付与
- **キーボード操作**: すべての操作をキーボードで実行可能に
- **フォーカス管理**: \`focus-visible\` で適切なフォーカススタイルを適用

### パフォーマンス最適化

- **React.memo**: 不要な再レンダリングを防ぐ
- **useMemo / useCallback**: 高コストな計算や関数の再生成を防ぐ
- **Code Splitting**: React.lazy + Suspense で遅延ロード
- **画像最適化**: WebP 形式、適切なサイズ、lazy loading

## 状態管理の実装ガイド

### Zustand の使い方

\`\`\`typescript
// stores/authStore.ts
import { create } from 'zustand';
import { devtools, persist } from 'zustand/middleware';

interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
  setUser: (user: User | null) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>()(
  devtools(
    persist(
      (set) => ({
        user: null,
        isAuthenticated: false,
        setUser: (user) => set({ user, isAuthenticated: !!user }),
        logout: () => set({ user: null, isAuthenticated: false }),
      }),
      { name: 'auth-storage' }
    )
  )
);
\`\`\`

### React Query の使い方

\`\`\`typescript
// api/taskApi.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

export const useTaskList = () => {
  return useQuery({
    queryKey: ['tasks'],
    queryFn: fetchTasks,
    staleTime: 5 * 60 * 1000, // 5分
  });
};

export const useCreateTask = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: createTask,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['tasks'] });
    },
  });
};
\`\`\`

## API 通信とデータ管理

### Axios インスタンスの設定

- **shared/api/client.ts** に axios インスタンスを作成
- インターセプターで認証トークンを自動付与
- エラーハンドリングの共通化

### エラーハンドリング

- **API エラー**: React Query の \`onError\` でハンドリング
- **グローバルエラー**: Error Boundary でキャッチ
- **ユーザーフィードバック**: Toast 通知で表示

### データ型定義

- **Zod スキーマ**: API レスポンスのバリデーション
- **TypeScript 型**: Zod スキーマから型を生成 (\`z.infer<typeof schema>\`)

## 認証 (Firebase Authentication)

### Google Sign-In フロー

1. **Firebase SDK 初期化**: \`lib/firebase/config.ts\` で設定
2. **Google プロバイダー**: \`signInWithPopup\` でログイン
3. **トークン管理**: Firebase が自動管理、\`onAuthStateChanged\` で状態監視
4. **Zustand に保存**: ログインユーザー情報を \`authStore\` に保存

### 認証ガード

- **ProtectedRoute コンポーネント**: 未認証時にログインページへリダイレクト
- **useAuth フック**: 認証状態を簡単に取得

## Google Calendar 連携

### OAuth2 フロー

1. **Google API Client Library**: \`gapi\` を使用
2. **スコープ**: \`https://www.googleapis.com/auth/calendar\`
3. **アクセストークン**: Firebase Auth の ID トークンとは別に管理

### カレンダーイベント同期

- **定期同期**: setInterval または Web Worker で定期的にポーリング
- **キャッシュ**: React Query でイベントをキャッシュ
- **オフライン対応**: IndexedDB に同期データを保存

## 通知機能

### Web Push API

- **Service Worker**: \`public/sw.js\` で通知受信
- **FCM**: Firebase Cloud Messaging でプッシュ通知配信
- **通知許可**: 初回アクセス時に許可を要求
- **通知クリック**: 特定のタスクやイベントページへ遷移

### リマインダーのスケジューリング

- **Web Worker**: バックグラウンドでタイマー実行
- **Notification API**: ローカル通知を表示
- **繰り返しタスク**: cron パターンを解析してスケジューリング

## テスト戦略

### 単体テスト (Vitest)

- **hooks**: \`@testing-library/react-hooks\` でテスト
- **utils**: 純粋関数のロジックをテスト
- **stores**: Zustand ストアのアクションと状態変化をテスト

### コンポーネントテスト (React Testing Library)

- **ユーザーインタラクション**: \`fireEvent\` / \`userEvent\` でイベントをシミュレート
- **非同期処理**: \`waitFor\` で非同期レンダリングを待機
- **モック**: MSW で API レスポンスをモック

### E2E テスト (Playwright / Cypress)

- **主要フロー**: ログイン → タスク作成 → 編集 → 削除のフローをテスト
- **クロスブラウザ**: Chrome, Firefox, Safari でテスト

## ビルドとデプロイ

### Vite ビルド設定

- **環境変数**: \`.env.development\`, \`.env.production\` で管理
- **コード分割**: 自動的に最適化されるが、必要に応じて手動設定
- **アセット最適化**: 画像・フォントの最適化

### Firebase Hosting

- **デプロイ**: \`firebase deploy --only hosting\`
- **プレビュー**: \`firebase hosting:channel:deploy preview\`
- **カスタムドメイン**: Firebase コンソールで設定

### CI/CD (GitHub Actions)

- **PR チェック**: リント、型チェック、テスト実行
- **自動デプロイ**: main ブランチへのマージで本番デプロイ

## コーディング規約・ベストプラクティス

### TypeScript の作法

- **strict モード**: \`tsconfig.json\` で \`strict: true\`
- **any の禁止**: \`no-explicit-any\` ルールを有効化
- **型推論の活用**: 冗長な型注釈は避け、推論に任せる
- **ユニオン型**: 状態を明示的に表現 (例: \`type Status = 'idle' | 'loading' | 'success' | 'error'\`)

### React の作法

- **関数コンポーネント**: クラスコンポーネントは使用しない
- **hooks のルール**: トップレベルでのみ呼び出し、条件分岐内で呼び出さない
- **useEffect の依存配列**: 正確に指定し、不要な再実行を防ぐ
- **key prop**: リストレンダリング時に一意で安定した key を使用

### 非同期処理

- **async/await**: Promise チェーンよりも優先
- **エラーハンドリング**: try-catch で必ずエラーをキャッチ
- **AbortController**: 不要なリクエストはキャンセル

### インポート順序

1. React 関連
2. 外部ライブラリ
3. 内部モジュール (features, shared, lib)
4. 型定義
5. スタイル

\`\`\`typescript
import { useState, useEffect } from 'react';
import { useQuery } from '@tanstack/react-query';

import { TaskList } from '@/features/task/components';
import { Button } from '@/shared/components/ui';
import { formatDate } from '@/shared/utils';

import type { Task } from '@/features/task/types';

import styles from './Home.module.css';
\`\`\`

### コメント

- **JSDoc**: 複雑な関数には JSDoc コメントを付与
- **TODO コメント**: 一時的な実装には \`// TODO:\` を残す
- **コメントアウト**: 不要なコードは削除し、コメントアウトは残さない

## アンチパターン

以下のパターンは避けてください。既存コードで発見した場合は、リファクタリングを提案してください。

### コンポーネント設計

- **巨大コンポーネント**: 1つのコンポーネントが200行を超える場合は分割を検討
- **Prop Drilling**: 深い階層での props バケツリレーは、Context や状態管理ライブラリで解決
- **useEffect の濫用**: データフェッチは React Query、イベントハンドラーで済む処理は useEffect を使わない

### 状態管理

- **過度なグローバル状態**: 真にグローバルな状態のみを Zustand で管理
- **useState の濫用**: 複雑な状態は useReducer で管理
- **直接的な状態変更**: イミュータブルな更新を心がける

### パフォーマンス

- **不要な再レンダリング**: React DevTools Profiler で計測し、必要に応じて最適化
- **過度な最適化**: 実測せずに useMemo/useCallback を多用しない
- **巨大なバンドル**: Code Splitting を活用し、初期ロードを軽量化

### TypeScript

- **any の濫用**: 型推論が難しい場合は \`unknown\` を使用し、型ガードで絞り込む
- **型アサーション (as)**: 必要最小限に留め、型の安全性を保つ
- **オプショナルの濫用**: 本当に必要な場合のみ \`?\` を使用

## セキュリティとプライバシー

- **環境変数**: API キーは \`.env\` で管理し、\`.gitignore\` に追加
- **XSS 対策**: ユーザー入力は適切にサニタイズ、React の JSX は自動エスケープ
- **CSRF 対策**: Firebase Authentication のトークンベース認証で対応
- **HTTPS 通信**: 本番環境では必ず HTTPS を使用
- **CSP (Content Security Policy)**: 適切な CSP ヘッダーを設定

## アクセシビリティ (a11y) ガイドライン

- **WCAG 2.1 AA レベル**: 準拠を目指す
- **スクリーンリーダー対応**: ARIA 属性を適切に使用
- **キーボードナビゲーション**: Tab, Enter, Escape キーでの操作をサポート
- **カラーコントラスト**: 4.5:1 以上のコントラスト比を維持
- **axe DevTools**: 開発時に定期的にチェック

## 国際化 (i18n)

- **react-i18next**: 多言語対応
- **言語ファイル**: \`public/locales/{lang}/translation.json\`
- **日付・数値フォーマット**: \`Intl\` API を活用
- **RTL 対応**: 将来的にアラビア語などに対応する場合を考慮

## まとめ

このドキュメントを常に最新に保ち、新しい技術選定や設計変更があった場合は適宜更新してください。GitHub Copilot や AI ツールは、このドキュメントを参照することで、プロジェクトのコンテキストを正確に理解し、より適切なコード提案を行うことができます。

チーム全体でこのガイドラインに従うことで、コードの一貫性と保守性が向上し、新しいメンバーのオンボーディングも円滑になります。

---

**TooMe's Task App (Web)** は、モダンな React 開発のベストプラクティスを取り入れた、スケーラブルで保守性の高いアーキテクチャを目指しています。
```

## 例2: KotlinでのAndroidアプリ

例2: KotlinでのAndroidアプリ (クリックで展開)

```md
# Copilot Instructions for TooMe's Task App (Android)

## このドキュメントについて

- GitHub Copilot や各種 AI ツールが本リポジトリのコンテキストを理解しやすくするためのガイドです。
- 新しい機能を実装する際はここで示す技術選定・設計方針・モジュール構成を前提にしてください。
- 不確かな点がある場合は、リポジトリのファイルを探索し、ユーザーに「こういうことですか?」と確認をするようにしてください。

## 前提条件

- 回答は必ず日本語でしてください。
- コードの変更をする際、変更量が200行を超える可能性が高い場合は、事前に「この指示では変更量が200行を超える可能性がありますが、実行しますか?」とユーザーに確認をとるようにしてください。
- 何か大きい変更を加える場合、まず何をするのか計画を立てた上で、ユーザーに「このような計画で進めようと思います。」と提案してください。この時、ユーザーから計画の修正を求められた場合は計画を修正して、再提案をしてください。

## アプリ概要

**TooMe's Task App** は、タスク管理とスケジュール管理を統合したAndroidアプリです。

### 主な機能

- **タスク管理**: Todoリストの作成・編集・削除・完了管理
- **Google Calendar連携**: Googleカレンダーとの同期により、予定とタスクを一元管理
- **プッシュ通知**: Firebase Cloud Messagingを利用した予定の通知
- **リマインダー機能**: 指定時刻にタスクや予定をリマインド
- **カテゴリ管理**: タスクをカテゴリ別に分類
- **繰り返しタスク**: 日次・週次・月次の繰り返しタスク設定

## 技術スタック概要

- **言語**: Kotlin 2.4.x
- **ビルド**: Android Gradle Plugin 8.2.x / Gradle Version Catalog (\`gradle/libs.versions.toml\`) で依存を集中管理
- **対応OS**: Min SDK 26 (Android 8.0), Target SDK 34, Compile SDK 34
- **依存性注入**: Hilt (Dagger Hilt)
- **非同期処理**: Kotlin Coroutines + Flow
- **シリアライゼーション**: kotlinx-serialization-json
- **ネットワーク**: Retrofit + OkHttp + Kotlin Serialization Converter
- **データベース**: Room (SQLite)
- **UI**: Jetpack Compose
- **ナビゲーション**: Navigation Compose
- **認証**: Google Sign-In (Google Calendar API連携用)
- **通知**: Firebase Cloud Messaging (FCM) + WorkManager
- **テスト**: JUnit5 + Kotest + MockK + Turbine

## モジュール構成と役割

本アプリはマルチモジュール構成を採用し、関心の分離とビルド時間の短縮を実現しています。

### アプリモジュール

- **app**: メインアプリモジュール。Applicationクラス、メイン Activity、ナビゲーショングラフを管理。各feature モジュールを統合。

### Core モジュール群

- **core:common**: 共通ユーティリティ、拡張関数、定数定義。全モジュールから参照可能。
- **core:model**: データモデル定義。Entity、DTO、ドメインモデルを集約。
- **core:data**: Repository実装。データソース(API/DB)の抽象化層。UseCase層から利用される。
- **core:database**: Room データベース定義。DAO、Entity、Migrationを管理。
- **core:network**: API通信。Retrofit クライアント設定、API インターフェース、認証処理。
- **core:datastore**: DataStore (Preferences) によるキーバリュー型データ永続化。ユーザー設定などを保存。
- **core:design**: Compose UI コンポーネント、テーマ、カラー、タイポグラフィ定義。Material3ベース。
- **core:ui**: 共通 Compose UI 部品。画面テンプレート、共通レイアウトなど。
- **core:notification**: 通知関連の共通処理。FCM、WorkManager によるローカル通知を管理。
- **core:analytics**: Firebase Analytics ラッパー。イベントログ送信を一元管理。

### Feature モジュール群

各機能は独立した feature モジュールとして実装され、MVVM アーキテクチャを採用しています。

- **feature:task**: タスク一覧・作成・編集・削除機能。
- **feature:calendar**: カレンダービュー、Google Calendar 連携機能。
- **feature:reminder**: リマインダー設定・管理機能。
- **feature:settings**: アプリ設定画面。通知設定、カレンダー同期設定など。
- **feature:auth**: Google Sign-In 認証フロー。

### 依存関係の方向

\`\`\`
app
 ├─ feature:task ──┐
 ├─ feature:calendar ┤
 ├─ feature:reminder ┤
 ├─ feature:settings ┤
 └─ feature:auth ───┘
                    │
                    ├─> core:ui ──> core:design
                    ├─> core:data ──> core:database
                    │               └─> core:network
                    ├─> core:notification
                    ├─> core:analytics
                    ├─> core:datastore
                    ├─> core:model
                    └─> core:common
\`\`\`

- **app** は各 feature を依存関係に含む
- **feature** は core モジュール群に依存するが、他の feature に依存しない
- **core** モジュール間は必要最小限の依存に留める

## アーキテクチャ指針

### MVVM + Clean Architecture

- **UI層**: Jetpack Compose + ViewModel
- **ドメイン層**: UseCase (core:data 内に配置)
- **データ層**: Repository + DataSource (API/DB)

### 状態管理

- **UIState**: ViewModel 内で \`StateFlow<UiState>\` として管理
- **イベント**: \`SharedFlow\` または \`Channel\` で一度きりのイベント(ナビゲーション、トースト表示など)を表現
- **状態ホイスティング**: Composable は状態を持たず、ViewModel から状態とイベントハンドラを受け取る

### 依存性注入 (Hilt)

- \`@HiltAndroidApp\` をApplication クラスに付与
- \`@AndroidEntryPoint\` をActivity/Fragment に付与
- \`@HiltViewModel\` を ViewModel に付与
- Repository、DataSource、UseCase などは \`@Inject constructor\` でコンストラクタインジェクション
- Module (\`@Module\` + \`@InstallIn\`) で抽象型のバインディングや外部ライブラリの提供を行う

### データフロー

1. **UI → ViewModel**: ユーザーアクションをイベントとして ViewModel に通知
2. **ViewModel → UseCase**: ビジネスロジックを UseCase に委譲
3. **UseCase → Repository**: データ取得・更新を Repository に依頼
4. **Repository → DataSource**: API または DB からデータを取得
5. **DataSource → Repository → UseCase → ViewModel → UI**: データを Flow で流し、UI に反映

## UI 実装ガイド

### Compose コンポーネント設計

- **core:design の優先利用**: \`TaskButton\`, \`TaskCard\`, \`TaskTextField\` など共通コンポーネントを優先的に使用
- **状態のホイスティング**: Composable 内部で状態を持たず、外部から \`state\` と \`onEvent\` を受け取る
- **プレビュー**: \`@Preview\` アノテーションを付与し、\`core:design\` のテーマでラップする
- **testTag 付与**: UI テストのため、主要な要素には \`Modifier.testTag()\` を必ず付与

### ナビゲーション

- \`androidx.navigation.compose\` を使用
- ナビゲーショングラフは \`app\` モジュールで定義
- 各 feature モジュールは \`NavGraphBuilder.featureXxxGraph()\` 拡張関数でルートを提供
- 画面遷移は ViewModel から \`NavigationEvent\` として発行し、UI層でハンドリング

### デザインシステム

- **Material3** ベース
- **カラーテーマ**: \`TaskAppTheme\` で Light/Dark テーマをサポート
- **タイポグラフィ**: \`TaskTypography\` で統一
- **アイコン**: Material Icons Extended を使用

## データ・ネットワーク層

### API 通信 (Retrofit)

- **core:network** 内に API インターフェースを定義
- エンドポイント: バックエンドは Firebase Functions または独自サーバー
- 認証: Google Sign-In で取得した ID Token を Bearer Token として API ヘッダーに付与
- エラーハンドリング: \`Result<T>\` 型で成功/失敗を表現

### Google Calendar API

- Google Sign-In で OAuth2 認証
- Google Calendar API v3 を Retrofit 経由で呼び出し
- \`core:network\` に \`GoogleCalendarApiService\` を定義
- 同期処理は \`feature:calendar\` の Repository で管理

### データベース (Room)

- **core:database** に定義
- Entity: \`TaskEntity\`, \`ReminderEntity\`, \`CategoryEntity\`
- DAO: \`TaskDao\`, \`ReminderDao\`, \`CategoryDao\`
- データベースバージョン管理: Migration を適切に定義

### DataStore (設定保存)

- **core:datastore** で管理
- ユーザー設定 (通知ON/OFF、同期間隔など) を保存
- \`Flow<T>\` で設定値を公開し、リアクティブに UI に反映

## 通知とリマインダー

### Firebase Cloud Messaging (FCM)

- **core:notification** で FCM トークン管理
- サーバーからのプッシュ通知受信
- 通知タップ時のディープリンク処理 (特定タスクやカレンダーイベントへ遷移)

### WorkManager によるローカル通知

- リマインダーは WorkManager の \`OneTimeWorkRequest\` または \`PeriodicWorkRequest\` でスケジュール
- \`ReminderWorker\` でタスクの通知を表示
- 繰り返しタスクは \`PeriodicWorkRequest\` で定期実行

### 通知チャネル

- Android O (API 26) 以降の通知チャネルを適切に設定
- 「タスク通知」「リマインダー」「システム通知」などチャネルを分離

## 分析・ログ

### Firebase Analytics

- **core:analytics** の \`AnalyticsLogger\` を経由してイベント送信
- 画面表示イベント: \`logScreenView(screenName: String)\`
- カスタムイベント: \`logEvent(eventName: String, params: Map<String, Any>)\`

### ログ出力

- Timber を使用し、リリースビルドでは自動的にログ出力を抑制
- デバッグビルドでは詳細ログを出力

## テスト戦略

### 単体テスト (JUnit5 + Kotest)

- ViewModel: 状態遷移とビジネスロジックをテスト。Turbine で Flow をテスト
- UseCase: ビジネスロジックの正当性をテスト
- Repository: MockK でデータソースをモック化してテスト

### UI テスト (Compose Test)

- 主要画面のUIテストを \`androidTest\` に実装
- \`testTag\` を利用して要素を取得
- ユーザーインタラクション (タップ、スワイプ、入力) をシミュレート

### インテグレーションテスト

- Room データベースのマイグレーションテスト
- API モックサーバー (MockWebServer) を使った通信テスト

## ビルド構成

### Product Flavors

- **dev**: 開発環境。開発サーバーに接続。デバッグメニュー有効。
- **prod**: 本番環境。本番サーバーに接続。

### Build Types

- **debug**: デバッグビルド。難読化なし。
- **release**: リリースビルド。ProGuard/R8 による難読化あり。

### 署名設定

- \`keystore.properties\` でキーストア情報を管理 (Git管理外)
- リリースビルド時に署名

## コーディング規約・ベストプラクティス

### Kotlin の作法

- **不変性の重視**: \`val\` を優先し、\`var\` は必要最小限に
- **Null 安全**: \`?.\` や \`?:\` を活用し、\`!!\` の使用は避ける
- **スコープ関数の適切な利用**: \`apply\`, \`let\`, \`run\`, \`also\`, \`with\` を目的に応じて使い分ける
- **拡張関数**: 共通処理は拡張関数として \`core:common\` に定義

### Coroutine の作法

- **適切なスコープ**: \`viewModelScope\`, \`lifecycleScope\` を使用。\`GlobalScope\` は禁止
- **Dispatcher の明示**: IO処理は \`Dispatchers.IO\`、CPU処理は \`Dispatchers.Default\`
- **キャンセルの伝搬**: \`CancellationException\` を握りつぶさない。\`suspendCancellableCoroutine\` を適切に使用
- **例外処理**: \`try-catch\` または \`runCatching\` で例外をハンドリング

### 命名規則

- **変数**: lowerCamelCase (例: \`taskList\`, \`isCompleted\`)
- **関数**: lowerCamelCase (例: \`fetchTasks()\`, \`updateTaskStatus()\`)
- **クラス**: UpperCamelCase (例: \`TaskRepository\`, \`TaskViewModel\`)
- **定数**: UPPER_SNAKE_CASE (例: \`MAX_TASK_COUNT\`, \`DEFAULT_REMINDER_MINUTES\`)
- **リソースID**: snake_case (例: \`task_item_title\`, \`reminder_button_save\`)

### コメント

- **KDoc**: public なクラス・関数には KDoc コメントを付与
- **インラインコメント**: 複雑なロジックには説明コメントを追加
- **TODOコメント**: 一時的な対応には \`// TODO:\` コメントを残す

## アンチパターン

以下のパターンは避けてください。既存コードで発見した場合は、リファクタリングを提案してください。

### 状態管理

- **シングルトンでの可変状態保持**: メモリリークやテストの困難さにつながるため、状態は ViewModel や Repository で管理
- **Activity/Fragment での状態保持**: プロセス終了時に消失するため、重要な状態は永続化または \`SavedStateHandle\` で保存

### 非同期処理

- **GlobalScope の使用**: キャンセル処理が困難なため禁止
- **runBlocking の濫用**: UI スレッドでの使用は ANR の原因となるため禁止
- **コールバック地獄**: Coroutine や Flow で非同期処理を統一

### アーキテクチャ

- **God Class**: 一つのクラスに責務を詰め込まない。単一責任の原則を守る
- **レイヤーの逆転**: UI層から直接 DB や API にアクセスしない。必ず Repository を経由
- **feature 間の直接依存**: feature モジュール間で相互依存しない。共通処理は core に配置

### UI

- **Compose での副作用の誤用**: \`LaunchedEffect\`, \`DisposableEffect\`, \`SideEffect\` を適切に使い分ける
- **Composable 内での状態保持**: 状態は ViewModel で管理し、Composable は状態を受け取るのみ
- **過度なリコンポジション**: \`remember\`, \`derivedStateOf\` で不要な再計算を避ける

## Google Calendar 連携の実装ガイド

### 認証フロー

1. **Google Sign-In**: \`feature:auth\` で Google Sign-In を実装
2. **OAuth スコープ**: \`https://www.googleapis.com/auth/calendar\` を要求
3. **トークン管理**: ID Token を \`core:datastore\` で安全に保存

### カレンダーイベントの取得

- Google Calendar API v3 の Events リソースを使用
- \`core:network\` の \`GoogleCalendarApiService\` で API 呼び出し
- \`feature:calendar\` の \`CalendarRepository\` でデータ取得・キャッシュ

### 同期処理

- WorkManager で定期的に同期 (例: 1時間ごと)
- 同期結果を Room DB にキャッシュし、オフライン対応
- 競合解決: サーバー側のタイムスタンプを優先

### イベント作成・更新

- ユーザーがタスクを作成時、オプションでカレンダーイベントとして登録
- 双方向同期: アプリ側の変更をカレンダーに反映、カレンダー側の変更をアプリに反映

## リマインダー機能の実装ガイド

### リマインダーのスケジューリング

- \`WorkManager\` で指定時刻にリマインダーを実行
- \`ReminderWorker\` でタスク情報を取得し、通知を表示
- 繰り返しリマインダーは \`PeriodicWorkRequest\` で実装

### 通知のカスタマイズ

- 通知タイトル: タスク名
- 通知本文: タスク詳細または期限
- アクション: 「完了」「スヌーズ」「開く」

### スヌーズ機能

- 通知のアクションボタンから「スヌーズ」を選択
- 指定時間後 (例: 10分後) に再度リマインダーをスケジュール

## セキュリティとプライバシー

- **API キーの管理**: \`local.properties\` で管理し、Git 管理外に配置
- **トークンの暗号化**: ID Token は EncryptedSharedPreferences で暗号化保存
- **通信の暗号化**: HTTPS 通信を必須化
- **権限の最小化**: 必要最小限の権限のみを要求 (通知、インターネット、カレンダー)

## まとめ

このドキュメントを常に最新に保ち、新しい技術選定や設計変更があった場合は適宜更新してください。GitHub Copilot や AI ツールは、このドキュメントを参照することで、プロジェクトのコンテキストを正確に理解し、より適切なコード提案を行うことができます。

---

**TooMe's Task App** は、モダンな Android 開発のベストプラクティスを取り入れた、保守性・拡張性の高いアーキテクチャを目指しています。
```

## おわりに

本記事では、GitHub Copilotをより便利に賢く使用するための `copilot-instructions.md` について紹介しました。

最近は、Claude Codeをはじめとした優秀なコーディングAIエージェントが次々と登場しています。 しかし、どのAIを使うにせよ、プロジェクトのコンテキスト（指示書）を渡すことで、AIがより優秀なエージェントになるという事実に変わりはありません。

皆さんもぜひ、ご自身のプロジェクトに `copilot-instructions.md` を導入して、"優秀なバイト"を"頼れる専属アシスタント"に育ててみてください。

[1](https://qiita.com/TooMe/items/?utm_source=Qiita+%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9&utm_campaign=36ec612051-Qiita_newsletter_694_10_29_2025&utm_medium=email&utm_term=0_e44feaa081-36ec612051-46912226#comments)

コメント一覧へ移動

X（Twitter）でシェアする

Facebookでシェアする

はてなブックマークに追加する

## Qiita Conference 2025 Autumn 11月5日(水)~7日(金)開催！

![](https://cdn.qiita.com/assets/public/official_campaigns/qiita_conference_2025_autumn/image-conference_2025_autumn_ogp-d35d2500cd0420d93f2ed69a8d162d74.png)

Qiita Conferenceは、AI時代のエンジニアに贈るQiita最大規模のテックカンファレンスです！

基調講演ゲスト(敬称略)

piacere、牛尾 剛、Esteban Suarez、和田 卓人、seya、ミノ駆動、市谷 聡啓、からあげ、岩瀬 義昌、まつもとゆきひろ、みのるん and more…

[イベント詳細を見る](https://qiita.com/official-campaigns/conference/2025-autumn)

[388](https://qiita.com/TooMe/items/873540da84567733d16b/likers)

いいねしたユーザー一覧へ移動

400

![](https://cdn.qiita.com/assets/public/push_notification/image-qiitan-572179a3bbde375850422ea48b2b6272.png)

Qiitaから通知を受け取りませんか？

最新のトレンドなどの情報をお届けします