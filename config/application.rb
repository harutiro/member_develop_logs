require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MemberDevelopLogs
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.time_zone = "Tokyo"
    config.active_record.default_timezone = :local

    # Rails 8.1の非推奨警告を解決
    config.active_support.to_time_preserves_timezone = :zone

    # SSL設定を無効化
    config.force_ssl = false

    # 本番環境で複数データベース接続を無効化
    if Rails.env.production?
      config.active_record.database_selector = nil
      config.active_record.database_resolver = nil

      # SolidQueueを無効化し、ActiveStorageの分析を同期的に実行
      config.active_storage.analyzers = []
      config.active_storage.previewers = []
      config.active_storage.variable_content_types = []
    end
  end
end
