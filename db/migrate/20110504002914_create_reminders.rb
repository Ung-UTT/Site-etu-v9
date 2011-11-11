class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.string     :content
      t.references :user

      t.timestamps
    end
  end
end
