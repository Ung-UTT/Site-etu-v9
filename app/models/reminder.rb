class Reminder < ActiveRecord::Base
  paginates_per 20

  attr_accessible :content, :user_id
  validates_presence_of :content

  has_paper_trail

  belongs_to :user
end
