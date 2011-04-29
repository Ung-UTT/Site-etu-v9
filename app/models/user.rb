class User < ActiveRecord::Base
  acts_as_authentic

  has_many :news
  has_many :quotes
end
