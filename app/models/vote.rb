class Vote < ActiveRecord::Base
  validate :uniqueness_of_vote_per_question

  belongs_to :question
  belongs_to :user

  def uniqueness_of_vote_per_question
    if Question.find(question_id).pool.voted_by?(User.find(user_id))
      errors.add(:user_id, "Can't vote to the same pool twice")
    end
  end
end
