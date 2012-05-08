class CreateTimesheetsUsers < ActiveRecord::Migration
  def change
    create_table :timesheets_users, id: false do |t|
      t.references :timesheet
      t.references :user
    end

    add_index(:timesheets_users, [ :timesheet_id, :user_id ])
  end
end

