class Role < ActiveRecord::Base
  has_paper_trail

  validates_presence_of :name


  # Rolify
  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true

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
