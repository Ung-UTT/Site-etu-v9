class User < ActiveRecord::Base
  attr_accessible(:login, :email, :password, :password_confirmation,
                  :preference_attributes, :profile_attributes)

  attr_accessor :password
  before_create :generate_token
  after_create :create_preferences
  before_save :encrypt_password

  validates :login, :presence => true, :uniqueness => true
  validates_uniqueness_of :login
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates :email, :presence => true, :format =>
    { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  paginates_per 30

  has_paper_trail

  has_one :preference, :dependent => :destroy
  accepts_nested_attributes_for :preference

  has_one :profile, :dependent => :destroy
  accepts_nested_attributes_for :profile

  has_many :carpools, :dependent => :destroy
  has_many :classifieds, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :news, :dependent => :destroy
  has_many :polls, :dependent => :destroy
  has_many :quotes, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  has_many :created_assos, :foreign_key => 'owner_id', :class_name => 'Asso', :dependent => :destroy
  has_many :created_events, :foreign_key => 'owner_id', :class_name => 'Event', :dependent => :destroy
  has_many :created_projects, :foreign_key => 'owner_id', :class_name => 'Project', :dependent => :destroy

  has_many :events_user, :dependent => :destroy
  has_many :events, :through => :events_user, :uniq => true

  has_many :projects_user, :dependent => :destroy
  has_many :projects, :through => :projects_user, :uniq => true

  has_many :roles_user, :dependent => :destroy
  has_many :roles, :through => :roles_user, :uniq => true

  has_many :timesheets_user, :dependent => :destroy
  has_many :timesheets, :through => :timesheets_user, :uniq => true

  # Recherche parmi les utilisateurs
  def self.search(name)
    # Prend la chaîne de recherche, la découpe selon les espaces, l'échappe et la joint
    names = name.split(' ').map{|n| Regexp.escape(n)}.join('|') # Emm|Car|...
    User.all.select do |u|
      content = [u.login]
      if u.profile
        content.push(u.real_name)
      end
      /(#{names})/i.match(content.join(' '))
    end
  end

  # Retourne l'utilisateur si le couple login/password est bon
  def self.authenticate(login, password)
    user = find_by_login(login)
    if user && user.crypted_password == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  # Créer un utilisateur rapidement (juste pour les tests)
  def self.simple_create(login, password = nil)
    password ||= SecureRandom.base64
    User.create(:login => login, :email => "#{login}@example.org",
                :password => password, :password_confirmation => password)
  end

  # Ne stocke pas le mot de passe en clair
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.crypted_password = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  # Génére le token de sécurité qui est propre à un utilisateur
  def generate_token
    begin
      self.auth_token = SecureRandom.hex
    end while User.exists?(:auth_token => self.auth_token)
  end

  # Préférences par défaut d'un utilisateur
  def create_preferences
    Preference.create(:user_id => self.id,
      :locale => I18n.default_locale.to_s, :quote_type => 'all')
  end

  # Associations = associations dans lesquelles l'utilisateur a un rôle
  def assos
    self.roles.map(&:asso).compact.uniq
  end

  # Cours = cours dans lesquels l'utilisateur participe à une horaire
  def courses
    self.timesheets.map(&:course).compact.uniq
  end

  # L'utilisateur devient un étudiant (utilisé dans le script d'import)
  def become_a_student
    # Devenir étudiant (rôle)
    if !is_student?
      roles << (Role.find_by_name('student') || Role.create(:name => 'student'))
    end
  end


  # Est-ce qu'il est membre d'une association
  def is_member_of?(asso)
    self.assos.include?(asso)
  end

  # Est-ce qu'il a le rôle "name" (éventuelement dans le cadre d'une association)
  def is?(name, asso = nil)
    res = self.roles.select { |r| r.name.to_sym == name }
    if asso
      res = res & asso.roles
    end
    !res.empty?
  end

  # Est-ce un étudiant ? (est-ce qu'il a le rôle d'étudiant ?)
  def is_student?
    self.is?(:student)
  end

  # Emploi du temps
  def schedule
    Timesheet.make_schedule([self.timesheets])
  end

  # Agenda (horaires rééls et événements futurs)
  def agenda
    agenda = Timesheet.make_agenda([self.timesheets])
    agenda += Event.make_agenda
  end

  # Nom réel si on l'a (Prénom NOM) sinon login (prenono)
  def real_name
    if self.profile.nil? or (self.profile.firstname.nil? and self.profile.lastname.nil?)
      self.login
    else
      "#{self.profile.firstname} #{self.profile.lastname}"
    end
  end
end
