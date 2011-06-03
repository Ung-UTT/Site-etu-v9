class Group < ActiveRecord::Base
  validates_presence_of :name

  has_paper_trail
  acts_as_nested_set :dependent => :destroy

  has_and_belongs_to_many :users, :uniq => true
end
