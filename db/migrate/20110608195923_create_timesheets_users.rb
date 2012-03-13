class CreateTimesheetsUsers < ActiveRecord::Migration
  def change
    create_table :timesheets_users do |t|
      t.references :timesheet
      t.references :user

      t.timestamps
    end
  end
end
