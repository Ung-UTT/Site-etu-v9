class CreateReminders < ActiveRecord::Migration
  def self.up
    create_table :reminders do |t|
      t.string  :content
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :reminders
  end
end
