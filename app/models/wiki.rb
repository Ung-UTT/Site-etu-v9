class Wiki < ActiveRecord::Base
  attr_accessible :title, :content, :parent_id
  validates_presence_of :title

  has_paper_trail
  # Arbre des pages du wiki
  acts_as_nested_set dependent: :destroy

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy

  # Page d'accueil (définie par la première page sans parent)
  def self.homepage
    Wiki.where(:parent_id => nil).first || Wiki.create(title: 'Accueil')
  end

  def to_s
    title
  end
end
