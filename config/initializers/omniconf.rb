Omniconf.setup do |config|
  config.sources = {
    yaml: {
      type: :yaml,
      file: "config/settings.yml"
    }
  }
end

