class CreateEventsUsers < ActiveRecord::Migration
  def self.up
    create_table :events_users, :id => false do |t|
      t.references :event
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :events_users
  end
end