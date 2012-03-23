class Preference < ActiveRecord::Base
  attr_accessible :locale, :quote_type, :user_id
  validates_presence_of :user_id
  validates_uniqueness_of :user_id
  validates :locale, :inclusion => {:in => I18n.available_locales.map(&:to_s)}
  validates :quote_type, :inclusion => {:in => Quote::TAGS}

  belongs_to :user
end
