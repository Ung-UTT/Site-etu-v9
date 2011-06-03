class TimeSheet < ActiveRecord::Base
  has_paper_trail

  belongs_to :course
  has_and_belongs_to_many :users, :uniq => true
end
