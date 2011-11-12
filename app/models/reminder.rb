class Reminder < ActiveRecord::Base
  paginates_per 20

  validates_presence_of :content
  validates_associated :user

  has_paper_trail

  belongs_to :user
end
