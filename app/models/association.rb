class Association < ActiveRecord::Base
  validates_presence_of :name, :president
  validates_uniqueness_of :name
  validates_associated :president

  acts_as_nested_set :dependent => :destroy

  belongs_to :president, :class_name => 'User'
  has_many :roles, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy

  after_create do create_member end

  def create_member
    roles << Role.create(:name => 'member')
  end

  def member
    return roles.select { |r| r.name == 'member' }
  end

  def delete_user(user)
    roles.each { |r| r.users.delete(user) }
  end

  def users
    return roles.map { |r| r.users }.flatten.uniq
  end
end
