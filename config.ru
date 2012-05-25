# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
map SiteEtu::Application.config.action_controller.relative_url_root || '/' do
  run SiteEtu::Application
end
