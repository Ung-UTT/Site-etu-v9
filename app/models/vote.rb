class Vote < ActiveRecord::Base
  validate :uniqueness_of_vote_per_answer

  belongs_to :answer
  belongs_to :user

  # Un utilisateur ne doit pas pouvoir voter deux fois au même sondage
  def uniqueness_of_vote_per_answer
    if Answer.find(answer_id).poll.voted_by?(User.find(user_id))
      errors.add(:user_id, "Can't vote to the same poll twice")
    end
  end
end
