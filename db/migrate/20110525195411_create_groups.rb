class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string     :name
      t.references :parent
      t.integer    :lft
      t.integer    :rgt

      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
