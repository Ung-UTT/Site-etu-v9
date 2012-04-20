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
    def random
      if (c = count) != 0
        find(:first, :offset => rand(c))
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecordExtensions)

