class Association < ActiveRecord::Base
  validates_presence_of :name, :president
  validates_uniqueness_of :name
  validates_associated :president

  has_paper_trail
  acts_as_nested_set :dependent => :destroy
  acts_as_taggable

  belongs_to :president, :class_name => 'User'
  has_many :roles, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :documents, :as => :documentable, :dependent => :destroy
  has_and_belongs_to_many :events, :uniq => true

  after_create do create_member end

  def create_member
    Role.create(:name => 'member', :association_id => self.id)
  end

  def member
    roles.select { |r| r.name == 'member' }
  end

  def delete_user(user)
    roles.each { |r| r.users.delete(user) }
  end

  def users
    roles.map { |r| r.users }.flatten.uniq
  end
end
