require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  # Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  Bundler.require(:default, :assets, Rails.env)
end

require 'open-uri'
require 'casclient'
require 'casclient/frameworks/rails/filter'

module SiteEtu
  class Application < Rails::Application
    config.version = `git log -1 --pretty='format:%h (%ci)'` rescue '[unknown]'

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Paris'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :fr
    config.i18n.fallbacks = true
    config.i18n.fallbacks = [:fr]

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    # Enable the asset pipeline
    config.assets.enabled = true
    # Change this to expire all assets
    config.assets.version = "1.0"

    config.action_mailer.default_url_options = { :host => 'etu.utt.fr' }
    config.rubycas.cas_base_url = 'https://cas.utt.fr/cas'

    # Protect mass assignment
    config.active_record.whitelist_attributes = true
  end
end
