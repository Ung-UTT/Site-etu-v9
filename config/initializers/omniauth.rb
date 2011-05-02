require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,  'K5Owb3RGHlCpSY2epOQOhg', 'MbPBKOuK85ej0i5aP4Dt8CWFlAyWSntNheBD3NghDxk'
  provider :CAS,  :cas_server => 'https://cas.utt.fr/cas/'
  provider :open_id, OpenID::Store::Filesystem.new('/tmp'), {:name => "google", :domain => "https://www.google.com/accounts/o8/id" }
end