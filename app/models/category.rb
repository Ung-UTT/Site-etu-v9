class Category < ActiveRecord::Base
  acts_as_nested_set :dependent => :destroy

  def objects
    [News, Classified].map {|c| c.all.select {|o| o.category_id == id}}.flatten
  end
end
