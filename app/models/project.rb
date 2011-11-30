class Project < ActiveRecord::Base
  paginates_per 20

  has_paper_trail

  belongs_to :owner, :class_name => 'User'
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :documents, :as => :documentable, :dependent => :destroy

  has_many :roles_user, :dependent => :destroy
  has_many :roles, :through => :roles_user, :uniq => true
end
