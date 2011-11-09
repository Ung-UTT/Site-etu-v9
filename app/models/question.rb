class Question < ActiveRecord::Base
  has_many :votes
  belongs_to :pool

  def voted_by?(user)
    votes.map(&:user_id).include?(user.id)
  end
end
