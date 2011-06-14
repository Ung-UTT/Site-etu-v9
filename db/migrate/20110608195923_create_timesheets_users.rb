class CreateTimesheetsUsers < ActiveRecord::Migration
  def self.up
    create_table :timesheets_users, :id => false do |t|
      t.references :timesheet
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :timesheets_users
  end
end
