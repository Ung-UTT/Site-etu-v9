class Role < ActiveRecord::Base
  belongs_to :association
  has_and_belongs_to_many :users
end
