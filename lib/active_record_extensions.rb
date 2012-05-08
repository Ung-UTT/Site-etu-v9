module ActiveRecordExtensions
  # Allow to include the following methods
  def self.included(base)
    base.extend(ClassMethods)
  end

  # SEO URLs with the humanly readable string of an object
  def to_param
    param_string = to_s.first(80).gsub(/[^a-z0-9]+/i, '-').chomp('-')
    "#{id}-#{param_string}"
  end

  module ClassMethods
    # Random record from a class (Quote.random, Course.random, ...)
    def random
      if (c = count) != 0
        find(:first, offset: rand(c))
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecordExtensions)

