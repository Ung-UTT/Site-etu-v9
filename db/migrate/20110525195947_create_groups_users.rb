class CreateGroupsUsers < ActiveRecord::Migration
  def self.change
    create_table :groups_users, :id => false do |t|
      t.references :group
      t.references :user

      t.timestamps
    end
  end
end
