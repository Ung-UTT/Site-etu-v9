class CreateTimesheetsUsers < ActiveRecord::Migration
  def self.change
    create_table :timesheets_users, :id => false do |t|
      t.references :timesheet
      t.references :user

      t.timestamps
    end
  end
end
