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

    add_index :roles, :asso_id
  end
end
