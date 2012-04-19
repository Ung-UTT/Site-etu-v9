class Answer < ActiveRecord::Base
  attr_accessible :content
  validates_presence_of :content, :poll

  has_paper_trail

  belongs_to :poll
  has_many :votes

  # Est-ce que l'utilisateur a répondu à cette réponse ?
  def voted_by?(user)
    votes.map(&:user_id).include?(user.id)
  end

  # Pourcentages de votes pour cette réponse
  def percent
    count_all = poll.votes.size.to_f
    if count_all == 0
      return 0
    else
      return (100 * votes.size / count_all).round.to_i
    end
  end
end
