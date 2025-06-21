# メンバー開発ログ管理システム

このシステムは、チームメンバーの開発時間を記録・管理し、レベルアップシステムとメンターアバター機能を備えたアプリケーションです。

## 主要機能

### 開発時間管理
- **開発開始/終了ボタン**: ホーム画面からワンクリックで開発時間を記録
- **開発時間履歴**: 過去の開発時間を一覧表示
- **リアルタイム記録**: 現在進行中の開発時間をリアルタイムで表示

### できたこと記録
- **成果記録**: 開発で達成したことを記録
- **ポイントシステム**: できたことにポイントを付与
- **履歴管理**: 過去の成果を一覧表示

### レベルアップシステム
- **ユーザーレベル**: 開発時間と成果に基づくレベルアップ
- **メンターアバター**: レベルに応じて新しいメンターを獲得
- **レベルアップ通知**: レベルアップ時のアニメーション表示

### ぬるぽクリッカーゲーム
- **クリックゲーム**: ITにまつわるぬるぽクリッカー
- **効果音・アニメーション**: クリック時の視覚・音響効果
- **重力システム**: アイコンが重力に従って積み重なる
- **自動クリック**: 自動クリックアニメーション
- **全メンバー統計**: 全メンバーの合計クリック数・ぬるぽ数表示

### 管理機能
- **ユーザー管理**: ユーザーの作成・編集・削除
- **メンター管理**: メンターアバターの管理
- **レベルアップ設定**: レベルアップ条件の設定
- **一斉レベルアップ**: 管理者による全ユーザーの一斉レベルアップ

## 管理画面 (/admin)

### アクセス方法
```
http://localhost:3000/admin
```

### 管理画面の機能

#### 1. ユーザー管理
- **ユーザー一覧**: 全ユーザーの表示
- **ユーザー作成**: 新しいユーザーの追加
- **ユーザー編集**: 既存ユーザーの情報変更
- **ユーザー削除**: ユーザーの削除

#### 2. メンター管理
- **メンター一覧**: 全メンターアバターの表示
- **メンター作成**: 新しいメンターの追加
- **メンター編集**: メンター情報の変更
- **メンター削除**: メンターの削除
- **画像管理**: Active Storageを使用した画像アップロード

#### 3. レベルアップ設定
- **レベル条件設定**: 各レベルに必要な経験値の設定
- **一斉レベルアップ**: 全ユーザーのレベルを一斉に上げる機能

#### 4. 統計情報
- **開発時間統計**: 全メンバーの開発時間合計
- **できたこと統計**: 全メンバーの成果統計
- **ぬるぽゲーム統計**: 全メンバーのゲーム統計

## 技術スタック

- **バックエンド**: Ruby on Rails 8
- **データベース**: PostgreSQL
- **フロントエンド**: Bootstrap 5, Font Awesome
- **JavaScript**: Stimulus, Chart.js
- **ファイルストレージ**: Active Storage
- **コンテナ**: Docker, Docker Compose
- **バックグラウンドジョブ**: SolidQueue (開発環境), Inline (本番環境)

## セットアップ

### 前提条件

- Docker
- Docker Compose
- Make

### 初期セットアップ

以下のコマンドで環境を構築します：

```bash
make setup
```

このコマンドは以下の処理を実行します：
- 依存関係のインストール
- データベースの作成
- マイグレーションの実行
- シードデータの投入

### 開発サーバーの起動

```bash
make up
```

アプリケーションは `http://localhost:3000` でアクセス可能です。

### 開発サーバーの停止

```bash
make down
```

### その他のコマンド

- データベースのリセット: `make db-reset`
- テストの実行: `make test`
- コンソールの起動: `make console`
- ログの確認: `make logs`

## データベース管理

### マイグレーションの実行
```bash
# 新しいマイグレーションを作成
docker compose exec web rails generate migration MigrationName

# マイグレーションを実行
docker compose exec web rails db:migrate

# マイグレーションをロールバック
docker compose exec web rails db:rollback
```

### シードデータの投入
```bash
docker compose exec web rails db:seed
```

## 本番環境デプロイ

### 高速ビルドオプション

#### 1. 通常ビルド（推奨）
```bash
make build-fast
```

#### 2. アセットスキップビルド（超高速）
```bash
make build-no-assets
```

#### 3. マルチステージビルド（超高速）
```bash
make build-multistage
```

#### 4. 並列ビルド（BuildKit使用）
```bash
make build-parallel
```

#### 5. 完全リビルド（キャッシュなし）
```bash
make rebuild
```

### デプロイ手順

#### 1. 本番環境へのデプロイ
```bash
make deploy
```

#### 2. 本番DBの初期化
```bash
make prod-init
```

#### 3. 本番DBのリセットのみ
```bash
make prod-db-reset
```

#### 4. 本番シード投入のみ
```bash
make prod-seed
```

### デプロイ状態の確認

