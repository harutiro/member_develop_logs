# Member Develop Logs

開発時間記録アプリケーション - チームメンバーの開発時間と実績を管理し、レベルアップシステムでモチベーション向上を図るWebアプリケーション

## 🚀 機能

- **開発時間記録**: 開始・終了時間を記録し、自動で開発時間を計算
- **実績管理**: カテゴリ別の実績を記録・管理
- **レベルアップシステム**: 開発時間と実績に基づく自動レベルアップ
- **メンターアバター**: レベルに応じたメンターアバターの獲得
- **管理画面**: ユーザー管理、一括レベルアップ機能
- **API**: RESTful APIでモバイルアプリ連携対応
- **PWA対応**: プログレッシブWebアプリとして動作

## 🛠 技術スタック

### バックエンド
- **Ruby on Rails 8.0.2**: Webフレームワーク
- **Ruby 3.3.1**: プログラミング言語
- **PostgreSQL**: 本番データベース
- **SQLite**: テスト環境データベース
- **Redis**: キャッシュ・セッション管理
- **Sidekiq**: バックグラウンドジョブ

### フロントエンド
- **Hotwire (Turbo + Stimulus)**: モダンなJavaScriptフレームワーク
- **Propshaft**: アセットパイプライン
- **Tailwind CSS**: スタイリング（推奨）

### インフラ・デプロイ
- **Docker**: コンテナ化
- **Docker Compose**: 開発・本番環境
- **Kamal**: デプロイメントツール
- **Nginx**: リバースプロキシ（本番）

### 開発・テスト
- **RSpec**: テストフレームワーク
- **Factory Bot**: テストデータ生成
- **Capybara**: システムテスト
- **RuboCop**: コードスタイルチェック
- **Brakeman**: セキュリティチェック

## 📋 必要条件

- Docker & Docker Compose
- Ruby 3.3.1（ローカル開発時）
- Node.js 18+（アセットビルド時）

## 🚀 クイックスタート

### 1. リポジトリのクローン
```bash
git clone <repository-url>
cd member_develop_logs
```

### 2. 開発環境の起動
```bash
# 初回セットアップ
make setup

# 開発サーバー起動
make up

# ブラウザでアクセス
open http://localhost:3000
```

### 3. データベースのセットアップ
```bash
# ローカル環境
make db-setup

# Docker環境
make db-setup
```

## 🧪 テスト

### テスト実行
```bash
make test
```

### システムテスト
```bash
make test-system
```

## 🏗 開発

### 開発サーバー起動
```bash
make up
```

### 開発サーバー停止
```bash
make down
```

### Railsコンソール
```bash
make shell
```

### ログ確認
```bash
make logs
```

### コードスタイルチェック
```bash
make lint
make lint-fix  # 自動修正
```

### セキュリティチェック
```bash
make security
```

## 🚀 デプロイ

### 本番環境へのデプロイ

#### 通常デプロイ
```bash
make deploy
```

#### 高速デプロイ（キャッシュ活用）
```bash
make deploy-prod
```

#### 超高速デプロイ（アセットスキップ）
```bash
make deploy-fast
```

### 環境変数設定

本番環境用の環境変数ファイル `.env.production` を作成：

```bash
# データベース
DATABASE_URL=postgresql://username:password@host:5432/database_name

# Rails設定
RAILS_ENV=production
SECRET_KEY_BASE=your_secret_key_here

# Redis
REDIS_URL=redis://host:6379/0

# その他
RAILS_MAX_THREADS=5
WEB_CONCURRENCY=2
```

## 📁 プロジェクト構造

```
member_develop_logs/
├── app/
│   ├── controllers/          # コントローラー
│   ├── models/              # モデル
│   ├── views/               # ビュー
│   ├── helpers/             # ヘルパー
│   ├── javascript/          # JavaScript
│   └── assets/              # アセット
├── config/                  # 設定ファイル
├── db/                      # データベース関連
├── test/                    # テスト
├── spec/                    # RSpecテスト
├── docker-compose.yml       # 開発環境
├── docker-compose.prod.yml  # 本番環境
├── Dockerfile               # 本番用Dockerfile
├── Dockerfile.multistage    # マルチステージビルド
├── Makefile                 # 開発コマンド集
└── README.md               # このファイル
```

