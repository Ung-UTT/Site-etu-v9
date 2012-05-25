class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :validatable
  paginates_per 32
  has_paper_trail

  attr_accessible :email, :login, :password, :password_confirmation,
                  :remember_me, :preference_attributes, :utt_address,
                  :parents_address, :surname, :once, :phone, :description,
                  :private_email, :website

  delegate :can?, :cannot?, to: :ability

  after_create :create_preferences

  validates_presence_of :login
  validates_uniqueness_of :login, :case_sensitive => false
  validates_inclusion_of :sex, in: %w(M F), allow_nil: true
  validates_email_format_of :email
  validates_email_format_of :private_email, allow_blank: true

  default_scope order: 'firstname,lastname'

  has_one :image, dependent: :destroy, as: :documentable
  has_one :preference, dependent: :destroy
  accepts_nested_attributes_for :preference

  has_many :carpools, dependent: :destroy
  has_many :classifieds, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :news, dependent: :destroy
  has_many :polls, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :created_assos, :foreign_key => 'owner_id', :class_name => 'Asso', dependent: :destroy
  has_many :created_events, :foreign_key => 'owner_id', :class_name => 'Event', dependent: :destroy

  has_many :events_user, dependent: :destroy
  has_many :events, through: :events_user, uniq: true

  has_many :projects_user, dependent: :destroy
  has_many :projects, through: :projects_user, uniq: true

  has_many :timesheets_user, dependent: :destroy
  has_many :timesheets, through: :timesheets_user, uniq: true

  include Extensions::Searchable
  searchable_attributes :login, :firstname, :lastname, :level

  # FIXME: We should optimize SQL querie for users, so it avoid the lot of
  #        SQL queries for user's images (but we should preserve performance
  #        for others cases)
  # default_scope include: :image

  # Return all administrators
  def self.administrators
    admin = Role.find_by_name('administrator')
    admin.nil? ? [] : admin.users
  end

  # Return all students
  def self.students
    student = Role.find_by_name('student')
    student.nil? ? [] : student.users
  end

  # Créer un utilisateur rapidement
  def self.simple_create(login, password = nil)
    password ||= Devise.friendly_token[0,20]
    User.create!(
      login: login,
      email: "#{login}@utt.fr",
      password: password
    )
  end

  def hours_per_week
    schedule.map(&:duration).sum / 60
  end

  def ability
    @ability ||= Ability.new(self)
  end

  # Préférences par défaut d'un utilisateur
  def create_preferences
    self.preference_attributes = { locale: I18n.default_locale.to_s, :quote_type => 'all' }
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

  # Real name if we have it (Prénom NOM) or login (nomprenom)
  def to_s
    if firstname.nil? and lastname.nil?
      login
    else
      "#{firstname} #{lastname}"
    end
  end
end
