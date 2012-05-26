class Poll < ActiveRecord::Base
  DEFAULT_ANSWERS = 5

  include Extensions::Searchable
  searchable_attributes :name, :description

  attr_accessible :name, :description, :answers_attributes
  validates_presence_of :name

  belongs_to :user
  has_many :answers
  has_many :votes, through: :answers, uniq: true

  # Pouvoir ajouter des réponses au sondage directement depuis le
  # formulaire de modification
  accepts_nested_attributes_for :answers, allow_destroy: true, reject_if: :all_blank

  # Est-ce que l'utilisateur a déjà voté pour ce sondage ?
  def voted_by?(user)
    votes.map(&:user_id).include?(user.id)
  end

  # Trouve le vote de l'utilisateur
  def vote_of(user)
    vote = votes.detect{ |v| v.user_id == user.id }
  end

  def to_s
    name
  end
end
