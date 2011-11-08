class Question < ActiveRecord::Base
  has_many :votes
  belongs_to :pool
end
