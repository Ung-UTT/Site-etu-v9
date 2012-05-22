class Role < ActiveRecord::Base
  attr_accessible :name
  validates_presence_of :name

  # Rolify
  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true

  default_scope order: 'name'

  has_paper_trail

  def short_users_list
    users.first(20).map(&:login).join(', ').truncate(80)
  end

  def to_s
    str = I18n.t("model.role.roles.#{name}", default: name)
    if resource_type
      str += " #{I18n.t('of')} #{resource_type}"
      str += " #{resource_id}" if resource_id
    else
      str += " (#{I18n.t('model.role.global')})"
    end
    str
  end
end
