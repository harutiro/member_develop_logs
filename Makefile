.PHONY: setup up down db-reset test console release-build deploy deploy-status rollback prod-db-reset prod-seed prod-init

# 初期セットアップ
setup:
	docker compose build
	docker compose run --rm web bundle install
	docker compose run --rm web rails db:create
	docker compose run --rm web rails db:migrate
	docker compose run --rm web rails db:seed

# 開発サーバーの起動
up:
	docker compose up -d
	open http://localhost:3000

web-client:
	open http://localhost:3000

# 開発サーバーの停止
down:
	docker compose down

# データベースのリセット
db-reset:
	docker compose run --rm web rails db:drop
	docker compose run --rm web rails db:create
	docker compose run --rm web rails db:migrate
	docker compose run --rm web rails db:seed

# テストの実行
test:
	docker compose run --rm web rails test

# コンソールの起動
console:
	docker compose run --rm web rails console

# リリース用のビルド
release-build:
	docker compose -f docker-compose.prod.yml build

# 本番環境へのデプロイ
deploy:
	docker compose -f docker-compose.prod.yml up -d
	docker compose -f docker-compose.prod.yml run --rm web bundle install
	docker compose -f docker-compose.prod.yml run --rm web rails db:migrate

# 本番DBリセット（全データ削除・再作成）
prod-db-reset:
	DISABLE_DATABASE_ENVIRONMENT_CHECK=1 docker compose -f docker-compose.prod.yml run --rm web rails db:migrate:reset

# 本番シード投入
prod-seed:
	docker compose -f docker-compose.prod.yml run --rm web rails db:seed

# 本番初期化（リセット＋シード）
prod-init: prod-db-reset prod-seed

# デプロイ状態の確認
deploy-status:
	docker compose -f docker-compose.prod.yml ps

# ロールバック
rollback:
	docker compose -f docker-compose.prod.yml down
	docker compose -f docker-compose.prod.yml up -d