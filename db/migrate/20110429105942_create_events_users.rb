class CreateEventsUsers < ActiveRecord::Migration
  def change
    create_table :events_users do |t|
      t.references :event
      t.references :user

      t.timestamps
    end
  end
end