```bash
# コンテナ状態確認
make deploy-status

# ログ確認
make logs          # 全サービス
make logs-web      # Webコンテナのみ
make logs-db       # DBコンテナのみ
```

### ロールバック

```bash
make rollback
```

## 環境変数

### 開発環境
```bash
# .env ファイルを作成
DATABASE_URL=postgresql://postgres:password@db:5432/member_develop_logs_development
RAILS_ENV=development
```

### 本番環境
```bash
# .env.production ファイルを作成
RAILS_ENV=production
DATABASE_URL=postgres://postgres:postgres@db:5432/member_develop_logs_production
SECRET_KEY_BASE=your_secret_key_here
MEMBER_DEVELOP_LOGS_DATABASE_PASSWORD=postgres
```

## シードデータ

初期データとして以下のメンバーが登録されます：

- 山田太郎
- 鈴木花子
- 佐藤次郎

また、最初のメンバー（山田太郎）に対して以下の作業ログが作成されます：

- 今日の作業ログ（9:00-18:00）
- 昨日の作業ログ（9:00-17:00）

## トラブルシューティング

### よくある問題

#### 1. アイコンが表示されない
- ブラウザキャッシュをクリア
- `public/icon.png` が存在することを確認
- ファイルサイズが適切か確認

#### 2. データベース接続エラー
```bash
# データベースコンテナの状態確認
docker compose ps db

# データベースの再起動
docker compose restart db
```

#### 3. 画像アップロードエラー
- Active Storageの設定を確認
- ストレージディレクトリの権限を確認
- SolidQueueの設定を確認（本番環境では無効化済み）

#### 4. レベルアップアニメーションが表示されない
- セッション情報を確認
- ブラウザのJavaScript設定を確認

#### 5. ビルドが遅い
- `make build-no-assets` を使用してアセットプリコンパイルをスキップ
- `make build-multistage` でマルチステージビルドを使用
- キャッシュを活用（`make build-fast`）

#### 6. 本番環境でのSolidQueueエラー
- 本番環境ではSolidQueueが無効化されています
- Active Jobは同期的に実行されます

## 開発ガイド

### 新しい機能の追加

1. **モデルの作成**
```bash
docker compose exec web rails generate model ModelName
```

2. **コントローラーの作成**
```bash
docker compose exec web rails generate controller ControllerName
```

3. **ルーティングの追加**
`config/routes.rb` にルートを追加

4. **ビューの作成**
`app/views/` にビューファイルを作成

### テストの実行

```bash
# 全テストの実行
make test

# 特定のテストファイルの実行
docker compose exec web rails test test/models/user_test.rb
```

## パフォーマンス最適化

### ビルド時間の短縮
- **アセットスキップ**: `make build-no-assets`
- **マルチステージビルド**: `make build-multistage`
- **並列ビルド**: `make build-parallel`
- **キャッシュ活用**: `make build-fast`

### 本番環境の最適化
- SolidQueueを無効化し、Active Jobを同期的に実行
- ActiveStorageの分析機能を無効化
- 複数データベース接続を無効化

## ライセンス

このプロジェクトは社内利用に限定されています。

## アプリアイコンの変更方法

### 1. アイコンファイルの準備
新しいアイコンファイルを以下の仕様で準備してください：
- **PNG形式**: 512x512ピクセル推奨
- **ファイル名**: `icon.png`

### 2. アイコンファイルの配置
準備したアイコンファイルを以下の場所に配置してください：
```
public/icon.png  # メインのPNGアイコン
```

### 3. ブラウザキャッシュのクリア
アイコンを変更した後、ブラウザのキャッシュをクリアしてください：
- Chrome: Ctrl+Shift+R (Windows/Linux) または Cmd+Shift+R (Mac)
- Safari: Cmd+Option+R
- Firefox: Ctrl+F5 (Windows/Linux) または Cmd+Shift+R (Mac)

### 4. アイコンが反映されない場合
- ブラウザの開発者ツールでキャッシュを無効化
- プライベートブラウジングモードで確認
- 複数のブラウザで確認

## アイコン設定ファイル

アイコンの設定は以下のファイルで管理されています：
- `app/views/layouts/application.html.erb` - ファビコンとApple Touch Icon
- `app/views/pwa/manifest.json.erb` - PWAマニフェスト

## 開発環境での確認

Docker環境でアプリを起動している場合：
```bash
# アイコンファイルを変更後、コンテナを再起動
docker compose restart web
```

## アイコンサイズの推奨仕様

- **ファビコン**: 16x16, 32x32, 48x48px
- **Apple Touch Icon**: 180x180px
- **PWAアイコン**: 512x512px
- **Androidアイコン**: 192x192, 512x512px

現在のアプリは512x512pxのPNG形式で設定されています。

## 注意事項

- SVGアイコンは使用していません（PNG形式のみ）
- アイコンファイルは `public/icon.png` のみ配置してください
- ファイルサイズが大きすぎる場合は、画像を最適化することをお勧めします
