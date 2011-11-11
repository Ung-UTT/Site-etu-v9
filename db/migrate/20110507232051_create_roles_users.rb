class CreateRolesUsers < ActiveRecord::Migration
  def self.change
    create_table :roles_users, :id => false do |t|
      t.references :role
      t.references :user

      t.timestamps
    end
  end
end
