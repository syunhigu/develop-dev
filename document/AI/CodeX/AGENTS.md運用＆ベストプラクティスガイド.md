# AGENTS.md 運用＆ベストプラクティスガイド

VS CodeのCodex拡張機能などでAIエージェントを活用する際の `AGENTS.md` の役割、育て方、チャット管理、および詳細ドキュメントとの分離手法に関するまとめです。

---

## 1. AGENTS.md の更新タイミングと作成手順

* **直接追記・更新して問題ない**
  * 別ファイルで下書きを作らず、そのまま `AGENTS.md` に直接反映（追記・修正）していって問題ありません。
  * **理由:** 
    * 同一チャット内であればAIがコンテキストを保持しているため、フォーマットや規約を維持したまま自然に更新できます。
    * 別ファイルを作ると最新版の二重管理が発生し、AIの認識齟齬の原因となります。

* **効率的な運用のコツ**
  * **作業の区切りでAIに更新させる:** 「ここまでの決定事項や作業内容を `AGENTS.md` の該当セクションに整理して反映して」と指示します。
  * **履歴管理は Git に任せる:** バックアップ用ファイルを残す代わりに、`git diff` やコミット履歴で修正前の状態を復元できるようにします。

---

## 2. チャット管理（新しいチャット vs 既存のチャット）

`AGENTS.md` の更新とタスクの進め方は、以下のサイクルで行うのが最もスマートです。

```
[現在のチャット] 作業・開発を実行
       │
       ▼
[現在のチャット] 区切りがついたら AGENTS.md に成果をまとめ・更新させる
       │
       ▼
[新しいチャット] 新規チャットを開き、最新の AGENTS.md を読み込ませて次の作業へ
```

### 使い分けの理由
* **更新作業自体は「既存のチャット」で行う**
  * 試行錯誤や決定事項などの生の情報（コンテキスト）がチャット内に残っているため、指示コストが低く、正確に `AGENTS.md` を書き換えられます。
* **次の作業を開始する際は「新しいチャット」を開く**
  * 会話が長くなりすぎるとトークン数が圧迫され、AIの精度低下や応答遅延が発生します。
  * 更新された最新の `AGENTS.md` をベースに新しいチャットを始めることで、AIはクリーンかつ正確な最新状態でリスタートできます。

---

## 3. AGENTS.md の肥大化防止（Progressive Disclosure / 段階的開示）

`AGENTS.md` が数百〜数千行に肥大化すると、AIの指示無視・回答精度の低下・コスト増につながります。本体は**100〜200行程度のルーティング（地図）**に留め、詳細は `docs/` 配下に分離・リンクさせる構成が推奨されます。

### ディレクトリ構成例
```text
my-project/
├── AGENTS.md                 ← 全体マップ・行動指針・制約（薄く保つ）
└── docs/
    ├── requirements.md       ← 詳細な機能仕様・要件定義
    ├── architecture.md       ← アーキテクチャやDB設計
    ├── testing-guide.md      ← テスト手順・環境構築
    └── rules/
        └── coding-style.md   ← 詳しいコーディング規約
```

### AGENTS.md の記述例（地図・参照先としての役割）
```markdown
# AGENTS.md

## 概要
TypeScript + React で構築されたWebアプリケーション。

## コマンド
- 開発起動: `pnpm dev`
- テスト実行: `pnpm test`

## 禁止事項 (Boundaries)
- `src/legacy/` 配下のファイルは変更しない
- `.env` の変更やDBマイグレーションの自動実行は禁止

## ドキュメント参照先（詳細は以下を参照すること）
- **要件・機能仕様**: `docs/requirements.md`
- **設計・構成**: `docs/architecture.md`
- **テスト手順**: `docs/testing-guide.md`
```

---

## 4. 参考となるQiita等の記事一覧

1. **AIに毎回プロジェクトを説明するのをやめる — AGENTS.md**
   * [https://qiita.com/akira_papa_AI/items/3fd7d14fc53d13a27f4a](https://qiita.com/akira_papa_AI/items/3fd7d14fc53d13a27f4a)
   * 概要: 書き方の5原則や汎用サンプル、Context Engineeringの考え方を解説。
2. **AIエージェント - AGENTS.mdベストプラクティス完全ガイド**
   * [https://qiita.com/dai_chi/items/61019c602c2c40dade07](https://qiita.com/dai_chi/items/61019c602c2c40dade07)
   * 概要: 推奨分量（60〜300行）や肥大化防止、Progressive Disclosure（段階的開示）を解説。
3. **Codexで使うAGENTS.mdの役割と実務**
   * [https://qiita.com/jtths474/items/4dbaeb37847fea67a502](https://qiita.com/jtths474/items/4dbaeb37847fea67a502)
   * 概要: Codexでの挙動や `docs/requirements/*.md` への切り出し実例。
4. **AGENTS.mdには何を書くべき？その1 〜推奨構成調査**
   * [https://qiita.com/rummy_p/items/7ad185f9ad20d1dfe65e](https://qiita.com/rummy_p/items/7ad185f9ad20d1dfe65e)
   * 概要: 「Source of Truth のルーティング」としての役割整理。
