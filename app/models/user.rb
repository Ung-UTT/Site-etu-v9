class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :lockable, :recoverable, :rememberable,
         :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me # Devise
  attr_accessible :preference_attributes, :profile_attributes

  after_create :create_preferences

  validates_presence_of :login
  validates_uniqueness_of :login, :case_sensitive => false
  validates :email, :presence => true, :format =>
    { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  paginates_per 100

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
  has_many :votes, :dependent => :destroy
  has_many :created_assos, :foreign_key => 'owner_id', :class_name => 'Asso', :dependent => :destroy
  has_many :created_events, :foreign_key => 'owner_id', :class_name => 'Event', :dependent => :destroy
  has_many :created_projects, :foreign_key => 'owner_id', :class_name => 'Project', :dependent => :destroy

  has_many :events_user, :dependent => :destroy
  has_many :events, :through => :events_user, :uniq => true

  has_many :projects_user, :dependent => :destroy
  has_many :projects, :through => :projects_user, :uniq => true

  has_many :timesheets_user, :dependent => :destroy
  has_many :timesheets, :through => :timesheets_user, :uniq => true

  class << self
    def students
      User.select { |user| user.has_role? :student }
    end

    # Recherche parmi les utilisateurs via une chaîne
    # Exemple : User.search("Emm Car") => [User (Emmanuel Carquin), ...]
    def search(clues)
      # FIXME : Enlever les accents (peut-être : http://snippets.dzone.com/posts/show/2384)
      # Prend la chaîne de recherche, la découpe selon les espaces, l'échappe et la joint
      clues = clues.split(' ').map{|n| Regexp.escape(n)} # [Emm, Car, ...]
      profiles = Profile.find(:all, :include => :user).select do |p|
        # Le profil fait parti des profils recherchés si il contient
        # chacun des indices
        string = [p.user.login, p.firstname, p.lastname, p.level].join(' ')
        clues.all? do |clue|
          string.include?(clue)
        end
      end.map(&:user)
    end

    # Créer un utilisateur rapidement
    def simple_create(login, password = nil)
      password ||= Devise.friendly_token[0,20]
      User.create!(
        :login => login,
        :email => "#{login}@utt.fr",
        :password => password
      )
    end
  end

  # Préférences par défaut d'un utilisateur
  def create_preferences
    self.preference_attributes = { :locale => I18n.default_locale.to_s, :quote_type => 'all' }
  end

  # Cours = cours dans lesquels l'utilisateur participe à une horaire
  def courses
    timesheets.map(&:course).compact.uniq
  end

  # Emploi du temps
  def schedule
    Timesheet.make_schedule(self.timesheets)
  end

  # Agenda (horaires rééls et événements futurs)
  def agenda
    agenda = Timesheet.make_agenda(self.timesheets)
    agenda += Event.make_agenda
  end

  # Nom réel si on l'a (Prénom NOM) sinon login (nomprenom)
  def real_name
    return @cached_real_name unless @cached_real_name.nil?

    if self.profile.nil? or (self.profile.firstname.nil? and self.profile.lastname.nil?)
      @cached_real_name = self.login
    else
      @cached_real_name ="#{self.profile.firstname} #{self.profile.lastname}"
    end

    @cached_real_name
  end
end
