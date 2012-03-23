class Poll < ActiveRecord::Base
  attr_accessible :name, :description, :user_id
  validates_presence_of :name

  belongs_to :user
  has_many :answers
  has_many :votes, :through => :answers, :uniq => true

  # Pouvoir ajouter des réponses au sondage directement depuis le
  # formulaire de modification
  accepts_nested_attributes_for :answers, :allow_destroy => true,
    :reject_if => lambda { |d| d[:content].blank? }

  # Est-ce que l'utilisateur a déjà voté pour ce sondage ?
  def voted_by?(user)
    votes.map(&:user_id).include?(user.id)
  end

  # Trouve le vote de l'utilisateur
  def vote_of(user)
    vote = votes.select{ |v| v.user_id == user.id}.first
  end
end
