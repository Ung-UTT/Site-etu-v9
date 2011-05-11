class Reminder < ActiveRecord::Base
  validates_presence_of :content
  validates_associated :user

  belongs_to :user
end
