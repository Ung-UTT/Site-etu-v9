class User < ActiveRecord::Base
  paginates_per 30

  has_paper_trail :ignore => ['persistence_token', 'login_count', 'failed_login_count',
                              'last_request_at', 'current_login_at', 'last_login_at',
                              'current_login_ip', 'last_login_ip', 'updated_at']
  acts_as_authentic # Gère aussi les validations

  has_many :carpools, :dependent => :destroy
  has_many :classifieds, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :news, :dependent => :destroy
  has_many :quotes, :dependent => :destroy
  has_many :reminders, :dependent => :destroy

  has_many :created_associations, :foreign_key => 'owner_id', :class_name => 'Association', :dependent => :destroy
  has_many :created_events, :foreign_key => 'owner_id', :class_name => 'Event', :dependent => :destroy
  has_many :created_projects, :foreign_key => 'owner_id', :class_name => 'Project', :dependent => :destroy
  has_and_belongs_to_many :events, :uniq => true
  has_and_belongs_to_many :groups, :uniq => true
  has_and_belongs_to_many :projects, :uniq => true
  has_and_belongs_to_many :roles, :uniq => true
  has_and_belongs_to_many :timesheets, :uniq => true

  # Enlève les participations
  before_destroy do self.events.delete_all end
  before_destroy do self.groups.delete_all end
  before_destroy do self.projects.delete_all end
  before_destroy do self.roles.delete_all end

  def associations
    roles.map(&:association).compact.uniq
  end

  def courses
    timesheets.map(&:course).uniq
  end

  def is_member_of?(association)
    associations.include?(association)
  end

  def is?(name, association = nil)
    res = roles.select { |r| r.symbol == name }
    if association
      res = res & association.roles
    end
    !res.empty?
  end

  def is_student?
    true # Si connexion avec CAS # Ou ancien… (versions…)
  end
end
