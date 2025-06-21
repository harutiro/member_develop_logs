#!/bin/bash

# Git hooks セットアップスクリプト
# プロジェクト内のhooksディレクトリを.git/hooksにシンボリックリンクします

set -e

echo "🔗 Git hooks のセットアップを開始します..."

# プロジェクトルートディレクトリに移動
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

# .gitディレクトリが存在するかチェック
if [ ! -d ".git" ]; then
    echo "❌ エラー: .gitディレクトリが見つかりません。Gitリポジトリ内で実行してください。"
    exit 1
fi

# hooksディレクトリが存在するかチェック
if [ ! -d "hooks" ]; then
    echo "❌ エラー: hooksディレクトリが見つかりません。"
    exit 1
fi

# .git/hooksディレクトリが存在しない場合は作成
if [ ! -d ".git/hooks" ]; then
    mkdir -p ".git/hooks"
fi

# 既存の.git/hooksディレクトリをバックアップ
if [ -d ".git/hooks" ] && [ "$(ls -A .git/hooks 2>/dev/null)" ]; then
    BACKUP_DIR=".git/hooks.backup.$(date +%Y%m%d_%H%M%S)"
    echo "📦 既存のhooksをバックアップ: $BACKUP_DIR"
    mv .git/hooks "$BACKUP_DIR"
fi

# プロジェクト内のhooksディレクトリを.git/hooksにシンボリックリンク
echo "🔗 hooksディレクトリをシンボリックリンクしています..."
ln -sf "$(pwd)/hooks" ".git/hooks"

# 実行権限を付与
echo "🔐 実行権限を付与しています..."
chmod +x hooks/*

echo "✅ Git hooks のセットアップが完了しました！"
echo ""
echo "📋 セットアップされたhooks:"
ls -la hooks/
echo ""
echo "💡 これでpush時に自動的にlintチェックとテストが実行されます。" 