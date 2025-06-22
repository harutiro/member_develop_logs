# Member Develop Logs - Makefile
# 開発・テスト・デプロイ用のコマンド集

.PHONY: help install test test-docker build run stop clean deploy lint lint-fix lint-check pre-push setup-hooks

# デフォルトターゲット
help:
	@echo "利用可能なコマンド:"
	@echo "  setup        - 開発環境をセットアップ"
	@echo "  install      - 依存関係をインストール"
	@echo "  test         - ローカルでテストを実行"
	@echo "  test-docker  - Dockerでテストを実行"
	@echo "  build        - Dockerイメージをビルド"
	@echo "  up          - 開発環境を起動"
	@echo "  down         - 開発環境を停止"
	@echo "  clean        - クリーンアップ"
	@echo "  deploy       - 本番環境にデプロイ"
	@echo "  deploy-prod  - 本番環境にデプロイ（高速ビルド）"
	@echo "  deploy-fast  - 本番環境にデプロイ（アセットスキップ）"
	@echo "  lint         - コードスタイルチェック"
	@echo "  lint-fix     - コードスタイル自動修正"
	@echo "  lint-check   - lintチェック（変更があればエラー）"
	@echo "  pre-push     - push前のチェック（lint + test）"
	@echo "  setup-hooks  - Git hooksをセットアップ"


setup:
	docker compose build
	docker compose run --rm web bundle install
	docker compose run --rm web bin/rails db:create
	docker compose run --rm web bin/rails db:migrate
	docker compose run --rm web bin/rails db:seed
	docker compose run --rm web bin/rails db:test:prepare
	docker compose run --rm web bin/rails test

# 依存関係のインストール
install:
	docker compose run --rm web bundle install

# Dockerでテスト実行
test-docker:
	docker compose run --rm -e RAILS_ENV=test web bin/rails db:test:prepare
	docker compose run --rm -e RAILS_ENV=test web bin/rails test

# Dockerイメージをビルド
build:
	docker compose build

# 開発環境を起動
up:
	docker compose up -d
	open http://localhost:3000

# 開発環境を停止
down:
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

# Dockerでコードスタイルチェック
lint-docker:
	docker compose run --rm web bundle exec rubocop

# Dockerでコードスタイル自動修正
lint-fix-docker:
	docker compose run --rm web bundle exec rubocop -A

# Dockerでlintチェック（変更があればエラー）
lint-check-docker:
	@echo "🔍 Docker環境でLintチェックを実行中..."
	@if docker compose run --rm web bundle exec rubocop --format=quiet; then \
		echo "✅ Lintチェック完了 - 問題なし"; \
	else \
		echo "❌ Lintエラーが検出されました"; \
		echo "自動修正を実行します..."; \
		docker compose run --rm web bundle exec rubocop -A; \
		echo "⚠️  ファイルが変更されました。再度lintチェックを実行してください"; \
		exit 1; \
	fi

# push前のチェック（lint + test）
pre-push: lint-check-docker test-docker
	@echo "✅ 全てのチェックが完了しました。push可能です。"

# Dockerでシステムテスト
test-system-docker:
	docker compose run --rm -e RAILS_ENV=test web bin/rails test:system

# Git hooksセットアップ
setup-hooks:
	@echo "🔗 Git hooks をセットアップしています..."
	@./scripts/setup-hooks.sh