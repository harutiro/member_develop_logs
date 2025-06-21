.PHONY: setup up down db-reset test console release-build deploy deploy-status rollback

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
	docker compose -f docker-compose.prod.yml run --rm web rails db:migrate

# デプロイ状態の確認
deploy-status:
	docker compose -f docker-compose.prod.yml ps

# ロールバック
rollback:
	docker compose -f docker-compose.prod.yml down
	docker compose -f docker-compose.prod.yml up -d