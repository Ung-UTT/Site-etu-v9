class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string     :name
      t.references :asso
      t.references :parent
      t.integer    :lft
      t.integer    :rgt

      t.timestamps
    end
  end
end
