class CreateGroupsUsers < ActiveRecord::Migration
  def self.up
    create_table :groups_users, :id => false do |t|
      t.references :group
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :group_users
  end
end
