class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string     :name
      t.references :asso
      t.references :parent
      t.integer    :lft
      t.integer    :rgt

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end
