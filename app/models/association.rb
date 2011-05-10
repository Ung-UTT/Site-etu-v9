class Association < ActiveRecord::Base
  acts_as_nested_set :dependent => :destroy
  belongs_to :president, :class_name => 'User'
  has_many :roles, :dependent => :destroy

  has_many :comments, :as => :commentable, :dependent => :destroy

  def create_member
    Role.create(:name => 'Membre', :association => self)
  end

  def member
    return Role.where(:association_id => self.id, :name => 'Membre')
  end

  def delete_user(user)
    roles.each { |r| r.users.delete(user) }
  end

  def users
    return roles.map { |r| r.users }.flatten.uniq
  end
end
