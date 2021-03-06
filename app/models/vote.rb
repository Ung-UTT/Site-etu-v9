class Vote < ActiveRecord::Base
  attr_accessible :answer_id
  validate :uniqueness_of_vote_per_answer

  belongs_to :answer
  belongs_to :user

  # Un utilisateur ne doit pas pouvoir voter deux fois au même sondage
  def uniqueness_of_vote_per_answer
    if Answer.find(answer_id).poll.voted_by?(User.find(user_id))
      errors.add(:user_id, I18n.t('model.vote.uniqueness'))
    end
  end
end
