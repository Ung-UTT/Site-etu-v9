class CreateEventsUsers < ActiveRecord::Migration
  def change
    create_table :events_users do |t|
      t.references :event
      t.references :user

      t.timestamps
    end

    add_index :events_users, :event_id
    add_index :events_users, :user_id
  end
end
