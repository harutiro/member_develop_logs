# Member Develop Logs - Makefile
# 開発・テスト・デプロイ用のコマンド集

.PHONY: help install test test-docker build run stop clean deploy

# デフォルトターゲット
help:
	@echo "利用可能なコマンド:"
	@echo "  install      - 依存関係をインストール"
	@echo "  test         - ローカルでテストを実行"
	@echo "  test-docker  - Dockerでテストを実行"
	@echo "  build        - Dockerイメージをビルド"
	@echo "  run          - 開発環境を起動"
	@echo "  stop         - 開発環境を停止"
	@echo "  clean        - クリーンアップ"
	@echo "  deploy       - 本番環境にデプロイ"
	@echo "  deploy-prod  - 本番環境にデプロイ（高速ビルド）"
	@echo "  deploy-fast  - 本番環境にデプロイ（アセットスキップ）"

# 依存関係のインストール
install:
	bundle install
	yarn install

# ローカルでテスト実行
test:
	bin/rails db:test:prepare
	bin/rails test

# Dockerでテスト実行
test-docker:
	docker compose run --rm -e RAILS_ENV=test web bin/rails db:test:prepare
	docker compose run --rm -e RAILS_ENV=test web bin/rails test

# Dockerイメージをビルド
build:
	docker compose build

# 開発環境を起動
run:
	docker compose up -d

# 開発環境を停止
stop:
	docker compose down

# クリーンアップ
clean:
	docker compose down -v
	docker system prune -f
	rm -rf tmp/cache
	rm -rf log/*.log

# 本番環境にデプロイ
deploy:
	docker compose -f docker-compose.prod.yml build
	docker compose -f docker-compose.prod.yml up -d

# 本番環境にデプロイ（高速ビルド）
deploy-prod:
	docker compose -f docker-compose.prod.yml build --no-cache
	docker compose -f docker-compose.prod.yml up -d

# 本番環境にデプロイ（アセットスキップ）
deploy-fast:
	SKIP_ASSETS=true docker compose -f docker-compose.prod.yml build
	docker compose -f docker-compose.prod.yml up -d

# データベース関連
db-setup:
	bin/rails db:create
	bin/rails db:migrate
	bin/rails db:seed

db-reset:
	bin/rails db:drop
	bin/rails db:create
	bin/rails db:migrate
	bin/rails db:seed

# Dockerでデータベース関連
db-setup-docker:
	docker compose run --rm web bin/rails db:create
	docker compose run --rm web bin/rails db:migrate
	docker compose run --rm web bin/rails db:seed

db-reset-docker:
	docker compose run --rm web bin/rails db:drop
	docker compose run --rm web bin/rails db:create
	docker compose run --rm web bin/rails db:migrate
	docker compose run --rm web bin/rails db:seed

# ログ確認
logs:
	docker compose logs -f web

logs-prod:
	docker compose -f docker-compose.prod.yml logs -f web

# シェルアクセス
shell:
	docker compose exec web bin/rails console

shell-prod:
	docker compose -f docker-compose.prod.yml exec web bin/rails console

# セキュリティチェック
security:
	bundle exec brakeman

# コードスタイルチェック
lint:
	bundle exec rubocop

# コードスタイル自動修正
lint-fix:
	bundle exec rubocop -a

# システムテスト
test-system:
	bin/rails test:system

# Dockerでシステムテスト
test-system-docker:
	docker compose run --rm -e RAILS_ENV=test web bin/rails test:system