class User < ActiveRecord::Base
  acts_as_authentic # Gére aussi les validations

  has_many :authorizations, :dependent => :destroy
  has_many :carpools, :dependent => :destroy
  has_many :classifieds, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :courses, :dependent => :destroy
  has_many :quotes, :dependent => :destroy
  has_many :reminders, :dependent => :destroy
  has_many :news, :dependent => :destroy

  has_many :created_associations, :foreign_key => 'president_id', :class_name => 'Association', :dependent => :destroy
  has_many :created_courses, :foreign_key => 'owner_id', :class_name => 'Course', :dependent => :destroy
  has_many :created_events, :foreign_key => 'organizer_id', :class_name => 'Event', :dependent => :destroy
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :events
  has_and_belongs_to_many :roles

  # Enléve les participations aux UVs, aux événements, et les rôles alloués
  before_destroy do self.course.delete_all end
  before_destroy do self.events.delete_all end
  before_destroy do self.roles.delete_all end

  def associations
    return roles.map { |r| r.association }.compact
  end

  def is_member_of?(association)
    return associations.include?(association)
  end

  def is?(name, association = nil)
    res = roles.select { |r| r.symbol == name }
    if association
      res = res & association.roles
    end
    return !res.empty?
  end
end
