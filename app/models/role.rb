class Role < ActiveRecord::Base
  attr_accessible :name
  validates_presence_of :name

  # Rolify
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  has_paper_trail

  def self.administrators
    Role.find_by_name('administrator')
  end

  def to_s
    str = I18n.t("model.role.roles.#{name}", default: name)
    str += " #{I18n.t('of')} #{resource_type}" if resource_type
    str += " #{resource.name}" if resource_id
    str
  end
end

