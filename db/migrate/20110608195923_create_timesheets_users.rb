class CreateTimesheetsUsers < ActiveRecord::Migration
  def change
    create_table :timesheets_users do |t|
      t.references :timesheet
      t.references :user

      t.timestamps
    end

    add_index :timesheets_users, :timesheet_id
    add_index :timesheets_users, :user_id
  end
end
