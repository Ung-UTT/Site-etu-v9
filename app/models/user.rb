class User < ActiveRecord::Base
  acts_as_authentic

  has_many :authorizations, :dependent => :destroy
  has_many :carpools, :dependent => :destroy
  has_many :classifieds, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :courses, :dependent => :destroy
  has_many :quotes, :dependent => :destroy
  has_many :reminders, :dependent => :destroy
  has_many :news, :dependent => :destroy

  has_many :created_associations, :foreign_key => 'president_id', :class_name => 'Association', :dependent => :destroy
  has_many :created_events, :foreign_key => 'organizer_id', :class_name => 'Event', :dependent => :destroy
  has_and_belongs_to_many :events
  has_and_belongs_to_many :roles
  
  # Enléve les participations aux événements et les rôles allouéss
  before_destroy do self.events.delete_all end
  before_destroy do self.roles.delete_all end

  def associations
    roles.map { |r| r.association }.compact.map { |a| a.name }
  end
end
