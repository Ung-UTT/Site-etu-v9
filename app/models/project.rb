class Project < ActiveRecord::Base
  paginates_per 20

  attr_accessible :name, :description, :owner_id
  validates_presence_of :name, :owner
  validates_uniqueness_of :name

  has_paper_trail

  belongs_to :owner, :class_name => 'User'
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :documents, :as => :documentable, :dependent => :destroy

  has_many :projects_user, :dependent => :destroy
  has_many :users, :through => :projects_user, :uniq => true

  def to_s
    res = name
    res += " : #{description.truncate(140)}" unless description.blank?
    res
  end
end
