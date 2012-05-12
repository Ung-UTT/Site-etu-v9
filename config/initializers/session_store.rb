# Be sure to restart your server when you modify this file.

if Rails.env.production?
  SiteEtu::Application.config.session_store :redis_store
else
  SiteEtu::Application.config.session_store :cookie_store, key: '_site_etu_session'
end

