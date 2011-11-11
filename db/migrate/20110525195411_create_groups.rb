class CreateGroups < ActiveRecord::Migration
  def self.change
    create_table :groups do |t|
      t.string     :name
      t.references :parent
      t.integer    :lft
      t.integer    :rgt

      t.timestamps
    end
  end
end
