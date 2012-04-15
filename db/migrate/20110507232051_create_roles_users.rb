class CreateRolesUsers < ActiveRecord::Migration
  def change
    create_table :roles_users do |t|
      t.references :role
      t.references :user

      t.timestamps
    end

    add_index :roles_users, :role_id
    add_index :roles_users, :user_id
  end
end
