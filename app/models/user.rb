class User < ActiveRecord::Base
  include EtuLdap
  attr_accessible :login, :email, :password, :password_confirmation, :cas

  attr_accessor :password
  before_create :generate_token
  after_create :create_preferences
  before_save :encrypt_password

  validates :login, :presence => true, :uniqueness => true
  validates_uniqueness_of :login
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates :email, :presence => true, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}

  paginates_per 30

  has_paper_trail

  has_one :preference, :dependent => :destroy

  has_many :carpools, :dependent => :destroy
  has_many :classifieds, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :news, :dependent => :destroy
  has_many :pools, :dependent => :destroy
  has_many :quotes, :dependent => :destroy
  has_many :reminders, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  has_many :created_assos, :foreign_key => 'owner_id', :class_name => 'Asso', :dependent => :destroy
  has_many :created_events, :foreign_key => 'owner_id', :class_name => 'Event', :dependent => :destroy
  has_many :created_projects, :foreign_key => 'owner_id', :class_name => 'Project', :dependent => :destroy

  # FIXME Deprecated: replace all has_and_belongs_to_many by "has_many, :through => ..."
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

  def self.authenticate(login, password)
    user = find_by_login(login)
    if user && user.crypted_password == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def self.simple_create(login, password)
    User.create(:login => login, :email => "#{login}@yopmail.com",
                :password => password, :password_reset => :password)
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.crypted_password = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def generate_token
    begin
      self.auth_token = SecureRandom.hex
    end while User.exists?(:auth_token => self.auth_token)
  end

  def create_preferences
    Preference.create(:user => self, :locale => I18n.default_locale.to_s, :quote_type => 'all')
  end

  def assos
    roles.map(&:asso).compact.uniq
  end

  def courses
    timesheets.map(&:course).uniq
  end

  def is_member_of?(asso)
    assos.include?(asso)
  end

  def is?(name, asso = nil)
    res = roles.select { |r| r.symbol == name }
    if asso
      res = res & asso.roles
    end
    !res.empty?
  end

  def is_student?
    !cas.nil? && cas == true
  end

  def ldap_attributes
    ldap_attributes_for_username(login)
  end

  def ldap_attribute(attr)
    ldap_attribute_for_username(login, attr)
  end
end
