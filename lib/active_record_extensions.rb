module ActiveRecordExtensions
  def self.included(base)
    base.extend(ClassMethods)
  end

  def to_param
    param_string = attributes.keys.detect { |k| ['name', 'title', 'login', 'content'].include?(k) }
    if param_string.nil?
      super
    else
      param_string = send(param_string)
      param_string = param_string.slice(0..80).gsub(/[^a-z0-9]+/i, '-').chomp('-')
      "#{id}-#{param_string}"
    end
  end

  module ClassMethods
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

    def random
      if (c = count) != 0
        find(:first, :offset => rand(c))
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecordExtensions)

