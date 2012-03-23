class AssosEvent < ActiveRecord::Base
  belongs_to :asso
  belongs_to :event
end
