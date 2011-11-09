class Pool < ActiveRecord::Base
  has_many :questions
  belongs_to :user

  def votes
    self.questions.map(&:votes).flatten.compact
  end

  def voted_by?(user)
    votes.map(&:user_id).include?(user.id)
  end

  def vote_of(user)
    vote = votes.select{ |v| v.user_id == user.id}.first
  end
end
