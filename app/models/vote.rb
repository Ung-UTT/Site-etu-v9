class Vote < ActiveRecord::Base
  validate :uniqueness_of_vote_per_answer

  belongs_to :answer
  belongs_to :user

  def uniqueness_of_vote_per_answer
    if Answer.find(answer_id).pool.voted_by?(User.find(user_id))
      errors.add(:user_id, "Can't vote to the same pool twice")
    end
  end
end
