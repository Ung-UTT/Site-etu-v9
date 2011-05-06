class User < ActiveRecord::Base
  acts_as_authentic

  has_many :authorizations
  has_many :carpools
  has_many :classifieds
  has_many :comments
  has_many :quotes
  has_many :reminders
  has_many :news

  has_many :created_events, :foreign_key => 'organizer_id', :class_name => 'Event'
  has_and_belongs_to_many :events
end
