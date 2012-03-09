class Preference < ActiveRecord::Base
  QUOTES_TYPES = %w(all quotes tooltips jokes none)

  validates_presence_of :user_id
  validates_uniqueness_of :user_id
  validates :locale, :inclusion => {:in => I18n.available_locales.map(&:to_s)}
  validates :quote_type, :inclusion => {:in => Quote::TYPES}

  belongs_to :user
end
