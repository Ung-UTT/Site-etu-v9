module ActiveRecordExtensions
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # ActiveRecord::Base.accessible
    # Example:
    #   accessible(
    #     default: [:title, :content, :event_id],
    #     moderator: [:is_moderated]
    #   )
    # is equivalent to:
    #   attr_accessible :title, :content, :event_id
    #   attr_accessible :title, :content, :event_id, :is_moderated, as: :moderator
    #   attr_accessible :title, :content, :event_id, :is_moderated, as: :administrator
    def accessible(hash)
      attributes = []
      [:default, :moderator, :administrator].each do |role|
        attributes |= hash[role] if hash[role]
        attributes.each do |attribute|
          instance_eval do
            attr_accessible attribute, as: role
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecordExtensions)

