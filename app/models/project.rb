class Project < ActiveRecord::Base
  paginates_per 20

  attr_accessible :name, :description
  validates_presence_of :name
  validates_uniqueness_of :name
  validate :at_least_one_user

  has_paper_trail

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy

  has_many :projects_user, dependent: :destroy
  has_many :users, through: :projects_user, uniq: true

  # There should be at least one user in the project
  def at_least_one_user
    if users.size < 1
      errors.add(:users, I18n.t('model.project.at_least_one_user'))
    end
  end

  def to_s
    res = name
    res += " : #{description.truncate(60)}" unless description.blank?
    res
  end
end
