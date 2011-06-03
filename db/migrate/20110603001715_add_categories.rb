class AddCategories < ActiveRecord::Migration
  def self.up
    [:news, :classifieds].each do |table|
      add_column table, :category_id, :integer
    end
  end

  def self.down
    [:news, :classifieds].each do |table|
      remove_column table, :category_id
    end
  end
end