## 🔧 設定

### データベース設定

#### 開発環境
- PostgreSQL（Docker）
- ポート: 5432
- データベース: `member_develop_logs_development`

#### テスト環境
- SQLite
- ファイル: `db/test.sqlite3`

#### 本番環境
- PostgreSQL
- 環境変数 `DATABASE_URL` で設定

### アセット設定

#### 開発環境
- リアルタイムコンパイル
- ホットリロード対応

#### 本番環境
- プリコンパイル済みアセット
- 圧縮・最適化

## 🐛 トラブルシューティング

### よくある問題

#### 1. データベース接続エラー
```bash
# データベースリセット
make db-reset
```

#### 2. Dockerビルドエラー
```bash
# キャッシュクリア
make clean
make build
```

#### 3. テストエラー
```bash
# テスト環境のデータベース準備
make test
```

#### 4. 権限エラー（本番環境）
```bash
# 環境変数確認
cat .env.production

# コンテナ再起動
docker compose -f docker-compose.prod.yml restart web
```

### ログ確認

#### 開発環境
```bash
make logs
```

#### 本番環境
```bash
make logs-prod
```

## 📚 API ドキュメント

### 認証
- セッションベース認証
- JWTトークン対応（API用）

### 主要エンドポイント

#### ユーザー管理
- `GET /api/v1/users` - ユーザー一覧
- `POST /api/v1/users` - ユーザー作成
- `GET /api/v1/users/:id` - ユーザー詳細
- `PATCH /api/v1/users/:id` - ユーザー更新

#### 開発時間
- `GET /api/v1/development_times` - 開発時間一覧
- `POST /api/v1/development_times` - 開発時間記録
- `GET /api/v1/development_times/:id` - 開発時間詳細

#### 実績
- `GET /api/v1/achievements` - 実績一覧
- `POST /api/v1/achievements` - 実績作成
- `GET /api/v1/achievements/:id` - 実績詳細

#### メンターアバター
- `GET /api/v1/mentor_avatars` - メンター一覧
- `GET /api/v1/mentor_avatars/:id` - メンター詳細

## 🤝 コントリビューション

1. フォークを作成
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add some amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

### 開発ガイドライン

- テストを必ず書く
- RuboCopのルールに従う
- コミットメッセージは日本語で
- 機能追加時はドキュメントも更新

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 👥 チーム

- 開発者: [Your Name]
- プロジェクトマネージャー: [PM Name]
- デザイナー: [Designer Name]

## 📞 サポート

問題や質問がある場合は、以下までお問い合わせください：

- イシュー: GitHub Issues
- メール: support@example.com
- Slack: #member-develop-logs

---

**Member Develop Logs** - チームの成長を記録し、モチベーションを向上させる開発時間管理システム

## 🔧 開発ワークフロー

### Git Hooks セットアップ

プロジェクト内のGit hooksを有効にするには、初回セットアップ時に以下を実行してください：

```bash
# Git hooksをセットアップ
make setup-hooks
```

これにより、プロジェクト内の`hooks/`ディレクトリが`.git/hooks`にシンボリックリンクされ、push時に自動的にlintチェックとテストが実行されます。

**注意**: 新しい開発者がプロジェクトをクローンした際は、必ず`make setup-hooks`を実行してください。

### 通常の開発フロー
1. 機能開発
2. テスト実行: `make test`
3. コードスタイルチェック: `make lint`
4. 必要に応じて自動修正: `make lint-fix`
5. コミット
6. Push（自動でlint + testチェック）

### Pre-pushフック
push時に自動的に以下のチェックが実行されます：
- コミットされていない変更の確認
- Lintチェック（エラーがあれば自動修正）
- テスト実行

**エラーが発生した場合：**
- pushが取り消されます
- エラーメッセージが表示されます
- 修正後、再度pushしてください

### 手動でのpush前チェック
```bash
make pre-push  # lint + testを実行
```

### Docker環境での開発
```bash
# lintチェック
make lint
make lint-fix

# テスト
make test
```
