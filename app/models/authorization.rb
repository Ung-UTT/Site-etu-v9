class Authorization < ActiveRecord::Base
  belongs_to :user

  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end

  def self.create_from_hash(hash, password, user = nil)
    if hash['provider'] == 'twitter'
      login = hash['user_info']['nickname']
    else
      login = hash['uid']
    end

    user ||= User.create(:login => login, :email => "#{login}@utt.fr",
                         :password => password, :password_confirmation => password)
    Authorization.create(:user_id => user.id, :uid => hash['uid'], :provider => hash['provider'])
  end
end
