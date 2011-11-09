class Question < ActiveRecord::Base
  validates_presence_of :name

  has_paper_trail

  has_many :votes
  belongs_to :pool

  def voted_by?(user)
    votes.map(&:user_id).include?(user.id)
  end
end
