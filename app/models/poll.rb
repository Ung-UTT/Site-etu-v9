class Poll < ActiveRecord::Base
  validates_presence_of :name

  belongs_to :user
  has_many :answers
  has_many :votes, :through => :answers, :uniq => true

  def voted_by?(user)
    votes.map(&:user_id).include?(user.id)
  end

  def vote_of(user)
    vote = votes.select{ |v| v.user_id == user.id}.first
  end
end
