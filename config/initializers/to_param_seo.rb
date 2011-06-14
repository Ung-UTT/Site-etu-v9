module ActiveRecord
  class Base
    def to_param
      param_string = attributes.keys.select {|k| ['name', 'title', 'login', 'content'].include?(k) }.first
      param_string = send(param_string)
      if param_string.nil?
        return id
      else
        param_string = param_string.slice(0..80).gsub(/[^a-z0-9]+/i, '-').chomp('-')
        return "#{id}-#{param_string}"
      end
    end
  end
end
