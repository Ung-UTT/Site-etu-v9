class Answer < ActiveRecord::Base
  validates_presence_of :content, :pool

  has_paper_trail

  belongs_to :pool
  has_many :votes

  # Est-ce que l'utilisateur "user" a déjà voté à cette réponse
  def voted_by?(user)
    votes.map(&:user_id).include?(user.id)
  end
end
