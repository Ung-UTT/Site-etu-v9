require 'resolv-replace'
require 'ping'

module ApplicationHelper
  def parent_select_options(name)
    return options_for_select(
      nested_set_options(name) {|i| "#{'..' * i.level} #{i.name}" }.unshift(["Pas de parent", nil])
    )
  end
end
