class AssosEvent < ActiveRecord::Base
  attr_accessible :asso_id, :event_id
  belongs_to :asso
  belongs_to :event
end
