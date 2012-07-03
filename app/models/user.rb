class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  paginates_per 32
  has_paper_trail ignore: [:reset_password_token, :remember_created_at, :sign_in_count,
                          :last_sign_in_at, :last_sign_in_ip]
  include Extensions::Searchable
  searchable_attributes :login, :firstname, :lastname, :level, :surname, :once

  attr_accessible :email, :login, :password, :password_confirmation,
                  :remember_me, :preference_attributes, :utt_address,
                  :parents_address, :surname, :once, :phone, :description,
                  :private_email, :website

  after_create :create_preferences

  validates_presence_of :login
  validates_uniqueness_of :login, :case_sensitive => false
  validates_inclusion_of :sex, in: %w(M F), allow_nil: true
  validates_email_format_of :email
  validates_email_format_of :private_email, allow_blank: true

  # Users with empty firstname come last
  default_scope order: 'case when firstname is null then 1 else 0 end,firstname,lastname'
  # FIXME: We should optimize SQL querie for users, so it avoid the lot of
  #        SQL queries for user's images (but we should preserve performance
  #        for others cases)
  # default_scope include: :image

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

  delegate :can?, :cannot?, to: :ability
  delegate :to_s, to: :decorator

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
    # Courses that are in week A or B count for the half
    durations = timesheets.map do |ts|
      ts.week ? ts.duration / 2 : ts.duration
    end

    durations.sum / 60
  end

  def age
    ((Time.now - birth_date.to_time) / 1.year).floor if birth_date
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
end
