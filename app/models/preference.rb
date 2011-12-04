class Preference < ActiveRecord::Base
  validates_presence_of :user_id
  validates_uniqueness_of :user_id
  validates :locale, :inclusion => {:in => I18n.available_locales.map(&:to_s)}
  # TODO: Implémenter quote_type
  validates :quote_type, :inclusion => {:in => %w(all quotes tooltips jokes none)}

  belongs_to :user
end
