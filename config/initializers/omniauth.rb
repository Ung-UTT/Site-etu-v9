require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,  'kic7XPhWl6Sm2YInckig', 'm0sfx36vwWMcJuBi8MVtjMyZDUcMwFu3Z6IcApAg'
  provider :CAS,  :cas_server => 'https://cas.utt.fr/cas/'
  provider :open_id, OpenID::Store::Filesystem.new('/tmp')
end