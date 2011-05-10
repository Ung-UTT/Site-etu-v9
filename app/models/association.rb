class Association < ActiveRecord::Base
  acts_as_nested_set :dependent => :destroy
  belongs_to :president, :class_name => 'User'
  has_many :roles, :dependent => :destroy

  has_many :comments, :as => :commentable, :dependent => :destroy

  def member
    role_member = Role.where(:association_id => self.id, :name => 'Membre')
    return role_member unless role_member.empty?
    return Role.create(:name => 'Membre', :association => self)
  end

  def delete_user(user)
    roles.each { |r| r.users.delete(user) }
  end

  def users
    roles.map { |r| r.users }.flatten.uniq
  end
end
