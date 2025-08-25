# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CuuTruyen
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults(6.0)
    config.time_zone = 'Hanoi'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.active_job.queue_adapter = :good_job

    config.good_job = {
      preserve_job_records: true,
      retry_on_unhandled_error: false,
      execution_mode: :external,
      max_threads: 5,
      enable_cron: true,
      cron: {
        log_mangas: {
          cron: '0 0 * * * Asia/Bangkok',
          class: 'LogMangasJob'
        },
        log_teams: {
          cron: '0 0 * * * Asia/Bangkok',
          class: 'LogTeamsJob'
        },
        clean: {
          cron: '0 0 * * * Asia/Bangkok',
          class: 'CleanJob'
        },
        # backup: {
        #   cron: '0 0 * * * Asia/Bangkok',
        #   class: 'BackupJob'
        # },
        persist_view: {
          cron: '*/30 * * * * Asia/Bangkok',
          class: 'PersistViewsCountJob'
        },
        unban: {
          cron: '0 * * * * Asia/Bangkok',
          class: 'UnbanJob'
        }
      }
    }

    config.cache_store = :redis_cache_store, { url: ENV.fetch("REDIS_URL") { "redis://redis:6379/1" } }
    config.action_mailer.default_url_options = { host: ENV['BASE_URL'], protocol: 'https' }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: ENV['SMTP_SERVER'],
      port: ENV['SMTP_PORT'],
      user_name: ENV['SMTP_USERNAME'],
      password: ENV['SMTP_PASSWORD']
    }
  end
end
