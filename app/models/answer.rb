class Answer < ActiveRecord::Base
  validates_presence_of :content, :poll

  has_paper_trail

  belongs_to :poll
  has_many :votes

  # Est-ce que l'utilisateur a répondu à cette question
  def voted_by?(user)
    votes.map(&:user_id).include?(user.id)
  end
end
